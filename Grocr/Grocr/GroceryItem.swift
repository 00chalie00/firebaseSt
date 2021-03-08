import Foundation
import Firebase

struct GroceryItem {
  let key: String
  let image: String?
  let productName: String?
  let price: String?
  let describe: String?
  let complete: Bool?
  let ref: DatabaseReference?
  
  init(key: String = "", image: String, name: String, price: String, describe: String, complete: Bool) {
    self.key = key
    self.image = image
    self.productName = name
    self.price = price
    self.describe = describe
    self.complete = complete
    self.ref = nil
  }
  
  init(snapshot: DataSnapshot) {
    let snapshotValue = snapshot.value as! [String: AnyObject]
    self.key = snapshot.key
    self.image = snapshotValue["image"] as? String
    self.productName = snapshotValue["name"] as? String
    self.price = snapshotValue["price"] as? String
    self.describe = snapshotValue["desc"] as? String
    self.complete = snapshotValue["complete"] as? Bool
    self.ref = snapshot.ref
  }
  
  init(document: QueryDocumentSnapshot) {
    let dataDic = document.data()
    
    self.key = document.documentID
    self.image = dataDic["Image URL"] as? String
    self.productName = dataDic["name"] as? String
    self.price = dataDic["price"] as? String
    self.describe = dataDic["desc"] as? String
    self.complete = dataDic["complete"] as? Bool
    self.ref = nil
    
  }
  
  func toAnyObject() -> Any {
    return [
      "image": image,
      "produceName": productName,
      "price": price,
      "describe": describe,
      "complete": complete
    ]
  }
  
}//End Of The Struct


