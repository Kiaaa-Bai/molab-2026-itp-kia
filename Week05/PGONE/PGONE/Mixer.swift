import AVFoundation
import SwiftUI

let files = ["bass.mp3", "drums.mp3", "metronome.mp3", "other.mp3", "vocals.mp3"]
let emojis = ["🔉", "🥁", "⏱️", "🎹", "🎤"]
let xs = [80.0, 320.0, 280.0, 120.0, 200.0]
let ys = [150.0, 150.0, 300.0, 300.0, 60.0]
let colors = [
    Color(red: 1.0, green: 0.39, blue: 0.39),
    Color(red: 1.0, green: 0.59, blue: 0.39),
    Color(red: 1.0, green: 0.78, blue: 0.39),
    Color(red: 0.59, green: 0.78, blue: 1.0),
    Color(red: 0.39, green: 0.59, blue: 1.0)
]

@Observable
class Mixer {
    var players: [AVAudioPlayer?] = []
    var volumes = [0.5, 0.5, 0.5, 0.5, 0.5]

    init() {
        for file in files {
            let player = loadBundleAudio(file)
            player?.numberOfLoops = -1
            player?.volume = 0.5
            players.append(player)
        }
    }

    func apply() {
        for i in 0..<players.count {
            players[i]?.volume = Float(volumes[i])
        }
    }

    func play() {
        for player in players {
            player?.play()
        }
    }

    func loadBundleAudio(_ fileName: String) -> AVAudioPlayer? {
        let path = Bundle.main.path(forResource: fileName, ofType: nil)!
        let url = URL(fileURLWithPath: path)
        do {
            return try AVAudioPlayer(contentsOf: url)
        } catch {
            print("loadBundleAudio error", error)
        }
        return nil
    }
}
