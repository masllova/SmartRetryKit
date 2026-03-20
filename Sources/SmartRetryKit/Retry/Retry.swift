import Foundation

public struct Retry {
    public static func run<T>(
        alias: String? = nil,
        strategy: RetryStrategy,
        jitter: Bool? = nil,
        retryIf: ((Error) -> Bool)? = nil,
        operation: @escaping () async throws -> T,
        validate: ((T) -> Bool)? = nil
    ) async throws -> T {
        let delays = strategy.makeDelays()
        let useJitter = jitter ?? strategy.defaultJitter
        var lastError: Error?
        
        for (index, baseDelay) in delays.enumerated() {
            do {
                await log(alias, "🚀 Attempt \(index + 1)")
                let result = try await operation()
                
                if let validate = validate {
                    if validate(result) {
                        await log(alias, "✅ Success")
                        return result
                    } else {
                        await log(alias, "⚠️ Validation failed")
                        lastError = RetryError.maxRetriesReached
                    }
                } else {
                    await log(alias, "✅ Success")
                    return result
                }
            } catch {
                if let retryIf = retryIf, !retryIf(error) {
                    await log(alias, "🛑 Not retrying error: \(error)")
                    throw error
                }
                await log(alias, "❌ Error: \(error)")
                lastError = error
            }
            if index < delays.count - 1 {
                var delay = baseDelay
  
                if useJitter && delay > 0 {
                    let jitterValue = Double.random(in: 0...0.3)
                    delay += jitterValue
                }
                if delay > 0 {
                    await log(alias, "🔁 Retry in \(format(delay))")
                    try await sleep(seconds: delay)
                } else {
                    await log(alias, "🔁 Retry immediately")
                }
            }
        }
        await log(alias, "🛑 Max retries reached")
        throw lastError ?? RetryError.maxRetriesReached
    }
}
