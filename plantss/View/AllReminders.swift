
import SwiftUI

struct AllCompleted: View {
    @State private var showSetReminder = false
    //هذا السطر يجيب MyPlantModel المشترك إلى شاشة AllCompleted، عشان تقدر تضيف نبتة جديدة لما تضغطين +.
    @Environment(MyPlantModel.self) private var viewModel

    var body: some View {
        VStack(spacing: 4) {
            Text("My Plants 🌱")
                .font(.system(size: 34, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.leading, 16)
                .padding(.top, 83)

            Rectangle()
                .fill(Color("dividerColor"))
                .frame(height: 1)
                .padding(.top, 20)

            Image("Plant")
                .resizable()
                .scaledToFit()
                .frame(width: 164, height: 200)
                .padding(.top, 127)

            Text("All Done! 🎉")
                .font(.system(size: 25, weight: .bold))
                .padding(.top, 60)

            Text("All Reminders Completed")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(width: 315)
                .padding(.top, 14)

            Spacer()
        }
        .frame(maxHeight: .infinity)
        .ignoresSafeArea()
        //هذا يضيف زرًا فوق الشاشة ويحطه في الزاوية السفلية اليمنى.
        .overlay(alignment: .bottomTrailing) {
            Button {
                //لما تضغطين زر +، يصير المتغير true، فتفتح صفحة إضافة التذكير.
                showSetReminder = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
            }
            //يعطي الزر شكلًا زجاجيًا بلون buttonsColor، ويتفاعل بصريًا مع اللمس.
            .glassEffect(.regular.tint(Color("buttonsColor")).interactive())
            .padding(.trailing, 20)
            .padding(.bottom, 40)
        }
        //لما تضغطين + تفتح صفحة الإضافة. داخلها:
        //- تضغطين ✓: يقفلها ويحفظ النبتة في القائمة.
       // - تضغطين X: يقفلها بدون حفظ.
            .sheet(isPresented: $showSetReminder) {
            SetReminder(
                onSave: { newPlant in
                    showSetReminder = false
                    viewModel.addPlant(newPlant)
                },
                onCancel: {
                    showSetReminder = false
                }
            )
        }
    }
}

#Preview {
    AllCompleted()
        .environment(MyPlantModel())
        .preferredColorScheme(.dark)
}
