//
//  main.swift
//  VersionBumper
//
//  Created by Damiano Giusti on 25/03/2020.
//  Copyright © 2020 Damiano Giusti. All rights reserved.
//

import Foundation

func process(
    fileAt url: URL,
    changingVersionTo versionName: String,
    with fileEditor: FileEditor
) {
    let bumpVersionOperation = BumpVersion(fileEditor: fileEditor)
    bumpVersionOperation(url, versionName)
}

let arguments = Arguments.parse(args: CommandLine.arguments)

if (arguments.showHelp) {
    print(Arguments.help)
} else {
    let fileManager = FileManager.default
    var isDirectory: ObjCBool = false
    fileManager.fileExists(atPath: arguments.directory, isDirectory: &isDirectory)

    guard isDirectory.boolValue else {
        fatalError("Provided path does not point to a directory \(arguments.directory)")
    }

    let enumeratorKeys: [URLResourceKey] = [.pathKey, .isDirectoryKey]
    let filesEnumerator = fileManager.enumerator(
        at: URL(string: arguments.directory)!,
        includingPropertiesForKeys: enumeratorKeys
    )

    filesEnumerator?.forEach { file in
        if let url = file as? URL,
            let resourceValues = try? url.resourceValues(forKeys: Set(enumeratorKeys)),
            resourceValues.isDirectory == false,
            let fileEditor = makeFileEditor(from: url) {
            process(fileAt: url, changingVersionTo: arguments.versionName, with: fileEditor)
        }
    }
}

print("\nkthxbye")
