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
