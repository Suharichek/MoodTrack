//
//  ContentView.swift
//  MoodTrack
//
//  Created by Сухарик on 11.11.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var entries: [MoodEntry] = [
        MoodEntry(mood: 3, note: "Отличный день!", date: Date()),
        MoodEntry(mood: 2, note: "Спокойно", date: Date().addingTimeInterval(-3600*24)),
        MoodEntry(mood: 1, note: "Нейтрально", date: Date().addingTimeInterval(-3600*24*2)),
        MoodEntry(mood: 0, note: "Плохо", date: Date().addingTimeInterval(-3600*24*3)),
        MoodEntry(mood: 2, note: "Легкий день", date: Date().addingTimeInterval(-3600*24*4)),
        MoodEntry(mood: 3, note: "Весело!", date: Date().addingTimeInterval(-3600*24*5))
    ]

    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("Главная", systemImage: "house")
                }

            StatsView(entries: entries)
                .tabItem {
                    Label("График", systemImage: "chart.line.uptrend.xyaxis")
                }

            SettingsView()
                .tabItem {
                    Label("Настройки", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
}
