//
//  AddContactViewController.swift
//  ContactAppCoreData
//
//  Created by Chhaileng Peng on 1/20/19.
//  Copyright © 2019 Chhaileng Peng. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var phone1TextField: UITextField!
    @IBOutlet weak var phone2TextField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var imagePicker: UIImagePickerController!
    
    
    var isEditVC: Bool = false
    var contact: Contact?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEditVC {
            title = "Update Contact"
            if let contact = contact {
                imageView.image = UIImage(data: contact.image!)
                nameTextField.text = contact.name
                ageTextField.text = "\(contact.age)"
                
                var phones = [Phone]()
                if let p = contact.phones {
                    for p in p {
                        phones.append(p as! Phone)
                    }
                }
                phone1TextField.text = phones[0].phone
                phone2TextField.text = phones[1].phone
            }
        } else {
            title = "Add New Contact"
        }

        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(browseImage))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
    }
    
    @objc func browseImage() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func saveButtonTap(_ sender: UIButton) {
        if isEditVC {
            contact?.name = nameTextField.text
            contact?.age = Int16(ageTextField.text!)!
            contact?.image = UIImage.pngData(imageView.image!)()
            
            let phone1 = Phone(context: context)
            let phone2 = Phone(context: context)
            
            phone1.label = "work"
            phone1.phone = phone1TextField.text
            phone2.label = "mobile"
            phone2.phone = phone2TextField.text
            
            contact?.addToPhones([phone1, phone2])
            
            try? contact?.managedObjectContext?.save()
//            try? context.save()
            
        } else {
            let contact = Contact(context: context)
            contact.name = nameTextField.text
            contact.age = Int16(ageTextField.text!)!
            contact.image = UIImage.pngData(imageView.image!)()
            
            let phone1 = Phone(context: context)
            let phone2 = Phone(context: context)
            
            phone1.label = "work"
            phone1.phone = phone1TextField.text
            phone2.label = "mobile"
            phone2.phone = phone2TextField.text
            
            contact.addToPhones([phone1, phone2])
            
            try? contact.managedObjectContext?.save()
        }
        
        navigationController?.popViewController(animated: true)
    }

}
