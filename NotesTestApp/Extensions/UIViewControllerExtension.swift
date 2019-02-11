//
//  UIViewControllerExtension.swift
//  NotesTestApp
//
//  Created by Екатерина on 07.02.2019.
//  Copyright © 2019 Wineapp. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, retryAction: (()->())?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let retry = retryAction {
            let retryAction = UIAlertAction(title: "Обновить данные", style: .default) { _ in
                retry()
            }
            let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
            alert.addAction(retryAction)
            alert.addAction(cancelAction)
        } else {
            let okAction = UIAlertAction(title: "ОК", style: .default, handler: nil)
            alert.addAction(okAction)
        }
        present(alert, animated: true, completion: nil)
    }
}
