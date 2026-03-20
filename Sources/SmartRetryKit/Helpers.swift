import Foundation

private extension Retry {
    static func sleep(seconds: TimeInterval) async throws {
        try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
    
    static func log(_ message: String) {
        guard isLoggingEnabled else { return }
        print("[Retry] \(message)")
    }
    
    static func format(_ value: TimeInterval) -> String {
        String(format: "%.1fs", value)
    }
}
