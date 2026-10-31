import Foundation

/// HIG の Components ページ (https://developer.apple.com/design/human-interface-guidelines/components)
/// に載っている全 64 項目。順序は HIG のカテゴリページと同じ。
///
/// `platforms` は HIG 各ページの冒頭に書かれている対応プラットフォームを
/// 2026-11 時点で写したもの。概要は HIG を元に日本語で書き起こした。
enum CatalogData {
    static let items: [CatalogItem] = content + layout + menus + navigation + presentation + selection + status + system

    static func items(in category: ComponentCategory) -> [CatalogItem] {
        items.filter { $0.category == category }
    }

    static func item(id: String) -> CatalogItem? {
        items.first { $0.id == id }
    }

    private static let all: Set<Platform> = [.iOS, .iPadOS, .macOS, .tvOS, .visionOS, .watchOS]
    private static let noWatch: Set<Platform> = [.iOS, .iPadOS, .macOS, .tvOS, .visionOS]
    private static let desktopAndMobile: Set<Platform> = [.iOS, .iPadOS, .macOS, .visionOS]

    // MARK: - Content

    static let content: [CatalogItem] = [
        CatalogItem(
            id: "charts", title: "Charts", titleJA: "チャート", category: .content,
            platforms: all,
            summary: "データの傾向や比較を図で伝える。Swift Charts で棒・折れ線・面・点などを描ける。軸やラベルは読み取りに必要な最小限にし、色だけで意味を伝えない。"
        ),
        CatalogItem(
            id: "image-views", title: "Image views", titleJA: "画像ビュー", category: .content,
            platforms: all,
            summary: "画像を 1 枚表示する。SwiftUI では Image。拡大縮小の方法 (fit / fill) と、SF Symbols の場合はテキストと同じ扱いで大きさや色が決まる。"
        ),
        CatalogItem(
            id: "text-views", title: "Text views", titleJA: "テキストビュー", category: .content,
            platforms: all,
            summary: "複数行の文章を表示し、必要なら編集もできる。SwiftUI では Text (表示のみ) と TextEditor (編集可)。Dynamic Type に追従させる。"
        ),
        CatalogItem(
            id: "web-views", title: "Web views", titleJA: "Web ビュー", category: .content,
            platforms: desktopAndMobile,
            summary: "アプリ内に Web コンテンツを埋め込む。iOS 26 からは SwiftUI 純正の WebView がある (従来は WKWebView)。ブラウザの代わりではなく、戻る/進むなどの操作は自前で用意する。",
            note: "通信が要る。ネットワークが無い環境では空白のままになる。"
        ),
    ]

    // MARK: - Layout and organization

