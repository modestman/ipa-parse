//
//  IpaInfoPlist.swift
//  ipa-parseTests
//
//  Created by Anton Glezman on 01/05/2019.
//

import Foundation

struct IpaInfoPlist {
    
    static let plist = """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>BuildMachineOSBuild</key>
    <string>16F73</string>
    <key>CFBundleDevelopmentRegion</key>
    <string>en_US</string>
    <key>CFBundleDisplayName</key>
    <string>4Bets</string>
    <key>CFBundleExecutable</key>
    <string>Bets</string>
    <key>CFBundleIcons</key>
    <dict>
        <key>CFBundlePrimaryIcon</key>
        <dict>
            <key>CFBundleIconFiles</key>
            <array>
                <string>AppIcon29x29</string>
                <string>AppIcon40x40</string>
                <string>AppIcon60x60</string>
            </array>
        </dict>
    </dict>
    <key>CFBundleIdentifier</key>
    <string>com.globus-ltd.Bets</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>Bets</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.1</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>CFBundleSupportedPlatforms</key>
    <array>
        <string>iPhoneOS</string>
    </array>
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLName</key>
            <string>vk5399781</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>vk5399781</string>
            </array>
        </dict>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLName</key>
            <string>fb1100377833359496</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>fb1100377833359496</string>
            </array>
        </dict>
    </array>
    <key>CFBundleVersion</key>
    <string>60</string>
    <key>DTCompiler</key>
    <string>com.apple.compilers.llvm.clang.1_0</string>
    <key>DTPlatformBuild</key>
    <string>14C89</string>
    <key>DTPlatformName</key>
    <string>iphoneos</string>
    <key>DTPlatformVersion</key>
    <string>10.2</string>
    <key>DTSDKBuild</key>
    <string>14C89</string>
    <key>DTSDKName</key>
    <string>iphoneos10.2</string>
    <key>DTXcode</key>
    <string>0821</string>
    <key>DTXcodeBuild</key>
    <string>8C1002</string>
    <key>Fabric</key>
    <dict>
        <key>APIKey</key>
        <string>fd04a0cd9aee61c66ddbad316c2832390476a7f5</string>
        <key>Kits</key>
        <array>
            <dict>
                <key>KitInfo</key>
                <dict/>
                <key>KitName</key>
                <string>Crashlytics</string>
            </dict>
        </array>
    </dict>
    <key>FacebookAppID</key>
    <string>1100377833359496</string>
    <key>FacebookDisplayName</key>
    <string>4Bets</string>
    <key>ITSAppUsesNonExemptEncryption</key>
    <false/>
    <key>LSApplicationQueriesSchemes</key>
    <array>
        <string>vk</string>
        <string>vk-share</string>
        <string>vkauthorize</string>
        <string>fbapi</string>
        <string>fb-messenger-api</string>
        <string>fbauth2</string>
        <string>fbshareextension</string>
    </array>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>MinimumOSVersion</key>
    <string>8.0</string>
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
        <key>NSExceptionDomains</key>
        <dict>
            <key>vk.com</key>
            <dict>
                <key>NSExceptionAllowsInsecureHTTPLoads</key>
                <true/>
                <key>NSExceptionRequiresForwardSecrecy</key>
                <false/>
                <key>NSIncludesSubdomains</key>
                <true/>
            </dict>
        </dict>
    </dict>
    <key>NSCameraUsageDescription</key>
    <string>Ваши фото не будут переданы третим лицам и используются только как аватар</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>Ваши фото не будут переданы третим лицам и используются только как аватар</string>
    <key>UIDeviceFamily</key>
    <array>
        <integer>1</integer>
    </array>
    <key>UILaunchStoryboardName</key>
    <string>LaunchScreen</string>
    <key>UIMainStoryboardFile</key>
    <string>Main</string>
    <key>UIRequiredDeviceCapabilities</key>
    <array>
        <string>armv7</string>
    </array>
    <key>UIStatusBarTintParameters</key>
    <dict>
        <key>UINavigationBar</key>
        <dict>
            <key>Style</key>
            <string>UIBarStyleBlack</string>
            <key>Translucent</key>
            <false/>
        </dict>
    </dict>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
    </array>
    <key>UIViewControllerBasedStatusBarAppearance</key>
    <false/>
</dict>
</plist>
"""
    
    static var appPropertyList: [AnyHashable: Any] {
        let data = plist.data(using: .utf8)!
        return try! PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [AnyHashable : Any]
    }
    
}