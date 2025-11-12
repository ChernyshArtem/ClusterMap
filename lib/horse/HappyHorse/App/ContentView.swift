import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    @State private var mode: Mode = .GameStart
    @State private var resultInfo: [Int] = []
    @State private var tab: Int = 0
    private let horseCount: Int = 5
    
    let BGM = SoundSetting(forResouce: "casino", withExtension: "wav")
    
    var body: some View {
        TabView(selection: $tab) {
            Tab("Игра", systemImage: "tray.and.arrow.down.fill", value: 0) {
                switch mode {
                case .GameStart:
                    GameStartView(mode: $mode, horseCount: .constant(horseCount))
                case .Game:
                    FinalGameProcessingView(mode: $mode, horseCount: .constant(horseCount), resultInfo: $resultInfo)
                        .toolbar(.hidden, for: .tabBar)
                case .Rank:
                    ResultView(mode: $mode, resultInfo: $resultInfo)
                        .toolbar(.hidden, for: .tabBar)
                }
            }
            
            
            Tab("История", systemImage: "tray.and.arrow.up.fill", value: 1) {
                HistoryView()
            }
        }
        .onChange(of: scenePhase) { actualPhase in
            switch actualPhase {
            case .active:
                BGM.playSound()
            default:
                BGM.stopSound()
            }
        }
        .onChange(of: mode, perform: { newValue in
            if newValue == .GameStart || newValue == .Game {
                setNewSpeed()
            }
        })
    }
    
    private func setNewSpeed() {
        resultInfo = []
        for _ in 1...horseCount {
            resultInfo.append((300...600).randomElement() ?? 60 )
        }
    }
}

enum Mode {
    case GameStart
    case Game
    case Rank
}
