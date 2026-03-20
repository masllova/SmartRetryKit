import Foundation

public struct Retry {
    public static func run<T>(
        delays: [TimeInterval],
        operation: @escaping () async throws -> T,
        validate: ((T) -> Bool)? = nil
    ) async throws -> T {
        var lastError: Error?
        
        for (index, delay) in delays.enumerated() {
            do {
                print("🚀 Attempt \(index + 1)")
                let result = try await operation()
                
                if let validate = validate {
                    if validate(result) {
                        print("✅ Success on attempt \(index + 1)")
                        return result
                    } else {
                        print("⚠️ Invalid result (validation failed)")
                        lastError = RetryError.maxRetriesReached
                    }
                } else {
                    print("✅ Success on attempt \(index + 1)")
                    return result
                }
            } catch {
                print("❌ Error on attempt \(index + 1): \(error)")
                lastError = error
            }
            if index < delays.count - 1 {
                print("🔁 Retry in \(format(delay))")
                try await sleep(seconds: delay)
            }
        }
        print("🛑 Max retries reached")
        throw lastError ?? RetryError.maxRetriesReached
    }
}
