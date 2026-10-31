import SwiftUI
import UIKit
import PhotosUI

// MARK: - Color wells

struct ColorWellsDemo: View {
    @State private var color: Color = .blue
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ColorPicker("色を選ぶ (ColorPicker)", selection: $color)
            ColorPicker("不透明度なし", selection: $color, supportsOpacity: false)
            RoundedRectangle(cornerRadius: 12).fill(color).frame(height: 60)
                .onChange(of: color) { _, _ in qlog(.debug, "colorwell", "色を変更") }
        }
    }
}

// MARK: - Combo boxes (macOS)

struct ComboBoxesDemo: View {
    @State private var text = ""
    private let candidates = ["東京", "大阪", "名古屋", "札幌", "福岡", "仙台", "広島"]
    private var matches: [String] {
        text.isEmpty ? candidates : candidates.filter { $0.contains(text) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("iOS で自作する場合の例: 入力欄 + 候補一覧。候補をタップすると入力欄に入ります。")
            TextField("都市名を入力", text: $text)
                .textFieldStyle(.roundedBorder)
            VStack(alignment: .leading, spacing: 0) {
                ForEach(matches, id: \.self) { c in
                    Button {
                        text = c
                        qlog(.info, "combobox", "候補を選択: \(c)")
                    } label: {
                        Text(c).frame(maxWidth: .infinity, alignment: .leading).padding(8)
                    }
                    .buttonStyle(.plain)
                    Divider()
                }
            }
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
        }
    }
}

// MARK: - Digit entry views (tvOS)

struct DigitEntryViewsDemo: View {
    @State private var code = ""
    @FocusState private var focused: Bool
    private let length = 4

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("iOS で自作する場合の例: 隠した TextField に数字キーボードで入力し、桁の枠を描く。")
            ZStack {
                TextField("", text: $code)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .focused($focused)
                    .opacity(0.01)
                    .frame(width: 1, height: 1)
                HStack(spacing: 12) {
                    ForEach(0..<length, id: \.self) { i in
                        let chars = Array(code)
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(focused && i == min(chars.count, length - 1) ? Color.accentColor : .secondary, lineWidth: 2)
                            .frame(width: 48, height: 56)
                            .overlay(Text(i < chars.count ? String(chars[i]) : "").font(.title))
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture { focused = true }
            }
            .onChange(of: code) { _, new in
                let digits = new.filter(\.isNumber)
                code = String(digits.prefix(length))
                if code.count == length { qlog(.info, "digitentry", "入力完了: \(code)") }
            }
            Button("クリア") { code = "" }.buttonStyle(.bordered)
        }
    }
}

// MARK: - Image wells (macOS)

struct ImageWellsDemo: View {
    @State private var selected: PhotosPickerItem?
    @State private var image: Image?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoCaption("iOS では PhotosPicker で写真を選びます。")
            PhotosPicker(selection: $selected, matching: .images) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
                        .foregroundStyle(.secondary)
                        .frame(width: 160, height: 120)
                    if let image {
                        image.resizable().scaledToFill()
                            .frame(width: 160, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        VStack {
                            Image(systemName: "photo.badge.plus").font(.largeTitle)
                            Text("写真を選ぶ").font(.caption)
                        }
                        .foregroundStyle(.secondary)
                    }
                }
            }
            .onChange(of: selected) { _, item in
                guard let item else { return }
                Task {
                    if let data = try? await item.loadTransferable(type: Data.self), let ui = UIImage(data: data) {
                        image = Image(uiImage: ui)
                        qlog(.info, "imagewell", "写真を読み込み: \(data.count) bytes")
                    } else {
                        qlog(.warning, "imagewell", "写真の読み込みに失敗")
                    }
                }
            }
        }
    }
}

// MARK: - Pickers

struct PickersDemo: View {
    @State private var fruit = "りんご"
    @State private var date = Date()
    private let fruits = ["りんご", "みかん", "ぶどう", "もも"]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DemoHeading("Picker (.menu)")
            Picker("果物", selection: $fruit) { ForEach(fruits, id: \.self) { Text($0) } }
                .pickerStyle(.menu)
            DemoHeading("Picker (.wheel)")
            Picker("果物", selection: $fruit) { ForEach(fruits, id: \.self) { Text($0) } }
                .pickerStyle(.wheel)
                .frame(height: 100)
            DemoHeading("Picker (.inline)")
            Picker("果物", selection: $fruit) { ForEach(fruits, id: \.self) { Text($0) } }
                .pickerStyle(.inline)
            DemoHeading("DatePicker")
            DatePicker("日時", selection: $date)
            DatePicker("日付 (graphical)", selection: $date, displayedComponents: .date)
                .datePickerStyle(.graphical)
            DemoCaption("選択: \(fruit) / \(date.formatted(date: .abbreviated, time: .shortened))")
        }
        .onChange(of: fruit) { _, v in qlog(.info, "pickers", "果物: \(v)") }
    }
}

// MARK: - Segmented controls

