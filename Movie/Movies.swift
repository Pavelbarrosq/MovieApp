//
//  Movie.swift
//  Movieapp
//
//  Created by Kim Nordin on 2019-04-30.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import Foundation

class Movies {

    var list = [Movie]()

    var count : Int {
        return list.count
    }
    
    func add(movie: Movie) {
        list.append(movie)
    }
    
    func delete(index: Int){
        list.remove(at: index)
    }
    
    func entry(index: Int) -> Movie? {
        
        if index >= 0 && index <= list.count {
            return list[index]
        }
        
        return nil
    }
}
