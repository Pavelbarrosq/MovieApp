//
//  Movies.swift
//  Movie
//
//  Created by Kim Nordin on 2019-04-29.
//  Copyright © 2019 kim. All rights reserved.
//

import Foundation
import UIKit

class Movie {
    var title: String
    var image: UIImage
    var selected: Bool = true
    
    init(title: String, image: UIImage, selected: Bool) {
        self.title = title
        self.image = image
        self.selected = selected
    }
}
