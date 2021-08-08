//
//  ViewController.swift
//  FMDBSample
//
//  Created by Viet Le on 08/08/2021.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  var peoples: [People]!

  override func viewDidLoad() {
    super.viewDidLoad()
    config()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchData()
  }
  
  private func config() {
    title = "People"
    tableView.delegate = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
  }
  
  private func fetchData() {
    peoples = DBController.shared.getListPeople()
    tableView.reloadData()
  }

  @IBAction func addName(_ sender: UIBarButtonItem) {
    showAlert(title: "New Person", message: "Enter new info") {[weak self] name, phone in
        self?.save(name: name, phone: phone)
        self?.tableView.reloadData()
    }
  }
  
  func update(name: String,phone: String,  index: Int) {
    let people = peoples[index]
    people.name = name
    people.phone = phone
    people.saveUpdate()
    tableView.reloadData()
  }
  
  func save(name: String, phone: String) {
    let people = People()
    people.peopleID = UUID().uuidString
    people.name = name
    people.phone = phone
    people.insertToDB()
    
    peoples.append(people)
    tableView.reloadData()
  }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return peoples.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let person = peoples[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.numberOfLines = 0
    cell.textLabel?.text = "Name: \(person.name)" + "\n" + "Phone: \(person.phone ?? "")"
    return cell
  }
}


extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    showAlert(title: "Update", message: "Enter new info") {[weak self] name, phone in
        self?.update(name: name, phone: phone, index: indexPath.row)
        self?.tableView.reloadData()
    }
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        let people = peoples[indexPath.row]
        people.delete()
        peoples.remove(at: indexPath.row)
        self.tableView.reloadData()
    }
  }
    
  func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    return "Delete"
  }
}

extension ViewController {
  func showAlert(title: String, message: String, saveCompletionHandler:((_ name: String, _ phone: String) -> Void)?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let saveAction = UIAlertAction(title: "Save", style: .default) { action in

      guard let textField = alert.textFields?.first,
        let nameToSave = textField.text else {
          return
      }
      
      guard let textField = alert.textFields?[1],
        let phoneToSave = textField.text else {
          return
      }

      saveCompletionHandler?(nameToSave, phoneToSave)
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
    
    alert.addTextField { nameTextField in
      nameTextField.placeholder = "name"
    }
    
    alert.addTextField { phoneTextFiled in
      phoneTextFiled.placeholder = "phone"
    }
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)

    present(alert, animated: true)
  }
}

