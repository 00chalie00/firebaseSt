/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import Firebase

class GroceryListTableViewController: UITableViewController {

  // MARK: Constants
  let listToUsers = "ListToUsers"
  
  // MARK: Properties 
  var items: [GroceryItem] = []
  var user: User!
  var userCountBarButtonItem: UIBarButtonItem!
  
  var firebaseReference = Database.database().reference()
  let childRefer = Database.database().reference(withPath: "chaile's grocery")
  
  let storageRef = Storage.storage().reference()
  
  // MARK: UIViewController Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.allowsMultipleSelectionDuringEditing = false
    
    userCountBarButtonItem = UIBarButtonItem(title: "1",
                                             style: .plain,
                                             target: self,
                                             action: #selector(userCountButtonDidTouch))
    userCountBarButtonItem.tintColor = UIColor.white
    navigationItem.leftBarButtonItem = userCountBarButtonItem
    
    user = User(uid: "FakeId", email: "test@test.com")
    //Server Data Load
    queryforServer("completed")
    
    uploadPicture()
  }
  
  // MARK: UITableView Delegate methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! CellController
    let groceryItem = items[indexPath.row]
    cell.IMG.image = UIImage(named: "person.circle")
      cell.name.text = groceryItem.name
      cell.addUser.text = groceryItem.addedByUser
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      items.remove(at: indexPath.row)
      tableView.reloadData()
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else { return }
    
    let groceryItem = items[indexPath.row]
    let toggledCompletion = !groceryItem.completed
    
    let value:[String:Any] = ["completed": toggledCompletion]
    let itemRefer = childRefer.child(cell.textLabel!.text!)
    
    toggleCellCheckbox(cell, isCompleted: toggledCompletion)
    items[indexPath.row].completed = toggledCompletion
    itemRefer.ref.updateChildValues(value)
    tableView.reloadData()
  }
  
  func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
    if !isCompleted {
      cell.accessoryType = .none
      cell.backgroundColor = UIColor.white
      cell.textLabel?.textColor = UIColor.black
      cell.detailTextLabel?.textColor = UIColor.black
    } else {
      cell.accessoryType = .checkmark
      cell.backgroundColor = UIColor.yellow
      cell.textLabel?.textColor = UIColor.red
      cell.detailTextLabel?.textColor = UIColor.red
    }
  }
  
  // MARK: Add Item
  
  @IBAction func addButtonDidTouch(_ sender: AnyObject) {
    let popUpVC = storyboard?.instantiateViewController(identifier: "PopUpController") as? PopUController
    
    present(popUpVC!, animated: true, completion: nil)
    
    
//    let alert = UIAlertController(title: "Grocery Item",
//                                  message: "Add an Item",
//                                  preferredStyle: .alert)
//
//    let saveAction = UIAlertAction(title: "Save",
//                                   style: .default) { action in
//      let textField = alert.textFields![0]
//      let groceryItem = GroceryItem(name: textField.text!,
//                                    addedByUser: self.user.email,
//                                    completed: false)
//      self.items.append(groceryItem)
//
//      //Upload the new Item
//      let itemRefer = self.childRefer.child(textField.text!)
//      let value:[String:Any] = ["name": textField.text!, "addedByUser": self.user.email, "completed": false]
//      itemRefer.setValue(value)
//
//      self.tableView.reloadData()
//    }
//
//    let cancelAction = UIAlertAction(title: "Cancel",
//                                     style: .default)
//    //add imageview in alert
//    var imageView = UIImageView(frame: CGRect(x: 50, y: 50, width: 40, height: 40))
//    imageView.backgroundColor = .green
//    alert.view.addSubview(imageView)
//
//
//    alert.addTextField()
//
//
//    alert.addAction(saveAction)
//    alert.addAction(cancelAction)
//
//    present(alert, animated: true, completion: nil)
  }
  
  @objc func userCountButtonDidTouch() {
    performSegue(withIdentifier: listToUsers, sender: nil)
  }
  
  func queryforServer(_ childName: String){
    print("Called Query Func")
    
    var returnItem: [GroceryItem] = []

    childRefer.queryOrdered(byChild: childName).observe(.value) {
      (dataSnapshot) in
      for item in dataSnapshot.children {
        let dnItem = GroceryItem(snapshot: item as! DataSnapshot)
        returnItem.append(dnItem)
      }
      self.items = returnItem
      self.tableView.reloadData()
    }
  }
  
  func uploadPicture(){
    let localFile = UIImage(named: "images-3.jpeg")
    let uploadRef = storageRef.child("upload Image.jpg")
    let imageData = localFile!.jpegData(compressionQuality: 1.0)
    uploadRef.putData(imageData!, metadata: nil) {
      meta, error in
      if error != nil {
        print(error?.localizedDescription)
      }
    }
  }
  
  @IBAction func itemIMGSetting(_ sender: UIButton) {
    print("pushed Img Btn")
    let sourceType: UIImagePickerController.SourceType = .camera
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      let cameraPicker = UIImagePickerController()
      cameraPicker.sourceType = sourceType
      cameraPicker.delegate = self
      self.present(cameraPicker, animated: true, completion: nil)
    } else {
      let alert = UIAlertController(title: "Camera Error", message: "Your Camera Device is Error", preferredStyle: .alert)
      present(alert, animated: true, completion: nil)
    }
    
  }
  
}//End Of The Class

// MARK: UIPickerController Extenstion
extension GroceryListTableViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImg = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
      
    }
    
  }
  
  
  
}
