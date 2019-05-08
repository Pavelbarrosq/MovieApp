//
//  Info.swift
//  Movieapp
//
//  Created by Kim Nordin on 2019-05-08.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import Foundation

class Info : Decodable {
    var page: Int
    var total_results: Int
    var total_pages: Int
    var results: [Movie]
    
    init(page: Int, total_results: Int, total_pages: Int, results: [Movie]) {
        self.page = page
        self.total_results = total_results
        self.total_pages = total_pages
        self.results = results
    }

}
