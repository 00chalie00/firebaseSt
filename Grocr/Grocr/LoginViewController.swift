import UIKit
import Firebase


class LoginViewController: UIViewController {
  
  // MARK: Constants
  let loginToList = "LoginToList"
  
  // MARK: Outlets
  @IBOutlet weak var textFieldLoginEmail: UITextField!
  @IBOutlet weak var textFieldLoginPassword: UITextField!
  
  var alert: UIAlertController?
  
  override func viewDidLoad() {
    
  }
  
  
  // MARK: Actions
  @IBAction func loginDidTouch(_ sender: AnyObject) {
    performSegue(withIdentifier: loginToList, sender: nil)
  }
  
  @IBAction func signUpDidTouch(_ sender: AnyObject) {
    alert = UIAlertController(title: "Register",
                                  message: "Please Input the ID/PW",
                                  preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Save",
                                   style: .default) { action in
      let emailTxt = self.alert!.textFields![0].text
      let passwordText = self.alert!.textFields![1].text
      
      //      call Firebase Auth
      if emailTxt != "" && passwordText != "" {
        Auth.auth().createUser(withEmail: emailTxt!, password: passwordText!) {
          (user, error) in
          print("Success to created a account: \(user!)")
          if user != nil {
            Auth.auth().signIn(withEmail: emailTxt!, password: passwordText!) {
              (user, error) in
              if error != nil {
                print(error!.localizedDescription)
              }
              print("Success to access the Firebase")
              self.performSegue(withIdentifier: self.loginToList, sender: nil)
            }
          }
          if error != nil {
            print(error!.localizedDescription)
          }
        }
      }
    }
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
    
    alert!.addTextField { textEmail in
      textEmail.placeholder = "Enter your email"
      textEmail.tag = 0
      textEmail.addTarget(self, action: #selector(self.textFieldChanged(sender:)), for: .editingChanged)
    }
    alert!.addTextField { textPassword in
      textPassword.isSecureTextEntry = true
      textPassword.placeholder = "Enter your password"
      textPassword.tag = 1
      textPassword.addTarget(self, action: #selector(self.textFieldChanged(sender:)), for: .editingChanged)
    }
    alert!.addAction(saveAction)
    alert!.addAction(cancelAction)
    alert!.actions[0].isEnabled = false
    
    self.present(alert!, animated: true, completion: nil)
  }
  
  @objc func textFieldChanged(sender: UITextField) {
//    let tf = sender
//    var resp: UIResponder! = tf
//    while !(resp is UIAlertController) { resp = resp.next }
//    let alert = resp as! UIAlertController
//    alert.actions[0].isEnabled = (tf.text != "")
    if sender.tag == 0 | 1 && sender.text != "" {
      alert?.actions[0].isEnabled = true
    }
  }
  
}//End Of The Class


extension LoginViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == textFieldLoginEmail {
      textFieldLoginPassword.becomeFirstResponder()
    }
    if textField == textFieldLoginPassword {
      textField.resignFirstResponder()
    }
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if (textField.text == "") {
      alert?.actions[0].isEnabled = false
    } else {
      alert?.actions[0].isEnabled = true
    }
  }
  
  
}//End of TxtFD Ext

