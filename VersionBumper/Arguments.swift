//
//  Arguments.swift
//  VersionBumper
//
//  Created by Damiano Giusti on 25/03/2020.
//  Copyright © 2020 Damiano Giusti. All rights reserved.
//

import Foundation

enum ArgumentKey: CaseIterable {
    case directory
    case newVersionName
    case help
    
    var key: String {
        switch self {
        case .directory: return "-d"
        case .newVersionName: return "-n"
        case .help: return "-h"
        }
    }
    
    var shortDescription: String {
        switch self {
        case .directory:
            return "The directory path in which search the files to bump"
        case .newVersionName:
            return "The new version name to apply"
        case .help:
            return "Shows the help manual"
        }
    }
}

class Arguments {
    private let args: [String: String]
    
    private init(_ args: [String: String]) {
        self.args = args
    }
    
    var directory: String {
        if let dir = args[ArgumentKey.directory.key] { return dir }
        else { fatalError("Missing directory argument \(ArgumentKey.directory.key)") }
    }
    
    var versionName: String {
        if let name = args[ArgumentKey.newVersionName.key] { return name }
        else { fatalError("Missing new version name argument \(ArgumentKey.newVersionName.key)") }
    }
    
    var showHelp: Bool {
        args[ArgumentKey.help.key] != nil
    }
    
    static func parse(args: [String]) -> Arguments {
        let args = Array(args.dropFirst())
        if args.contains(ArgumentKey.help.key) {
            return Arguments([ArgumentKey.help.key: ""])
        } else if args.count % 2 == 0 {
            var _arguments: [String: String] = [:]
            for i in stride(from: 0, to: args.count, by: 2) {
                _arguments[args[i]] = args[i + 1]
            }
            return Arguments(_arguments)
        } else {
            fatalError("Invalid argument count provided")
        }
    }
    
    static let help: String = {
"""
 ##     ## ######## ########   ######  ####  #######  ##    ##
 ##     ## ##       ##     ## ##    ##  ##  ##     ## ###   ##
 ##     ## ##       ##     ## ##        ##  ##     ## ####  ##
 ##     ## ######   ########   ######   ##  ##     ## ## ## ##
  ##   ##  ##       ##   ##         ##  ##  ##     ## ##  ####
   ## ##   ##       ##    ##  ##    ##  ##  ##     ## ##   ###
    ###    ######## ##     ##  ######  ####  #######  ##    ##
       ########  ##     ## ##     ## ########  ######## ########
       ##     ## ##     ## ###   ### ##     ## ##       ##     ##
       ##     ## ##     ## #### #### ##     ## ##       ##     ##
       ########  ##     ## ## ### ## ########  ######   ########
       ##     ## ##     ## ##     ## ##        ##       ##   ##
       ##     ## ##     ## ##     ## ##        ##       ##    ##
       ########   #######  ##     ## ##        ######## ##     ##
""" + "\n\n" +
        "Welcome to the Version Bumper by Damiano Giusti!" + "\n" +
        "This CLI runs only on macOS. But that's none of your business " +
        "since you're reading this!" + "\n\n" +
        "Here you have the main parameters with a short description:" + "\n\n" +
        ArgumentKey.allCases.map { "\($0.key)\t\($0.shortDescription)" }.joined(separator: "\n")
    }()
}