    static let layout: [CatalogItem] = [
        CatalogItem(
            id: "boxes", title: "Boxes", titleJA: "ボックス", category: .layoutAndOrganization,
            platforms: desktopAndMobile,
            summary: "関連する項目を枠で囲んでひとまとまりに見せる。SwiftUI では GroupBox。見出しを付けられる。"
        ),
        CatalogItem(
            id: "collections", title: "Collections", titleJA: "コレクション", category: .layoutAndOrganization,
            platforms: noWatch,
            summary: "同じ種類の項目を格子状に並べる。写真やアルバムのように画像中心のときに向く。SwiftUI では LazyVGrid / LazyHGrid。"
        ),
        CatalogItem(
            id: "column-views", title: "Column views", titleJA: "カラムビュー", category: .layoutAndOrganization,
            platforms: [.macOS],
            summary: "Finder のカラム表示のように、階層を横に並んだ列で辿る。macOS 専用。",
            iosAlternative: "iPad では NavigationSplitView の 3 カラム (サイドバー・一覧・詳細) が最も近い。iPhone では階層ごとに画面を進める NavigationStack になる。"
        ),
        CatalogItem(
            id: "disclosure-controls", title: "Disclosure controls", titleJA: "開閉コントロール", category: .layoutAndOrganization,
            platforms: desktopAndMobile,
            summary: "シェブロン (>) をタップして内容を展開・折りたたむ。SwiftUI では DisclosureGroup。"
        ),
        CatalogItem(
            id: "labels", title: "Labels", titleJA: "ラベル", category: .layoutAndOrganization,
            platforms: all,
            summary: "短い静的なテキスト。SwiftUI の Label はアイコンと文字の組で、置かれる場所 (リスト・メニュー・ツールバー) に応じて見た目が変わる。"
        ),
        CatalogItem(
            id: "lists-and-tables", title: "Lists and tables", titleJA: "リストとテーブル", category: .layoutAndOrganization,
            platforms: all,
            summary: "縦に並ぶ行でデータを見せる。SwiftUI の List には plain / inset / grouped / insetGrouped / sidebar の各スタイルがある。Table は複数列だが、iPhone では先頭列しか出ない。"
        ),
        CatalogItem(
            id: "lockups", title: "Lockups", titleJA: "ロックアップ", category: .layoutAndOrganization,
            platforms: [.tvOS],
            summary: "tvOS で画像・見出し・サブタイトルを 1 つにまとめ、フォーカスが当たると浮き上がる部品。tvOS 専用。",
            iosAlternative: "iOS ではカード (画像 + タイトル + 説明を VStack で組み、角丸の背景に乗せる) が同じ役割。タップ時の浮き上がりは scaleEffect で再現できる。"
        ),
        CatalogItem(
            id: "outline-views", title: "Outline views", titleJA: "アウトラインビュー", category: .layoutAndOrganization,
            platforms: desktopAndMobile,
            summary: "入れ子になったデータを木構造で見せる。SwiftUI では List(children:) または OutlineGroup。"
        ),
        CatalogItem(
            id: "split-views", title: "Split views", titleJA: "分割ビュー", category: .layoutAndOrganization,
            platforms: noWatch,
            summary: "画面を 2〜3 の領域に分け、左で選んだものを右に表示する。SwiftUI では NavigationSplitView。iPhone では自動でスタック表示に畳まれる。"
        ),
        CatalogItem(
            id: "tab-views", title: "Tab views", titleJA: "タブビュー", category: .layoutAndOrganization,
            platforms: [.macOS, .visionOS],
            summary: "ウインドウ内でタブを切り替えて、同じ場所に別の内容を出す (macOS の「システム設定」のような使い方)。iOS の画面下のタブバーとは別物で、HIG では macOS / visionOS 向け。",
            iosAlternative: "iOS では画面下の Tab bars (TabView) か、画面の一部を切り替えるなら Segmented control + 条件分岐で同じことをする。"
        ),
    ]

    // MARK: - Menus and actions

