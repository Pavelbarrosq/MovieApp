//
//  Shows.swift
//  Movieapp
//
//  Created by Kim Nordin on 2019-05-15.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import Foundation

class Shows {
    
    var list = [Show]()
    
    var count : Int {
        return list.count
    }
    
    func add(show: Show) {
        list.append(show)
    }
    
    func delete(index: Int){
        list.remove(at: index)
    }
    
    func entry(index: Int) -> Show? {
        
        if index >= 0 && index <= list.count {
            return list[index]
        }
        
        return nil
    }
    
    func clear() {
        list.removeAll()
    }
}
