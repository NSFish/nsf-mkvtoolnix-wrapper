//
//  MKVMerge.swift
//  nsf-mkvtoolnix-wrapper
//
//  Created by nsfish on 2020/8/25.
//

import Foundation

class MKVMerge: MKVTaskProtocol {
    
    var currentDirectoryURL: URL?
    var executableURL = URL(fileURLWithPath: "/usr/local/bin/mkvmerge")
    
    static let shared = MKVMerge()
    private init(){}
}

extension MKVMerge {
    
    func removeAllAttachmentsFromFile(at url: URL) throws {
        let attachments = try attachmentsInFile(at: url)
        if attachments.count == 0 {
            Hint.pass.humanReadable(url: url)
        }
        else {
            let flag = "--no-attachments"

            Hint.startProcessing.humanReadable(url: url)
            try executeTask(with: url, arguments: [flag], showOutput: true)
        }
    }

    func removeAllTracksFromFile(at url: URL, type: MKV.TrackType) throws {
        let unknownFlag = ""
        let flag: String = {
            switch type {
            case .video: return "--no-video"
            case .audio: return "--no-audio"
            case .subtitles: return "--no-subtitles"
            case .unknown: return unknownFlag
            }
        }()
        
        guard flag != unknownFlag else {
            throw NSFMKVError.dummy
        }
        
        let tracks = try MKVInfo.shared.tracksInFile(at: url, type: type)
        if tracks.count == 0 {
            Hint.pass.humanReadable(url: url)
        }
        else {
            Hint.startProcessing.humanReadable(url: url)
            try executeTask(with: url, arguments: [flag], showOutput: true)
        }
    }
}

// Private
private extension MKVMerge {
    
    func attachmentsInFile(at url: URL) throws -> [MKV.Attachment] {
        let fileName = url.lastPathComponent
        let output = startTask(with: executableURL, arguments: ["-i", fileName])

        var attachments = [MKV.Attachment]()
        output.forEach { line in
            if line.contains("Attachment ID") {
                let attachmentID = line.components(separatedBy: "Attachment ID ")
                    .last!.components(separatedBy: ": type").first!
                let MIMEType = line.components(separatedBy: "type '").last!.components(separatedBy: "', size").first!
                let fileName = line.components(separatedBy: "file name '").last!
                    .replacingOccurrences(of: "'", with: "")
                
                let attachment = MKV.Attachment.init(id: attachmentID,
                                                     fileName: fileName,
                                                     MIMEType: MIMEType)
                attachments.append(attachment)
            }
        }
        
        return attachments
    }
    
    func executeTask(with fileURL: URL,
                     arguments: [String],
                     showOutput: Bool = false) throws {
        let fileName = fileURL.lastPathComponent
        let newFileName = fileURL.deletingPathExtension().lastPathComponent + "_temp" + ".mkv"
        
        startTask(with: executableURL,
                  arguments: ["-o", newFileName] + arguments + [fileName],
                  showOutput: showOutput)
        
        // TODO: let dirURL = file.deletingLastPathComponent() 为什么不行？
        let dirURL = URL.init(fileURLWithPath: fileURL.deletingLastPathComponent().path)
        let newFileURL = dirURL.appendingPathComponent(newFileName)
        try FileManager.default.removeItem(at: fileURL)
        try FileManager.default.moveItem(at: newFileURL, to: fileURL)
    }
}
