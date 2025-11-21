//
//  MainView.swift
//  MoodTrack
//
//  Created by Сухарик on 11.11.2025.
//

import SwiftUI

struct ModernButton: View {
    var title: String
    var action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.buttonBackground)
                .cornerRadius(14)
                .shadow(color: Color.black.opacity(isPressed ? 0.1 : 0.2),
                        radius: isPressed ? 2 : 5,
                        x: 0, y: isPressed ? 1 : 3)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.black, lineWidth: 1.5)
                )
                .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged({ _ in withAnimation(.easeIn(duration: 0.1)) { isPressed = true } })
                .onEnded({ _ in withAnimation(.easeOut(duration: 0.1)) { isPressed = false } })
        )
    }
}

struct MainView: View {
    @State private var selectedMood: Int? = nil
    @State private var note: String = ""
    @State private var showSavedOverlay = false
    
    private let moods = ["Грустно", "Спокойно", "Хорошо", "Отлично"]
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack(spacing: 32) {
                    Spacer()
                    
                    Text("Как твоё настроение сегодня?")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.5))
                    
                    HStack(spacing: 24) {
                        ForEach(0..<4) { i in
                            VStack(spacing: 8) {
                                Button {
                                    withAnimation(.spring()) { selectedMood = i }
                                } label: {
                                    Text(emoji(for: i))
                                        .font(.system(size: 40))
                                        .padding()
                                        .background(
                                            Circle()
                                                .fill(selectedMood == i ? color(for: i) : Color.white.opacity(0.2))
                                                .shadow(color: selectedMood == i ? color(for: i).opacity(0.4) : .clear,
                                                        radius: 5, x: 0, y: 3)
                                        )
                                }
                                .buttonStyle(.plain)
                                
                                Text(moods[i])
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }
                    }
                    
                    Text("Небольшая заметка")
                        .foregroundColor(.white.opacity(0.7))
                    
                    TextEditor(text: $note)
                        .frame(height: 100)
                        .padding(8)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(5)
                    
                    ModernButton(title: "Сохранить") {
                        print("Сохраняем настроение: \(selectedMood ?? -1), заметка: \(note)")
                        note = ""
                        selectedMood = nil
                        withAnimation {
                            showSavedOverlay = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation { showSavedOverlay = false }
                        }
                    }
                    .disabled(selectedMood == nil)
                    
                    Spacer()
                }
                .padding()
                .background(Color.pastelBackground.ignoresSafeArea())
            }
            
            if showSavedOverlay {
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                    
                    Text("Сохранено!")
                        .foregroundColor(.white)
                        .font(.title2.bold())
                }
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(14)
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    func emoji(for mood: Int) -> String {
        switch mood {
        case 0: return "😞"
        case 1: return "😐"
        case 2: return "☺️"
        case 3: return "😄"
        default: return "☺️"
        }
    }
    
    func color(for mood: Int) -> Color {
        switch mood {
        case 0: return .moodSad
        case 1: return .moodNeutral
        case 2: return .moodHappy
        case 3: return .moodExcellent
        default: return .gray
        }
    }
}

#Preview {
    MainView()
}