    static let menus: [CatalogItem] = [
        CatalogItem(
            id: "activity-views", title: "Activity views", titleJA: "アクティビティビュー (共有シート)", category: .menusAndActions,
            platforms: desktopAndMobile,
            summary: "共有シート。コピー、AirDrop、他アプリへの送信などをシステムが列挙する。SwiftUI では ShareLink。自前で送信先の一覧を作らない。"
        ),
        CatalogItem(
            id: "buttons", title: "Buttons", titleJA: "ボタン", category: .menusAndActions,
            platforms: all,
            summary: "タップで動作を起こす。iOS 26 では Liquid Glass のスタイル (glass / glassProminent) が加わった。役割 (destructive / cancel) を付けると色や並びが変わる。"
        ),
        CatalogItem(
            id: "context-menus", title: "Context menus", titleJA: "コンテキストメニュー", category: .menusAndActions,
            platforms: desktopAndMobile,
            summary: "長押しで出る、その項目に関する操作の一覧。SwiftUI では .contextMenu。プレビュー付きにもできる。"
        ),
        CatalogItem(
            id: "dock-menus", title: "Dock menus", titleJA: "Dock メニュー", category: .menusAndActions,
            platforms: [.macOS],
            summary: "macOS の Dock でアプリアイコンを右クリックしたときのメニュー。macOS 専用。",
            iosAlternative: "iOS でアイコン長押しに対応するのは Home Screen quick actions。"
        ),
        CatalogItem(
            id: "edit-menus", title: "Edit menus", titleJA: "編集メニュー", category: .menusAndActions,
            platforms: desktopAndMobile,
            summary: "テキストを選択したときに出る「コピー / ペースト / 調べる」などのメニュー。テキスト入力欄なら自動で出る。"
        ),
        CatalogItem(
            id: "home-screen-quick-actions", title: "Home Screen quick actions", titleJA: "ホーム画面のクイックアクション", category: .menusAndActions,
            platforms: [.iOS, .iPadOS],
            summary: "ホーム画面でアプリアイコンを長押ししたときに出るショートカット。このアプリには「ランダムな部品を開く」「ログを開く」の 2 つを Info.plist (UIApplicationShortcutItems) に静的登録してある。",
            note: "アプリを一度終了してからホーム画面のアイコンを長押しして確認する。受け取った内容はログに残る。"
        ),
        CatalogItem(
            id: "menus", title: "Menus", titleJA: "メニュー", category: .menusAndActions,
            platforms: all,
            summary: "操作の一覧。SwiftUI の Menu は iOS ではボタンから出るポップアップになる。区切り (Divider)、入れ子 (サブメニュー)、チェック状態 (Toggle) を入れられる。"
        ),
        CatalogItem(
            id: "ornaments", title: "Ornaments", titleJA: "オーナメント", category: .menusAndActions,
            platforms: [.visionOS],
            summary: "visionOS でウインドウの縁の外側に浮かぶツールバーやタブバー。visionOS 専用。",
            iosAlternative: "iOS では画面下の Toolbar (.toolbar に bottomBar) が同じ役割。iOS 26 ではガラス風に浮いて見える。"
        ),
        CatalogItem(
            id: "pop-up-buttons", title: "Pop-up buttons", titleJA: "ポップアップボタン", category: .menusAndActions,
            platforms: desktopAndMobile,
            summary: "現在の選択肢を表示し、タップすると他の選択肢の一覧が出るボタン。SwiftUI では Picker の .menu スタイル。"
        ),
        CatalogItem(
            id: "pull-down-buttons", title: "Pull-down buttons", titleJA: "プルダウンボタン", category: .menusAndActions,
            platforms: desktopAndMobile,
            summary: "タップすると操作の一覧が出るボタン。ポップアップボタンと違い、選んだ結果をボタンに表示しない。SwiftUI では Menu。"
        ),
        CatalogItem(
            id: "the-menu-bar", title: "The menu bar", titleJA: "メニューバー", category: .menusAndActions,
            platforms: [.macOS, .iPadOS],
            summary: "画面上端のメニュー。iPadOS 26 からはアプリにもメニューバーがあり、画面上端から下へスワイプすると出る。SwiftUI では .commands で項目を足す。このアプリには「カタログ」メニューを追加してある。",
            note: "iPad のみ。画面上端から下へスワイプ (またはキーボード接続時はポインタを上端へ) で表示される。"
        ),
        CatalogItem(
            id: "toolbars", title: "Toolbars", titleJA: "ツールバー", category: .menusAndActions,
            platforms: all,
            summary: "画面の上下の縁にある、その画面でよく使う操作の置き場。SwiftUI では .toolbar。iOS 26 では項目がガラスの上に乗り、ToolbarSpacer でグループを分けられる。"
        ),
    ]

    // MARK: - Navigation and search

    static let navigation: [CatalogItem] = [
        CatalogItem(
            id: "path-controls", title: "Path controls", titleJA: "パスコントロール", category: .navigationAndSearch,
            platforms: [.macOS],
            summary: "Finder のウインドウ下部のように、現在位置までのフォルダ階層を横並びで表示する。macOS 専用。",
            iosAlternative: "iOS ではナビゲーションバーの戻るボタンが階層を担う。横並びのパン屑 (breadcrumb) を自作するなら横スクロールの HStack で作る。"
        ),
        CatalogItem(
            id: "search-fields", title: "Search fields", titleJA: "検索フィールド", category: .navigationAndSearch,
            platforms: all,
            summary: "検索語を入力する欄。SwiftUI では .searchable。iOS 26 ではタブバーの検索タブやツールバーの検索ボタンとして置ける。候補 (.searchSuggestions) やスコープも付けられる。"
        ),
        CatalogItem(
            id: "sidebars", title: "Sidebars", titleJA: "サイドバー", category: .navigationAndSearch,
            platforms: noWatch,
            summary: "アプリの最上位の区分を縦に並べる。iPad の横向きや Mac で見える。SwiftUI では NavigationSplitView の先頭カラム、または List の .sidebar スタイル。"
        ),
        CatalogItem(
            id: "tab-bars", title: "Tab bars", titleJA: "タブバー", category: .navigationAndSearch,
            platforms: [.iOS, .iPadOS, .tvOS, .visionOS, .watchOS],
            summary: "画面下でアプリの主要な区分を切り替える。iOS 26 ではガラスの帯になり、スクロールで縮む (tabBarMinimizeBehavior)。検索タブは Tab(role: .search) で右端に分離される。"
        ),
        CatalogItem(
            id: "token-fields", title: "Token fields", titleJA: "トークンフィールド", category: .navigationAndSearch,
            platforms: [.macOS],
            summary: "メールの宛先欄のように、入力した語がカプセル状のトークンになる欄。macOS 専用。",
            iosAlternative: "iOS では FlowLayout や横スクロールの HStack にカプセルを並べ、TextField を末尾に置いて自作する。"
        ),
    ]

