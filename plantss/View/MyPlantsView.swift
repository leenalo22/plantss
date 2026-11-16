import SwiftUI

struct MyPlantsView: View {

    @State private var showSetReminder = false
    @Environment(MyPlantModel.self) private var viewModel

    var body: some View {

        VStack(spacing: 4) {

            Text("My Plants 🌱")
            //يستخدم خط النظام
                .font(.system(size: 34, weight: .bold))
            //يحدد إطار العنصر بحيث يأخذ أكبر عرض ممكن، ويضع محتواه في أعلى اليسار
                .frame(maxWidth: .infinity, alignment: .topLeading)
            //يضيف مسافة من جهة بداية السطر
                .padding(.leading, 16)
            // يضيف مسافة من الأعل
                .padding(.top, 83)

            Rectangle()
                .fill(Color("dividerColor"))
                .frame(height: 1)
                .padding(.top, 20)

            Image("Plant")
                .resizable()
                .scaledToFit()
                .frame(width: 164, height: 200)
                .padding(.top, 77)

            Text("Start your plant journey!")
                .font(.system(size: 25, weight: .bold))
                .padding(.top, 37)

            Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(.secondary)
            //يُوسّط النص إذا كان على أكثر من سطر.
                .multilineTextAlignment(.center)
                .frame(width: 315)
                .padding(.top, 25)

            Button {
                showSetReminder = true
            } label: {
                Text("Set Plant Reminder ")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.white)
                    .frame(width: 280, height: 42)
            }
            //يعطي العنصر مظهرًا زجاجيًا بلون buttonsColor، ويتفاعل مع اللمس.
            .glassEffect(.regular.tint(Color("buttonsColor")).interactive())
            .padding(.top, 105)
            
            //يضيف مساحة فارغة مرنة، ويدفع العناصر بعيدًا عن بعض.
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .ignoresSafeArea()
        
    //يعرض نافذة عند تفعيل المتغير.
        .sheet(isPresented: $showSetReminder) {
            SetReminder(
                //عند الحفظ، يغلق النافذة ويضيف النبات.
                onSave: { newPlant in
                    //يغلق نافذة التذكير.
                    showSetReminder = false
                    //يضيف النبات الجديد إلى بيانات التطبيق.
                    viewModel.addPlant(newPlant)
                },
                //عند الإلغاء، يغلق النافذة ويتخطى الخطوة
                onCancel: {
                    showSetReminder = false
                    viewModel.skip()
                    //يتخطّى خطوة إعداد التذكير
                }
            )
        }
    }
}

#Preview {
    MyPlantsView()
        .environment(MyPlantModel())
        .preferredColorScheme(.dark)
}
