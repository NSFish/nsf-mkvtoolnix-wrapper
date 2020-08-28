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
        else {
            let trackType = MKV.TrackType.init(rawValue: target.rawValue)

            switch operation {
            case .query:
                print("")
                
                //            if option == .onlyUndefined {
                //                try showFilesThatOnlyContainsLanguageUndefinedTracks(among: files, type: type)
                //            }
                //            else {
                //                try showTracks(among: files, type: type)
            //            }
            case .extract:
                try extractAllTracks(among: files, type: trackType)
            case .modify:
                print("")
                //            guard let language = language else {
                //                throw NSFMKVError.dummy
                //            }
                //
                //            if let name = name {
                //                try modifyTrackName(among: files, type: type, language: language, name: name)
                //            }
                //            else {
                //                try setLanguageForUndefinedTracks(among: files, type: type, language: language)
            //            }
            case .remove:
                try removeAllTracks(among: files, type: trackType)
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
        let mkvFiles = items.filter { url -> Bool in
            return url.pathExtension.lowercased() == "mkv"
        }
        
        return mkvFiles
    }
}
