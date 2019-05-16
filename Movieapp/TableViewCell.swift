//
//  TableViewCell.swift
//  Movie
//
//  Created by Kim Nordin on 2019-04-29.
//  Copyright © 2019 kim. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var rating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configCell(movie : Movie?){
        let movieName = movie?.title
        print(movieName, "MOVIE NAME")
        let movieImage = movie?.poster_path
        print(movieImage, "POSTER NAME")
        
        if let image = movieImage {
            guard let url = URL(string: "http://image.tmdb.org/t/p/w500/" + image) else {print("bad url"); return } //UITableViewCell()
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    self.poster.image = UIImage(data: data!)
                }
            }).resume()
        }
        title.text = movie?.title
        rating.text = movie?.vote_average.description
        
    }
    func configCell(show: Show?){
        let showName = show?.name
        print(showName, "SHOW NAME")
        let showImage = show?.poster_path
        print(showImage, "POSTER NAME")
        
        if let image = showImage {
            guard let url = URL(string: "http://image.tmdb.org/t/p/w500/" + image) else {print("bad url"); return } //UITableViewCell()
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    self.poster.image = UIImage(data: data!)
                }
            }).resume()
        }
        title.text = show?.name
        rating.text = show?.vote_average.description
        
    }
    

}
