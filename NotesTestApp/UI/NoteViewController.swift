//
//  NoteViewController.swift
//  NotesTestApp
//
//  Created by Екатерина on 11.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var entryLabel: UILabel!
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let entry = note {
            entryLabel.text = entry.body
        }
    }

}
