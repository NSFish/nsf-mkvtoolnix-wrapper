//
//  MKV.swift
//  nsf-mkvtoolnix-wrapper
//
//  Created by nsfish on 2020/8/25.
//

import Foundation
import ArgumentParser

class MKV {
    
    // title
    // track:
    //    - video
    //    - audio
    //    - subtitles
    // chapters
    // attachments
    // tags
    enum Target: String, CaseIterable {
        case title
        case video
        case audio
        case subtitles
        case chapter
        case tag
        case attachments
        case unsupported
        
        var humanReadable: String {
            switch self {
            case .title: return "标题"
            case .video: return "视频"
            case .audio: return "音轨"
            case .subtitles: return "字幕"
            case .chapter: return "章节"
            case .tag: return "标签"
            case .attachments: return "附件"
            case .unsupported: return "尚不支持的 target"}
        }
        
        func isTrack() -> Bool {
            return self == .video
            || self == .audio
            || self == .subtitles
        }
    }
    
    enum TrackType: String, CaseIterable {
        case video
        case audio
        case subtitles
        case unknown
        
        var humanReadable: String {
            switch self {
            case .video: return "视频"
            case .audio: return "音轨"
            case .subtitles: return "字幕"
            case .unknown: return "未知 track"}
        }
    }
    
    enum Language: String, CaseIterable {
        case jpn
        case eng
        case rus
        case undefined
        
        var humanReadable: String {
            switch self {
            case .jpn: return "日语"
            case .eng: return "英语"
            case .rus: return "俄语"
            case .undefined: return "未知"}
        }
    }
    
    class Track {
        // 目前主要是为了标记 mkvinfo 中获取的字幕文件类型
        // 以便于使用 mkvextract 时输入相应的扩展名
        enum ContentType: String {
            case `default`
            case srt = "utf8"
            case ssa
            case ass
            
            var humanReadable: String {
                switch self {
                case .`default`: return "default"
                case .srt: return "srt"
                case .ssa: return "ssa"
                case .ass: return "ass"}
            }
        }
        
        let id: String
        let type: TrackType
        let language: Language
        let contentType: ContentType
        let name: String
        
        init(id: String, type: String, language: String, contentType: String, name: String) {
            self.id = id
            self.type = TrackType.init(rawValue: type)
            self.language = Language.init(rawValue: language)
            self.contentType = ContentType.init(rawValue: contentType.lowercased())
            self.name = name
        }
    }
    
    class Attachment {
        
        let id: String
        let fileName: String
        let MIMEType: String
        
        init(id: String, fileName: String, MIMEType: String) {
            self.id = id
            self.fileName = fileName
            self.MIMEType = MIMEType
        }
    }
}

// https://www.latenightswift.com/2019/02/04/unknown-enum-cases/
extension MKV.TrackType: Codable {}
extension MKV.TrackType: UnknownCaseRepresentable {
    static let unknownCase: MKV.TrackType = .unknown
}

extension MKV.Language: Codable {}
extension MKV.Language: UnknownCaseRepresentable {
    static let unknownCase: MKV.Language = .undefined
}

extension MKV.Track.ContentType: Codable {}
extension MKV.Track.ContentType: UnknownCaseRepresentable {
    static let unknownCase: MKV.Track.ContentType = .default
}
