import Foundation

public struct Retry {
    public static func run<T>(
        alias: String? = nil,
        strategy: RetryStrategy,
        operation: @escaping () async throws -> T,
        validate: ((T) -> Bool)? = nil
    ) async throws -> T {
        
        let delays = strategy.makeDelays()
        
        var lastError: Error?
        
        for (index, delay) in delays.enumerated() {
            do {
                print(alias ?? "", "🚀 Attempt \(index + 1)")
                
                let result = try await operation()
                
                if let validate = validate {
                    if validate(result) {
                        print(alias ?? "", "✅ Success")
                        return result
                    } else {
                        print(alias ?? "", "⚠️ Validation failed")
                        lastError = RetryError.maxRetriesReached
                    }
                } else {
                    print(alias ?? "", "✅ Success")
                    return result
                }
                
            } catch {
                print(alias ?? "", "❌ Error: \(error)")
                lastError = error
            }
            
            if index < delays.count - 1 {
                if delay > 0 {
                    print(alias ?? "", "🔁 Retry in \(format(delay))")
                    try await sleep(seconds: delay)
                } else {
                    print(alias ?? "", "🔁 Retry immediately")
                }
            }
        }
        
        print(alias ?? "", "🛑 Max retries reached")
        throw lastError ?? RetryError.maxRetriesReached
    }
}
