//
//  NewTripViewController.swift
//  Travelogue
//
//  Created by obbrbt on 12/9/20.
//

import UIKit

class NewTripViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self

    }
    
    func alertNotifyUser(message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveTrip(_ sender: UIBarButtonItem) {
        let trip = Trip(title: titleTextField.text ?? "")
        
        do
        {
            try trip?.managedObjectContext?.save()
            self.navigationController?.popViewController(animated: true)
        } catch
        {
            alertNotifyUser(message: "Trip could not be saved.")
        }
    }
}
