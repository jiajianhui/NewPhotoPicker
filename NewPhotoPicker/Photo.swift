//
//  Photo.swift
//  NewPhotoPicker
//
//  Created by 贾建辉 on 2025/7/9.
//

import Foundation
import SwiftData


@Model
class Photo {
    var createAt: Date = Date.now
    
    @Attribute(.externalStorage)
    var image: Data?
    
    init(image: Data?) {
        self.createAt = Date.now
        self.image = image
    }
    
}
