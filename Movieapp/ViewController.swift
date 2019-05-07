//
//  ViewController.swift
//  Movie
//
//  Created by Kim Nordin on 2019-04-29.
//  Copyright © 2019 kim. All rights reserved.
//

import UIKit
import SVProgressHUD

//struct Movie {
//    var title = ""
//    var image = #imageLiteral(resourceName: "KillBill")
//}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    let titleArray = ["Avengers", "Kill Bill", "Film", "Film", "Film"]
    let imageArray: [UIImage] = [#imageLiteral(resourceName: "Avengers"), #imageLiteral(resourceName: "KillBill")]
    let dogColorArray = [UIColor.red, UIColor.blue, UIColor.green, UIColor.orange, UIColor.purple, UIColor.yellow, UIColor.magenta]
//    let movie = Movies(title: "", image: #imageLiteral(resourceName: "KillBill"))
    var movie: Movie?
    var filteredMovies = Movies()
    var movies = Movies()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let avengers = Movie(title: "Avengers", image: #imageLiteral(resourceName: "Avengers"), selected: true)
        movies.add(movie: avengers)
       
        let killbill = Movie(title: "KillBill", image: #imageLiteral(resourceName: "KillBill"), selected: true)
        movies.add(movie: killbill)
        //comment
        
        let bvs = Movie(title: "Batman VS Superman", image: #imageLiteral(resourceName: "BVS"), selected: true)
        movies.add(movie: bvs)
        
        let evangelion = Movie(title: "Evangelion", image: #imageLiteral(resourceName: "Evangelion"), selected: true)
        movies.add(movie: evangelion)
        
        let aquaman = Movie(title: "Aquaman", image: #imageLiteral(resourceName: "Aquaman"), selected: true)
        movies.add(movie: aquaman)
        
        print(movies.list) //[Movieapp.Movie, Movieapp.Movie, Movieapp.Movie]
        print(movies.list.count) //3
        for movies in movies.list {
            print(movies.title)
        }

        filteredMovies.list = movies.list
        
        // Pavel
        
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.text = ""
        self.view.endEditing(true)
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        if searchBar.text == "" {
            filteredMovies.list = movies.list
            return false
        }
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchText)
        tableView.reloadData()
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        if searchBar.text != "" {
            filteredMovies.list = movies.list.filter({( movie : Movie) -> Bool in
                return movie.title.lowercased().contains(searchText.lowercased())
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering() == true {
            print("is filtering")
            return filteredMovies.list.count
        }
        print("not filtering")
        return movies.list.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        if isFiltering() {
            print("filtered cells")
            movie = filteredMovies.entry(index: indexPath.section)
        }
        else {
            print("all cells")
            movie = movies.entry(index: indexPath.section)
        }
//        let uimage = imageArray.image(index: indexPath.row)
        cell.movieImage.image = movie?.image
        cell.movieTitle.text = movie?.title
        cell.movieTitle.backgroundColor = UIColor(red:50.0/255.0, green:50.0/255.0, blue:50.0/255.0, alpha:0.7)

        return cell
    }
    
}

