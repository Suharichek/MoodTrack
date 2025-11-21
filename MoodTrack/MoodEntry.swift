//
//  MoodEntry.swift
//  MoodTrack
//
//  Created by Сухарик on 11.11.2025.
//

import Foundation

struct MoodEntry: Identifiable {
    let id = UUID()
    let mood: Int       // 0 = грустно, 1 = нейтрально, 2 = хорошо, 3 = отлично
    let note: String?
    let date: Date
}
