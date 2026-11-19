import SwiftUI

@Observable
class MyPlantModel {
    
    var plants: [Plant] = []
    var sortedPlants: [Plant] {
        plants.filter { !$0.isDone } + plants.filter { $0.isDone }
    }
    var hasStarted = false
    enum Screen {case start, home, today, completed}
    
    var screen: Screen {
        if !hasStarted { return .start }
        if plants.isEmpty { return .home }
        return plants.allSatisfy(\.isDone) ? .completed : .today
    }
    
    func addPlant(_ plant: Plant) {
        if !plants.isEmpty && plants.allSatisfy(\.isDone) {
            
            for oldPlant in plants {
                PlantNotificationManager.cancel(for: oldPlant)
            }
            plants.removeAll()
        }

        plants.append(plant)
        hasStarted = true
        
        Task { await PlantNotificationManager.schedule(for: plant) }
    }
    func skip() {
        hasStarted = true
    }
    func delete(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }
        PlantNotificationManager.cancel(for: plant)
    }
    func update(_ plant: Plant) {
        if let i = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[i] = plant
            Task { await PlantNotificationManager.schedule(for: plant) }
        }
    }
    func toggle(_ plant: Plant) {
        if let i = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[i].isDone.toggle()
        }
    }
    
    var doneCount: Int {
        plants.filter { $0.isDone }.count
    }
    
    var progress: Double {
        plants.isEmpty ? 0 : Double(doneCount) / Double(plants.count)
    }
    
    var message: String {
        doneCount == 0
        ? "Your plants are waiting for a sip 💦"
        : "\(doneCount) of your plants feel loved today✨"
    }
}
