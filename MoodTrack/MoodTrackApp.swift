//
//  MoodTrackApp.swift
//  MoodTrack
//
//  Created by Сухарик on 11.11.2025.
//

import SwiftUI

@main
struct MoodTrackApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension Color {
    static let moodSad = Color(red: 231/255, green: 111/255, blue: 81/255)
    static let moodNeutral = Color(red: 244/255, green: 162/255, blue: 97/255)
    static let moodHappy = Color(red: 233/255, green: 196/255, blue: 106/255)
    static let moodExcellent = Color(red: 42/255, green: 157/255, blue: 143/255)
    static let buttonBackground = Color(red: 123/255, green: 158/255, blue: 168/255)
    static let pastelBackground = Color(red: 38/255, green: 70/255, blue: 83/255)
}
