import SwiftUI
import AVKit

struct PlayerView: View {
    @State private var player: AVPlayer? = nil
    let url: URL

    var body: some View {
        VStack {
            if let player = player {
                VideoPlayer(player: player)
                    .onAppear { player.play() }
                    .onDisappear { player.pause() }
            } else {
                Text("Carregando player...")
            }
        }
        .onAppear {
            player = AVPlayer(url: url)
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(url: URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8")!)
    }
}
