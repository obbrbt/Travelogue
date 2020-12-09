//
//  NewEntryViewController.swift
//  Travelogue
//
//  Created by obbrbt on 12/9/20.
//

import UIKit

class NewEntryViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    let imagePickerController = UIImagePickerController()
    
    var entry: Entry?
    var trip: Trip?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = ""
        
        if let entry = entry
        {
            let entryTitle = entry.title
            titleTextField.text = title
            bodyTextView.text = entry.body
            title = entryTitle
            photoView.image = image
        }
        
        imagePickerController.delegate = self
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func alertNotifyUser(message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cameraSelected(_ sender: UIBarButtonItem) {
        openCamera()
    }
    
    @IBAction func folderSelected(_ sender: UIBarButtonItem) {
        openGallery()
    }
    
    func openCamera()
    {
        if(!UIImagePickerController.isSourceTypeAvailable(.camera))
        {
            alertNotifyUser(message: "This device has no camera.")
        } else
        {
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func openGallery()
    {
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            photoView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveEntry(_ sender: Any) {
        guard let title = titleTextField.text else
        {
            alertNotifyUser(message: "Entry could not be saved.\nThe name is not accessible.")
            return
        }
        
        let body = bodyTextView.text
        
        if entry == nil
        {
            entry = Entry(title: title, body: body, image: photoView.image)
        } else
        {
            entry?.update(title: title, body: body, image: photoView.image)
        }
        
        if let entry = entry
        {
            do
            {
                let managedContext = entry.managedObjectContext
                try managedContext?.save()
            } catch
            {
                alertNotifyUser(message: "The entry context could not be saved.")
            }
        } else
        {
            alertNotifyUser(message: "The entry could not be created.")
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nameChanged(_ sender: Any) {
        title = titleTextField.text
    }
}
