## SmartRetry

Lightweight retry & resilience utility для iOS

Инструмент для надёжного выполнения сетевых запросов с контролем повторов, стратегий и валидации ответов

**SmartRetry** - это лёгкая библиотека, которая добавляет retry-механику поверх любых async/await операций и позволяет:

• автоматически повторять запросы при ошибках  
• применять стратегии backoff (linear, exponential и др.)  
• фильтровать ошибки, при которых retry допустим  
• валидировать ответы (например, на пустые данные)  
• добавлять jitter для уменьшения нагрузки  
• получать прозрачные логи выполнения  

⸻

### Возможности

• retry любых async операций  
• поддержка стратегий задержек (RetryStrategy)  
• retry по условиям (retryIf)  
• retry по валидности ответа (validate)  
• jitter (случайная задержка)  
• безопасная работа с concurrency  
• детализированное логирование  
• расширение для URLSession (one-line usage)  
• удобный API через `URLSession.shared.retry(...)`


⸻

### Установка (SPM)

.package(url: "https://github.com/yourname/SmartRetry.git", from: "1.0.0")

### Использование

Базовый пример

``` swift
let result = try await Retry.run(
    alias: "Posts API",
    strategy: .exponentialBackoff(maxRetries: 3),
    operation: {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
)
```
Интегрирован в нативный механизм `URLSession`, через extension

``` swift
let (data, _) = try await URLSession.shared.retry(
    url: url,
    strategy: .exponentialBackoff(maxRetries: 3)
)
```

Retry с фильтром ошибок

``` swift
let result = try await Retry.run(
    alias: "Timeout test",
    strategy: .linear(delays: [3, 5, 10]),
    retryIf: { error in
        (error as? URLError)?.code == .timedOut
    },
    operation: {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
)
```

Retry с валидацией ответа

``` swift
let result = try await Retry.run(
    alias: "Empty posts",
    strategy: .linear(delays: [3, 5, 10]),
    operation: {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([Post].self, from: data)
    },
    validate: { posts in
        !posts.isEmpty
    }
)
```

⸻

### Пример вывода в консоль
```
[Retry][jsonplaceholder.typicode.com/posts/1] Attempt 1
[Retry][HTTP 500] Attempt 1
[Retry][Empty posts] Attempt 1
[Retry][Timeout test] Attempt 1

[Retry][Empty posts] Validation failed
[Retry][Empty posts] 🔁 Retry in 3.00s

[Retry][Empty posts] Attempt 2
[Retry][Empty posts] Validation failed
[Retry][Empty posts] 🔁 Retry in 5.00s

[Retry][Empty posts] Attempt 3
[Retry][Empty posts] Validation failed
[Retry][Empty posts] 🛑 Max retries reached
```
Логи можно отключить через Config

⸻

### Как читать логи

Основные события:

• Attempt - начало попытки выполнения  
• Validation failed - ответ не прошёл проверку  
• 🔁 Retry in Xs - ожидание перед повтором  
• ❌ Error - ошибка сети или запроса  
• 🛑 Max retries reached - исчерпаны попытки  
• Success / validation passed - успешный результат  


⸻

### Retry стратегии

Библиотека поддерживает различные стратегии:

• linear - фиксированные задержки  
• exponential backoff - экспоненциальный рост задержек  
• custom delays - пользовательский массив задержек  
• until success - попытки до успешного результата  

Также поддерживается:

• jitter - случайное смещение задержки  
• комбинирование стратегий с лимитом попыток  

⸻

### Когда использовать

SmartRetry полезен когда:

• сеть нестабильна  
• API может возвращать временные ошибки  
• возможны пустые или некорректные ответы  
• нужно повысить надёжность UX без усложнения архитектуры  
