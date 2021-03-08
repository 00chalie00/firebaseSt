import UIKit
import Firebase


class LoginViewController: UIViewController {
  
  // MARK: Constants
  let loginToList = "LoginToList"
  
  // MARK: Outlets
  @IBOutlet weak var textFieldLoginEmail: UITextField!
  @IBOutlet weak var textFieldLoginPassword: UITextField!
  
  override func viewDidLoad() {
    
  }
  
  
  // MARK: Actions
  @IBAction func loginDidTouch(_ sender: AnyObject) {
    performSegue(withIdentifier: loginToList, sender: nil)
  }
  
  @IBAction func signUpDidTouch(_ sender: AnyObject) {
    let alert = UIAlertController(title: "Register",
                                  message: "Register",
                                  preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Save",
                                   style: .default) { action in
      let emailTxt = alert.textFields![0].text
      let passwordText = alert.textFields![1].text
      
      //call Firebase Auth
      Auth.auth().createUser(withEmail: emailTxt!, password: passwordText!) {
        (user, error) in
        if error != nil {
          print(error!.localizedDescription)
        }
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
      }
    }
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
    
    alert.addTextField { textEmail in
      textEmail.placeholder = "Enter your email"
    }
    
    alert.addTextField { textPassword in
      textPassword.isSecureTextEntry = true
      textPassword.placeholder = "Enter your password"
    }
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true, completion: nil)
  }
  
}

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
  
}

