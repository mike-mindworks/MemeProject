//
//  Meme.swift
//  MemeTestProject
//
//  Created by Mike Allan on 2020-04-12.
//  Copyright © 2020 Mindworks Software Design, Inc. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    
    var topText: String?
    var bottomText: String?
    var originalImage: UIImage?
    var memedImage: UIImage?

    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}
