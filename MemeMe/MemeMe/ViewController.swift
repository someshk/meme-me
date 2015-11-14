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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // Add Label
        let label = UILabel()
        label.frame = CGRectMake(150,150,60,60)
        label.text = "0"
        self.label = label
        
        self.view.addSubview(label)
        
        // Add Button
        let button = UIButton()
        button.frame = CGRectMake(150, 250,60,60)
        button.setTitle("Click", forState: .Normal)
        button.setTitleColor(UIColor.blueColor(), forState: .Normal)
        self.view.addSubview(button)
        
        button.addTarget(self, action: "incrementCount", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    @IBAction func pickAnImage(sender: UIBarButtonItem) {
        let controller = UIImagePickerController()
        controller.delegate = self
        self.presentViewController(controller, animated: true, completion:nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("User picked an image")
        // Close the image picker
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("User cancelled the operation")
    }
    
    @IBAction func imageButtonClicked(sender: UIButton) {
        let image = UIImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion:nil)
    }

    @IBAction func showAlertButtonClicker(sender: UIButton) {
        let controller = UIAlertController()
        let okAction = UIAlertAction (title: "Ok", style: UIAlertActionStyle.Default){ action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let cancelAction = UIAlertAction (title: "Cancel", style: UIAlertActionStyle.Default){ action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func incrementCount() {
        self.count++
        self.label.text = "\(self.count)"
        // Change the background color
        self.view.backgroundColor = UIColor.redColor()
    }


}

