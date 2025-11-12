import SwiftUI
import SpriteKit

struct FinalGameProcessingView: View {
    @Binding var mode: Mode
    @Binding var horseCount: Int
    @Binding var resultInfo: [Int]
    
    let horseSoundSetting = SoundSetting(forResouce: "HorseGallop", withExtension: "m4a")
    
    var body: some View {
        ZStack {
            SpriteView(scene: FinalHorseRunningScene(size: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), horseCount: horseCount, randomSecond: resultInfo))
                .ignoresSafeArea()
        }
        .onAppear {
            horseSoundSetting.playSound()
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                horseSoundSetting.player?.stop()
                mode = .Rank
            }
        }
    }
}

class FinalHorseRunningScene: SKScene {
    
    let backgroundFinish = SKSpriteNode(imageNamed: "backgroundFinish")
    private var horseArray: [SKSpriteNode?] = []
    var randomSecond: [Int] = []
    var getResult: () -> Void = {}
    
    private var horseRunningFrames: [SKTexture] = []
    var horseCount: Int = 5
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // инициализатор для получения количества лошадей
    convenience init(size: CGSize, horseCount: Int, randomSecond: [Int]) {
        self.init(size: size)
        self.horseCount = horseCount
        self.randomSecond = randomSecond
    }
    
    override func didMove(to view: SKView) {
        // настройка размера фона
        backgroundFinish.anchorPoint = CGPoint.zero
        backgroundFinish.size.width = UIScreen.main.bounds.size.width
        backgroundFinish.size.height = UIScreen.main.bounds.size.height
        backgroundFinish.zPosition = -10
        addChild(backgroundFinish)
        
        for i in 1...horseCount {
            buildHorse(number: i)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // обновление положения лошадей
        for (i, horse) in horseArray.enumerated() {
            horse?.position.x += CGFloat(UIScreen.main.bounds.size.width / CGFloat(randomSecond[i]))
        }
    }
    
    // создание атласа для лошади
    func buildHorse(number: Int) {
        let horseAnimatedAtlas = SKTextureAtlas(named: "horse\(number)Images")
        var runFrames: [SKTexture] = []
        
        let horseSpeed: Double = 40
        let numImages = horseAnimatedAtlas.textureNames.count
        
        for i in 1...numImages {
            let horseTextureName = "horse\(number)-\(i)"
            runFrames.append(horseAnimatedAtlas.textureNamed(horseTextureName))
        }
        horseRunningFrames = runFrames
        
        let firstFrameTexture = horseRunningFrames[Int.random(in: 1...2)]
        horseArray.append(SKSpriteNode(texture: firstFrameTexture))
        
        if let horseNode = horseArray[number-1] {
            horseNode.position = CGPoint(x: frame.minX - 10, y: UIScreen.main.bounds.height / CGFloat((horseCount) + 3) * CGFloat(number))
            
            horseNode.zPosition = -CGFloat(number)  // настройка zPosition, чтобы лошади позади не накладывались
            horseNode.size = CGSize(width: 188, height: 106)
            addChild(horseNode)
            
            animateHorse(number: number, speed: horseSpeed)
        }
    }
    
    // анимация движения лошади, speed - скорость движения ног лошади
    func animateHorse(number: Int, speed: Double) {
        let timePerFrame = 1 / speed
        
        // действие бега
        let runningAction = SKAction.repeatForever(SKAction.animate(with: horseRunningFrames, timePerFrame: timePerFrame))
        
        // выполнение действия
        if let horseNode = horseArray[number-1] {
            horseNode.run(SKAction.sequence([runningAction]),
                          withKey: "horse\(number)Running"
            )
        }
    }
}
