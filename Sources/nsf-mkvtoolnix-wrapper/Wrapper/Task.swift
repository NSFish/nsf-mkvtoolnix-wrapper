//
//  Task.swift
//  nsf-mkvtoolnix-wrapper
//
//  Created by nsfish on 2020/8/25.
//

import Foundation

protocol MKVTaskProtocol {
            
    var currentDirectoryURL: URL? { get set}
    var executableURL: URL { get }
}

extension MKVTaskProtocol {
    
    @discardableResult func startTask(with executableURL: URL,
                                      arguments: [String],
                                      showOutput: Bool = false) -> [String] {
        let task = Process()
        if #available(OSX 10.13, *) {
            task.currentDirectoryURL = currentDirectoryURL
            task.executableURL = executableURL
        }
        task.arguments = arguments
        
        let outputPipe = Pipe()
        if !showOutput {
            task.standardOutput = outputPipe
        }
        
        // 防止在 Console 中输出 error log
        task.standardError = Pipe()
        
        task.launch()
        
        var output = [String]()
        if !showOutput {
            // https://stackoverflow.com/a/29519615
            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            if var string = String(data: outputData, encoding: .utf8) {
                string = string.trimmingCharacters(in: .newlines)
                output = string.components(separatedBy: "\n")
            }
        }
        
        task.waitUntilExit()
        
        //        let status = task.terminationStatus
        
        return output
    }
}

final class MKVTask {
    
    enum Operation {
        case query
        case extract
        case modify
        case remove
    }

    enum Option: String {
        case all = "--all"
        case undefined = "--undefined"
        case none
    }
}
