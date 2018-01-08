//
//  HomeController.swift
//  LetsMovie
//
//  Created by David on 08/01/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation
import UIKit

class HomeController: UIViewController {
    
    let client = MovieClient()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        client.getFeed(from: .topRated) { (result) in
            switch result {
            case .success(let movieFeedResult):
                guard let movieResults = movieFeedResult?.results else { return }
                
                movieResults.forEach({ (movie) in
                    print(movie.title ?? "")
                })
                
            case .failure(error: let error):
                if let error = error {
                    print("the error: \(error.locoalizedDescription)")
                }
            }
        }
    }
}
