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
    // fonts
    // tags
    enum Target: String, CaseIterable {
        case title
        case video
        case audio
        case subtitles
        case chapter
        case tag
        case font
        case unsupported
        
        var humanReadable: String {
            switch self {
            case .title: return "标题"
            case .video: return "视频"
            case .audio: return "音轨"
            case .subtitles: return "字幕"
            case .chapter: return "章节"
            case .tag: return "标签"
            case .font: return "字体"
            case .unsupported: return "尚不支持的 target"}
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
        let id: String
        let type: TrackType
        let language: Language
        
        init(id: String, type: String, language: String) {
            self.id = id
            
            self.type = TrackType.init(rawValue: type)
            self.language = Language.init(rawValue: language)
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
