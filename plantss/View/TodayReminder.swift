import SwiftUI

struct TodayReminder: View {

    // يفتح فورم إضافة نبتة جديدة (زر +)
    @State private var showSetReminder = false

    // النبتة اللي نعدّلها. إذا فيها نبتة تفتح صفحة EditReminder، وإذا nil ما تفتح
    @State private var editingPlant: Plant? = nil

    // الصندوق المشترك (الـ ViewModel): منه ناخذ النباتات والأوامر
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

//يأخذ الجملة من الموديل، والموديل يختارها حسب عدد النباتات المسقيّة. هذا السطر يعرضها على الشاشة.
            Text(viewModel.message)
                .font(.system(size: 16))
                .padding(.top, 20)

            //  يعرض شريط التقدّم حسب نسبة النباتات المسقيّة
            GeometryReader { geo in
                ZStack(alignment: .leading) {

                    Capsule()
                        .fill(Color.gray.opacity(0.25))

                    // الكبسولة الخضرا: عرضها = عرض الشريط × نسبة النباتات المسقيّة
                    Capsule()
                        .fill(Color(red: 0.31, green: 0.50, blue: 0.42))                        .frame(width: geo.size.width * viewModel.progress)
                }
            }
            .frame(height: 8)
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .animation(.easeInOut, value: viewModel.progress)
            

            ScrollView {
                LazyVStack(spacing: 0) {

//List تعرض كل نبتة في viewModel.plants بصف لحالها. plant هي النبتة اللي يعرض صفّها الآن.
                    //  الحين ForEach هو اللي يسوي صف لكل نبتة بدل List
                    ForEach(viewModel.sortedPlants) { plant in
                        
                        SwipeToDelete {
                            withAnimation {
                                viewModel.delete(plant)
                            }
                        } content: {

                            HStack(spacing: 12) {

                                Button {
                                    viewModel.toggle(plant)
                                } label: {

// يحدد شكل الدائرة: إذا النبتة مسقيّة تظهر علامة صح خضراء، وإذا ما انسقت تظهر دائرة رمادية
                                    Image(systemName: plant.isDone ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 24))
                                        .foregroundStyle(plant.isDone ? Color(red: 0.43, green: 0.91, blue: 0.70) : .gray)
                                }
                                .buttonStyle(.plain)

                                VStack(alignment: .leading, spacing: 4) {


                                    HStack(spacing: 4) {
                                        Image(systemName: "location")
                                        Text("in \(plant.room)")
                                    }
                                    .font(.system(size: 13))                                    .foregroundStyle(.secondary)

                                    Text(plant.name)
                                        .font(.system(size: 28))

                                    HStack(spacing: 6) {
                                        badge(plant.light, icon: "sun.max", iconColor: Color("Yellow"), textColor: Color("Yellow"))
                                        badge(plant.water, icon: "drop", iconColor: Color("LightCyan"), textColor: Color("LightCyan"))
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                                .opacity(plant.isDone ? 0.5 : 1)
                                .onTapGesture {
                                    editingPlant = plant
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }

                        Rectangle()
                            .fill(Color("dividerColor"))
                            .frame(height: 1)
                    }
                }
            }
            .padding(.top, 20)

            // صفحة التعديل: تفتح لما editingPlant يصير فيه نبتة
            // نستخدم item (مو isPresented) عشان نعرف أي نبتة نعدّل
            .sheet(item: $editingPlant) { plant in
                EditReminder(
                    plant: plant,

                    onSave: { updated in
                        editingPlant = nil
                        viewModel.update(updated)
                    },

                    onCancel: {
                        editingPlant = nil
                    },

                    // Delete Reminder: نقفل الصفحة ونطلب من الـ ViewModel يحذف النبتة
                    onDelete: {
                        editingPlant = nil
                        viewModel.delete(plant)
                    }
                )
            }
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
        // صفحة إضافة نبتة جديدة: تفتح لما تضغط +
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

    func badge(_ text: String, icon: String, iconColor: Color, textColor: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
            Text(text)
                .foregroundStyle(textColor)
        }
        .font(.system(size: 13))
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
       .background(Color.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 8))    }
}

struct SwipeToDelete<Content: View>: View {

    // أمر الحذف: اللي يستخدم الصندوق يقرر وش يصير لما تضغطين السلة
    var onDelete: () -> Void

