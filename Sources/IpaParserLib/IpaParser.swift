//
//  IpaParser.swift
//  ipa-parse
//
//  Created by Anton Glezman on 22/04/2019.
//

import Foundation

public final class IpaParser {
    
    // MARK: - Private properties
    
    private let file: String
    
    
    // MARK: - Init
    
    /// Init IpaParser
    ///
    /// - Parameter file: .ipa file destination
    public init(file: String) {
        self.file = file
    }
    
    
    // MARK: - Public methods
    
    public func run() throws {
        guard FileManager.default.fileExists(atPath: file) else {
            throw ParserErrors.fileNotExists
        }
        guard file.hasSuffix(".ipa") else {
            throw ParserErrors.fileNotIpa
        }
        
        // Create temporary folder for extracting files
        let tempDirFolder = try createTempDir()
        #if DEBUG
        print(tempDirFolder)
        #endif
        defer {
            try? deleteTempDir(at: tempDirFolder)
        }
        
        // Get ipa file name and size
        let attr = try FileManager.default.attributesOfItem(atPath: file)
        let fileSize = attr[FileAttributeKey.size] as! UInt64
        let fileName = (file as NSString).lastPathComponent
        var ipaDescription = IpaDescription(fileName: fileName, size: fileSize)
        
        // Get the embedded provisioning & plist from an app archive
        extractInfoAndProvisionFiles(ipaPath: file, tempDir: tempDirFolder)
        
        // Parse Info.plist
        let plistPath = (tempDirFolder as NSString).appendingPathComponent("Info.plist")
        let plistData = try Data(contentsOf: URL(fileURLWithPath: plistPath))
        guard let appPropertyList = try PropertyListSerialization
            .propertyList(from: plistData, options: [], format: nil) as? [AnyHashable : Any] else {
                throw ParserErrors.cantParseInfoPlist
        }
        ipaDescription.infoPlist = InfoPlist.make(propertyList: appPropertyList)
        
        // Get icon image
        if let iconName = mainIconNameForApp(propertyList: appPropertyList),
           let iconData = extractImage(from: file, imageName: iconName) {
            let file = Base64File(data: iconData, name: "\(iconName).png", type: "image/png")
            ipaDescription.icon = file
        }
        
        // Get Effective Entitlements
//        let execName = appPropertyList["CFBundleExecutable"] as! String
//        extractExecutableFile(ipaPath: file, tempDir: tempDirFolder, execName: execName)
//        if let codesignEntitlementsData = codesignEntitlementsDataFromApp(tempDir: tempDirFolder, execName: execName) {
//            let _ = try PropertyListSerialization
//                .propertyList(from: codesignEntitlementsData, options: [], format: nil)
//        }
        
        // Get Provisioning and certificates info
        if let mobileProvosion = try decodeProvisionDataFromFile(tempDir: tempDirFolder) {
            var provisioning = Provisioning(mobileProvosion: mobileProvosion)
            let certificates = getCertificatesInfo(mobileProvosion.developerCertificates)
            provisioning.developerCertificates = certificates
            ipaDescription.provisioningProfile = provisioning
        }
        
        // Json output
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try encoder.encode(ipaDescription)
        print(String(data: jsonData, encoding: .utf8)!)
    }
    
    
    // MARK: - Private methods
    
    private func createTempDir() throws -> String {
        let path = (NSTemporaryDirectory() as NSString).appendingPathComponent("ipa-parser/\(UUID().uuidString)")
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        return path
    }
    
    private func deleteTempDir(at path: String) throws {
        try FileManager.default.removeItem(atPath: path)
    }
    
    private func extractInfoAndProvisionFiles(ipaPath: String, tempDir: String) {
        let unzipTask = Process()
        unzipTask.launchPath = "/usr/bin/unzip"
        unzipTask.arguments = ["-u", "-j", "-q", "-d",
                               tempDir, ipaPath,
                               "Payload/*.app/embedded.mobileprovision",
                               "Payload/*.app/Info.plist"]
        unzipTask.launch()
        unzipTask.waitUntilExit()
    }
    
    private func extractExecutableFile(ipaPath: String, tempDir: String, execName: String) {
        let execPath = ("Payload/*.app/" as NSString).appendingPathComponent(execName)
        let unzipTask = Process()
        unzipTask.launchPath = "/usr/bin/unzip"
        unzipTask.arguments = ["-u", "-j", "-q", "-d",
                               tempDir, ipaPath,
                               execPath]
        unzipTask.launch()
        unzipTask.waitUntilExit()
    }
    
