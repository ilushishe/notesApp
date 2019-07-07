import Foundation
import UIKit

struct  Note {
    let uid : String
    let title : String
    let content : String
    let color : UIColor
    let importance : Importances
    let selfDestructionDate: Date?
    
    init(uid: String = UUID().uuidString,
         title: String,
         content: String,
         color: UIColor = UIColor.white,
         importance : Importances,
         selfDestructionDate: Date?) {
        
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.importance = importance
        self.selfDestructionDate = selfDestructionDate
    }
    
    enum Importances: String {
        case Minor = "Minor"
        case Normal = "Normal"
        case Major = "Major"
    }
}
