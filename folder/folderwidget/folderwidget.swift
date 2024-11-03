//
//  folderwidget.swift
//  folderwidget
//
//  Created by Gokula Krishnan R on 26/04/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    @ObservedObject private var recentP = SettingFetcher()
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent() , workspace: recentP.recent_project)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration , workspace: recentP.recent_project)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration , workspace: recentP.recent_project)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let workspace: [Workspace]?
}

struct folderwidgetEntryView : View {
    var entry: Provider.Entry
    @State private var searchText = ""
    @State private var successMessage: String?
    var body: some View {
        VStack {
            HStack{
                
                Image(systemName: "folder.fill")
                Text("vs code workspace")
                    .font(.headline)
            }
//            listWorkspace(searchText: $searchText , successMessage: $successMessage , workspace: entry.workspace)
            listworkspaces(successMessage: $successMessage , searchText: $searchText)
        }
       
    }
}

struct folderwidget: Widget {
    let kind: String = "folderwidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            folderwidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}


