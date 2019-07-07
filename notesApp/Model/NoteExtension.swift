import Foundation
import UIKit

extension Note {
    
    static func parse(json: [String: Any]) -> Note? {
        
        guard let uid = json["uid"] as? String,
            let title = json["title"] as? String,
            let content = json["content"] as? String
            else {
                return nil
        }
        
        let color: UIColor
        
        if let colorComponents = json["color"] as? [String : Double]{
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            
            if let redComponent = colorComponents["red"]{
                r = CGFloat(redComponent)
            }
            if let greenComponent = colorComponents["green"]{
                g = CGFloat(greenComponent)
            }
            if let blueComponent = colorComponents["blue"]{
                b = CGFloat(blueComponent)
            }
            if let alphaComponent = colorComponents["alpha"]{
                a = CGFloat(alphaComponent)
            }
            color = UIColor(red: r, green: g, blue: b, alpha: a)
        } else {
            color = UIColor.white
        }
        
        let importance: Importances
        
        if let importanceFromJson = json["importance"] as? String {
            importance = Importances(rawValue: importanceFromJson) ?? Importances.Normal
        } else {
            importance = Importances.Normal
        }
        
        var selfDestructionDate: Date? = nil
        
        if let destructionDateFromJson = json["selfDestructionDate"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            selfDestructionDate = dateFormatter.date(from: destructionDateFromJson)
        }
        
        
        return Note(uid: uid, title: title, content: content, color: color, importance: importance, selfDestructionDate: selfDestructionDate)
    }
    
    var json: [String: Any] {
            var myDict = [String : Any] ()
            myDict["uid"] = self.uid
            myDict["title"] = self.title
            myDict["content"] = self.content
            
            if self.color != UIColor.white {
                
                var r: CGFloat = 0
                var g: CGFloat = 0
                var b: CGFloat = 0
                var a: CGFloat = 0
                
                self.color.getRed(&r, green: &g, blue: &b, alpha: &a)
                myDict["color"] = ["red" : Double(r), "green" : Double(g),"blue" : Double(b),"alpha" : Double(a)]
            }
            
            if self.importance != Importances.Normal {
                
                myDict["importance"] = self.importance.rawValue
            }
            
            
        if self.selfDestructionDate != nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let stringDate = dateFormatter.string(from: self.selfDestructionDate!)
                myDict["selfDestructionDate"] = stringDate
            }
            
            return myDict
        }
}
