actor RetryConfig {
    static let shared = RetryConfig()
    
    private(set) var isLoggingEnabled: Bool = false
    
    func setLogging(_ enabled: Bool) {
        isLoggingEnabled = enabled
    }
    func getLogging() -> Bool {
        isLoggingEnabled
    }
}
