import SwiftUI

@main
struct plantssApp: App {
//: أنشئ نموذج البيانات وأحتفظ به طوال تشغيل التطبيق.
    @State private var viewModel = MyPlantModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
            //يشارك البيانات مع الشاشات.
                .environment(viewModel)
                .preferredColorScheme(.dark)
        }
    }
}
