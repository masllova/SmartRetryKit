import Foundation

extension Retry {
    static func sleep(seconds: TimeInterval) async throws {
        try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
    
    static func log(_ alias: String?, _ message: String) async {
        let isEnabled = await RetryConfig.shared.getLogging()
        guard isEnabled else { return }
        
        print("[Retry][\(alias ?? "request")] \(message)")
    }
    
    static func format(_ value: TimeInterval) -> String {
        String(format: "%.2fs", value)
    }
}
