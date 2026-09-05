import SwiftUI

struct ContentView: View {
    @State private var entries: [PlaylistEntry] = []
    @State private var selectedURL: URL?
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            List(entries) { entry in
                Button(action: { open(entry: entry) }) {
                    HStack {
                        Text(entry.name)
                        Spacer()
                        Text(entry.type.uppercased()).font(.caption).foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("IPTV Brasil")
            .onAppear(perform: load)

            Text("Selecione um canal")
        }
        .sheet(item: $selectedURL) { url in
            PlayerView(url: url)
        }
        .alert(item: Binding(get: {
            errorMessage.map { ErrorWrapper(message: $0) }
        }, set: { _ in errorMessage = nil })) { wrapper in
            Alert(title: Text("Erro"), message: Text(wrapper.message), dismissButton: .default(Text("OK")))
        }
    }

    func load() {
        do {
            try ConfigManager.shared.ensureConfigExists()
            let config = try ConfigManager.shared.loadConfig()
            let parsed = PlaylistParser.parse(config: config)
            entries = parsed
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func open(entry: PlaylistEntry) {
        guard let url = URL(string: entry.url) else { errorMessage = "URL inválida"; return }
        if entry.type.lowercased() == "m3u" {
            // fetch and parse m3u
            URLSession.shared.dataTask(with: url) { data, resp, err in
                if let data = data, let text = String(data: data, encoding: .utf8) {
                    let list = PlaylistParser.parseM3U(data: text)
                    DispatchQueue.main.async {
                        if let first = list.first, let u = URL(string: first.1) {
                            selectedURL = u
                        } else {
                            errorMessage = "Nenhum stream encontrado no M3U"
                        }
                    }
                } else {
                    DispatchQueue.main.async { errorMessage = err?.localizedDescription ?? "Erro ao baixar M3U" }
                }
            }.resume()
        } else {
            selectedURL = url
        }
    }
}

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let message: String
}