    private func codesignEntitlementsDataFromApp(tempDir: String, execName: String) -> Data? {
        let binaryPath = (tempDir as NSString).appendingPathComponent(execName)
        let codesignTask = Process()
        codesignTask.launchPath = "/usr/bin/codesign"
        codesignTask.standardOutput = Pipe()
        codesignTask.arguments = ["-d", binaryPath, "--entitlements", ":-"]
        codesignTask.launch()
        
        guard let pipe = codesignTask.standardOutput as? Pipe else { return nil }
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        codesignTask.waitUntilExit()
        return data
    }
    
    private func decodeProvisionDataFromFile(tempDir: String) throws -> MobileProvision? {
        let path = (tempDir as NSString).appendingPathComponent("embedded.mobileprovision")
        let url = URL(fileURLWithPath: path)
        let mobileprovisionData = try Data(contentsOf: url)
        
        var decoderRef: CMSDecoder?
        CMSDecoderCreate(&decoderRef)
        guard let decoder = decoderRef else { return nil }
        mobileprovisionData.withUnsafeBytes { (buffer: UnsafeRawBufferPointer) -> Void in
            guard let baseAddress = buffer.baseAddress else { return }
            CMSDecoderUpdateMessage(decoder, baseAddress, buffer.count)
        }
        CMSDecoderFinalizeMessage(decoder)
        var dataRef: CFData?
        CMSDecoderCopyContent(decoder, &dataRef)
        let _data: Data? = (dataRef as NSData?) as Data?
        guard let decodedData = _data, decodedData.count > 0 else { return nil }
        
        return try PropertyListDecoder().decode(MobileProvision.self, from: decodedData)
    }
    
    private func getCertificatesInfo(_ certsData: [Data]) -> [Certificate] {
        var certificates = [Certificate]()
        for certData in certsData {
            guard let certificateRef = SecCertificateCreateWithData(nil, certData as CFData) else { return [] }
            guard let summary = (SecCertificateCopySubjectSummary(certificateRef) as String?) else { return [] }
            var cert = Certificate(summary: summary)
            
            var error: Unmanaged<CFError>?
            if let dict = (SecCertificateCopyValues(
                            certificateRef,
                            [kSecOIDX509V1SubjectName, "Expired"] as CFArray,
                            &error) as NSDictionary?) {
                
                // Find organization name
                if let subject = (dict[kSecOIDX509V1SubjectName] as? NSDictionary)?[kSecPropertyKeyValue] as? NSArray {
                    for item in subject {
                        let valueDict = item as! NSDictionary
                        if (valueDict[kSecPropertyKeyLabel] as! CFString) == kSecOIDOrganizationName {
                            let organizationName = valueDict[kSecPropertyKeyValue] as! String
                            cert.organizationName = organizationName
                            break
                        }
                    }
                }
                
                // Find Expiration date
                if let expired = (dict["Expired"] as? NSDictionary)?[kSecPropertyKeyValue] as? Date {
                    cert.expirationDate = expired
                }
            }
            certificates.append(cert)
        }
        return certificates
    }
    
    private func extractImage(from file: String, imageName: String) -> Data? {
        // get the embedded icon from an app arcive using: unzip -p <URL> 'Payload/*.app/<fileName>' (piped to standard output)
        let unzipTask = Process()
        unzipTask.launchPath = "/usr/bin/unzip"
        unzipTask.standardOutput = Pipe()
        unzipTask.arguments = ["-p", file, "Payload/*.app/\(imageName)*"]
        unzipTask.launch()
        if let pipe = unzipTask.standardOutput as? Pipe {
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            unzipTask.waitUntilExit()
            return data
        }
        return nil
    }
    
    private func mainIconNameForApp(propertyList: [AnyHashable : Any]) -> String? {
        var icons: [AnyHashable : Any]? = nil
        icons = propertyList["CFBundleIcons"] as? [AnyHashable : Any]
        if icons == nil {
            icons = propertyList["CFBundleIcons~ipad"] as? [AnyHashable : Any]
        }
        let primaryIconDict = icons?["CFBundlePrimaryIcon"] as? [AnyHashable : Any]
        guard let iconFiles = primaryIconDict?["CFBundleIconFiles"] as? [String] else { return nil }
        
        // Search some patterns for primary app icon (120x120)
        let matches = ["120", "60"]
        for match in matches {
            let results = iconFiles.filter { $0.hasSuffix(match) }
            if results.count != 0 {
                return results.first
            }
        }
        
        //If no one matches any pattern, just take last item
        return iconFiles.last
    }
    
}
