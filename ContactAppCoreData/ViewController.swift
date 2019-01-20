//
//  ViewController.swift
//  ContactAppCoreData
//
//  Created by Chhaileng Peng on 1/19/19.
//  Copyright © 2019 Chhaileng Peng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var contacts = [Contact]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        write()
        
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        read()
    }
    
    func read() {
        contacts = try! context.fetch(Contact.fetchRequest())
        tableView.reloadData()
//        print(contacts?.count)
//        if let newContacts = contacts {
//            for contact in newContacts {
//                print("NAME : \(contact.name!)")
//                print("AGE  : \(contact.age)")
//
//                if let phones = contact.phones {
//                    for phone in phones {
//                        if let phone = phone as? Phone {
//                            print("\(phone.label!): \(phone.phone!)")
//                        }
//                    }
//                }
//                print("=====================")
//            }
//        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell")
        cell?.textLabel?.text = contacts[indexPath.row].name
        cell?.detailTextLabel?.text = "Age: \(contacts[indexPath.row].age) years old"
        cell?.imageView?.image = UIImage(data: contacts[indexPath.row].image!)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            let editVC = self.storyboard?.instantiateViewController(withIdentifier: "addScreen") as! AddContactViewController
            editVC.isEditVC = true
            editVC.contact = self.contacts[indexPath.row]
            self.navigationController?.pushViewController(editVC, animated: true)
        }
        
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            self.context.delete(self.contacts[indexPath.row])
            self.contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            try? self.context.save()
        }
        
        return UISwipeActionsConfiguration(actions: [delete])
    }


}

