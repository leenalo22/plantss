import SwiftUI

struct TodayReminder: View {

    // يفتح فورم إضافة نبتة جديدة (زر +)
    @State private var showSetReminder = false

    // النبتة اللي نعدّلها. إذا فيها نبتة تفتح صفحة EditReminder، وإذا nil ما تفتح
    @State private var editingPlant: Plant? = nil

    // الصندوق المشترك (الـ ViewModel): منه ناخذ النباتات والأوامر
    @Environment(MyPlantModel.self) private var viewModel

    var body: some View {

        // VStack: يرتب كل الصفحة فوق بعض
        VStack(spacing: 4) {

            // العنوان
            Text("My Plants 🌱")
                .font(.system(size: 34, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.leading, 16)
                .padding(.top, 83)

            // الخط الفاصل تحت العنوان
            Rectangle()
                .fill(Color("dividerColor"))
                .frame(height: 1)
                .padding(.top, 20)

            // الجملة: الـ ViewModel هو اللي يقرر وش يكتب (حسب كم نبتة انسقت)
            Text(viewModel.message)
                .font(.system(size: 14))
                .padding(.top, 20)

            // الشريط: يتعبّى حسب النسبة اللي يحسبها الـ ViewModel
            // scaleEffect: يكبّره بالارتفاع عشان يصير أسمك مثل التصميم
            ProgressView(value: viewModel.progress)
                .tint(Color("buttonsColor"))
                .scaleEffect(x: 1, y: 2)
                .padding(.horizontal, 16)
                .padding(.top, 8)

            // القائمة: List يمر على كل نبتة ويسوي لها صف
            // نقدر نمر على plants لأن Plant فيها Identifiable (كل وحدة لها id)
            List(viewModel.plants) { plant in

                // صف النبتة: الدائرة جنب النص
                HStack(spacing: 12) {

                    // زر الدائرة: يعلّم النبتة (انسقت / ما انسقت)
                    // الصفحة ما تغيّر البيانات بنفسها، تطلب من الـ ViewModel
                    Button {
                        viewModel.toggle(plant)
                    } label: {
                        // الأيقونة تتغير حسب isDone: صح إذا انسقت، ودائرة فاضية إذا لا
                        Image(systemName: plant.isDone ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 24))
                            .foregroundStyle(plant.isDone ? Color(red: 0.43, green: 0.91, blue: 0.70) : .gray)
                    }
                    // plain: ضروري داخل القائمة، وإلا الصف كله يصير زر
                    .buttonStyle(.plain)

                    // نص النبتة: الغرفة، الاسم، الشارات (فوق بعض)
                    VStack(alignment: .leading, spacing: 4) {

                        // الغرفة مع السهم
                        HStack(spacing: 4) {
                            Image(systemName: "location")
                            Text("in \(plant.room)")
                        }
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                        // اسم النبتة
                        Text(plant.name)
                            .font(.title3)

                        // الشارتين: الإضاءة والماء
                        HStack(spacing: 6) {
                            badge(plant.light, icon: "sun.max", iconColor: Color("Yellow"), textColor: Color("gray"))
                            badge(plant.water, icon: "drop", iconColor: Color("LightCyan"), textColor: Color("LightCyan"))
                        }
                    }
                    // نخلي النص ياخذ كل العرض عشان منطقة الضغط تكون كبيرة
                    .frame(maxWidth: .infinity, alignment: .leading)
                    // contentShape: يخلي الضغط يشتغل حتى على الفراغات
                    .contentShape(Rectangle())
                    // الضغط على النبتة: نحفظها في editingPlant، فتفتح صفحة التعديل
                    .onTapGesture {
                        editingPlant = plant
                    }
                }
                .padding(.vertical, 4)
                // النبتة اللي انسقت يخف لونها مثل التصميم
                .opacity(plant.isDone ? 0.5 : 1)
                // السحب للحذف: يطلع زر سلة لما تسحب الصف لليسار
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewModel.delete(plant)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                }
            }
            .listStyle(.plain)
            .padding(.top, 20)

            // صفحة التعديل: تفتح لما editingPlant يصير فيه نبتة
            // نستخدم item (مو isPresented) عشان نعرف أي نبتة نعدّل
            .sheet(item: $editingPlant) { plant in
                EditReminder(
                    plant: plant,

                    // ✓: نقفل الصفحة أول، وبعدها نطلب من الـ ViewModel يبدّل النبتة القديمة بالمعدّلة
                    onSave: { updated in
                        editingPlant = nil
                        viewModel.update(updated)
                    },

                    // X: نقفل الصفحة بس
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
        // الصفحة تاخذ كل الشاشة، وتمتد تحت الشريط العلوي والسفلي
        .frame(maxHeight: .infinity)
        .ignoresSafeArea()
        // زر +: يطلع فوق الصفحة في الزاوية تحت اليمين
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
                // ✓: نقفل الصفحة ونضيف النبتة للـ ViewModel
                onSave: { newPlant in
                    showSetReminder = false
                    viewModel.addPlant(newPlant)
                },
                // X: نقفل الصفحة بس
                onCancel: {
                    showSetReminder = false
                }
            )
        }
    }

