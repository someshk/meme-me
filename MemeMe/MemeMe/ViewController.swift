//
//  ViewController.swift
//  MemeMe
//
//  Created by Somesh Kumar on 10/29/15.
//  Copyright © 2015 Somesh Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
                UINavigationControllerDelegate {

    var count = 0
    var label:UILabel!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextLabel: UITextField!
    @IBOutlet weak var bottomTextLabel: UITextField!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.redColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : 2
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set the text Style Attributes for the text labels
        topTextLabel.defaultTextAttributes = memeTextAttributes
        topTextLabel.textAlignment = NSTextAlignment.Center
        
        bottomTextLabel.defaultTextAttributes = memeTextAttributes
        bottomTextLabel.textAlignment = NSTextAlignment.Center
        
        self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscribe to keyboard notifications, to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Unsubscribe keyboard notifications
        self.unsubscribeFromKeyboardNotifications()
    }
    
    
    @IBAction func cameraButtonClicked(sender: UIBarButtonItem) {
        let controller = UIImagePickerController()
//        controller.sourceType = UIImagePickerControllerSourceType.Camera
        controller.delegate = self
        self.presentViewController(controller, animated: true, completion:nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("imagePickerController: Image picked")
            
        // Close the image picker and select the image to show in the UIImageView
        dismissViewControllerAnimated(true) { () -> Void in
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.imagePickerView.image = image
            }
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("imagePickerControllerDidCancel: Cancelled operation")
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func albumButtonClicked(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion:nil)
    }
    
    
    func keyBoardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    
    func getKeyboardHeight(notification: NSNotification) ->CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardWillShow", name: UIKeyboardDidShowNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
}

