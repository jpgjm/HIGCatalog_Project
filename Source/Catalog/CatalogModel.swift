import Foundation

/// HIG の Components ページにある 8 つのカテゴリ。順序も HIG と同じ。
enum ComponentCategory: String, CaseIterable, Identifiable {
    case content
    case layoutAndOrganization
    case menusAndActions
    case navigationAndSearch
    case presentation
    case selectionAndInput
    case status
    case systemExperiences

    var id: String { rawValue }

    /// HIG の英語名。
    var title: String {
        switch self {
        case .content: return "Content"
        case .layoutAndOrganization: return "Layout and organization"
        case .menusAndActions: return "Menus and actions"
        case .navigationAndSearch: return "Navigation and search"
        case .presentation: return "Presentation"
        case .selectionAndInput: return "Selection and input"
        case .status: return "Status"
        case .systemExperiences: return "System experiences"
        }
    }

    var titleJA: String {
        switch self {
        case .content: return "コンテンツ"
        case .layoutAndOrganization: return "レイアウトと整理"
        case .menusAndActions: return "メニューと操作"
        case .navigationAndSearch: return "ナビゲーションと検索"
        case .presentation: return "表示"
        case .selectionAndInput: return "選択と入力"
        case .status: return "状態"
        case .systemExperiences: return "システム体験"
        }
    }

    var symbolName: String {
        switch self {
        case .content: return "doc.richtext"
        case .layoutAndOrganization: return "square.grid.2x2"
        case .menusAndActions: return "filemenu.and.selection"
        case .navigationAndSearch: return "sidebar.left"
        case .presentation: return "rectangle.on.rectangle"
        case .selectionAndInput: return "slider.horizontal.3"
        case .status: return "gauge.with.dots.needle.33percent"
        case .systemExperiences: return "iphone.gen3"
        }
    }

    /// HIG のカテゴリページの slug。
    var higSlug: String {
        switch self {
        case .content: return "content"
        case .layoutAndOrganization: return "layout-and-organization"
        case .menusAndActions: return "menus-and-actions"
        case .navigationAndSearch: return "navigation-and-search"
        case .presentation: return "presentation"
        case .selectionAndInput: return "selection-and-input"
        case .status: return "status"
        case .systemExperiences: return "system-experiences"
        }
    }
}

/// HIG が対応を明記しているプラットフォーム。
enum Platform: String, CaseIterable, Identifiable, Hashable {
    case iOS, iPadOS, macOS, tvOS, visionOS, watchOS
    var id: String { rawValue }
}

/// 部品 1 つ分の情報。
struct CatalogItem: Identifiable, Hashable {
    /// HIG の URL slug。デモの切り替えにも使う。
    let id: String
    /// HIG の英語名 (ページの見出しそのまま)。
    let title: String
    let titleJA: String
    let category: ComponentCategory
    /// HIG が対応を明記しているプラットフォーム。
    let platforms: Set<Platform>
    /// 日本語の概要 (HIG を元にこちらで書き起こしたもの)。
    let summary: String
    /// iOS/iPadOS に無い部品について、iOS で近いことをする手段。
    let iosAlternative: String?
    /// 検証に注意が要る場合の補足 (SideStore / Extension / 権限など)。
    let note: String?

    init(
        id: String,
        title: String,
        titleJA: String,
        category: ComponentCategory,
        platforms: Set<Platform>,
        summary: String,
        iosAlternative: String? = nil,
        note: String? = nil
    ) {
        self.id = id
        self.title = title
        self.titleJA = titleJA
        self.category = category
        self.platforms = platforms
        self.summary = summary
        self.iosAlternative = iosAlternative
        self.note = note
    }

    /// iPhone / iPad のどちらかで使える部品か。
    var isAvailableOnIOS: Bool {
        platforms.contains(.iOS) || platforms.contains(.iPadOS)
    }

    var higURL: URL {
        URL(string: "https://developer.apple.com/design/human-interface-guidelines/\(id)")!
    }

    var higURLJapanese: URL {
        URL(string: "https://developer.apple.com/jp/design/human-interface-guidelines/\(id)")!
    }

    var platformList: String {
        Platform.allCases.filter { platforms.contains($0) }.map(\.rawValue).joined(separator: " / ")
    }
}
