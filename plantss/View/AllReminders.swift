
import SwiftUI

struct AllCompleted: View {
    @State private var showSetReminder = false
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
                .padding(.top, 77)

            Text("All Done! 🎉")
                .font(.system(size: 25, weight: .bold))
                .padding(.top, 37)

            Text("All Reminders Completed")
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(width: 315)
                .padding(.top, 25)

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
    AllCompleted()
        .environment(MyPlantModel())
        .preferredColorScheme(.dark)
}