struct SegmentedControlsDemo: View {
    @State private var view = 0
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("表示", selection: $view) {
                Text("日").tag(0)
                Text("週").tag(1)
                Text("月").tag(2)
                Text("年").tag(3)
            }
            .pickerStyle(.segmented)
            Picker("", selection: $view) {
                Image(systemName: "list.bullet").tag(0)
                Image(systemName: "square.grid.2x2").tag(1)
                Image(systemName: "map").tag(2)
                Image(systemName: "calendar").tag(3)
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 240)
            DemoCaption("選択: \(view)")
                .onChange(of: view) { _, v in qlog(.info, "segmented", "選択: \(v)") }
        }
    }
}

// MARK: - Sliders

struct SlidersDemo: View {
    @State private var value = 0.5
    @State private var stepped = 5.0
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Slider(value: $value)
            Slider(value: $value) {
                Text("音量")
            } minimumValueLabel: {
                Image(systemName: "speaker")
            } maximumValueLabel: {
                Image(systemName: "speaker.wave.3")
            }
            Slider(value: $stepped, in: 0...10, step: 1) { Text("段階") }
            DemoCaption(String(format: "値: %.2f / 段階: %.0f", value, stepped))
        }
        .onChange(of: value) { _, v in qlog(.debug, "slider", String(format: "%.2f", v)) }
    }
}

// MARK: - Steppers

struct SteppersDemo: View {
    @State private var count = 1
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Stepper("数量: \(count)", value: $count, in: 0...10)
            Stepper("2 ずつ: \(count)", value: $count, in: 0...10, step: 2)
            Stepper(onIncrement: {
                count += 1
                qlog(.debug, "stepper", "+1 → \(count)")
            }, onDecrement: {
                count -= 1
                qlog(.debug, "stepper", "-1 → \(count)")
            }) {
                Text("ラベルをカスタム")
            }
        }
    }
}

// MARK: - Text fields

struct TextFieldsDemo: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var multi = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("名前 (.roundedBorder)", text: $name)
                .textFieldStyle(.roundedBorder)
                .textContentType(.name)
            TextField("メール (.plain)", text: $email)
                .textFieldStyle(.plain)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .textInputAutocapitalization(.never)
                .padding(8)
                .background(.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
            SecureField("パスワード (SecureField)", text: $password)
                .textFieldStyle(.roundedBorder)
            TextField("複数行に伸びる (axis: .vertical)", text: $multi, axis: .vertical)
                .lineLimit(2...5)
                .textFieldStyle(.roundedBorder)
            DemoHeading("Form の中では")
            Form {
                TextField("名前", text: $name)
                TextField("メール", text: $email)
                    .keyboardType(.emailAddress)
            }
            .frame(height: 140)
            .scrollDisabled(true)
        }
        .onSubmit { qlog(.info, "textfield", "Return") }
    }
}

// MARK: - Toggles

struct TogglesDemo: View {
    @State private var a = true
    @State private var b = false
    @State private var c = true
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Toggle("スイッチ (.switch)", isOn: $a)
            Toggle(isOn: $b) { Label("ボタン型 (.button)", systemImage: "bold") }
                .toggleStyle(.button)
            Toggle("色付き", isOn: $c).tint(.green)
            Toggle("無効", isOn: .constant(true)).disabled(true)
        }
        .onChange(of: a) { _, v in qlog(.info, "toggle", "switch: \(v)") }
        .onChange(of: b) { _, v in qlog(.info, "toggle", "button: \(v)") }
    }
}

// MARK: - Virtual keyboards

struct VirtualKeyboardsDemo: View {
    struct KB: Identifiable {
        let id: String
        let type: UIKeyboardType
    }

    private let kinds: [KB] = [
        .init(id: "default", type: .default),
        .init(id: "numberPad", type: .numberPad),
        .init(id: "decimalPad", type: .decimalPad),
        .init(id: "phonePad", type: .phonePad),
        .init(id: "emailAddress", type: .emailAddress),
        .init(id: "URL", type: .URL),
        .init(id: "numbersAndPunctuation", type: .numbersAndPunctuation),
        .init(id: "asciiCapable", type: .asciiCapable),
    ]
    @State private var selected = "default"
    @State private var text = ""
    @State private var submitLabel = 0
    @FocusState private var focused: Bool

    private var current: UIKeyboardType { kinds.first { $0.id == selected }?.type ?? .default }
    private var label: SubmitLabel {
        switch submitLabel {
        case 1: return .search
        case 2: return .go
        case 3: return .send
        default: return .done
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("キーボードの種類", selection: $selected) {
                ForEach(kinds) { Text($0.id).tag($0.id) }
            }
            .pickerStyle(.menu)
            Picker("Return キー", selection: $submitLabel) {
                Text("done").tag(0)
                Text("search").tag(1)
                Text("go").tag(2)
                Text("send").tag(3)
            }
            .pickerStyle(.segmented)
            TextField("ここをタップしてキーボードを出す", text: $text)
                .textFieldStyle(.roundedBorder)
                .keyboardType(current)
                .submitLabel(label)
                .focused($focused)
                .id(selected + "\(submitLabel)")
                .onSubmit { qlog(.info, "keyboard", "submit (\(selected))") }
            HStack {
                Button("キーボードを出す") { focused = true }
                Button("閉じる") { focused = false }
            }
            .buttonStyle(.bordered)
        }
        .onChange(of: selected) { _, v in qlog(.info, "keyboard", "種類: \(v)") }
    }
}
