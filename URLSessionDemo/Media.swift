//
//  Media.swift
//  URLSessionDemo
//
//  Created by l on 7/13/17.
//  Copyright © 2017 l. All rights reserved.
//

import UIKit

struct Media {
    let key:String
    let fileName:String
    let data:Data
    let mime:String
    
    init?(withImage image:UIImage, forKey key:String) {
        self.key = key
        self.mime = "image/jpeg"
        self.fileName = "\(arc4random()).jpeg"
        
        guard let data = UIImageJPEGRepresentation(image,0.7) else {return nil}
        self.data = data
    }
}
