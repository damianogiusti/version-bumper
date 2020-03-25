//
//  Extensions.swift
//  VersionBumper
//
//  Created by Damiano Giusti on 26/03/2020.
//  Copyright © 2020 Damiano Giusti. All rights reserved.
//

import Foundation

extension NSRegularExpression {
    
    func matches(in string: String) -> [NSTextCheckingResult] {
        self.matches(
            in: string,
            range: NSRange(location: 0, length: string.count)
        )
    }
}

extension NSTextCheckingResult {
    
    func capture(at: Int, in string: String) -> String? {
        if let stringRange = Range(range(at: at), in: string) {
            return String(string[stringRange])
        } else {
            return nil
        }
    }
}

extension URL {
    func contentsOrNil() -> String? {
        try? String(contentsOf: self, encoding: .isoLatin1)
    }
}
