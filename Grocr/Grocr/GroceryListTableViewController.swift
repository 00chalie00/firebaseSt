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
    
    queryforServer()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.items = []
    self.tableView.reloadData()
    queryforServer()
    self.tableView.reloadData()
    print("Will")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.items = []
    self.tableView.reloadData()
    queryforServer()
    self.tableView.reloadData()
    print("Did")
  }
  
  @objc func refresh() {
    self.items = []
    queryforServer()
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
  
  func queryforServer(){
    print("Called Query Func")
    var returnItem: [GroceryItem] = []
    
    Firestore.firestore().collection("Market Price").getDocuments(completion: {
      snapshot, error in
      if error != nil {
        print(error?.localizedDescription as Any)
      }
      if let dnData = snapshot {
        let convertData = dnData.documents
        for i in 0..<convertData.count {
          returnItem.append(GroceryItem(document: convertData[i]))
        }
        self.items = returnItem
        self.tableView.reloadData()
      }
      
      // Query from RealTime DB
      //    childRefer.queryOrdered(byChild: childName).observe(.value) {
      //      (dataSnapshot) in
      //      for item in dataSnapshot.children {
      //        let dnItem = GroceryItem(snapshot: item as! DataSnapshot)
      //        returnItem.append(dnItem)
      //      }
      //      self.items = returnItem
      //      //print("\(returnItem[0].productName)")
      //      self.tableView.reloadData()
      //    }
    })
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
  
    cell.name.text = groceryItem.productName!
    print(groceryItem.productName!)
    cell.price.text = groceryItem.price!
    
    let imgUrl:URL = URL(string: groceryItem.image!)!
    let imgData = try! Data(contentsOf: imgUrl)
    cell.IMG.image = UIImage(data: imgData)
    
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
//    let detailvc = storyboard?.instantiateViewController(identifier: "DetailVC") as? DetailViewController
//    present(detailvc!, animated: true, completion: nil)
    performSegue(withIdentifier: "DetailVC", sender: nil)
    
  }
  
}//End Of The Class



// MARK: UIPickerController Extenstion
extension GroceryListTableViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImg = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
      
    }
  }
}

