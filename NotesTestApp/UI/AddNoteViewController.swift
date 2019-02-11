//
//  ViewController.swift
//  NotesTestApp
//
//  Created by Екатерина on 29.01.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

class AddNoteViewController: UIViewController {

    @IBOutlet weak var noteTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noteTextView.delegate = self
        self.setupPlaceholder()
    }

    @IBAction func addNewNote(_ sender: Any) {
        self.requestAddNote()
    }
    
}

// MARK: - TextView Delegate

extension AddNoteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if noteTextView.textColor == UIColor.lightGray {
            noteTextView.text = nil
            noteTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if noteTextView.text.isEmpty {
            self.setupPlaceholder()
        }
    }
    
    func setupPlaceholder() {
        self.noteTextView.text = "Введите текст.."
        self.noteTextView.textColor = UIColor.lightGray
    }
}

// MARK: - Networking

extension AddNoteViewController {
    
    private func requestAddNote() {
        guard let textNote = noteTextView.text,
            let session = UserDefaults.standard.string(forKey: "session") else {
                return
        }
        let params: [String:String] = [
            "session" : session,
            "body" : textNote
        ]
        NetworkManager.shared.requestWith(params: params, method: "add_entry") { data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
                else {
                    self.showAlert(title: "Ошибка сети", message: "Проверьте свое подключение к интернету", retryAction: self.requestAddNote)
                    return
            }
            
            self.parseResponse(data: data)
        }
    }
    
    private func parseResponse(data : Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [String : Any],
                let status = json["status"] as? Int
                else {
                    print("Invalid json format")
                    return
            }
            DispatchQueue.main.async {
                if status == 1 {
                    //show success popup
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let error = json["error"] as? String
                    print(error)
                    self.showAlert(title: "Ошибка", message: "Не удалось сохранить заметку. Повторите попытку позже", retryAction: self.requestAddNote)
                }
            }
        } catch {
            self.showAlert(title: "Ошибка", message: "Что-то пошло не так. Повторите попытку позже", retryAction: self.requestAddNote)
        }
    }
}

