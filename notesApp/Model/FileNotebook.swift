//Создайте файл FileNotebook.swift. В нём вам предстоит реализовать записную книжку.
//Записная книжка должна удовлетворять следующим условиям:
//Объявлена как класс: class FileNotebook.
//Содержит закрытую для внешнего изменения, но открытую для получения коллекцию Note.
//Содержит функцию добавления новой заметки: public func add(_ note: Note).
//Содержит функцию удаления заметки на основе uid: public func remove(with uid: String).
//Содержит функцию сохранения всей записной книжки в файл: public func saveToFile(), сигнатура дана для примера.
//Содержит функцию загрузки записной книжки из файла: public func loadFromFile(), сигнатура дана для примера.

import Foundation
import UIKit
import CocoaLumberjack

class FileNotebook {
    
    private(set) var notes: [String : Note] = [:]
    
    init() {
        loadFromFile()
    }
    
    public func add(_ note: Note) {
         notes[note.uid] = note
    }
    
    public func remove(with uid: String) {
            notes[uid] = nil
    }
    
    //MARK: - Save/Load Data methods
    func documetnsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documetnsDirectory().appendingPathComponent("notes")
    }
    
    public func saveToFile() {
        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        print(dataFilePath())
        if !fileManager.fileExists(atPath: dataFilePath().path, isDirectory: &isDir), !isDir.boolValue  {
            do {
                try fileManager.createDirectory(atPath: dataFilePath().path, withIntermediateDirectories: true, attributes: nil)
                DDLogInfo("Created")
            } catch {
                DDLogInfo("error")
            }
        }
        
        for note in notes {
            do {
                let data = try JSONSerialization.data(withJSONObject: note.value.json, options: [])
                let filePath = dataFilePath().appendingPathComponent(note.value.uid).path
                if fileManager.fileExists(atPath: filePath) {
                    try fileManager.removeItem(atPath: filePath)
                }
                if fileManager.createFile(atPath: filePath, contents: data, attributes: [:]) {
                    DDLogInfo("Note \(note.value.uid) saved")
                } else {
                    DDLogInfo("Can't save note with uid: \(note.value.uid)")
                }
            } catch {
                DDLogInfo("Error")
            }
        }
    }
    
    public func loadFromFile() {
        if let contents = try? FileManager.default.contentsOfDirectory(atPath: dataFilePath().path), !contents.isEmpty {
            for content in contents {
                do {
                    let data = try Data(contentsOf: dataFilePath().appendingPathComponent(content))
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                    if let note = Note.parse(json: json) {
                        add(note)
                        DDLogInfo("added")
                    }
                } catch {
                    DDLogInfo("worth")
                }
            }
        }
    }
    
    
}
