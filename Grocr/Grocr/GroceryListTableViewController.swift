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
  let childRefer = Database.database().reference(withPath: "Market Price")
  
  let storageRef = Storage.storage().reference(withPath: "Market Price")
  
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
    
    NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: Notification.Name("newDataNoti"), object: nil)
    
    //Server Data Load
    queryforServer("complete")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.items = []
    self.tableView.reloadData()
    queryforServer("complete")
    self.tableView.reloadData()
    print("Will")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.items = []
    self.tableView.reloadData()
    queryforServer("complete")
    self.tableView.reloadData()
    print("Did")
  }
  
  @objc func refresh() {
    self.items = []
    queryforServer("complete")
    self.tableView.reloadData()
    print("NOTI")
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
      print("\(returnItem[0].productName)")
      self.tableView.reloadData()
    }
  }
  
  @IBAction func itemIMGSetting(_ sender: UIButton) {
    print("pushed Img Btn")
  }
  
  
  // MARK: UITableView Delegate methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print(items.count)
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! CellController
    let groceryItem = items[indexPath.row]
       //cell.IMG.image = UIImage(named: "person.circle")
      //cell.name.text = groceryItem.name
      //cell.addUser.text = groceryItem.addedByUser
    
    cell.name.text = groceryItem.productName
    cell.price.text = String(groceryItem.price)
    cell.IMG.image = UIImage(named: "users.png")
    
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
    // let toggledCompletion = !groceryItem.completed
    //let value:[String:Any] = ["completed": toggledCompletion]
    //let itemRefer = childRefer.child(cell.textLabel!.text!)
    //toggleCellCheckbox(cell, isCompleted: toggledCompletion)
    //itemRefer.ref.updateChildValues(value)
    tableView.reloadData()
  }
  
}//End Of The Class



// MARK: UIPickerController Extenstion
extension GroceryListTableViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImg = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
      
    }
  }
}
