//
//  LoginViewController.swift
//  sefi
//
//  Created by Kevin Meresse on 4/13/15.
//  Copyright (c) 2015 KM. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UISplitViewControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var birthdateTextField: UITextField!
    @IBOutlet weak var authButton: UIButton!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var messageTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Delete stored credentials
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(User.usernameKey)
        defaults.removeObjectForKey(User.birthdateKey)
        
        // Delegate actions concerning text field
        birthdateTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func authenticate(sender: AnyObject) {
        println("LoginViewController:authenticate: Authenticating...")
        // Disable fields and show loading spinner
        idTextField.enabled = false
        birthdateTextField.enabled = false
        authButton.hidden = true
        authButton.enabled = false
        loadingSpinner.startAnimating()
        messageTextField.hidden = true
        
        // Authenticate to server
        SOAPService
            .POST(RequestFactory.login(id: idTextField.text, birthdate: StringFormatter.getXmlDate(birthdateTextField.text)))
            .success({xml in {XMLParser.checkIfAuthenticated(xml)} ~> {self.showContent($0, message: $1)}})
            .failure(onFailure, queue: NSOperationQueue.mainQueue())
    }
    
    private func showContent(authenticated: Bool, message: String?) {
        if authenticated {
            println("LoginViewController:showContent: Successfully authenticated!")
            // Store credentials
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(idTextField.text, forKey: User.usernameKey)
            defaults.setObject(StringFormatter.getXmlDate(birthdateTextField.text), forKey: User.birthdateKey)
            
            // Forward to app content
            self.performSegueWithIdentifier("showAppContent", sender: nil)
        } else {
            println("LoginViewController:showContent: Failed authenticating!")
            // Re-enable fields and hide loading spinner
            resetForm(false)
            messageTextField.hidden = false
            messageTextField.text = message
        }
    }
    
    private func resetForm(emptyFields: Bool) {
        idTextField.enabled = true
        birthdateTextField.enabled = true
        authButton.hidden = false
        authButton.enabled = true
        loadingSpinner.stopAnimating()
        messageTextField.hidden = true
        
        if emptyFields {
            idTextField.text = ""
            birthdateTextField.text = ""
        }
    }
    
    private func onFailure(statusCode: Int, error: NSError?)
    {
        println("HTTP status code \(statusCode)")
        
        let
        title = "Erreur",
        msg   = error?.localizedDescription ?? "Une erreur est survenue.",
        alert = UIAlertController(
            title: title,
            message: msg,
            preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .Default,
            handler: { _ in
                self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        resetForm(false)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // Dismiss keyboard when clicking outside a textview
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        authenticate(textField)
        return true
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showAppContent" || segue.identifier == "forwardToAppContent" {
            // Get the split view controller and configure it
            if let splitViewController = segue.destinationViewController as? UISplitViewController {
                let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
                //navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
                splitViewController.delegate = self
            }
        }
    }
    
    // MARK: - Split view
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
        if let secondaryAsNavController = secondaryViewController as? UINavigationController {
            if let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController {
                if topAsDetailController.detailItem == nil {
                    // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
                    return true
                }
            }
        }
        return false
    }

}
