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
    
    struct Info: Decodable {
        let page: Int
        let total_results: Int
        let total_pages: Int
        let results: [Movie]
    }

    let tmdbApi = "https://api.themoviedb.org/3/discover/movie?api_key=d5c04206ed27091dae4a910d147726cc&language"

    var movie: Movie?
    var filteredMovies = Movies()
    var movies = Movies()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let jsonUrl = ("\(tmdbApi)" + "=en-US&page=1")
        guard let url = URL(string: jsonUrl) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Error retreving data: \(error?.localizedDescription)")
            } else {
                print("hi")
                guard let data = data else {return}
                
                do {
                    let movieInfo = try JSONDecoder().decode(Info.self, from: data)
                    print("\(movieInfo.results)", " RESULTS")
                    for each in movieInfo.results {
                        self.movies.list.append(each)
                    }
                    
                } catch {
                    print("could not decode")
                }
            }
            }.resume()

        filteredMovies.list = movies.list
        
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        
        tableView.delegate = self
        tableView.dataSource = self
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
            print("Found These Movies: ", filteredMovies.list)
            return filteredMovies.list.count
        }
        print("not filtering")
        print("Found These Movies: ", movies.list)
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

        let movieImage = movie?.poster_path
        print(movie?.poster_path, "POSTER NAME")
        
        if let image = movieImage {
            guard let url = URL(string: "http://image.tmdb.org/t/p/w185/" + image) else {print("bad url"); return UITableViewCell()}
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    cell.movieImage.image = UIImage(data: data!)
                }
            }).resume()
        }
        cell.movieTitle.text = movie?.title
        cell.movieTitle.backgroundColor = UIColor(red:50.0/255.0, green:50.0/255.0, blue:50.0/255.0, alpha:0.7)

        return cell
    }
    
}

