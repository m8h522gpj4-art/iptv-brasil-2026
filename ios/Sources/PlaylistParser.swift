import Foundation

struct PlaylistEntry: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: String // "m3u", "hls", "json"
    let url: String
}

final class PlaylistParser {
    static func parse(config: [String: Any]) -> [PlaylistEntry] {
        guard let playlists = config["playlists"] as? [[String: Any]] else { return [] }
        return playlists.compactMap { item in
            guard let name = item["name"] as? String,
                  let type = item["type"] as? String,
                  let url = item["url"] as? String else { return nil }
            return PlaylistEntry(name: name, type: type, url: url)
        }
    }

    // Minimal m3u parser — returns array of (title, url)
    static func parseM3U(data: String) -> [(String, String)] {
        var result: [(String, String)] = []
        let lines = data.components(separatedBy: .newlines)
        var currentTitle: String? = nil
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespaces)
            if trimmed.isEmpty { continue }
            if trimmed.hasPrefix("#EXTINF") {
                if let commaIndex = trimmed.firstIndex(of: ",") {
                    let title = String(trimmed[trimmed.index(after: commaIndex)...]).trimmingCharacters(in: .whitespaces)
                    currentTitle = title
                }
            } else if trimmed.hasPrefix("#") {
                continue
            } else {
                let url = trimmed
                let title = currentTitle ?? url
                result.append((title, url))
                currentTitle = nil
            }
        }
        return result
    }
}
