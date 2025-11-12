import AVKit

class SoundSetting {
    var player: AVAudioPlayer?
    let forResource: String
    let withExtension: String
    
    init(forResouce: String, withExtension: String) {
        self.forResource = forResouce
        self.withExtension = withExtension
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: forResource, withExtension: withExtension) else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            
            if forResource == "casino" {
                player?.numberOfLoops = 100
                player?.volume = 0.3
            }
            
        } catch let error {
            print("\(error.localizedDescription)")
        }
        
    }
    
    func stopSound() {
        guard let url = Bundle.main.url(forResource: forResource, withExtension: withExtension) else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.stop()
            
        } catch let error {
            print("\(error.localizedDescription)")
        }
        
    }
}
