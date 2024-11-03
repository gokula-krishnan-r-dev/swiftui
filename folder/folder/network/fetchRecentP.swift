//
//  fetchRecentP.swift
//  folder
//
//  Created by Gokula Krishnan R on 22/04/24.
//

import Foundation
class SettingFetcher: ObservableObject {
    @Published var recent_project : [Workspace]?
    @Published var workSpaces: [String: Any]?
    @Published var recentproject: [String: Any]?
    init() {
        self.fetchRecent()
        self.fetchWorkspaces()

    }
    
    func fetchWorkspaces() {
        if let jsonData = self.readJSONFile(filePath: "/Users/gokulakrishnanr/Library/Application Support/Code/User/globalStorage/storage.json") {
            self.parseJSON(jsonData: jsonData) { (result: Result<[String: Any], Error>) in
                              switch result {
                              case .success(let data):
                                let finalworkSpace =   self.populateWorkspaces(data: data)
                                  
                                  self.workSpaces = finalworkSpace
                              case .failure(let error):
                                  print(" working Error parsing JSON:", error)
                              }
                          }
                      }
    }
    
    
    func fetchRecent() {
            guard let url = URL(string: "http://localhost:8080/settings") else { return }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching data:", error.localizedDescription)
                    return
                }
                
                guard let data = data else {
                    print("No data received from the server")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    let response = try decoder.decode(WorkspaceResponse.self, from: data)
                   
                    DispatchQueue.main.async {
                        self.recent_project = response.workspaces // Update recent_project
                       
                    }
                } catch {
                    print("Error decoding JSON:", error.localizedDescription)
                    print("Error data:", error)
                    print("error data:", String(data: data, encoding: .utf8) ?? "Data could not be converted to UTF-8 string")

                }
            }.resume()
        }
    
    
    func filterFilePath(_ path: String) -> String {
        // Check if the path starts with "file://"
        if path.hasPrefix("file://") {
            // If it does, remove "file://" prefix
            var filteredPath = path.replacingOccurrences(of: "file://", with: "")
            // Replace %20 with backslashes
            filteredPath = filteredPath.replacingOccurrences(of: "%20", with: "\\")
            return filteredPath
        } else {
            // If it doesn't start with "file://", return the original path
            return path
        }
    }

    func openTerminal(at path: String) {
        let filteredPath = filterFilePath(path)
        print(filteredPath)
        let commands = [
//            "chmod +x \(filteredPath)",
//            "cd \(filteredPath)",
            "open -a 'Visual Studio Code' \(path)",
//            "cd /Library/Application Support/Code/User/globalStorage/storage.json"
        ]
        
        for command in commands {
            shell(command)
        }
                }

    func deleteProject(at path: String) {
        let filteredPath = filterFilePath(path)
        print(filteredPath)
        let commands = [
            "chmod +x \(filteredPath)",
            "cd \(filteredPath)",
//            "rm -r \(filteredPath)"
        ]
        
        for command in commands {
            shell(command)
        }
                }

    func shell(_ command: String, completion: ((String) -> Void)? = nil) {
        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.standardInput = nil
        // Launch the task asynchronously
        task.launch()
        
        // Read and print the output asynchronously
        pipe.fileHandleForReading.readabilityHandler = { pipe in
            if let output = String(data: pipe.availableData, encoding: .utf8) {
                print(output)
                completion?(output)
            }
        }
        func checkAndExecute(command: String, checkOutput: String, executeCommand: String) {
            let task = Process()
            let pipe = Pipe()
            
            task.standardOutput = pipe
            task.arguments = ["-c", command]
            task.launchPath = "/bin/zsh"
            task.launch()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)
            
            if let output = output, output.trimmingCharacters(in: .whitespacesAndNewlines) == checkOutput {
                print("Output matches the checkOutput: \(checkOutput)")
                print("Executing command: \(executeCommand)")
                let executeTask = Process()
                executeTask.launchPath = "/bin/zsh"
                executeTask.arguments = ["-c", executeCommand]
                executeTask.launch()
                executeTask.waitUntilExit()
            } else {
                print("Output doesn't match the checkOutput: \(checkOutput)")
            }
        }
        
    }
    func readJSONFile(filePath: String) -> Data? {
        let fileURL = URL(fileURLWithPath: filePath)
        
        do {
            let data = try Data(contentsOf: fileURL)
            return data
        } catch {
            print("Error reading file:", error)
            return nil
        }
    }
    func parseJSON(jsonData: Data, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                throw NSError(domain: "ParsingError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert JSON to dictionary"])
            }
            completion(.success(jsonObject))
        } catch {
            completion(.failure(error))
        }
    }
    func populateWorkspaces(data: [String: Any]) -> [String: Any] {
        guard let profileAssociations = data["profileAssociations"] as? [String: Any],
              let workspacesDict = profileAssociations["workspaces"] as? [String: Any] else {
            print("profileAssociations or workspaces not found in JSON data")
            return [:]
        }
        
        guard let lastKnownMenubarData = data["lastKnownMenubarData"] as? [String: Any],
              let menus = lastKnownMenubarData["menus"] as? [String: Any],
              let items = menus["File"] as? [String: Any],
              let fileItems = items["items"] as? [[String: Any]] else {
            print("Menus or File items not found in JSON data")
            return [:] // or appropriate action if data is not available
        }

        let filteredItems = fileItems.filter { item in
            if let id = item["id"] as? String {
                return id == "submenuitem.MenubarRecentMenu"
                
            }
            return false
        }
        
        var workspaces: [[String: Any]] = []

        for (path, profile) in workspacesDict {
            let file = URL(fileURLWithPath: path).lastPathComponent
            let language = determineLanguage(from: path)
            let id = Int.random(in: 0..<100000000)
            
            var workspaceDetails: [String: Any] = [:]
            workspaceDetails["filename"] = file
            workspaceDetails["id"] = id
            workspaceDetails["language"] = language
            workspaceDetails["path"] = path
            workspaceDetails["profile"] = profile
            workspaces.append(workspaceDetails)
        }
        
        return ["workspaces": workspaces , "recent_project": filteredItems]
    }
    
    func determineLanguage(from path: String) -> String {
        // You can implement logic to determine the language based on the file extension or content
//        shell("cd \(path)")
        
        return ""
    }
}
