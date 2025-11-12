import SwiftUI

struct HistoryView: View {
    @AppStorage("history")
    private var resultStorage: [MatchResult] = []

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "EBDCCC")
                    .ignoresSafeArea()
                ScrollView {
                    if resultStorage.isEmpty {
                        Text("Тут пока пусто, попробуйте сыграть для отображения истории")
                    } else {
                        ForEach(resultStorage, id: \.self) { result in
                            NavigationLink(destination: ResultView(mode: .constant(.Rank), resultInfo: .constant(result.resultInfo), isDisabled: true).toolbar(.hidden, for: .tabBar)) {
                                Text(result.name)
                                    .frame(width: 300)
                                    .padding(16)
                                    .background(.white)
                                    .foregroundColor(.black)
                                    .font(.system(size: 16, weight: .heavy))
                                    .cornerRadius(16)
                                    .padding(4)
                            }
                        }
                    }
                }
            }
            .navigationTitle("История")
        }
        .navigationViewStyle(.stack)
    }
}
