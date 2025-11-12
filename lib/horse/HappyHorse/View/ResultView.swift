import SwiftUI

struct ResultView: View {
    @AppStorage("history")
    private var resultStorage: [MatchResult] = []
    
    let restartButtonSound = SoundSetting(forResouce: "startButtonSound", withExtension: "wav")
    
    @Binding var mode: Mode
    @Binding var resultInfo: [Int]
    
    typealias RankingInfo = (horseNum: Int, second: Float)
    @State private var capsuleWidth: CGFloat = .zero
    @State private var circleWidth: CGFloat = .zero
    private var isDisabled: Bool
    
    init(mode: Binding<Mode>, resultInfo: Binding<[Int]>, isDisabled: Bool = false) {
        self._mode = mode
        self._resultInfo = resultInfo
        self.isDisabled = isDisabled
        self.rows = Array<GridItem>(repeating: GridItem(.flexible(), spacing: 8, alignment: .leading), count: 3)
        var info: [RankingInfo] = []
        for (i, value) in resultInfo.wrappedValue.enumerated() {
            info.append(RankingInfo(horseNum: i, second: Float(value) / 60.0))
        }
        
        self.rankingInfo = info.sorted { $0.second < $1.second }
    }
    
    private let rankingInfo: [RankingInfo]
    private var rows: [GridItem]
    
    private var columnCount: Int {
        (rankingInfo.count < 4) ? 1 : 2
    }
    
    @State private var gridWidth: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color(hex: "EBDCCC")
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                Spacer()
                Text("Итого")
                    .font(.title)
                Spacer()
                VStack(spacing: 15) {
                    HStack(spacing: 20) {
                        ForEach(0..<columnCount, id: \.self) { _ in
                            HStack(spacing: 15) {
                                Text("Место")
                                    .foregroundColor(.black)
                                    .font(.footnote.bold())
                                    .frame(width: circleWidth)
                                
                                HStack {
                                    Text("Лошадь")
                                        .foregroundColor(.black)
                                        .font(.footnote.bold())
                                        .frame(maxWidth: .infinity)
                                    
                                    Text("Время прохождения")
                                        .foregroundColor(.black)
                                        .font(.footnote.bold())
                                        .frame(maxWidth: .infinity)
                                }
                                .frame(width: capsuleWidth)
                            }
                        }
                    }
                    
                    RankingGridView(num: rankingInfo.count, rankingInfo: rankingInfo) { (ranking, num, second) in
                        HStack(spacing: 15) {
                            Circle()
                                .fill(Color.white)
                                .frame(maxHeight: 65)
                                .aspectRatio(1, contentMode: .fit)
                                .overlay(
                                    Text("\(ranking+1)")
                                        .foregroundColor(.black)
                                        .font(.title2.bold())
                                )
                                .modifier(SizeModifier())
                                .onPreferenceChange(SizePreferenceKey.self) { size in
                                    circleWidth = size.width
                                }
                            
                            HStack(spacing: 0) {
                                Image("horse\(num+1)\(rankingInfo.count < 4 ? "byOne" : "byTwo")")
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Capsule())
                                
                                Spacer()
                                
                                HStack(spacing: 0) {
                                    Text("№\(num + 1)")
                                        .bold()
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.3)
                                        .foregroundColor(Color(hex: "481B15"))
                                    
                                    Spacer()
                                    
                                    Text(getTimeLiteral(second))
                                        .font(.subheadline)
                                        .bold()
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                        .foregroundColor(Color(hex: "481B15"))
                                        .padding(.trailing, 30)
                                        .frame(width: 100)
                                    
                                }
                            }
                            .frame(minWidth: 180, maxWidth: 300, maxHeight: 65)
                            .background(
                                Capsule()
                                    .fill(Color.white)
                                    .modifier(SizeModifier())
                                    .onPreferenceChange(SizePreferenceKey.self) { size in
                                        capsuleWidth = size.width
                                    }
                            )
                        }
                    }
                }
                
                if !isDisabled {
                    Button {
                        withAnimation(.spring()) {
                            restartButtonSound.playSound()
                            let count = resultStorage.count
                            resultStorage.append(MatchResult(name: "Результат №\(count + 1)", resultInfo: resultInfo))
                            mode = .GameStart
                        }
                    } label: {
                        Text("Попробуй еще")
                            .font(.body.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color(hex: "481B15"))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 60)
            .padding(.vertical, 38)
        }
        .ignoresSafeArea()
    }
    
    private func getTimeLiteral(_ second: Float) -> String {
        let value = second
        let second = Int(value)
        let millisecond = value - Float(second)
        return String(second) + "s " + String(format: "%.2f", millisecond).dropFirst(2) + "ms"
    }
    
    struct RankingGridView<ItemView: View>: View {
        
        var num: Int
        var rankingInfo: [RankingInfo]
        let content: (Int, Int, Float) -> ItemView
        
        init(num: Int, rankingInfo: [RankingInfo], @ViewBuilder content: @escaping (Int, Int, Float) -> ItemView) {
            self.num = num
            self.content = content
            self.rankingInfo = rankingInfo
        }
        
        var body: some View {
            HStack(alignment: .top, spacing: 20) {
                VStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { i in
                        content(i, rankingInfo[i].horseNum, rankingInfo[i].second)
                    }
                }
                VStack(spacing: 8) {
                    ForEach(3..<5, id: \.self) { i in
                        content(i, rankingInfo[i].horseNum, rankingInfo[i].second)
                    }
                    content(0, rankingInfo[0].horseNum, rankingInfo[0].second)
                        .opacity(0)
                }
            }
        }
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct SizeModifier: ViewModifier {
    private var sizeView: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
        }
    }
    
    func body(content: Content) -> some View {
        content.background(sizeView)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct MatchResult: Codable, Hashable  {
    var name: String
    var resultInfo: [Int]
}
