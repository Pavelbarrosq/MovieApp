//
//  Query.swift
//  Movieapp
//
//  Created by Kim Nordin on 2019-05-08.
//  Copyright © 2019 Pavel Barros Quintanilla. All rights reserved.
//

import Foundation

class Query {
    
    typealias QueryResult = ([Movie]?, String) -> ()
    typealias JSONDictionary = [String: Any]
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    var movies: [Movie] = []
    var errorMessage = ""
    
//    let titleString = titleString.replacingOccurances(of: " ", with "+")
    
    func getSearchResults(searchTerm: String, completion: @escaping QueryResult) {
        // 1
        dataTask?.cancel()
        // 2
        if var urlComponents = URLComponents(string: "https://api.themoviedb.org/3/discover/movie?api_key=d5c04206ed27091dae4a910d147726cc&language=en-US") {
            urlComponents.query = "&query=\(searchTerm)"
            // 3
            guard let url = urlComponents.url else { return }
            // 4
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                // 5
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.updateSearchResults(data)
                    // 6
                    DispatchQueue.main.async {
                        completion(self.movies, self.errorMessage)
                    }
                }
            }
            // 7
            dataTask?.resume()
        }
    }
    
    
    fileprivate func updateSearchResults(_ data: Data) {
        var response: JSONDictionary?
        movies.removeAll()

        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }

        guard let array = response!["results"] as? [Any] else {
            errorMessage += "Dictionary does not contain results key\n"
            return
        }
        var index = 0
        for movieDictionary in array {
            if let movieDictionary = movieDictionary as? JSONDictionary,
                let movieTitle = movieDictionary["title"] as? String,
                let voteAverage = movieDictionary["vote_average"] as? Double,
                let movieImage = movieDictionary["poster_path"] as? String {
                movies.append(Movie(title: movieTitle, vote_average: voteAverage, poster_path: movieImage))
                index += 1
                print(movieTitle, "movieTitle")
                print(movieImage, "movieImage")
            } else {
                errorMessage += "Problem parsing movieDictionary\n"
            }
        }
    }
}