    // MARK: - Presentation

    static let presentation: [CatalogItem] = [
        CatalogItem(
            id: "action-sheets", title: "Action sheets", titleJA: "アクションシート", category: .presentation,
            platforms: [.iOS, .iPadOS, .visionOS, .watchOS],
            summary: "操作の選択肢を下から出す。削除前の確認などに使う。SwiftUI では .confirmationDialog。iPad ではポップオーバーになる。"
        ),
        CatalogItem(
            id: "alerts", title: "Alerts", titleJA: "アラート", category: .presentation,
            platforms: all,
            summary: "重要な情報を伝え、応答を求める。ボタンは 1〜2 個が基本。SwiftUI では .alert。ボタンを書かなければ OK だけが自動で付く。"
        ),
        CatalogItem(
            id: "page-controls", title: "Page controls", titleJA: "ページコントロール", category: .presentation,
            platforms: [.iOS, .iPadOS, .tvOS, .visionOS],
            summary: "横にめくるページの枚数と現在位置を点で示す。SwiftUI では TabView の .page スタイルで自動で付く。"
        ),
        CatalogItem(
            id: "panels", title: "Panels", titleJA: "パネル", category: .presentation,
            platforms: [.macOS],
            summary: "macOS で他のウインドウの上に浮かぶ補助ウインドウ (インスペクタなど)。macOS 専用。",
            iosAlternative: "iPad では .inspector (右側のパネル) が近い。iPhone では inspector はシートになる。"
        ),
        CatalogItem(
            id: "popovers", title: "Popovers", titleJA: "ポップオーバー", category: .presentation,
            platforms: desktopAndMobile,
            summary: "ボタンなどから吹き出しで出る小さなビュー。iPad では吹き出し、iPhone ではシートになる (presentationCompactAdaptation で吹き出しのままにもできる)。"
        ),
        CatalogItem(
            id: "scroll-views", title: "Scroll views", titleJA: "スクロールビュー", category: .presentation,
            platforms: all,
            summary: "画面に収まらない内容をスクロールして見せる。SwiftUI では ScrollView。ページ単位で止める (.paging) やスナップもできる。iOS 26 ではスクロール端で縁のガラスが透ける。"
        ),
        CatalogItem(
            id: "sheets", title: "Sheets", titleJA: "シート", category: .presentation,
            platforms: all,
            summary: "下からせり上がって親画面に重なるビュー。SwiftUI では .sheet。高さは presentationDetents で段階を指定できる。全画面にするなら .fullScreenCover。"
        ),
        CatalogItem(
            id: "windows", title: "Windows", titleJA: "ウインドウ", category: .presentation,
            platforms: all,
            summary: "アプリの内容を載せる土台。iPad では複数ウインドウを開ける (openWindow)。このアプリは UIApplicationSupportsMultipleScenes を有効にしてある。",
            note: "複数ウインドウは iPad のみ。iPhone では openWindow は使えない (supportsMultipleWindows が false)。"
        ),
    ]

    // MARK: - Selection and input

