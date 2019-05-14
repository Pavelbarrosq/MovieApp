//
//  ViewController.swift
//  Movie
//
//  Created by Kim Nordin on 2019-04-29.
//  Copyright © 2019 kim. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    struct Info: Decodable {
        let page: Int
        let total_results: Int
        let total_pages: Int
        let results: [Movie]
    }

//    var tmdbApi = "https://api.themoviedb.org/3/discover/movie?api_key=d5c04206ed27091dae4a910d147726cc&language=en-US&page=1"
    var jsonUrl = "https://api.themoviedb.org/3/discover/movie?sort_by=vote_average.asc&api_key=d5c04206ed27091dae4a910d147726cc&vote_count.gte=50&page=" //page=1&

    var movie: Movie?
    var filteredMovies = Movies()
    var movies = Movies()
    var page =  0
    var busyLoading = false

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func indexChanged(_ sender: Any) {
        
       
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
        
        
        movies.clear()
        filteredMovies.clear()
        
        self.tableView.reloadData()
        
        page = 1
        print("INDEX CHANGED with page: \(page) and moviecount: \(movies.count)")
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {

       
            switch self.segmentedControl.selectedSegmentIndex
            {
            case 0:
                self.jsonUrl =  "https://api.themoviedb.org/3/discover/movie?sort_by=vote_average.asc&api_key=d5c04206ed27091dae4a910d147726cc&vote_count.gte=50&page=" //
                self.reloadMovies()
                //            print(jsonUrl)
            case 1:
                self.jsonUrl = "https://api.themoviedb.org/3/discover/movie?sort_by=vote_average.desc&api_key=d5c04206ed27091dae4a910d147726cc&vote_count.gte=50&page="
                self.reloadMovies()
                //            print(jsonUrl)
            default:
                break
        }
        //}
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        page = 1
        busyLoading = false
        
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
        
       
        
      // filteredMovies.list = movies.list
    }
    
    override func viewWillAppear(_ animated: Bool) {

         reloadMovies()
    }
    
    func reloadMovies() {
        print("€€€€€€€### JSONURL = \(jsonUrl)")
        print("Page is : \(page)")
     
        guard let url = URL(string: jsonUrl + String(page)) else {return}
        
        print("New URL: \(url)")
        
        SVProgressHUD.show(withStatus: "Finding...")
        print("progressbar")
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Error retreving data: \(error?.localizedDescription)")
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            } else {
                //                print("hi")
                guard let data = data else {return}
                
//                Try fetching the API data specifed in the Info Struct
                do {
                    let movieInfo = try JSONDecoder().decode(Info.self, from: data)
                    print("\(movieInfo.results)", " RESULTS")
                    DispatchQueue.main.async {
                        for each in movieInfo.results {
                                self.movies.list.append(each)
                        }
                        //        On start, append all movies to the filteredMovies list
                        self.filteredMovies.list = self.movies.list
                        print("antal movies hittade: \(self.movies.list.count)")
                        self.tableView.reloadData()
                        SVProgressHUD.dismiss()
                        print("dismissing progressbar")
                        //enable the loading of more movies
                        self.busyLoading = false
                    }

                    
                } catch {
                    print("could not decode")
                }
            }
            }.resume()

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
        if filteredMovies.count < 1 {
            print("status progressbar")
            SVProgressHUD.showInfo(withStatus: "Search found nothing")
        }else{
            SVProgressHUD.dismiss()
        }
        //SVProgressHUD.dismiss(withDelay: 3)
        tableView.reloadData()
    }
    
//    Filter movies where movie.title matches searchBar.text
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
    
//    Return the filteredMovies list if filtering, return all Movies if not
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering() == true {
            print("is filtering")
            print("Found These Movies: ", filteredMovies.list)
            return filteredMovies.list.count
        }
//        print("not filtering")
//        print("Found These Movies: ", movies.list)
        return movies.list.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        if isFiltering() {
//            print("filtered cells")
            movie = filteredMovies.entry(index: indexPath.section)
        }
        else {
//            print("all cells")
            movie = movies.entry(index: indexPath.section)
        }
        let movieName = movie?.title
        print(movieName, "MOVIE NAME")
        let movieImage = movie?.poster_path
        print(movieImage, "POSTER NAME")
        
        if let image = movieImage {
            guard let url = URL(string: "http://image.tmdb.org/t/p/w500/" + image) else {print("bad url"); return UITableViewCell()}
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
        cell.movieRating.text = movie?.vote_average.description
        cell.movieRating.layer.cornerRadius = cell.movieRating.frame.width/2
        cell.movieRating.clipsToBounds = true
        cell.movieTitle.text = movie?.title
        cell.movieTitle.backgroundColor = UIColor(red:50.0/255.0, green:50.0/255.0, blue:50.0/255.0, alpha:0.7)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //print(busyLoading)
        if ((scrollView.contentOffset.y + 1) >= (scrollView.contentSize.height - scrollView.frame.size.height) && !busyLoading && !isFiltering() && movies.count > 0) {
            busyLoading = true
            print( "on page: \(page)")
            page += 1
            reloadMovies()
        }
    }
}

