//
//  ViewController.swift
//  MemeMe
//
//  Created by Somesh Kumar on 10/29/15.
//  Copyright © 2015 Somesh Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
                UINavigationControllerDelegate, UITextFieldDelegate {

    var count = 0
    var label:UILabel!
    
    let topTextDefault: String = "Top"
    let bottomTextDefault: String = "Bottom"
    var revertTextLabel: String!
    var activeField: UITextField!
    
    var keyboardHeight: CGFloat = 0
    
    var activityViewController:UIActivityViewController!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.grayColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -2.0
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the text Style Attributes for the text labels
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        topTextField.delegate = self
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.delegate = self
        
        navigationItem.title = "Meme"
        
        // Setup the share button
        navigationItem.leftBarButtonItem = UIBarButtonItem(
                            barButtonSystemItem: .Action, target: self, action: "handleShare:")
        
        // Set up the cancel button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "handleCancel:")
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscribe to keyboard notifications, to allow the view to raise when necessary
         subscribeToKeyboardNotifications()
        
        // Enable / Disable Camera Button depending on if device supports camera or not
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Disable Share button
        navigationItem.leftBarButtonItem?.enabled = false;
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe keyboard notifications
        unsubscribeFromKeyboardNotifications()
    }
    
    func handleShare(Sender: UIBarButtonItem) {
        print("handleShare")
        
        // Create the Meme and save it
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memedImage: generateMemeImage())
        
        print("Meme Top Text: " + meme.topText)
        print("Meme Bottom Text: " + meme.bottomText)
        
        let shareMeme:Array = [meme.memedImage]
        
        activityViewController = UIActivityViewController(
            activityItems: shareMeme,
            applicationActivities: nil)
        
        /// Excludes following share options
        activityViewController.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo]
        
        // Set Completion handler
        activityViewController.completionWithItemsHandler = activityCompletionHandler;
        presentViewController(activityViewController,
            animated: true,
            completion: {
        })
        
    }
    
    func activityCompletionHandler(activityType: String?,
        completed: Bool,
        returnedItems: [AnyObject]?,
        activityError: NSError?){
            print("activityCompletionHandler")
            dismissViewControllerAnimated(true, completion: nil)
            
    }
    
    func handleCancel(Sender: UIBarButtonItem) {
        print("handleCancel")
        
        // Remove the selected image from the Image View
        imagePickerView.image = nil
        
        // Disable the Meme Share button
        navigationItem.leftBarButtonItem?.enabled = false
        
        // Reset the top and bottom text fields to default
        topTextField.text = topTextDefault
        bottomTextField.text = bottomTextDefault
    }

    
    @IBAction func cameraButtonClicked(sender: UIBarButtonItem) {
        let controller = UIImagePickerController()
        controller.sourceType = UIImagePickerControllerSourceType.Camera
        controller.delegate = self
        presentViewController(controller, animated: true, completion:nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("imagePickerController: Image picked")
            
        // Close the image picker and select the image to show in the UIImageView
        dismissViewControllerAnimated(true) { () -> Void in
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.imagePickerView.image = image
                
                // Enable the Meme Share button
                self.navigationItem.leftBarButtonItem?.enabled = true
            }
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("imagePickerControllerDidCancel: Cancelled operation")
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func albumButtonClicked(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion:nil)
    }
    
    
    func keyboardDidAppear(notification: NSNotification) {
        print("keyboardDidAppear")
        let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= frame.size.height
        if (!CGRectContainsPoint(aRect, activeField!.frame.origin))
        {
            UIView.animateWithDuration(0.5) {
                self.view.frame.origin.y -= frame.size.height
                self.keyboardHeight = frame.size.height
            }
        } else {
            self.keyboardHeight = 0
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        print("keyboardWillHide")
        view.frame.origin.y += self.keyboardHeight
    }
    
    
    func getKeyboardHeight(notification: NSNotification) ->CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    
    func subscribeToKeyboardNotifications() {
        print("subscribeToKeyboardNotifications")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidAppear:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        print("unsubscribeFromKeyboardNotifications")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    func generateMemeImage() -> UIImage
    {
        // Hide the Navigation and toolbar
       navigationController?.navigationBarHidden = true
       navigationController?.setToolbarHidden(true, animated: false)
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        // Show navigation and tool bar
        navigationController?.navigationBarHidden = false
        navigationController?.setToolbarHidden(false, animated: false)
        
        return memedImage
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        print("textFieldDidBeginEditing")
        activeField = textField
        if textField.text!.compare(topTextDefault) == NSComparisonResult.OrderedSame ||
            textField.text!.compare(bottomTextDefault) == NSComparisonResult.OrderedSame {
                revertTextLabel = textField.text;
                textField.text = "";
        } else {
            
        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // Add code to dismiss the keyboard
        activeField = nil
        if textField.text?.isEmpty == false {
            print(textField.text)
        } else {
            // Text field is empty - need to see which text field it was
            textField.text = revertTextLabel;
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}