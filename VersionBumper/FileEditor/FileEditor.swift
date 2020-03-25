//
//  FileEditor.swift
//  VersionBumper
//
//  Created by Damiano Giusti on 25/03/2020.
//  Copyright © 2020 Damiano Giusti. All rights reserved.
//

import Foundation

// MARK: - Protocols

protocol FileReader {
    func readVersionName() -> String
    func readVersionNumber() -> Int
}

protocol FileWriter {
    func write(
        replacingOldVersion name: String,
        with newName: String,
        oldCode code: Int,
        with newCode: Int
    )
}

typealias FileEditor = FileReader & FileWriter

// MARK: - Factory

func makeFileEditor(from fileUrl: URL) -> FileEditor? {
    if fileUrl.lastPathComponent == "build.gradle" &&
        !fileUrl.pathComponents.contains("build") {
        if let contents = fileUrl.contentsOrNil(),
                contents.contains("android") &&
                contents.contains("versionCode") &&
                contents.contains("versionName") {
            return AndroidFileEditor(
                url: fileUrl,
                contents: contents,
                writeDelegate: BaseRegexFileWriter(
                    url: fileUrl, contents: contents,
                    versionNameRegex: AndroidFileEditor.versionNameRegex,
                    versionNumberRegex: AndroidFileEditor.versionCodeRegex
                )
            )
        } else {
            return nil
        }
    } else if fileUrl.lastPathComponent == "Info.plist" &&
        !fileUrl.pathComponents.contains("build") &&
        !fileUrl.pathComponents.contains("Pods") &&
        !fileUrl.absoluteString.contains(".framework") {
        if let contents = fileUrl.contentsOrNil(),
                contents.contains("CFBundleShortVersionString") &&
                contents.contains("CFBundleVersion") {
            return IosFileEditor(
                url: fileUrl,
                contents: contents,
                writeDelegate: BaseRegexFileWriter(
                    url: fileUrl,
                    contents: contents,
                    versionNameRegex: IosFileEditor.versionNameRegex,
                    versionNumberRegex: IosFileEditor.versionCodeRegex
                )
            )
        } else {
            return nil
        }
    } else {
        return nil
    }
}
