import SwiftUI

@Observable
class MyPlantModel {
  // يخزّن قائمة النباتات
    var plants: [Plant] = []
    var hasStarted = false
    // يحدد هل بدأ المستخدم استخدام التطبيق
    enum Screen {case start, home, today, completed}

    var screen: Screen {
        if !hasStarted { return .start }
        if plants.isEmpty { return .home }
        return plants.allSatisfy(\.isDone) ? .completed : .today
    }
    // يضيف نبتة ويحدد أن التطبيق بدأ
    func addPlant(_ plant: Plant) {
        plants.append(plant)
        hasStarted = true
    }
    // يتجاوز خطوة البداية
    func skip() {
        hasStarted = true
    }
    // يحذف النبتة من القائمة
    func delete(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }
    
    }
    // يحدّث بيانات النبتة
    func update(_ plant: Plant) {
        if let i = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[i] = plant
        }
    }
    // يغيّر حالة النبتة بين مسقيّة وغير مسقيّة
    func toggle(_ plant: Plant) {
        if let i = plants.firstIndex(where: { $0.id == plant.id }) {
            plants[i].isDone.toggle()
        }
    }

    // كم نبتة انسقت
    var doneCount: Int {
        plants.filter { $0.isDone }.count
    }

    // يحسب نسبة الإنجاز من 0 إلى 1
    var progress: Double {
        plants.isEmpty ? 0 : Double(doneCount) / Double(plants.count)
    }

    // يعرض رسالة حسب عدد النباتات المسقيّة
    var message: String {
        doneCount == 0
            ? "Your plants are waiting for a sip 💦"
            : "\(doneCount) of your plants feel loved today✨"
    }
}
//يدير بيانات النباتات في التطبيق، ويحدد الشاشة المناسبة، ويضيف النباتات أو يحذفها ويعدّلها، ويتابع عدد النباتات المسقيّة ونسبة الإنجاز
