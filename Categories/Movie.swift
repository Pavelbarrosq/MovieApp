//
//  Movies.swift
//  Movie
//
//  Created by Kim Nordin on 2019-04-29.
//  Copyright © 2019 kim. All rights reserved.
//

import Foundation
import UIKit

class Movie : Decodable {
    var title: String
    var vote_average: Double
    var poster_path: String
}
