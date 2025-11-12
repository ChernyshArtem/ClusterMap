import SwiftUI

struct GameStartView: View {
    @Binding var mode: Mode
    @Binding var horseCount: Int
    
    let startButtonSound = SoundSetting(forResouce: "startButtonSound", withExtension: "wav")
    let changeButtonSound = SoundSetting(forResouce: "changeSound", withExtension: "wav")
    let negativeSound = SoundSetting(forResouce: "negativeSound", withExtension: "wav")
    
    var body: some View {
        ZStack {
            Image("startBgImg")
                .resizable()
                .ignoresSafeArea()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 70)
                .scaledToFill().clipped()
            
            VStack {
                Spacer()
                HStack(spacing: 0) {
                    ForEach(1...horseCount, id:\.self) { num in
                        VStack {
                            Image("horse\(num)").resizable()
                                .frame(maxHeight: 200, alignment: .center)
                                .scaledToFit()
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
                
                Text("Пожалуйста, запомните свою лошадь до начала игры!")
                    .font(.system(size: 20, weight: .heavy))
                    .foregroundColor(Color("startBtnColor"))
                Button {
                    startButtonSound.playSound()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            mode = .Game
                        }
                    }
                    
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 92, height: 37, alignment: .center)
                        .foregroundColor(Color("startBtnColor"))
                        .overlay(
                            Text("СТАРТ")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .heavy))
                        )
                        .padding()
                }
                .padding(.bottom, 60)
            }
        }
        .onTapGesture {
            self.endTextEditing()
        }
    }
}
