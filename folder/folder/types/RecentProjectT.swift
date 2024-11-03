//
//  RecentProjectT.swift
//  folder
//
//  Created by Gokula Krishnan R on 22/04/24.
//

import Foundation

//// MARK: - RecentProjectT
//struct RecentProjectT: Codable {
//    let recentProject: [RecentProject]
//
//    enum CodingKeys: String, CodingKey {
//        case recentProject = "recent_project"
//    }
//}
//
//// MARK: - RecentProject
//struct RecentProject: Codable {
//    let id, label: String
//    let submenu: Submenu
//}
//
//// MARK: - Submenu
//struct Submenu: Codable {
//    let items: [Item]
//}
//
//// MARK: - Item
//struct Item: Codable {
//    let id: String
//    let label: String?
//    let uri: URI
//    let enabled: Bool?
//}
//
//// MARK: - URI
//struct URI: Codable {
//    let mid: Int
//    let path: String
//    let scheme: Scheme
//
//    enum CodingKeys: String, CodingKey {
//        case mid = "$mid"
//        case path, scheme
//    }
//}
//
//enum Scheme: String, Codable {
//    case empty = ""
//    case file = "file"
//}


struct WorkspaceResponse: Codable {
    let workspaces: [Workspace]
}

struct Workspace: Codable, Identifiable {
    let id: Int
    let filename: String
    let language: String
    let path: String
}
