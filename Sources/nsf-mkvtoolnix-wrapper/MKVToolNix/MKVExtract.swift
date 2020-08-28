//
//  MKVExtract.swift
//  nsf-mkvtoolnix-wrapper
//
//  Created by nsfish on 2020/8/28.
//

import Foundation

class MKVExtract: MKVTaskProtocol {
    
    var currentDirectoryURL: URL?
    let executableURL = URL(fileURLWithPath: "/usr/local/bin/mkvextract")
    
    static let shared = MKVExtract()
    private init(){}
    
    func extractAllTracksFromFile(at url: URL, type: MKV.TrackType) throws {
        let tracks = try MKVInfo.shared.tracksInFile(at: url, type: type)
        if tracks.count == 0 {
            Hint.pass.humanReadable(url: url)
        }
        else {
            Hint.startProcessing.humanReadable(url: url)
            
            tracks.forEach { track in
                // Todo: 如何根据 mkvinfo 提供的信息在这里标识输出文件的扩展名是个难点
                // 这里暂时只处理字幕文件
                let fileName = url.deletingPathExtension()
                    .appendingPathExtension(track.contentType.humanReadable)
                    .lastPathComponent
                // mkvextract tracks <your_mkv_video> <track_numer>:<subtitle_file.srt>
                startTask(with: executableURL,
                          arguments: ["tracks", url.path, track.id + ":" + fileName],
                          showOutput: true)
            }
        }
    }
}
