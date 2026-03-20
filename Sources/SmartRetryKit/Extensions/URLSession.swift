import Foundation

public extension URLSession {
    func retry(
        from url: URL,
        alias: String? = nil,
        strategy: RetryStrategy,
        jitter: Bool? = nil,
        retryIf: ((Error) -> Bool)? = nil,
        validate: ((Data) -> Bool)? = nil
    ) async throws -> (Data, URLResponse) {
        try await Retry.run(
            alias: alias ?? "\(url.host ?? "")\(url.path)",
            strategy: strategy,
            jitter: jitter,
            retryIf: retryIf
        ) {
            let (data, response) = try await self.data(from: url)
            
            if let validate = validate {
                if !validate(data) {
                    throw RetryError.maxRetriesReached
                }
            }
            return (data, response)
        }
    }
}
