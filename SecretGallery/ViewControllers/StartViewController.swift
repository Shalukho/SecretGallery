//
//  StartViewController.swift
//  SecretGallery
//
//  Created by Анастасия Шалухо on 9.07.22.
//

import UIKit

class StartViewController: UIViewController {
    
    //MARK: - IBOutlets and properties
    @IBOutlet weak var enterPIN: UITextField!
    @IBOutlet weak var PINInfo: UILabel!
    let PIN = "123"
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        enterPIN.text = ""
        enterPIN.keyboardType = UIKeyboardType.numberPad
        PINInfo.alpha = 0
    }
    
    // MARK: - IBA actions
    @IBAction func enterButton(_ sender: Any) {
        if enterPIN.text == PIN {
            if let finalVC = storyboard?.instantiateViewController(withIdentifier: "ShowPhotoVC") as? UINavigationController {
                finalVC.modalPresentationStyle = .fullScreen
                present(finalVC, animated: false, completion: nil)
            }
        } else {
            PINInfo.alpha = 1
            PINInfo.text = "Incorrect PIN. Check please."
            enterPIN.text = ""
        }
    }
}
