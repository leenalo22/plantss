import SwiftUI

struct Home: View {

    @State private var showSetReminder = false
    @Environment(MyPlantModel.self) private var viewModel

    var body: some View {

        VStack {
            Text("My Plants 🌱")
                .font(.system(size: 34, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.leading, 16)
                .padding(.top, 83)

            Rectangle()
                .fill(Color("dividerColor"))
                .frame(height: 1)
                .padding(.top, 20)

            Spacer()

            Text("No reminders set yet..")
                .font(.system(size: 20))
                .foregroundStyle(.secondary)

            Spacer()
        }
        .frame(maxHeight: .infinity)
        .ignoresSafeArea()
        .overlay(alignment: .bottomTrailing) {
            Button {
                showSetReminder = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
            }
            .glassEffect(.regular.tint(Color("buttonsColor")).interactive())
            .padding(.trailing, 20)
            .padding(.bottom, 40)
        }
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
    Home()
        .environment(MyPlantModel())
        .preferredColorScheme(.dark)
}