    // @ViewBuilder: يخلي الصندوق يقبل أي شكل داخله (مثل VStack)
    @ViewBuilder var content: Content

    @State private var offset: CGFloat = 0

    @State private var isOpen = false

    private let openWidth: CGFloat = 90

    var body: some View {
        ZStack(alignment: .trailing) {

            Button {
                withAnimation(.spring) {
                    offset = 0
                    isOpen = false
                }
                onDelete()
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 60, height: 40)
                    .background(Color(red: 0.93, green: 0.33, blue: 0.33), in: Capsule())
            }
            .padding(.trailing, 16)
            .opacity(offset < 0 ? 1 : 0)

            content
                .background(Color.black)
                .offset(x: offset)
                .gesture(
                    DragGesture(minimumDistance: 20)
                        .onChanged { value in
                            guard abs(value.translation.width) > abs(value.translation.height) else { return }
                            let start: CGFloat = isOpen ? -openWidth : 0
                            offset = min(0, max(start + value.translation.width, -openWidth * 1.5))
                        }
                        .onEnded { _ in
                            withAnimation(.spring) {
                                isOpen = offset < -openWidth / 2
                                offset = isOpen ? -openWidth : 0
                            }
                        }
                )
        }
        // clipped: يقص أي شي يطلع برا حدود الصف
        .clipped()
    }
}

#Preview {
    let viewModel = MyPlantModel()
    viewModel.addPlant(Plant(name: "Monstera", room: "Kitchen", light: "Full sun", days: "Every day", water: "20-50 ml"))
    viewModel.addPlant(Plant(name: "Pothos", room: "Bedroom", light: "Full sun", days: "Every day", water: "20-50 ml"))
    return TodayReminder()
        .environment(viewModel)
        .preferredColorScheme(.dark)
}


struct EditReminder: View {


    // النبتة اللي نعدّلها. الصفحة ما تعرف بياناتها بنفسها، اللي يفتحها يعطيها إياها
    var plant: Plant

    var onSave: (Plant) -> Void

    var onCancel: () -> Void

    var onDelete: () -> Void

 
    @State private var name: String
    @State private var room: String
    @State private var light: String
    @State private var days: String
    @State private var water: String

    init(plant: Plant,
         onSave: @escaping (Plant) -> Void,
         onCancel: @escaping () -> Void,
         onDelete: @escaping () -> Void) {

        self.plant = plant
        self.onSave = onSave
        self.onCancel = onCancel
        self.onDelete = onDelete

        // نقول لكل خانة: ابدأ بقيمة النبتة (العلامة _ تعني نتعامل مع الخانة نفسها)
        _name = State(initialValue: plant.name)
        _room = State(initialValue: plant.room)
        _light = State(initialValue: plant.light)
        _days = State(initialValue: plant.days)
        _water = State(initialValue: plant.water)
    }

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
                    var edited = plant

                    edited.name = name
                    edited.room = room
                    edited.light = light
                    edited.days = days
                    edited.water = water

                    onSave(edited)
                } label: {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Color("buttonsColor"), in: Circle())
                }
                .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                .opacity(name.trimmingCharacters(in: .whitespaces).isEmpty ? 0.4 : 1)
            }

            
            HStack {
                Text("Plant Name")
                TextField("Pothos", text: $name)
            }
            .padding()
            .background(Color(.systemGray5), in: Capsule())

          
            VStack(spacing: 0) {
                row("location", "Room", ["Bedroom", "Living Room", "Kitchen", "Balcony", "Bathroom"], $room)
                Divider()
                row("sun.max", "Light", ["Full sun", "Partial sun", "Low light"], $light)
            }
            .padding(.horizontal)
            .background(Color(.systemGray5), in: RoundedRectangle(cornerRadius: 24))

            VStack(spacing: 0) {
                row("drop", "Watering Days", ["Every day", "Every 2 days", "Every 3 days", "Once a week", "Every 10 days", "Every 2 weeks"], $days)
                Divider()
                row("drop", "Water", ["20-50 ml", "50-100 ml", "100-200 ml", "200-300 ml"], $water)
            }
            .padding(.horizontal)
            .background(Color(.systemGray5), in: RoundedRectangle(cornerRadius: 24))

            Button {
                onDelete()
            } label: {
                Text("Delete Reminder")
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color(.systemGray5), in: Capsule())
            }

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
