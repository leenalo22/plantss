# Planto 🌱

<img width="716" height="359" alt="Planto banner" src="https://github.com/user-attachments/assets/f2d0697c-cc68-4b57-bb33-3ca4ec7124f6" />

A simple iOS app that reminds you to water your plants, so they all stay happy and healthy.

## Description

Planto keeps all your plants in one place. Add a plant with its room, light needs, watering schedule, and water amount, and Planto will remind you when it's time to water it. Each day you can see your plants in one list, check them off as you water them, and follow your progress with a progress bar. When every plant is watered, Planto celebrates with an "All Done" screen 🎉.

## Main Features

- **Add a plant reminder:** set the plant's name, room, light, watering days, and water amount.
- **Today's reminders:** see all your plants in one list, with a progress bar showing how many you've watered.
- **Mark as watered:** tap the circle next to a plant to check it off.
- **Edit a reminder:** tap a plant to change its details.
- **Delete a reminder:** swipe left on a plant, or use "Delete Reminder" on the edit screen.
- **All Done screen:** when every plant is watered, you see a celebration screen. Adding a new plant after that starts a fresh list.
- **Watering notifications:** you get a local notification based on each plant's watering schedule (every day, every 2 days, once a week, etc.).

## Technologies Used

- Swift & SwiftUI
- MVVM architecture
- Observation (`@Observable`) for shared app state
- UserNotifications for local reminders

## Known Limitations

- Plants are not saved after closing the app yet.
- The watered check doesn't reset automatically each day yet.

## Contact

- Leen Alotaibi — [GitHub](https://github.com/leenalo22)
