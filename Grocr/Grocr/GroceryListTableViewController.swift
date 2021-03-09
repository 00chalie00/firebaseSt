import UIKit
import Firebase

class GroceryListTableViewController: UITableViewController {
  
  // MARK: Constants
  let listToUsers = "ListToUsers"
  
  // MARK: Properties 
  var items: [GroceryItem] = []
  var currentData:[String:Any] = [:]
  var currentImg: UIImage = UIImage()
  
  var user: User!
  var userCountBarButtonItem: UIBarButtonItem!
  var loadView = UIView()
  var loadLabel = UILabel()
  var spinner = UIActivityIndicatorView()
  
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
  
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//    self.items = []
//    self.currentData = [:]
//    self.currentImg = nil
//
//    queryforServer()
//    self.tableView.reloadData()
//    print("Will")
//  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.items = []
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
    
    setLoadingScreen()

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
      self.spinnerOff()
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
  
  func setLoadingScreen() {
    let width: CGFloat = 230
    let height: CGFloat = 30
    let x = (tableView.frame.width / 2) - (width / 2)
    let y = (tableView.frame.height / 2) - (height / 2)
    loadView.frame = CGRect(x: x, y: y, width: width, height: height)
    
    loadLabel.text = "Loading Please Wait"
    loadLabel.textAlignment = .center
    loadLabel.frame = CGRect(x: 30, y: 0, width: 200, height: 30)
    
    spinner.style = .medium
    spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    spinner.startAnimating()
    
    loadView.addSubview(loadLabel)
    loadView.addSubview(spinner)
    
    tableView.addSubview(loadView)
    
  }
  
  func spinnerOff() {
    spinner.stopAnimating()
    spinner.isHidden = true
    loadView.isHidden = true
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
    cell.price.text = groceryItem.price!
    
    let imgUrl:URL = URL(string: groceryItem.image!)!
    let imgData = try! Data(contentsOf: imgUrl)
    cell.img.image = UIImage(data: imgData)
    if let selImage = cell.img.image {
      DispatchQueue.main.async {
        self.currentImg = selImage
      }
    }

    
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
    currentData = ["Name": indexData.productName, "Price": indexData.price]
    performSegue(withIdentifier: "DetailVC", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    print("Segue")
    let destinationVC = segue.destination as! DetailViewController
    destinationVC.name = currentData["Name"] as? String
    destinationVC.price = currentData["Price"] as? String
    destinationVC.productIMG = currentImg
    print(currentImg)
  }
  
}//End Of The Class



// MARK: UIPickerController Extenstion
extension GroceryListTableViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImg = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
      
    }
  }
}