    // الشارة الصغيرة (الإضاءة / الماء): كتبناها مرة وحدة واستخدمناها مرتين
    // لونين منفصلين: واحد للأيقونة وواحد للنص
    func badge(_ text: String, icon: String, iconColor: Color, textColor: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundStyle(iconColor)
            Text(text)
                .foregroundStyle(textColor)
        }
        .font(.caption2)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        // كبسولة رمادية خفيفة خلف الشارة
        .background(Color.gray.opacity(0.2), in: Capsule())
    }
}

// الـ Preview: نسوي صندوق فيه نبتتين تجريبيتين عشان نشوف شكل الصفحة
#Preview {
    let viewModel = MyPlantModel()
    viewModel.addPlant(Plant(name: "Monstera", room: "Kitchen", light: "Full sun", days: "Every day", water: "20-50 ml"))
    viewModel.addPlant(Plant(name: "Pothos", room: "Bedroom", light: "Full sun", days: "Every day", water: "20-50 ml"))
    return TodayReminder()
        .environment(viewModel)
        .preferredColorScheme(.dark)
}

// ═════════ صفحة التعديل / الحذف (EditReminder) ═════════

struct EditReminder: View {

    // ───────── المعلومات اللي تحتاجها الصفحة ─────────

    // النبتة اللي نعدّلها. الصفحة ما تعرف بياناتها بنفسها، اللي يفتحها يعطيها إياها
    var plant: Plant

    // أمر "احفظ": ياخذ النبتة بعد التعديل. اللي فتح الصفحة يقرر وش يسوي فيها
    var onSave: (Plant) -> Void

    // أمر "ألغِ": لزر X، يقفل الصفحة بدون ما يحفظ
    var onCancel: () -> Void

    // أمر "احذف": لزر Delete Reminder
    var onDelete: () -> Void

    // ───────── الخانات اللي نعدّل عليها ─────────
    // @State: يحفظ القيمة، وأي تغيير فيها يحدّث الشاشة تلقائيًا
    // ما كتبنا لها قيمة هنا لأن قيمتها الأولى تجي من النبتة (في الـ init تحت)
    @State private var name: String
    @State private var room: String
    @State private var light: String
    @State private var days: String
    @State private var water: String

