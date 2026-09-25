import UserNotifications

/// Prepends the event's device-local date to the provider's fallback body.
final class NotificationService: UNNotificationServiceExtension {
    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var originalContent: UNNotificationContent?
    private var mutableContent: UNMutableNotificationContent?

    override func didReceive(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void
    ) {
        self.contentHandler = contentHandler
        originalContent = request.content
        mutableContent = request.content.mutableCopy() as? UNMutableNotificationContent

        if let content = mutableContent,
           let prefix = Self.localDatePrefix(userInfo: content.userInfo) {
            content.body = content.body.isEmpty ? prefix : "\(prefix) · \(content.body)"
        }

        deliver()
    }

    override func serviceExtensionTimeWillExpire() {
        deliver()
    }

    private func deliver() {
        guard let handler = contentHandler else { return }
        contentHandler = nil
        handler(mutableContent ?? originalContent ?? UNNotificationContent())
    }

    private static func localDatePrefix(userInfo: [AnyHashable: Any]) -> String? {
        let data = additionalData(userInfo: userInfo)
        guard data["type"] as? String == "event-created",
              let raw = data["eventDate"] as? String,
              let date = parseISO8601(raw) else { return nil }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "d MMM"

        let timeFormatter = DateFormatter()
        timeFormatter.locale = .current
        timeFormatter.timeZone = .current
        timeFormatter.dateFormat = "HH:mm"

        return "\(dateFormatter.string(from: date)), \(timeFormatter.string(from: date))"
    }

    /// OneSignal nests custom payload data under `custom.a`.
    private static func additionalData(userInfo: [AnyHashable: Any]) -> [AnyHashable: Any] {
        if let custom = userInfo["custom"] as? [AnyHashable: Any],
           let additional = custom["a"] as? [AnyHashable: Any] {
            return additional
        }
        return userInfo
    }

    private static func parseISO8601(_ value: String) -> Date? {
        let fractional = ISO8601DateFormatter()
        fractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = fractional.date(from: value) { return date }

        let plain = ISO8601DateFormatter()
        plain.formatOptions = [.withInternetDateTime]
        return plain.date(from: value)
    }
}
