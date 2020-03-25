//
//  IosFileEditor.swift
//  VersionBumper
//
//  Created by Damiano Giusti on 25/03/2020.
//  Copyright © 2020 Damiano Giusti. All rights reserved.
//

import Foundation

private let kVersionNameRegex = "<key>CFBundleShortVersionString<\\/key>[\\s]+<string>([\\w\\d\\.,]+)<\\/string>"
private let kVersionNumberRegex = "<key>CFBundleVersion<\\/key>[\\s]+<string>([\\d]+)<\\/string>"

class IosFileEditor: FileEditor {
    
    static let versionCodeRegex = try! NSRegularExpression(pattern: kVersionNumberRegex)
    static let versionNameRegex = try! NSRegularExpression(pattern: kVersionNameRegex)
    
    init(url: URL, contents: String, writeDelegate: FileWriter) {
        self.url = url
        self.contents = contents
        self.writeDelegate = writeDelegate
    }

    func readVersionName() -> String {
        if let versionName = parsedPlist["CFBundleShortVersionString"] as? String {
            return versionName
        } else {
            fatalError("Error reading CFBundleShortVersionString from Info.plist")
        }
    }
    
    func readVersionNumber() -> Int {
        if let versionNumber = (parsedPlist["CFBundleVersion"] as? String).flatMap(Int.init) {
            return versionNumber
        } else {
            fatalError("Error reading CFBundleVersion from Info.plist")
        }
    }
    
    func write(replacingOldVersion name: String, with newName: String, oldCode code: Int, with newCode: Int) {
        writeDelegate.write(replacingOldVersion: name, with: newName, oldCode: code, with: newCode)
    }
    
    // MARK: Private methods
    
    private func plist(from string: String) -> [String: Any] {
        var format = PropertyListSerialization.PropertyListFormat.xml
        if let data = contents.data(using: .isoLatin1) {
            do {
                return try PropertyListSerialization.propertyList(
                    from: data,
                    options: .mutableContainersAndLeaves,
                    format: &format
                ) as! [String : Any]
            } catch {
                fatalError(error.localizedDescription)
            }
        } else {
            fatalError("Error getting data from iOS Info.plist")
        }
    }
    
    // MARK: Private properties
    
    private let url: URL
    private let contents: String
    private let writeDelegate: FileWriter
    
    private lazy var parsedPlist: [String: Any] = plist(from: contents)
}