    // الـ init: نحتاجه عشان نعبي الخانات ببيانات النبتة من أول ما تظهر الصفحة
    // @escaping: لازمة لأننا نخزّن الأوامر ونستدعيها بعدين (لما تضغط الأزرار)
    init(plant: Plant,
         onSave: @escaping (Plant) -> Void,
         onCancel: @escaping () -> Void,
         onDelete: @escaping () -> Void) {

        // نحفظ اللي انعطيناه داخل الصفحة
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

    // ───────── شكل الصفحة ─────────
    var body: some View {

        // VStack: يرتب كل العناصر فوق بعض، والمسافة بينهم 40
        VStack(spacing: 40) {

            // الشريط العلوي: HStack يرتب (X، العنوان، ✓) جنب بعض
            HStack {

                // زر X: يستدعي أمر الإلغاء عشان اللي فتح الصفحة يقفلها
                Button {
                    onCancel()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.gray.opacity(0.3), in: Circle())
                }

                // Spacer: فراغ مرن يدفع X لليسار والعنوان للنص
                Spacer()
                Text("Set Reminder").font(.headline)
                Spacer()

                // زر ✓: يحفظ التعديلات
                Button {
                    // ننسخ النبتة (النسخة لها نفس الـ id، عشان الـ ViewModel يعرف أي نبتة يبدّل)
                    var edited = plant

                    // نحط القيم الجديدة اللي اختارها المستخدم في النسخة
                    edited.name = name
                    edited.room = room
                    edited.light = light
                    edited.days = days
                    edited.water = water

                    // نرسل النسخة المعدّلة لمن فتح الصفحة
                    onSave(edited)
                } label: {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Color("buttonsColor"), in: Circle())
                }
            }

            // حقل اسم النبتة: Text للعنوان و TextField للكتابة
            // $name: يربط الحقل بالخانة، فاللي تكتبه ينحفظ في name
            HStack {
                Text("Plant Name")
                TextField("Pothos", text: $name)
            }
            .padding()
            // Capsule: شكل بحواف مدورة كاملة مثل التصميم
            .background(Color(.systemGray5), in: Capsule())

            // المجموعة الأولى: الغرفة + الإضاءة (في صندوق واحد)
            // spacing: 0 عشان الصفين يلزقون ويفصلهم Divider بس
            VStack(spacing: 0) {
                row("location", "Room", ["Bedroom", "Living Room", "Kitchen", "Balcony", "Bathroom"], $room)
                // Divider: الخط الرفيع بين الصفين
                Divider()
                row("sun.max", "Light", ["Full sun", "Partial sun", "Low light"], $light)
            }
            .padding(.horizontal)
            // RoundedRectangle: صندوق بزوايا مدورة
            .background(Color(.systemGray5), in: RoundedRectangle(cornerRadius: 24))

            // المجموعة الثانية: أيام السقي + كمية الماء
            VStack(spacing: 0) {
                row("drop", "Watering Days", ["Every day", "Every 2 days", "Every 3 days", "Once a week", "Every 10 days", "Every 2 weeks"], $days)
                Divider()
                row("drop", "Water", ["20-50 ml", "50-100 ml", "100-200 ml", "200-300 ml"], $water)
            }
            .padding(.horizontal)
            .background(Color(.systemGray5), in: RoundedRectangle(cornerRadius: 24))

            // زر الحذف: يستدعي أمر الحذف، واللي فتح الصفحة هو اللي يحذف النبتة فعليًا
            Button {
                onDelete()
            } label: {
                Text("Delete Reminder")
                    .foregroundStyle(.red)
                    // maxWidth: .infinity يخليه ياخذ كل العرض المتاح
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color(.systemGray5), in: Capsule())
            }

            // Spacer أخير: يدفع كل شي لفوق
            Spacer()
        }
        // مسافة من جوانب الشاشة ومن فوق
        .padding(.horizontal, 16)
        .padding(.top, 20)
    }

    // ───────── دالة مساعدة: صف واحد (أيقونة + اسم + قائمة اختيار) ─────────
    // كتبناها مرة وحدة واستخدمناها 4 مرات، بدل ما نكرر نفس الكود
    // icon: اسم الأيقونة، title: اسم الصف، options: الخيارات، selection: الخانة اللي نحفظ فيها الاختيار
    func row(_ icon: String, _ title: String, _ options: [String], _ selection: Binding<String>) -> some View {
        HStack {
            // الأيقونة مع الاسم
            Label(title, systemImage: icon)
            Spacer()
            // Picker: قائمة منسدلة، ForEach يسوي سطر لكل خيار
            Picker(title, selection: selection) {
                ForEach(options, id: \.self) { Text($0) }
            }
            // نخفي اسم الـ Picker لأنه مكتوب أصلًا في Label
            .labelsHidden()
            .tint(.secondary)
        }
        // ارتفاع ثابت لكل صف
        .frame(height: 40)
    }
}
