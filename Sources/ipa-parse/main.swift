import IpaParserLib
import Foundation

if CommandLine.arguments.count > 1 {
    do {
        let parser = IpaParser(file: arguments[1])
        try parser.run()
    } catch let e as ParserErrors {
        print(e.localizedDescription)
        exit(-1)
    } catch let e as NSError {
        print(e.localizedDescription)
        exit(Int32(e.code))
    }
} else {
    // print help
}
