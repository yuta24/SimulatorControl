//
//  App.swift
//  SimulatorControl
//
//  Created by Yu Tawata on 2020/02/09.
//  Copyright © 2020 Yu Tawata. All rights reserved.
//

import Foundation

struct App: Decodable {
    enum ApplicationType: String, Decodable {
        case system = "System"
        case user = "User"
    }

    enum CodingKeys: String, CodingKey {
        case applicationType = "ApplicationType"
        case bundle
        case bundleContainer = "BundleContainer"
        case bundleDisplayName = "CFBundleDisplayName"
        case bundleExecutable = "CFBundleExecutable"
        case bundleIdentifier = "CFBundleIdentifier"
        case bundleName = "CFBundleName"
        case bundleVersion = "CFBundleVersion"
        case dataContainer = "DataContainer"
        case groupContainers = "GroupContainers"
        case path = "Path"
    }

    let applicationType: ApplicationType
    let bundle: String?
    let bundleContainer: String?
    let bundleDisplayName: String
    let bundleExecutable: String
    let bundleIdentifier: String
    let bundleName: String
    let bundleVersion: String
    let dataContainer: String?
    let groupContainers: [String: String]
    let path: String
}
