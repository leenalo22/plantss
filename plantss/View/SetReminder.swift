import SwiftUI

struct SetReminder: View {
    var onSave: (Plant) -> Void
    var onCancel: () -> Void

    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var room = "Bedroom"
    @State private var light = "Full sun"
    @State private var days = "Every day"
    @State private var water = "20-50 ml"
    
    var body: some View {
        VStack(spacing: 40) {
            
            // الشريط العلوي
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
            }
            
            // اسم النبتة
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
            
            // Watering Days + Water
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
    
    // صف واحد: أيقونة + اسم + قائمة اختيار
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
    // الـ Preview يعرضها كـ Sheet مثل التصميم
#Preview {
    SetReminder(
        onSave: { _ in },
        onCancel: {}
    )
}
