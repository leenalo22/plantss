import SwiftUI

struct SetReminder: View {
    var onSave: (Plant) -> Void
    var onCancel: () -> Void

    
    @State private var name = ""
    @State private var room = "Bedroom"
    @State private var light = "Full sun"
    @State private var days = "Every day"
    @State private var water = "20-50 ml"
    
    var body: some View {
        VStack(spacing: 40) {
            
            HStack {
                Button {
                    onCancel()
                } label: {
                    
                    Image(systemName: "xmark")
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.gray.opacity(0.3), in: Circle())
                }
                
                Spacer()
                Text("Set Reminder").font(.headline)
                Spacer()
                
                Button {
                    let plant = Plant(name: name, room: room, light: light, days: days, water: water)
                    onSave(plant)
                } label: {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Color("buttonsColor"), in: Circle())
                }
                //الزر ما يشتغل إذا الاسم فاضي
              
            }
            
            HStack {
                Text("Plant Name")
                TextField("Pothos", text: $name)
                
            }
            .padding()
            .background(Color(.systemGray5), in: Capsule())
            
            // Room + Light
            VStack(spacing: 0) {
                row("location", "Room", ["Bedroom", "Living Room", "Kitchen", "Balcony", "Bathroom"], $room)
                Divider()
                row("sun.max", "Light", ["Full sun", "Partial sun", "Low light"], $light)
            }
            .padding(.horizontal)
            .background(Color(.systemGray5), in: RoundedRectangle(cornerRadius: 24))
            //عندي 4 صفوف (Room، و Light، و Watering Days، و Water)، فبدل ما أكتب نفس الكود 4 مرات، كتبته مرة وحدة في دالة، وأناديها 4 مرات بمعلومات مختلفة."
            VStack(spacing: 0) {
                row("drop", "Watering Days", ["Every day", "Every 2 days", "Every 3 days", "Once a week", "Every 10 days", "Every 2 weeks"], $days)
                Divider()
                row("drop", "Water", ["20-50 ml", "50-100 ml", "100-200 ml", "200-300 ml"], $water)
            }
            .padding(.horizontal)
            .background(Color(.systemGray5), in: RoundedRectangle(cornerRadius: 24))
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
    }
    
    func row(_ icon: String, _ title: String, _ options: [String], _ selection: Binding<String>) -> some View {
        HStack {
            Label(title, systemImage: icon)
            Spacer()
            Picker(title, selection: selection) {
                ForEach(options, id: \.self) { Text($0) }
            }
            .labelsHidden()
            .tint(.secondary)
        }
        .frame(height: 40)
    }
}
#Preview {
    SetReminder(
        onSave: { _ in },
        onCancel: {}
    )
}