    static let selection: [CatalogItem] = [
        CatalogItem(
            id: "color-wells", title: "Color wells", titleJA: "カラーウェル", category: .selectionAndInput,
            platforms: desktopAndMobile,
            summary: "現在の色を表示し、タップするとシステムのカラーピッカーが開く。SwiftUI では ColorPicker。"
        ),
        CatalogItem(
            id: "combo-boxes", title: "Combo boxes", titleJA: "コンボボックス", category: .selectionAndInput,
            platforms: [.macOS],
            summary: "テキスト入力と選択肢一覧を兼ねた欄。macOS 専用。",
            iosAlternative: "iOS では TextField + 入力に応じた候補一覧 (List) を自作するか、Picker (.menu) と TextField を別々に置く。"
        ),
        CatalogItem(
            id: "digit-entry-views", title: "Digit entry views", titleJA: "数字入力ビュー", category: .selectionAndInput,
            platforms: [.tvOS],
            summary: "tvOS で暗証番号などの数字を 1 桁ずつ入れる専用画面。tvOS 専用。",
            iosAlternative: "iOS では TextField に .keyboardType(.numberPad) と .textContentType(.oneTimeCode) を付け、桁数分の枠を自作する。"
        ),
        CatalogItem(
            id: "image-wells", title: "Image wells", titleJA: "イメージウェル", category: .selectionAndInput,
            platforms: [.macOS],
            summary: "画像をドラッグ＆ドロップで差し替えられる枠。macOS 専用。",
            iosAlternative: "iOS では PhotosPicker で写真を選ぶか、.dropDestination でドロップを受ける。"
        ),
        CatalogItem(
            id: "pickers", title: "Pickers", titleJA: "ピッカー", category: .selectionAndInput,
            platforms: all,
            summary: "複数の選択肢から 1 つ選ぶ。SwiftUI の Picker には wheel / menu / inline / segmented / navigationLink の各スタイルがあり、日付には DatePicker がある。"
        ),
        CatalogItem(
            id: "segmented-controls", title: "Segmented controls", titleJA: "セグメンテッドコントロール", category: .selectionAndInput,
            platforms: noWatch,
            summary: "横に並んだ 2〜5 個の区分から 1 つ選ぶ。SwiftUI では Picker の .segmented スタイル。"
        ),
        CatalogItem(
            id: "sliders", title: "Sliders", titleJA: "スライダー", category: .selectionAndInput,
            platforms: all,
            summary: "範囲の中の値をつまみで選ぶ。SwiftUI では Slider。両端にアイコンを置ける。"
        ),
        CatalogItem(
            id: "steppers", title: "Steppers", titleJA: "ステッパー", category: .selectionAndInput,
            platforms: desktopAndMobile,
            summary: "+ / − で値を 1 段ずつ変える。SwiftUI では Stepper。値の範囲が小さいときに向く。"
        ),
        CatalogItem(
            id: "text-fields", title: "Text fields", titleJA: "テキストフィールド", category: .selectionAndInput,
            platforms: all,
            summary: "1 行のテキスト入力。SwiftUI では TextField / SecureField。プレースホルダ、キーボードの種類、入力内容の種類 (textContentType) を指定する。"
        ),
        CatalogItem(
            id: "toggles", title: "Toggles", titleJA: "トグル", category: .selectionAndInput,
            platforms: all,
            summary: "オン/オフの切り替え。SwiftUI では Toggle。.switch (スイッチ) と .button (押しボタン) のスタイルがある。"
        ),
        CatalogItem(
            id: "virtual-keyboards", title: "Virtual keyboards", titleJA: "仮想キーボード", category: .selectionAndInput,
            platforms: [.iOS, .iPadOS, .tvOS, .visionOS],
            summary: "画面上のキーボード。入力欄ごとに種類 (数字・メール・URL など) を指定し、返るキーの名前 (submitLabel) も合わせる。"
        ),
    ]

    // MARK: - Status

    static let status: [CatalogItem] = [
        CatalogItem(
            id: "activity-rings", title: "Activity rings", titleJA: "アクティビティリング", category: .status,
            platforms: [.watchOS],
            summary: "ムーブ・エクササイズ・スタンドの 3 重のリング。HealthKit の目標達成を表すもので、他の用途に使ってはいけない。watchOS 専用 (iOS では「フィットネス」App が表示)。",
            iosAlternative: "同じ見た目を他の用途に使うことは HIG で禁じられている。進捗をリングで見せたいなら Gauge の .accessoryCircularCapacity スタイルか Circle の trim で 1 本のリングを描く。"
        ),
        CatalogItem(
            id: "gauges", title: "Gauges", titleJA: "ゲージ", category: .status,
            platforms: [.iOS, .iPadOS, .macOS, .visionOS, .watchOS],
            summary: "範囲の中の現在値を示す (燃料計のようなもの)。SwiftUI では Gauge。線形・円形のスタイルがあり、グラデーションも付けられる。"
        ),
        CatalogItem(
            id: "progress-indicators", title: "Progress indicators", titleJA: "進捗インジケータ", category: .status,
            platforms: all,
            summary: "処理中であることを示す。終わりが分かるならバー (determinate)、分からないならスピナー (indeterminate)。SwiftUI では ProgressView。"
        ),
        CatalogItem(
            id: "rating-indicators", title: "Rating indicators", titleJA: "評価インジケータ", category: .status,
            platforms: [.macOS],
            summary: "星の数で評価を示す (ミュージックの星評価など)。macOS 専用。",
            iosAlternative: "iOS では星の Image を HStack に並べ、タップで値を変える部品を自作する。"
        ),
    ]

    // MARK: - System experiences

