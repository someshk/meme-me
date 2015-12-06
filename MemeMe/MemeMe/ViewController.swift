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
    
    var activityViewController:UIActivityViewController!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextLabel: UITextField!
    @IBOutlet weak var bottomTextLabel: UITextField!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.grayColor(),
//        NSForegroundColorAttributeName : UIColor.redColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : 2
    ]
    
    func handleShare(Sender: UIBarButtonItem) {
        print("handleShare")
        
        // Create the Meme and save it
        let meme = Meme(topText: topTextLabel.text!, bottomText: bottomTextLabel.text!, image: imagePickerView.image!, memedImage: generateMemeImage())
        
        print("Meme Top Text: " + meme.topText)
        print("Meme Bottom Text: " + meme.bottomText)
        
        activityViewController = UIActivityViewController(
            activityItems: [NSString(string: "Sharing Meme")],
            applicationActivities: nil)
        
        presentViewController(activityViewController,
            animated: true,
            completion: {
        })
    
    }
    
    func handleCancel(Sender: UIBarButtonItem) {
        print("handleCancel")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        navigationItem.setRightBarButtonItem(cancelButton, animated: true)
        
        // Set the text Style Attributes for the text labels
        topTextLabel.defaultTextAttributes = memeTextAttributes
        topTextLabel.textAlignment = NSTextAlignment.Center
        
        bottomTextLabel.defaultTextAttributes = memeTextAttributes
        bottomTextLabel.textAlignment = NSTextAlignment.Center
        
        self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
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
    
    func generateMemeImage() -> UIImage
    {
        // Hide the Navigation and toolbar
       self.navigationController?.navigationBarHidden = true
       self.navigationController?.setToolbarHidden(true, animated: false)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        // Show navigation and tool bar
        // Hide the Navigation and toolbar
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.setToolbarHidden(true, animated: false)
        
        return memedImage
    }
}

