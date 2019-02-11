//
//  APIClient.swift
//  NotesTestApp
//
//  Created by Екатерина on 30.01.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

enum Config {
    static let baseURL = "https://bnet.i-partner.ru/testAPI/"
    static let token = "tzeVucW-og-QxkMnQa"
    static let session = UserDefaults.standard.string(forKey: "session") ?? ""
}


class Helper {
    
    public static func requestNewSession() {
        let url = URL(string: Config.baseURL)
        var request = URLRequest(url: url!)
        //request.addValue(Config.token, forHTTPHeaderField: "token")
        request.setValue(Config.token, forHTTPHeaderField: "token")
        request.httpMethod = "POST"
        //print(request.allHTTPHeaderFields)
        //request.allHTTPHeaderFields = ["token":Config.token]
        let parameters = "a=new_session"
        request.httpBody = parameters.data(using: .utf8)
        //request.httpMethod = "new_session"
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                error == nil,
                (response as? HTTPURLResponse)?.statusCode == 200,
                let data = data
                else {
                    print((response as? HTTPURLResponse)?.statusCode)
                    print(error.debugDescription)
                    return
            }
            self.parseNewSessionResponse(data: data)
        }
        dataTask.resume()
        

    }
    
    private static func parseNewSessionResponse(data : Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: AnyObject]
            
            guard
                let json = jsonObject as? [String : Any],
                let status = json["status"] as? Int
                else {
                    print("Invalid json format")
                    return
            }
            DispatchQueue.main.async {
                if status == 1 {
                    let data = json["data"] as? [String:String]
                    let session = data!["session"]
                    UserDefaults.standard.set(session, forKey: "session")
                } else {
                    let error = json["error"] as? String
                    print(error)
                    //self.showErrorAlert(title: "Ошибка", message: "Не удалось сохранить заметку. Повторите попытку позже", completion: self.requestAddNote)
                }
            }
        } catch {
            //self.showErrorAlert(title: "Ошибка", message: "Что-то пошло не так. Повторите попытку позже", completion: self.requestAddNote)
            print("\n\n===========Error===========")
            print("Error Code: \(error._code)")
            print("Error Messsage: \(error.localizedDescription)")
            debugPrint(error)
            print("===========================\n\n")
        }
    }
}


