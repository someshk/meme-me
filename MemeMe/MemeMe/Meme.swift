//
//  Meme.swift
//  MemeMe
//
//  Created by Somesh Kumar on 12/6/15.
//  Copyright © 2015 Somesh Kumar. All rights reserved.
//

import Foundation
import UIKit

public struct Meme {
    
    public var topText: String = ""
    public var bottomText: String = ""
    public var image: UIImage!
    public var memedImage: UIImage!
    
    public init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
}