import Foundation

public struct Retry {
    public static var isLoggingEnabled = true
    
    public static func run<T>(
        delays: [TimeInterval],
        operation: @escaping () async throws -> T,
        validate: ((T) -> Bool)? = nil
    ) async throws -> T {
        var lastError: Error?
        
        for (index, delay) in delays.enumerated() {
            do {
                log("🚀 Attempt \(index + 1)")
                let result = try await operation()
                
                if let validate = validate {
                    if validate(result) {
                        log("✅ Success on attempt \(index + 1)")
                        return result
                    } else {
                        log("⚠️ Invalid result (validation failed)")
                        lastError = RetryError.maxRetriesReached
                    }
                } else {
                    log("✅ Success on attempt \(index + 1)")
                    return result
                }
            } catch {
                log("❌ Error on attempt \(index + 1): \(error)")
                lastError = error
            }
            if index < delays.count - 1 {
                log("🔁 Retry in \(format(delay))")
                try await sleep(seconds: delay)
            }
        }
        log("🛑 Max retries reached")
        throw lastError ?? RetryError.maxRetriesReached
    }
}
