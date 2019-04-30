//
//  ViewController.swift
//  Movie
//
//  Created by Kim Nordin on 2019-04-29.
//  Copyright © 2019 kim. All rights reserved.
//

import UIKit

//struct Movie {
//    var title = ""
//    var image = #imageLiteral(resourceName: "KillBill")
//}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let titleArray = ["Avengers", "Kill Bill", "Film", "Film", "Film"]
    let imageArray: [UIImage] = [#imageLiteral(resourceName: "Avengers"), #imageLiteral(resourceName: "KillBill")]
    let dogColorArray = [UIColor.red, UIColor.blue, UIColor.green, UIColor.orange, UIColor.purple, UIColor.yellow, UIColor.magenta]
//    let movie = Movies(title: "", image: #imageLiteral(resourceName: "KillBill"))
    var searchText = ""
    var movie: Movie?
    let movieList = Movies()

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let avengers = Movie(title: "Avengers", image: #imageLiteral(resourceName: "Avengers"))
        movieList.add(movie: avengers)
       
        
        let killbill = Movie(title: "KillBill", image: #imageLiteral(resourceName: "KillBill"))
        movieList.add(movie: killbill)
        //comment
        

        
        searchButton.layer.cornerRadius = 15
        searchButton.clipsToBounds = true
        // Do any additional setup after loading the view.

        
        // Pavel

        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    @IBAction func searchButton(_ sender: Any) {
        if let name = searchField.text {
            print(name, "banan")
            print(movieList.count)
                for n in 0...movieList.list.count-1 {
                    print("n är", n)
                    if movieList.entry(index: n)?.title != name {
                        print("suave")
                        movieList.delete(index: n)
                    }
                    else {
                        print("error")
                    }
                }
//            if name == movieList.entry(index: 0)?.title {
//                print("coolt")
//            }
//            if name == movieList.entry(index: 1)?.title {
//
//            }

            tableView.reloadData()
        }

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if searchField.text != nil {
            searchField.resignFirstResponder()
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return movieList.count

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tjo")
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        
        headerView.backgroundColor = UIColor.clear

        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
//        let uimage = imageArray.image(index: indexPath.row)
        cell.movieImage.image = movieList.entry(index: indexPath.section)?.image
        cell.movieTitle.text = movieList.entry(index: indexPath.section)?.title
        cell.movieTitle.backgroundColor = UIColor(red:50.0/255.0, green:50.0/255.0, blue:50.0/255.0, alpha:0.7)

        print("hej")
        return cell
    }
    
}

