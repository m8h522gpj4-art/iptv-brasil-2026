import Foundation

final class ConfigManager {
    static let shared = ConfigManager()
    private init() {}

    private let fileName = "config.json"
    private var configURL: URL? {
        let fm = FileManager.default
        do {
            let appSupport = try fm.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            if !fm.fileExists(atPath: appSupport.path) {
                try fm.createDirectory(at: appSupport, withIntermediateDirectories: true)
            }
            return appSupport.appendingPathComponent(fileName)
        } catch {
            return nil
        }
    }

    func ensureConfigExists() throws {
        guard let dest = configURL else { throw NSError(domain: "Config", code: 1) }
        let fm = FileManager.default
        if !fm.fileExists(atPath: dest.path) {
            if let bundleURL = Bundle.main.url(forResource: "default_config", withExtension: "json") {
                try fm.copyItem(at: bundleURL, to: dest)
            } else {
                throw NSError(domain: "Config", code: 2, userInfo: [NSLocalizedDescriptionKey: "default_config.json missing in bundle"]) 
            }
        }
    }

    func loadConfig() throws -> [String: Any] {
        guard let url = configURL else { throw NSError(domain: "Config", code: 3) }
        let data = try Data(contentsOf: url)
        let obj = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dict = obj as? [String: Any] else { throw NSError(domain: "Config", code: 4) }
        return dict
    }

    func saveConfig(_ dict: [String: Any]) throws {
        guard let url = configURL else { throw NSError(domain: "Config", code: 5) }
        let data = try JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
        try data.write(to: url, options: [.atomic])
    }

    // Simple migration example — extend for real schema changes
    func migrateIfNeeded() throws {
        var config = try loadConfig()
        let currentVersion = config["configVersion"] as? Int ?? 1
        let targetVersion = 1
        if currentVersion < targetVersion {
            // perform migrations incrementally
            // e.g., if currentVersion == 1 { do changes; currentVersion = 2 }
            config["configVersion"] = targetVersion
            try saveConfig(config)
        }
    }
}
