actor RetryConfig {
    static let shared = RetryConfig()
    
    private(set) var isLoggingEnabled: Bool = true
    
    func setLogging(_ enabled: Bool) {
        isLoggingEnabled = enabled
    }
    func getLogging() -> Bool {
        isLoggingEnabled
    }
}
