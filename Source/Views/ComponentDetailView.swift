import SwiftUI

/// 部品 1 つ分の画面: デモ → 概要 → 対応プラットフォーム → HIG リンク。
struct ComponentDetailView: View {
    let item: CatalogItem
    @Environment(\.openURL) private var openURL

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // --- 見出し -----------------------------------------------
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.titleJA)
                        .font(.title2.bold())
                    Text("\(item.category.title) › \(item.title)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if !item.isAvailableOnIOS {
                    NotOnIOSBanner(item: item)
                }

                // --- デモ ---------------------------------------------------
                GroupBox {
                    DemoView(itemID: item.id)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } label: {
                    Label(item.isAvailableOnIOS ? "デモ" : "iOS での代替", systemImage: "play.rectangle")
                }

                // --- 概要 ---------------------------------------------------
                GroupBox {
                    Text(item.summary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } label: {
                    Label("概要", systemImage: "text.alignleft")
                }

                if let note = item.note {
                    GroupBox {
                        Text(note)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } label: {
                        Label("確認のしかた・注意", systemImage: "exclamationmark.circle")
                    }
                }

                // --- 対応プラットフォーム --------------------------------------
                GroupBox {
                    PlatformChips(platforms: item.platforms)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } label: {
                    Label("HIG が対応を明記しているプラットフォーム", systemImage: "square.stack.3d.up")
                }

                // --- HIG リンク ---------------------------------------------
                VStack(spacing: 10) {
                    Button {
                        qlog(.info, "detail", "HIG を開く (英語): \(item.id)")
                        openURL(item.higURL)
                    } label: {
                        Label("HIG を開く (英語)", systemImage: "safari")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.glassProminent)
                    Button {
                        qlog(.info, "detail", "HIG を開く (日本語): \(item.id)")
                        openURL(item.higURLJapanese)
                    } label: {
                        Label("HIG を開く (日本語)", systemImage: "safari")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.glass)
                }
                .controlSize(.large)
            }
            .padding()
            .frame(maxWidth: 700)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            qlog(.debug, "detail", "表示: \(item.id)")
        }
    }
}

struct NotOnIOSBanner: View {
    let item: CatalogItem

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("この部品は iOS / iPadOS にはありません", systemImage: "exclamationmark.triangle.fill")
                .font(.headline)
            Text("HIG では \(item.platformList) 向けの部品です。")
                .font(.subheadline)
            if let alt = item.iosAlternative {
                Text(alt)
                    .font(.subheadline)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.orange.opacity(0.15), in: RoundedRectangle(cornerRadius: 12))
        .foregroundStyle(.primary)
    }
}

struct PlatformChips: View {
    let platforms: Set<Platform>

    var body: some View {
        HStack(spacing: 6) {
            ForEach(Platform.allCases) { p in
                let on = platforms.contains(p)
                Text(p.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(on ? Color.accentColor.opacity(0.2) : Color.secondary.opacity(0.08), in: Capsule())
                    .foregroundStyle(on ? Color.accentColor : Color.secondary)
            }
        }
    }
}
