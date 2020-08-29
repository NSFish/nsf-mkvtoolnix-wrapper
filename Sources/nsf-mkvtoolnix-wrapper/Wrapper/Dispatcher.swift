//
//  Dispatcher.swift
//  nsf-mkvtoolnix-wrapper
//
//  Created by nsfish on 2020/8/25.
//

import Foundation


class Dispatcher {
    
    class func deal(directoryURL: URL,
                    operation: MKVTask.Operation,
                    target: MKV.Target,
                    language: MKV.Language?,
                    id: String?,
                    name: String?,
                    options:[MKVTask.Option] = [MKVTask.Option]()) throws {
        setCurrentDirectoryURL(directoryURL)
        
        let files = try detectMKVFilesIn(directory: directoryURL)
        if (files.count == 0) {
            // 在指定目录下没找到 mkv 文件
            throw NSFMKVError.dummy
        }
        
        // 标题只能 query 和 modify
        if target == .title {
            
        }
        else if target.isTrack() {
            let trackType = MKV.TrackType.init(rawValue: target.rawValue)
            
            switch operation {
            case .query:
                print("")
            case .extract:
                try extractAllTracks(among: files, type: trackType)
            case .modify:
                print("")
            case .remove:
                try removeAllTracks(among: files, type: trackType)
            }
        }
        else {
            switch operation {
            case .query:
                print("")
            case .extract:
                print("")
            case .modify:
                print("")
            case .remove:
                print("")
                if target == .attachments {
                    try removeAllAttachments(among: files)
                }
            }
        }
        
        setCurrentDirectoryURL(nil)
    }
}

// Track - Extract
private extension Dispatcher {
    
    class func extractAllTracks(among files: [URL], type: MKV.TrackType) throws {
        try files.forEach { url in
            try MKVExtract.shared.extractAllTracksFromFile(at: url, type: type)
        }
    }
}

// Track - Remove
private extension Dispatcher {
    
    class func removeAllAttachments(among files: [URL]) throws {
        try files.forEach { url in
            try MKVMerge.shared.removeAllAttachmentsFromFile(at: url)
        }
    }
    
    class func removeAllTracks(among files: [URL], type: MKV.TrackType) throws {
        try files.forEach { url in
            try MKVMerge.shared.removeAllTracksFromFile(at: url, type: type)
        }
    }
}

// Helper
private extension Dispatcher {
    
    class func setCurrentDirectoryURL(_ url: URL?) {
        MKVInfo.shared.currentDirectoryURL = url
        MKVMerge.shared.currentDirectoryURL = url
        MKVExtract.shared.currentDirectoryURL = url
    }
    
    class func detectMKVFilesIn(directory: URL) throws -> [URL] {
        let items = try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: .none, options: .skipsHiddenFiles)
        let mkvFiles = items.filter({ $0.pathExtension.lowercased() == "mkv" })
            .sorted { (url1, url2) -> Bool in
                return url1.lastPathComponent < url2.lastPathComponent
        }
        
        return mkvFiles
    }
}
