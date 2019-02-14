//
//  NotesTableViewController.swift
//  NotesTestApp
//
//  Created by Екатерина on 03.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

class NotesTableViewController: UITableViewController {
    
    var activityIndicatorView: UIActivityIndicatorView!
    var notes : [Note]?
    let networkManager = NetworkManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        tableView.backgroundView = activityIndicatorView
        
        if (Config.session.isEmpty) {
            self.requestNewSession()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestEntries()
        if (notes == nil) {
            activityIndicatorView.startAnimating()
            tableView.separatorStyle = .none
        }
    }

}

// MARK: - TableView data source

extension NotesTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return (self.notes == nil) ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
        
        let note = self.notes![indexPath.row]
        
        cell.entryLabel.text = note.body.substring(upTo: 200)
        let date = Date.init(timeIntervalSince1970: Double(note.da)!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        cell.dateLabel.text = dateFormatter.string(from: date)
        
        return cell
    }
}

// MARK: - Navigation

extension NotesTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNote" {
            let destinationVC = segue.destination as! NoteViewController
            let row = self.tableView.indexPathForSelectedRow?.row
            destinationVC.note = notes![row!]
        }
    }
}

// MARK: - Networking

extension NotesTableViewController {
    
    private func requestNewSession() {
        networkManager.requestWith(method: "new_session") { data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
                else {
                    self.showAlert(title: "Ошибка сети", message: "Проверьте свое подключение к интернету") {
                        self.requestNewSession()
                    }
                    return
            }
            self.parseNewSessionResponse(data: data)
        }
    }
    
    private func parseNewSessionResponse(data: Data) {
        do {
            let response = try JSONDecoder().decode(SessionResponse.self, from: data)
            
            if response.status == 1 {
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.tableView.separatorStyle = .singleLine
                    UserDefaults.standard.set(response.data["session"], forKey: "session")
                }
            } else {
                self.showAlert(title: "Ошибка", message: "Что-то пошло не так, повторите попытку позже", retryAction: self.requestNewSession)
            }
        } catch {
            self.showAlert(title: "Ошибка", message: "Что-то пошло не так, повторите попытку позже", retryAction: nil)
        }
    }
    
    private func requestEntries() {
        guard let session = UserDefaults.standard.string(forKey: "session")
            else {
                return
        }
        let params: [String:String] = [
            "session" : session
        ]
        networkManager.requestWith(params: params, method: "get_entries") { data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
                else {
                    self.showAlert(title: "Ошибка сети", message: "Проверьте свое подключение к интернету", retryAction: self.requestEntries)
                    return
            }
            self.parseGetEntriesResponse(data: data)
        }
    }
    
    private func parseGetEntriesResponse(data: Data) {
        do {
            let response = try JSONDecoder().decode(EntriesResponse.self, from: data)
            if response.status == 1 {
                self.notes = response.data[0]
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.tableView.separatorStyle = .singleLine
                    self.tableView.reloadData()
                    self.tableView.tableFooterView = UIView()
                }
            } else {
                self.showAlert(title: "Ошибка", message: "Что-то пошло не так, повторите попытку позже", retryAction: self.requestEntries)
            }
        } catch {
            self.showAlert(title: "Ошибка", message: "Что-то пошло не так. Повторите попытку позже", retryAction: nil)
        }
    }
}
