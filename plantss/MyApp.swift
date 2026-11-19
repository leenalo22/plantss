import SwiftUI

@main
struct plantssApp: App {
//: أنشئ نموذج البيانات وأحتفظ به طوال تشغيل التطبيق.
    @State private var viewModel = MyPlantModel()
//ليش Scene مو View؟ "لأن هذا التطبيق كامل، والتطبيق يتكون من نوافذ (Scenes)، أما الشاشات فهي Views."
    var body: some Scene {
        WindowGroup {
            ContentView()
            //يشارك البيانات مع الشاشات.
                .environment(viewModel)
                .preferredColorScheme(.dark)
            
            
            
        }
    }
}
