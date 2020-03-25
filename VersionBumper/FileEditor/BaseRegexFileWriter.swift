//
//  BaseRegexFileWriter.swift
//  VersionBumper
//
//  Created by Damiano Giusti on 25/03/2020.
//  Copyright © 2020 Damiano Giusti. All rights reserved.
//

import Foundation

class BaseRegexFileWriter: FileWriter {
    let versionNameRegex: NSRegularExpression
    let versionNumberRegex: NSRegularExpression
    let url: URL
    let contents: String
    
    init(
        url: URL, contents: String,
        versionNameRegex: NSRegularExpression,
        versionNumberRegex: NSRegularExpression
    ) {
        self.url = url
        self.contents = contents
        self.versionNameRegex = versionNameRegex
        self.versionNumberRegex = versionNumberRegex
    }
    
    func write(
        replacingOldVersion name: String,
        with newName: String,
        oldCode code: Int,
        with newCode: Int
    ) {
        if let nameMatch = versionNameRegex.matches(in: contents).first?.capture(at: 0, in: contents),
            let numberMatch = versionNumberRegex.matches(in: contents).first?.capture(at: 0, in: contents) {
            let newNameMatch = nameMatch.replacingOccurrences(
                of: name, with: newName
            )
            let newNumberMatch = numberMatch.replacingOccurrences(
                of: String(code), with: String(newCode)
            )
            
            try! contents
                .replacingOccurrences(of: nameMatch, with: newNameMatch)
                .replacingOccurrences(of: numberMatch, with: newNumberMatch)
                .write(to: url, atomically: true, encoding: .utf8)
        } else {
            fatalError("Cannot update version in file \(url)")
        }
    }
}
