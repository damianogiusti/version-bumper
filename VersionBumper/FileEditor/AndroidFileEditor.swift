//
//  AndroidFileEditor.swift
//  VersionBumper
//
//  Created by Damiano Giusti on 25/03/2020.
//  Copyright © 2020 Damiano Giusti. All rights reserved.
//

import Foundation

private let kVersionCodeRegex = "[\\s]+versionCode[\\s]*([0-9]+)"
private let kVersionNameRegex = "[\\s]+versionName[\\s]*\"([\\w\\d\\.,]+)\""

class AndroidFileEditor: FileEditor {
    
    static let versionCodeRegex = try! NSRegularExpression(pattern: kVersionCodeRegex)
    static let versionNameRegex = try! NSRegularExpression(pattern: kVersionNameRegex)
    
    init(url: URL, contents: String, writeDelegate: FileWriter) {
        self.url = url
        self.contents = contents
        self.writeDelegate = writeDelegate
    }
    
    func readVersionName() -> String {
        if let name = Self.versionNameRegex.matches(in: contents).first?.capture(at: 1, in: contents) {
            return name.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            fatalError("Error reading versionName from build.gradle")
        }
    }
    
    func readVersionNumber() -> Int {
        if let rawNumber = Self.versionCodeRegex.matches(in: contents).first?.capture(at: 1, in: contents),
            let number = Int(rawNumber.trimmingCharacters(in: .whitespacesAndNewlines)) {
            return number
        } else {
            fatalError("Error reading versionCode from build.gradle")
        }
    }
    
    func write(replacingOldVersion name: String, with newName: String, oldCode code: Int, with newCode: Int) {
        writeDelegate.write(replacingOldVersion: name, with: newName, oldCode: code, with: newCode)
    }
    
    // MARK: Private properties
    
    private let url: URL
    private let contents: String
    private let writeDelegate: FileWriter
}
