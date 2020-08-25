//
//  Hint.swift
//  nsf-mkvtoolnix-wrapper
//
//  Created by nsfish on 2020/8/25.
//

import Foundation

enum Hint {
    case startProcessing
    case pass
    
    func humanReadable(url: URL) {
        switch self {
        case .startProcessing:
            print("开始处理 " + url.lastPathComponent + "...")
        case .pass:
            print("无须处理 " + url.lastPathComponent + ", 跳过.")
        }
    }
}
