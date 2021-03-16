import UIKit
import Firebase

class GroceryListTableViewController: UITableViewController {
  
  // MARK: Constants
  let listToUsers = "ListToUsers"
  
  // MARK: Properties 
  var items: [GroceryItem] = []
  var currentData:[String:Any] = [:]
  var currentImg: UIImage?
  
  var user: User!
  var userCountBarButtonItem: UIBarButtonItem!
  
  var loadScreen:UIVC = UIVC()
  
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
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

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
    
    loadScreen.setLoadingScreen(uiView: tableView)
    tableView.reloadData()
    
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
        print(returnItem)
        self.tableView.reloadData()
      }
      self.loadScreen.spinnerOff()
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
    return items.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! CellController
    let groceryItem = items[indexPath.row]
  
    cell.name.text = groceryItem.productName!
    //Convert Price Format
    let numberFormat = NumberFormatter()
    numberFormat.numberStyle = .decimal
    let lastPrice = groceryItem.price.last!!
    let lastPriceStr = numberFormat.string(for: Int(lastPrice))
    cell.price.text = lastPriceStr!
    
    let imgUrl:URL = URL(string: groceryItem.image!)!
    let imgData = try! Data(contentsOf: imgUrl)
    cell.img.image = UIImage(data: imgData)
    
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
    let indexData = items[indexPath.row]
    currentData = ["Name": indexData.productName!, "Price": indexData.price, "LastPrice": indexData.price.last!!, "Current Date": indexData.currentDate]
    guard let cell = tableView.cellForRow(at: indexPath) as? CellController else { return }
    currentImg = cell.img.image
    
    performSegue(withIdentifier: "DetailVC", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    print("Segue")
    let destinationVC = segue.destination as! DetailViewController
    destinationVC.name = currentData["Name"] as? String
    destinationVC.price = currentData["LastPrice"] as? String
    destinationVC.priceS = currentData["Price"] as? [String]
    destinationVC.currentDate = currentData["Current Date"] as? [NSDate]
    destinationVC.productIMG = currentImg!
  }
  
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAC = UIContextualAction(style: .normal, title: "Delete") { (action, view, complionHalder) in
      print("Swipe Delete")
      complionHalder(true)
    }
//    let updateAC = UIContextualAction(style: .destructive, title: "Update") { (action, view, completionHalder) in
//      print("Swipe Update")
//      completionHalder(true)
//    }
    
    return UISwipeActionsConfiguration(actions: [deleteAC])
    
  }
  
}//End Of The Class



// MARK: UIPickerController Extenstion
extension GroceryListTableViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if (info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage) != nil {
      
    }
  }
}

