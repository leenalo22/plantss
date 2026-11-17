
import SwiftUI

struct ContentView: View {
    @Environment(MyPlantModel.self) private var viewModel

    var body: some View {
        switch viewModel.screen {
        case .start:
            MyPlantsView()
        case .home:
            Home()
        case .today:
            TodayReminder()
        case .completed:
            AllCompleted()
        }
    }
}

#Preview {
    ContentView()
        .environment(MyPlantModel())
    //يعطي المعاينة موديلًا تجريبيًا عشان تقدر تعرض الشاشة.
}
