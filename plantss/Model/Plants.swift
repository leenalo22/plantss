import Foundation
struct Plant: Identifiable {
    let id = UUID()
    var name: String
    var room: String
    var light: String
    var days: String
    var water: String
    var isDone = false
   
}


