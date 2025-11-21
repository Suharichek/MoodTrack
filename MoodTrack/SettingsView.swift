//
//  SettingsView.swift
//  MoodTrack
//
//  Created by Сухарик on 11.11.2025.
//

import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = false
    @State private var reminderTime = Date()
    @State private var showEmojiYAxis = true
    @State private var chartType = "Линейный"
    
    private let chartTypes = ["Линейный", "Столбчатый", "Круговой"]
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Уведомления")
                    .foregroundColor(.white.opacity(0.7))
                ) {
                    Toggle("Push-уведомления о настроении", isOn: $notificationsEnabled)
                    if notificationsEnabled {
                        DatePicker("Время напоминания", selection: $reminderTime, displayedComponents: .hourAndMinute)
                    }
                }
                
                Section(header: Text("Графики и статистика")
                    .foregroundColor(.white.opacity(0.7))
                ) {
                    Picker("Тип графика", selection: $chartType) {
                        ForEach(chartTypes, id: \.self) { type in
                            Text(type)
                        }
                    }
                    
                    Toggle("Показывать эмодзи на оси Y", isOn: $showEmojiYAxis)
                    
                    HStack {
                        Text("Количество записей за неделю:")
                        Spacer()
                        Text("12") // примерное число, позже будет динамическое
                            .foregroundColor(.black)
                    }
                    
                    HStack {
                        Text("Среднее настроение:")
                        Spacer()
                        Text("☺️") // пример
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Тренд настроения:")
                        Spacer()
                        Text("Улучшается 😊") // пример
                            .foregroundColor(.black)
                    }
                }
                
                Section(header: Text("Данные")
                    .foregroundColor(.white.opacity(0.7))
                ) {
                    Button("Экспорт в CSV") {}
                    Button("Экспорт в PDF") {}
                    Button("Импорт заметок") {}
                    Button("Сброс всех данных") {}
                        .foregroundColor(.red)
                }
            }
            .padding(.top)
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.pastelBackground.ignoresSafeArea())
        }
    }
}

#Preview {
    SettingsView()
}
