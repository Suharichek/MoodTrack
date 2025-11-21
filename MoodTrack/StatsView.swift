//
//  StatsView.swift
//  MoodTrack
//
//  Created by Сухарик on 11.11.2025.
//

import SwiftUI
import Charts

struct StatsView: View {
    var entries: [MoodEntry] = []
    
    @State private var selectedRange: RangeType = .week
    
    enum RangeType: String, CaseIterable, Identifiable {
        case day = "День"
        case week = "Неделя"
        case month = "Месяц"
        
        var id: String { rawValue }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("График настроения")
                .font(.title)
                .foregroundColor(.white.opacity(0.7))
                .bold()
                .padding(.horizontal)
            
            Picker("Период", selection: $selectedRange) {
                ForEach(RangeType.allCases) { range in
                    Text(range.rawValue).tag(range)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            if entries.isEmpty {
                Text("Нет данных — добавь первую запись")
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.top, 20)
                    .padding(.horizontal)
            } else {
                VStack(alignment: .leading) {
                    Text(currentMonthName())
                        .font(.title2.bold())
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.leading)
                    
                    Chart {
                        ForEach(dataPoints()) { item in
                            LineMark(
                                x: .value("День", item.date, unit: .day),
                                y: .value("Настроение", item.moodValue)
                            )
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(.orange)
                            
                            PointMark(
                                x: .value("День", item.date, unit: .day),
                                y: .value("Настроение", item.moodValue)
                            )
                            .foregroundStyle(Color.pastelBackground)
                            .symbolSize(80)
                        }
                    }
                    .chartYScale(domain: 0...3)
                    .chartXAxis {
                        AxisMarks(values: dataPoints().map { $0.date }) { value in
                            AxisValueLabel(format: .dateTime.day())
                            AxisTick()
                            AxisGridLine()
                        }
                    }
                    .chartYAxis {
                        AxisMarks(values: [0, 1, 2, 3]) { value in
                            AxisValueLabel {
                                switch value.as(Int.self) {
                                case 0: Text("😞")
                                case 1: Text("😐")
                                case 2: Text("☺️")
                                case 3: Text("😄")
                                default: Text("")
                                }
                            }
                            AxisTick()
                            AxisGridLine()
                        }
                    }
                    .frame(height: 420)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .white.opacity(0.5), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text(averageMoodText())
                            .foregroundColor(.white)
                        
                        Text(trendText())
                            .foregroundColor(.white)
                        
                        if let bestDay = bestMoodDay() {
                            Text("Лучший день: \(formattedDate(bestDay.date)) \(emoji(for: bestDay.moodValue))")
                                .foregroundColor(.white)
                        }
                        
                        if let worstDay = worstMoodDay() {
                            Text("Худший день: \(formattedDate(worstDay.date)) \(emoji(for: worstDay.moodValue))")
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
        }
        .padding(.top)
        .background(Color(red: 38/255, green: 70/255, blue: 83/255).ignoresSafeArea())
    }

    func dataPoints() -> [MoodPoint] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let startDate: Date
        
        switch selectedRange {
        case .day:
            startDate = today
        case .week:
            startDate = calendar.date(byAdding: .day, value: -6, to: today) ?? today
        case .month:
            startDate = calendar.date(byAdding: .day, value: -29, to: today) ?? today
        }
        
        var pointsDict: [Date: [Int]] = [:]
        
        for entry in entries {
            if entry.date >= startDate {
                let day = calendar.startOfDay(for: entry.date)
                pointsDict[day, default: []].append(entry.mood)
            }
        }
        
        var result: [MoodPoint] = []
        let daysCount = calendar.dateComponents([.day], from: startDate, to: today).day ?? 0
        
        for i in 0...daysCount {
            if let date = calendar.date(byAdding: .day, value: i, to: startDate) {
                let day = calendar.startOfDay(for: date)
                let moods = pointsDict[day] ?? []
                let avgMood = moods.isEmpty ? 2 : moods.reduce(0, +) / moods.count
                result.append(MoodPoint(date: day, moodValue: avgMood))
            }
        }
        
        return result
    }
    
    func currentMonthName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL"
        formatter.locale = Locale(identifier: "ru_RU")
        if let firstDate = dataPoints().first?.date {
            return formatter.string(from: firstDate).capitalized
        }
        return ""
    }
    
    func averageMoodText() -> String {
        let moods = entries.map { $0.mood }
        guard !moods.isEmpty else { return "" }
        let avg = Double(moods.reduce(0, +)) / Double(moods.count)
        return "Среднее настроение: \(emoji(for: Int(round(avg))))"
    }
    
    func trendText() -> String {
        let points = dataPoints()
        guard points.count >= 2 else { return "-" }
        let diff = points.last!.moodValue - points.first!.moodValue
        if diff > 0 { return "Твое настроение улучшается 😊" }
        if diff < 0 { return "Твое настроение ухудшается 😔" }
        return "Твое настроение стабильное 😐"
    }
    
    func bestMoodDay() -> MoodPoint? {
        dataPoints().max(by: { $0.moodValue < $1.moodValue })
    }
    
    func worstMoodDay() -> MoodPoint? {
        dataPoints().min(by: { $0.moodValue < $1.moodValue })
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter.string(from: date)
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
    
    struct MoodPoint: Identifiable {
        let id = UUID()
        let date: Date
        let moodValue: Int
    }
}

#Preview {
    StatsView(entries: [
        MoodEntry(mood: 3, note: "Отлично", date: Date()),
        MoodEntry(mood: 2, note: "Спокойно", date: Date().addingTimeInterval(-3600*24)),
        MoodEntry(mood: 1, note: "Нейтрально", date: Date().addingTimeInterval(-3600*24*2)),
        MoodEntry(mood: 0, note: "Плохо", date: Date().addingTimeInterval(-3600*24*3)),
        MoodEntry(mood: 2, note: "Легкий день", date: Date().addingTimeInterval(-3600*24*4)),
        MoodEntry(mood: 3, note: "Весело!", date: Date().addingTimeInterval(-3600*24*5))
    ])
}
