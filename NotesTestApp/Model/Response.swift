//
//  Response.swift
//  NotesTestApp
//
//  Created by Екатерина on 09.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

struct EntriesResponse: Decodable {
    let status : Int
    let data : [[Note]]
}

struct SessionResponse : Decodable {
    let status : Int
    let data : [String : String]
}

struct AddEntryResponse: Decodable {
    let status : Int
    let data : [String : String]
}
