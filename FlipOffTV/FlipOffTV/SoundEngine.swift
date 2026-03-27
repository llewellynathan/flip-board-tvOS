import AVFoundation

class SoundEngine {
    private var audioPlayer: AVAudioPlayer?
    private(set) var isMuted = false

    init() {
        guard let url = Bundle.main.url(forResource: "flap", withExtension: "mp3") else {
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 0.8
        } catch {
            print("Failed to load flap audio: \(error)")
        }
    }

    func playTransition() {
        guard !isMuted, let player = audioPlayer else { return }
        player.currentTime = 0
        player.play()
    }

    @discardableResult
    func toggleMute() -> Bool {
        isMuted.toggle()
        return isMuted
    }
}
