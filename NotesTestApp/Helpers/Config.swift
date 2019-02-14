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