    static let system: [CatalogItem] = [
        CatalogItem(
            id: "app-shortcuts", title: "App Shortcuts", titleJA: "App ショートカット", category: .systemExperiences,
            platforms: [.iOS, .iPadOS, .macOS, .visionOS, .watchOS],
            summary: "アプリの機能を Siri・Spotlight・ショートカット App から呼べるようにする。App Intents で定義し、AppShortcutsProvider で登録する。このアプリは「HIG の部品数を表示」を登録してある。",
            note: "確認はショートカット App → 「HIG Catalog」を探す、または Spotlight で「HIG Catalog」と検索する。"
        ),
        CatalogItem(
            id: "complications", title: "Complications", titleJA: "コンプリケーション", category: .systemExperiences,
            platforms: [.watchOS],
            summary: "Apple Watch の文字盤に置く小さな情報表示。watchOS 専用。",
            iosAlternative: "iOS で同じ WidgetKit の仕組みを使うのはロック画面ウィジェット (accessoryCircular / accessoryRectangular / accessoryInline)。このアプリの Widget はその 3 種に対応している。"
        ),
        CatalogItem(
            id: "controls", title: "Controls", titleJA: "コントロール", category: .systemExperiences,
            platforms: [.iOS, .iPadOS],
            summary: "コントロールセンター・ロック画面・アクションボタンに置けるボタンやトグル (iOS 18+)。Widget Extension の ControlWidget で作る。このアプリには「HIG Catalog を開く」ボタンがある。",
            note: "確認はコントロールセンターを開く → 長押しで編集 → 「コントロールを追加」→ 「HIG Catalog」。"
        ),
        CatalogItem(
            id: "live-activities", title: "Live Activities", titleJA: "ライブアクティビティ", category: .systemExperiences,
            platforms: [.iOS, .iPadOS, .watchOS],
            summary: "進行中の出来事をロック画面と Dynamic Island に出す。ActivityKit で開始・更新・終了し、表示は Widget Extension が担う。entitlement は不要。",
            note: "Dynamic Island は対応 iPhone のみ。iPad ではロック画面に出る。"
        ),
        CatalogItem(
            id: "notifications", title: "Notifications", titleJA: "通知", category: .systemExperiences,
            platforms: all,
            summary: "アプリの外から知らせる。ここではローカル通知 (UNUserNotificationCenter) を使う。Push 通知は有料アカウントが要るのでこのアプリでは扱わない。",
            note: "初回に通知の許可ダイアログが出る。拒否すると設定 App から変える必要がある。"
        ),
        CatalogItem(
            id: "snippets", title: "Snippets", titleJA: "スニペット", category: .systemExperiences,
            platforms: [.iOS, .iPadOS],
            summary: "Siri やショートカットの結果として出る小さなビュー。App Intent の perform() から view を返すと表示される。このアプリの App ショートカット「HIG の部品数を表示」がスニペットを返す。",
            note: "確認はショートカット App で「HIG の部品数を表示」を実行する。"
        ),
        CatalogItem(
            id: "status-bars", title: "Status bars", titleJA: "ステータスバー", category: .systemExperiences,
            platforms: [.iOS, .iPadOS],
            summary: "画面上端の時刻・電波・電池。アプリは隠す (.statusBarHidden) ことと、背景に合わせて明暗を変えることができる。"
        ),
        CatalogItem(
            id: "top-shelf", title: "Top Shelf", titleJA: "Top Shelf", category: .systemExperiences,
            platforms: [.tvOS],
            summary: "Apple TV のホーム画面上部で、最前列のアプリが大きな画像で内容を見せる領域。tvOS 専用。",
            iosAlternative: "iOS でホーム画面にアプリの内容を見せるのは Widgets。"
        ),
        CatalogItem(
            id: "watch-faces", title: "Watch faces", titleJA: "文字盤", category: .systemExperiences,
            platforms: [.watchOS],
            summary: "Apple Watch の文字盤。アプリが作れるのは文字盤そのものではなくコンプリケーションと、文字盤を共有する機能。watchOS 専用。",
            iosAlternative: "iOS には相当するものが無い。"
        ),
        CatalogItem(
            id: "widgets", title: "Widgets", titleJA: "ウィジェット", category: .systemExperiences,
            platforms: [.iOS, .iPadOS, .macOS, .visionOS, .watchOS],
            summary: "ホーム画面・ロック画面・今日の表示に置く小さなビュー。WidgetKit と Widget Extension で作る。このアプリは小・中サイズとロック画面用を提供する。",
            note: "確認はホーム画面を長押し → 「編集」→ 「ウィジェットを追加」→ 「HIG Catalog」。"
        ),
    ]
}
