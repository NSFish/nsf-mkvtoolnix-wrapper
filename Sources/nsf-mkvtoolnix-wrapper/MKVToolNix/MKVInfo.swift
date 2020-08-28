//
//  MKVInfo.swift
//  nsf-mkvtoolnix-wrapper
//
//  Created by nsfish on 2020/8/25.
//

import Foundation

class MKVInfo: MKVTaskProtocol {
    
    var currentDirectoryURL: URL?
    let executableURL = URL(fileURLWithPath: "/usr/local/bin/mkvinfo")
    
    static let shared = MKVInfo()
    private init(){}
    
    func titleOfFile(at url: URL) -> String {
        let fileName = url.lastPathComponent
        let output = startTask(with: executableURL, arguments: [fileName])
        
        let titleLine = output.first() { $0.contains("Title:") }
        
        guard let title = titleLine?.split(separator: ":").last?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return ""
        }
        
        return title
    }
    
    func tracksInFile(at url: URL, type: MKV.TrackType) throws -> [MKV.Track] {
        return try tracksInFile(at: url).filter { $0.type == type }
    }
}

// Private
private extension MKVInfo {
    
    func tracksInFile(at url: URL) throws -> [MKV.Track] {
        let fileName = url.lastPathComponent
        let output = startTask(with: executableURL, arguments: [fileName])
        
        let trackInfos = try trackInfosFrom(output: output)
        
        var tracks = [MKV.Track]()
        trackInfos.forEach { trackInfo in
            var trackID = ""
            var trackType = ""
            var trackLanguage = ""
            var trackContentType = MKV.Track.ContentType.default.rawValue

            trackInfo.forEach { line in
                if line.contains("|  + Track number:") {
                    trackID = String(line.split(separator: ":").last!.trimmingCharacters(in: CharacterSet.decimalDigits.inverted))
                }
                else if line.contains("|  + Track type:") {
                    trackType = line.split(separator: ":").last!.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                else if line.contains("|  + Language: ") {
                    trackLanguage = line.split(separator: ":").last!.trimmingCharacters(in: .whitespacesAndNewlines)
                }
                else if line.contains("|  + Codec ID:") {
                    let array = line.components(separatedBy: ": S_TEXT/")
                    if array.count > 1 {
                        trackContentType = array.last!
                    }
                }
            }
            
            let track = MKV.Track.init(id: trackID,
                                       type: trackType,
                                       language: trackLanguage,
                                       contentType: trackContentType)
            tracks.append(track)
        }
        
        return tracks
    }
    
    func trackInfosFrom(output: [String]) throws -> [[String]] {
        // 先找到 "|+ Tracks" 所在行
        // 也可能是 "| + Tracks"，不同的文件空格会不一样，不太懂
        // 暂时先只搜 "Tracks"
        guard let trackStartIndex = output.firstIndex(where: { $0.contains("Tracks")}) else {
            throw NSFMKVError.dummy
        }
        
        // 截掉 "| + Track" 所在行之前的内容，再找到 "|+ EBML void"
        var trackLines = Array(output[trackStartIndex + 1...output.count - 1])
        guard let trackEndIndex = trackLines.firstIndex(where: { $0.contains("|+ EBML void")}) else {
            throw NSFMKVError.dummy
        }
        
        trackLines = Array(trackLines[0...trackEndIndex - 1])
        
        return trackLines.split(separator: "| + Track").map { Array($0) }
    }
}
