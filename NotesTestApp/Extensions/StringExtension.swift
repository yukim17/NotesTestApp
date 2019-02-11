//
//  StringExtension.swift
//  NotesTestApp
//
//  Created by Екатерина on 10.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import Foundation

extension String {
    func substring(upTo : Int) -> String {
        if self.count <= upTo {
            return self
        }
        let indexEndOfText = self.index(self.startIndex, offsetBy: upTo)
        return String(self[..<indexEndOfText]) + ".."
    }
}
