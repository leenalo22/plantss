import UserNotifications

enum PlantNotificationManager {
    static func schedule(for plant: Plant) async {
        let center = UNUserNotificationCenter.current()

        do {
            let allowed = try await center.requestAuthorization(
                options: [.alert, .sound]
            )
            guard allowed else { return }

            let content = UNMutableNotificationContent()
            content.title = "Planto"
            content.body = "Hey! Let's water your \(plant.name) 🌱"
            content.sound = .default

            let days: Double
            switch plant.days {
            case "Every 2 days": days = 2
            case "Every 3 days": days = 3
            case "Once a week": days = 7
            case "Every 10 days": days = 10
            case "Every 2 weeks": days = 14
            default: days = 1
            }

            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: days * 24 * 60 * 60,
                repeats: true
            )
            let request = UNNotificationRequest(
                identifier: "plant-\(plant.id.uuidString)",
                content: content,
                trigger: trigger
            )

            try await center.add(request)
        } catch {
            print("Notification error: \(error)")
        }
    }

    static func cancel(for plant: Plant) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: ["plant-\(plant.id.uuidString)"]
            )
    }
}
