import SwiftUI
import UIKit
import Charts
import WebKit

// MARK: - Charts

struct ChartsDemo: View {
    struct Sample: Identifiable {
        let id = UUID()
        let month: String
        let value: Double
    }

    private let data: [Sample] = [
        .init(month: "1月", value: 12), .init(month: "2月", value: 18), .init(month: "3月", value: 9),
        .init(month: "4月", value: 22), .init(month: "5月", value: 17), .init(month: "6月", value: 25),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoHeading("棒グラフ (BarMark)")
            Chart(data) { s in
                BarMark(x: .value("月", s.month), y: .value("値", s.value))
                    .foregroundStyle(.blue.gradient)
            }
            .frame(height: 160)

            DemoHeading("折れ線 + 面 (LineMark / AreaMark)")
            Chart(data) { s in
                AreaMark(x: .value("月", s.month), y: .value("値", s.value))
                    .foregroundStyle(.green.opacity(0.2))
                LineMark(x: .value("月", s.month), y: .value("値", s.value))
                    .foregroundStyle(.green)
                    .symbol(.circle)
            }
            .frame(height: 160)

            DemoHeading("円グラフ (SectorMark)")
            Chart(data) { s in
                SectorMark(angle: .value("値", s.value), innerRadius: .ratio(0.5), angularInset: 1)
                    .foregroundStyle(by: .value("月", s.month))
            }
            .frame(height: 180)
        }
    }
}

// MARK: - Image views

struct ImageViewsDemo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoHeading("SF Symbols (文字と同じ扱い)")
            HStack(spacing: 16) {
                Image(systemName: "photo").font(.body)
                Image(systemName: "photo").font(.title)
                Image(systemName: "photo").font(.largeTitle)
                Image(systemName: "photo.badge.plus").font(.largeTitle).symbolRenderingMode(.multicolor)
                Image(systemName: "photo.on.rectangle.angled").font(.largeTitle).foregroundStyle(.blue, .orange)
            }

            DemoHeading("ラスター画像の拡大縮小 (fit / fill)")
            HStack(spacing: 12) {
                VStack {
                    sampleImage.resizable().scaledToFit()
                        .frame(width: 120, height: 80)
                        .border(.secondary)
                    DemoCaption("scaledToFit")
                }
                VStack {
                    sampleImage.resizable().scaledToFill()
                        .frame(width: 120, height: 80)
                        .clipped()
                        .border(.secondary)
                    DemoCaption("scaledToFill + clipped")
                }
            }

            DemoHeading("角丸・円形")
            HStack(spacing: 12) {
                sampleImage.resizable().scaledToFill()
                    .frame(width: 72, height: 72)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                sampleImage.resizable().scaledToFill()
                    .frame(width: 72, height: 72)
                    .clipShape(Circle())
            }
        }
    }

    /// 画像ファイルを持たずに、コードで作った画像を使う。
    private var sampleImage: Image {
        let size = CGSize(width: 320, height: 200)
        let renderer = UIGraphicsImageRenderer(size: size)
        let uiImage = renderer.image { ctx in
            let colors = [UIColor.systemTeal.cgColor, UIColor.systemIndigo.cgColor] as CFArray
            let space = CGColorSpaceCreateDeviceRGB()
            if let gradient = CGGradient(colorsSpace: space, colors: colors, locations: [0, 1]) {
                ctx.cgContext.drawLinearGradient(gradient, start: .zero, end: CGPoint(x: size.width, y: size.height), options: [])
            }
            UIColor.white.withAlphaComponent(0.6).setFill()
            ctx.cgContext.fillEllipse(in: CGRect(x: 200, y: 30, width: 90, height: 90))
        }
        return Image(uiImage: uiImage)
    }
}

// MARK: - Text views

struct TextViewsDemo: View {
    @State private var text = "ここは編集できる TextEditor です。\n複数行を入力して、折り返しやスクロールを確かめてください。"

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoHeading("表示のみ (Text)")
            Text("Text は複数行を自動で折り返します。Dynamic Type の設定を変えると大きさが追従します。**太字** や *斜体*、`等幅` も Markdown で書けます。")
                .textSelection(.enabled)

            DemoHeading("編集できる (TextEditor)")
            TextEditor(text: $text)
                .frame(height: 120)
                .padding(4)
                .background(.background, in: RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(.secondary.opacity(0.4)))
                .onChange(of: text) { _, new in
                    qlog(.debug, "textviews", "編集: \(new.count) 文字")
                }
            DemoCaption("\(text.count) 文字")
        }
    }
}

// MARK: - Web views

struct WebViewsDemo: View {
    @State private var showWeb = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("iOS 26 の SwiftUI 純正 WebView で HIG の Web views ページを開きます。")
            FullScreenDemoButton(title: "WebView を全画面で開く") {
                NavigationStack {
                    WebView(url: URL(string: "https://developer.apple.com/design/human-interface-guidelines/web-views")!)
                        .ignoresSafeArea(edges: .bottom)
                        .navigationTitle("WebView")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) { DemoCloseButton() }
                        }
                        .onAppear { qlog(.info, "webviews", "WebView を表示") }
                }
            }
            .buttonStyle(.bordered)
            DemoHeading("埋め込み (高さ 240)")
            WebView(url: URL(string: "https://developer.apple.com/design/human-interface-guidelines/web-views")!)
                .frame(height: 240)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(.secondary.opacity(0.4)))
        }
    }
}
