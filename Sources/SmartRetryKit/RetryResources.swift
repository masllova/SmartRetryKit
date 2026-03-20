enum RetryResources {
    static let success = "Success"
    static let validationFailed = "Validation failed"
    static let maxRetries = "🛑 Max retries reached"
    static let retryImmediately = "🔁 Retry immediately"
    
    static func makeLog(alias: String?, message: String) -> String {
        "[Retry][\(alias ?? "request")] \(message)"
    }
    
    static func makeAttemptInfo(index: Int) -> String {
        "Attempt \(index)"
    }
    
    static func makeError(_ error: Error) -> String {
        "❌ Error: \(error)"
    }
    
    static func makeNotRetryingError(_ error: Error) -> String {
        "🛑 Not retrying error: \(error)"
    }
    
    static func makeRetryInfo(_ info: String) -> String {
        "🔁 Retry in \(info)"
    }
}
