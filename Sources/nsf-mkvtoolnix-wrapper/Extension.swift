//
//  Extension.swift
//  nsf-mkvtoolnix-wrapper
//
//  Created by nsfish on 2020/8/25.
//

import Foundation

// https://www.latenightswift.com/2019/02/04/unknown-enum-cases/
protocol UnknownCaseRepresentable: RawRepresentable, CaseIterable where RawValue: Equatable {
    static var unknownCase: Self { get }
}

extension UnknownCaseRepresentable {
    init(rawValue: RawValue) {
        let value = Self.allCases.first(where: { $0.rawValue == rawValue })
        self = value ?? Self.unknownCase
    }
}
