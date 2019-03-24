import AVFoundation

var mediaPlayer: AVAudioPlayer?

public func playSound(name: String) {
    guard let sound = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
    do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)            
        try AVAudioSession.sharedInstance().setActive(true)
        mediaPlayer = try AVAudioPlayer(contentsOf: sound, fileTypeHint: AVFileType.mp3.rawValue)
        if let player = mediaPlayer { 
            player.play() 
        }
    } catch let error {

    }
}