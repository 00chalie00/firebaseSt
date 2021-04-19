import UIKit
import Firebase

class GroceryListTableViewController: UITableViewController {
  
  // MARK: Constants
  let listToUsers = "ListToUsers"
  
  // MARK: Properties 
  var items: [GroceryItem] = []
  var currentData:[String:Any] = [:]
  var currentImg: UIImage?
  var returnDayArr:[String] = []
  
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
    print("will")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("did")
  }
  
  @objc func refresh() {
    self.items = []
    
    let loadView = UIView()
    let loadLabel = UILabel()
    let spinner = UIActivityIndicatorView()
    
    print("Start Spinner")
    
    let width: CGFloat = 230
    let height: CGFloat = 30
    let x = (tableView.frame.width / 2) - (width / 2)
    let y = (tableView.frame.height / 2) - (height / 2)
    loadView.frame = CGRect(x: 0, y: 0, width: width, height: height)
    loadView.backgroundColor = .lightGray
    
    loadLabel.text = "Loading Please Wait"
    loadLabel.textColor = .black
    loadLabel.textAlignment = .center
    loadLabel.frame = CGRect(x: 30, y: 0, width: 200, height: 30)
    
    spinner.style = .medium
    spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    spinner.startAnimating()
    
    loadView.addSubview(loadLabel)
    loadView.addSubview(spinner)
    
    tableView.addSubview(loadView)
    queryforServer()
    
    spinner.stopAnimating()
    spinner.isHidden = true
    loadView.isHidden = true
    
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
    
    tableView.reloadData()
    loadScreen.setLoadingScreen(uiView: tableView)
    
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
        for i in 0..<self.items.count {
          var compareDate = self.items[i].currentDate
          var comparePrice = self.items[i].price
          if self.items[i].price.count > self.items[i].currentDate.count {
            print("price is more")
            let loopCount = self.items[i].price.count - self.items[i].currentDate.count
            for _ in 0..<loopCount {
              let lastDate = self.items[i].currentDate.last
              compareDate.append(lastDate!!)
              returnItem[i].currentDate = compareDate
            }
            //self.returnDayArr = self.getDays(days: self.items[i].currentDate)
            self.items = returnItem
          } else if self.items[i].price.count < self.items[i].currentDate.count  {
            print("date is more")
            let loopCount = self.items[i].currentDate.count - self.items[i].price.count
            for _ in 0..<loopCount {
              let lastPrice = self.items[i].price.last
              comparePrice.append(lastPrice!!)
              returnItem[i].price = comparePrice
            }
            //self.returnDayArr = self.getDays(days: self.items[i].currentDate)
            self.items = returnItem
          } else if self.items[i].price.count == self.items[i].currentDate.count {
            print("equal")
            self.items = returnItem
            //self.returnDayArr = self.getDays(days: self.items[i].currentDate)
          }
        }
        self.loadScreen.spinnerOff()
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
  
  func getDays(days: [String?]) -> [String] {
    var dayArr:[String] = []
    for i in 0..<days.count {
      let dayStr = days[i]
      let startDay = dayStr!.index(dayStr!.startIndex, offsetBy: 8)
      let endDay = dayStr!.index(dayStr!.startIndex, offsetBy: 9)
      let returnDay = String(dayStr![startDay...endDay])
      dayArr.append(returnDay)
    }
    print("TVC")
    return dayArr
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
  
    let defaultUrlStr = "https://firebasestorage.googleapis.com/v0/b/fir-study-b239d.appspot.com/o/Market%20Price%2FMarket%20Price%2F%EB%A7%A4%EC%A7%81%20%EB%A7%88%EC%9A%B0%EC%8A%A4?alt=media&token=27241331-c409-40be-9749-66c4621d3ef9"
    let imgUrl:URL = URL(string: groceryItem.image ?? defaultUrlStr)!
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
    print("did select")
    let indexData = items[indexPath.row]
    currentData = ["Name": indexData.productName!, "Price": indexData.price, "LastPrice": indexData.price.last!!, "Current Date": indexData.currentDate]
    guard let cell = tableView.cellForRow(at: indexPath) as? CellController else { return }
    currentImg = cell.img.image
    
    self.returnDayArr = self.getDays(days: indexData.currentDate)
    
    performSegue(withIdentifier: "DetailVC", sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    print("Segue")
    let destinationVC = segue.destination as! DetailViewController
    destinationVC.name = currentData["Name"] as? String
    destinationVC.price = currentData["LastPrice"] as? String
    //    destinationVC.priceS = currentData["Price"] as? [String]
    //    destinationVC.currentDate = currentData["Current Date"] as? [String]
    
    print((currentData["Price"] as? [String])!.count)
    print((currentData["Current Date"] as? [String])!.count)
    
    destinationVC.priceS = currentData["Price"] as? [String]
    destinationVC.currentDate = currentData["Current Date"] as? [String]
    destinationVC.dayArr = returnDayArr
    destinationVC.productIMG = currentImg!
    //let text = tableView.indexPathForSelectedRow
    destinationVC.indexPathInt = tableView.indexPathForSelectedRow!
    print("IndexPath.Row \(String(describing: tableView.indexPathForSelectedRow))")
  }
  
  override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAC = UIContextualAction(style: .normal, title: "Delete") { (action, view, complionHalder) in
      print("Swipe Delete")
      let deletItem = self.items[indexPath.row]
      Firestore.firestore().collection("Market Price").document(deletItem.key).delete {
        error in
        if error != nil {
          print(error?.localizedDescription as Any)
        }
        self.items.remove(at: indexPath.row)
        self.queryforServer()
      }
      
      
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

