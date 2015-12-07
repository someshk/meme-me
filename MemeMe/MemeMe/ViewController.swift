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
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextLabel: UITextField!
    @IBOutlet weak var bottomTextLabel: UITextField!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.grayColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : 2
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the text Style Attributes for the text labels
        self.topTextLabel.defaultTextAttributes = memeTextAttributes
        self.topTextLabel.textAlignment = NSTextAlignment.Center
        
        self.bottomTextLabel.defaultTextAttributes = memeTextAttributes
        self.bottomTextLabel.textAlignment = NSTextAlignment.Center
        
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
        
        // Enable / Disable Camera Button
        self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Unsubscribe keyboard notifications
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func handleShare(Sender: UIBarButtonItem) {
        print("handleShare")
        
        // Create the Meme and save it
        let meme = Meme(topText: topTextLabel.text!, bottomText: bottomTextLabel.text!, image: imagePickerView.image!, memedImage: generateMemeImage())
        
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
            self.dismissViewControllerAnimated(true, completion: nil)
            if completed && activityError == nil {
                
                let item = returnedItems?[0] as! NSExtensionItem
                
                //                if let attachments = item.attachments{
                //
                //                    let attachment = attachments[0] as! NSItemProvider
                //
                //                    if attachment.hasItemConformingToTypeIdentifier(type){
                //                        attachment.loadItemForTypeIdentifier(type, options: nil,
                //                            completionHandler:{
                //                                (item: NSSecureCoding?, error: NSError?) in
                //
                //                                if let error = error{
                //                                    self.textField.text = "\(error)"
                //                                } else if let value = item as? String{
                //                                    self.textField.text = value
                //                                }
                //
                //                        })
                //                    }
                
                //                }
                
            }
            
    }
    
    func handleCancel(Sender: UIBarButtonItem) {
        print("handleCancel")
    }

    
    @IBAction func cameraButtonClicked(sender: UIBarButtonItem) {
        let controller = UIImagePickerController()
        controller.sourceType = UIImagePickerControllerSourceType.Camera
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
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        return memedImage
    }
}