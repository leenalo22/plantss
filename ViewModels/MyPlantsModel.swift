import SwiftUI
//الدفتر اللي يحتفظ بكل النباتات ويغيّر بياناتها.

@Observable
class MyPlantModel {
    
    // يخزّن قائمة النباتات
    var plants: [Plant] = []
    var hasStarted = false
    // يحدد هل بدأ المستخدم استخدام التطبيق
    enum Screen {case start, home, today, completed}
    
    var screen: Screen {
        //يقرر اي شاشه تظهر
        if !hasStarted { return .start }
        //اذا المشتخدم مابدا hastated يفتح من البدايه
        if plants.isEmpty { return .home }
        //إذا قائمة النباتات فاضية، اعرض الشاشة الرئيسية .home اللي تقول ما فيه تذكيرات.
        return plants.allSatisfy(\.isDone) ? .completed : .today
    }
    
    func addPlant(_ plant: Plant) {
        plants.append(plant)
        hasStarted = true
        Task { await PlantNotificationManager.schedule(for: plant) }
    }
    // يتجاوز خطوة البداية
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
