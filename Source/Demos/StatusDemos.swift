import SwiftUI

// MARK: - Activity rings (watchOS)

struct ActivityRingsDemo: View {
    @State private var progress = 0.65
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("3 重のアクティビティリングの見た目を他の用途に使うことは HIG で禁じられています。iOS で進捗をリングで見せるなら 1 本で描きます。")
            HStack(spacing: 24) {
                Gauge(value: progress) {
                    Text("進捗")
                } currentValueLabel: {
                    Text("\(Int(progress * 100))%")
                }
                .gaugeStyle(.accessoryCircularCapacity)
                .tint(.pink)
                ZStack {
                    Circle().stroke(.pink.opacity(0.2), lineWidth: 12)
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(.pink, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    Text("\(Int(progress * 100))%").font(.caption.bold())
                }
                .frame(width: 72, height: 72)
            }
            Slider(value: $progress)
        }
    }
}

// MARK: - Gauges

struct GaugesDemo: View {
    @State private var value = 0.4
    private let gradient = Gradient(colors: [.green, .yellow, .orange, .red])

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Gauge(value: value) { Text("線形 (既定)") }
            Gauge(value: value) { Text("線形 + ラベル") } currentValueLabel: {
                Text("\(Int(value * 100))")
            } minimumValueLabel: { Text("0") } maximumValueLabel: { Text("100") }
            Gauge(value: value) { Text("グラデーション") }
                .gaugeStyle(.linearCapacity)
                .tint(gradient)
            HStack(spacing: 24) {
                Gauge(value: value) { Image(systemName: "thermometer") } currentValueLabel: {
                    Text("\(Int(value * 40))°")
                }
                .gaugeStyle(.accessoryCircular)
                .tint(gradient)
                Gauge(value: value) { Text("容量") } currentValueLabel: {
                    Text("\(Int(value * 100))%")
                }
                .gaugeStyle(.accessoryCircularCapacity)
                Gauge(value: value) { Text("線形 (accessory)") }
                    .gaugeStyle(.accessoryLinear)
            }
            Slider(value: $value)
        }
    }
}

// MARK: - Progress indicators

struct ProgressIndicatorsDemo: View {
    @State private var progress = 0.0
    @State private var running = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoHeading("終わりが分からない (indeterminate)")
            HStack(spacing: 24) {
                ProgressView()
                ProgressView().controlSize(.large)
                ProgressView("読み込み中…")
            }
            DemoHeading("終わりが分かる (determinate)")
            ProgressView(value: progress) {
                Text("ダウンロード")
            } currentValueLabel: {
                Text("\(Int(progress * 100))%")
            }
            ProgressView(value: progress).progressViewStyle(.circular)
            Button(running ? "停止" : "進捗を動かす") {
                running.toggle()
                qlog(.info, "progress", running ? "開始" : "停止")
            }
            .buttonStyle(.bordered)
            .task(id: running) {
                guard running else { return }
                while running && !Task.isCancelled {
                    try? await Task.sleep(for: .milliseconds(200))
                    progress = progress >= 1 ? 0 : progress + 0.05
                }
            }
        }
    }
}

// MARK: - Rating indicators (macOS)

struct RatingIndicatorsDemo: View {
    @State private var rating = 3
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("iOS で自作する場合の例。星をタップして評価を変えます。")
            HStack(spacing: 6) {
                ForEach(1...5, id: \.self) { i in
                    Image(systemName: i <= rating ? "star.fill" : "star")
                        .font(.title)
                        .foregroundStyle(.yellow)
                        .onTapGesture {
                            rating = (rating == i) ? i - 1 : i
                            qlog(.info, "rating", "評価: \(rating)")
                        }
                }
            }
            DemoCaption("評価: \(rating) / 5")
        }
    }
}
