import Foundation

public enum RetryStrategy {
    /// fixed delays
    case custom([TimeInterval])
    /// 1, 2, 4, 8...
    case exponentialBackoff(maxRetries: Int, initial: TimeInterval = 1)
    /// constant delay
    case fixed(delay: TimeInterval, maxRetries: Int)
    /// request all the way (dangerous)
    case untilSuccess(delay: TimeInterval)
    /// N attempts without delay
    case immediate(maxRetries: Int)
    
    
    func makeDelays() -> [TimeInterval] {
        switch self {
        case .custom(let delays):
            return delays
        case .exponentialBackoff(let maxRetries, let initial):
            return (0..<maxRetries).map {
                initial * pow(2, Double($0))
            }
        case .fixed(let delay, let maxRetries):
            return Array(repeating: delay, count: maxRetries)
        case .immediate(let maxRetries):
            return Array(repeating: 0, count: maxRetries)
        case .untilSuccess(let delay):
            return Array(repeating: delay, count: 1000)
        }
    }
}
