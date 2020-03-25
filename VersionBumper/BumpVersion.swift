//
//  BumpVersion.swift
//  VersionBumper
//
//  Created by Damiano Giusti on 25/03/2020.
//  Copyright © 2020 Damiano Giusti. All rights reserved.
//

import Foundation

typealias BumpVersionOperation = (URL, String) -> ()

func BumpVersion(
    fileEditor: FileEditor
) -> BumpVersionOperation {
    return { url, newVersionName in
        let oldVersionName = fileEditor.readVersionName()
        let oldVersionNumber = fileEditor.readVersionNumber()
        let newVersionNumber = oldVersionNumber + 1
        print("Upgrading from version \(oldVersionName) (\(oldVersionNumber)) " +
              "to version \(newVersionName) (\(newVersionNumber))")
        fileEditor.write(
            replacingOldVersion: oldVersionName,
            with: newVersionName,
            oldCode: oldVersionNumber,
            with: newVersionNumber
        )
    }
}
