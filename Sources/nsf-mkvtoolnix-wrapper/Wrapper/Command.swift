
//
//  Command.swift
//  nsf-mkvtoolnix-wrapper
//
//  Created by nsfish on 2020/8/25.
//

import Foundation
import ArgumentParser

extension MKV.Language: ExpressibleByArgument {}
extension MKV.Target: ExpressibleByArgument {}


struct NSFMKVToolNixWrapper: ParsableCommand {
    
    static var configuration = CommandConfiguration(
        // Optional abstracts and discussions are used for help output.
        abstract: "Wrapping up mkvtoolnix",
        
        // Commands can define a version for automatic '--version' support.
        version: "1.0.0",
        
        // Pass an array to `subcommands` to set up a nested tree of subcommands.
        // With language support for type-level introspection, this could be
        // provided by automatically finding nested `ParsableCommand` types.
        subcommands: [Extract.self, Remove.self])
    
    struct Options: ParsableArguments {
        @Option(help: "jpn, eng, rus, etc.")
        var language: MKV.Language?
        
        @Argument(help: "directory url", transform: { URL.init(fileURLWithPath: $0) })
        var directoryURL: URL
        
        @Flag(help: "")
        var all = false
    }
}

extension NSFMKVToolNixWrapper {
    
    struct Extract: ParsableCommand {
        @Argument(help: "")
        var target: MKV.Target = .unsupported
        
        @OptionGroup()
        var parentOptions: Options
        
        mutating func run() throws {
            try Dispatcher.deal(directoryURL: parentOptions.directoryURL,
                                operation: MKVTask.Operation.extract,
                                target: target,
                                language: parentOptions.language,
                                id: nil,
                                name: nil)
        }
    }
    
    struct Remove: ParsableCommand {
        @Argument(help: "")
        var target: MKV.Target = .unsupported
        
        @OptionGroup()
        var parentOptions: Options
        
        mutating func run() throws {
            try Dispatcher.deal(directoryURL: parentOptions.directoryURL,
                                operation: MKVTask.Operation.remove,
                                target: target,
                                language: parentOptions.language,
                                id: nil,
                                name: nil)
        }
    }
}
