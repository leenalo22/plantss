import SwiftUI

struct Home: View {
    
    @State private var showSetReminder = false
    
    var body: some View {
        
        VStack {
            Text("My Plants 🌱")
                .font(.system(size: 34 , weight: .bold))
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.leading,16)
                .padding(.top, 83)
                .ignoresSafeArea()
            
            
            
            Rectangle()
                .fill(Color("dividerColor"))
                .frame(height: 1)
                .padding(.top, 20)
            
            
            Spacer()
            
            Text("No reminders set yet..")
                .font(.system(size: 20))                .foregroundStyle(.secondary)
                .padding(.top, 100)
                .ignoresSafeArea()
            Spacer()
            
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .ignoresSafeArea()
        .overlay(alignment: .bottomTrailing) {
            Button {
                showSetReminder = true
            } label: {
                Image(systemName: "plus")
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(Color("buttonsColor"), in: Circle())
            }
            .padding(.trailing, 20)
            .padding(.bottom, 40)
        }
        .sheet(isPresented: $showSetReminder) {
            Text("Set Reminder")
        }
    }
}
            #Preview {
                Home()
        }
