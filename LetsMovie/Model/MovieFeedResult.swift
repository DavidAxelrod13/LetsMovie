//
//  MovieFeedResult.swift
//  LetsMovie
//
//  Created by David on 08/01/2018.
//  Copyright © 2018 David. All rights reserved.
//

import Foundation

struct MovieFeedResult: Decodable {
    
    let results: [Movie]?
    
}

struct Movie: Decodable {
    
    let title: String?
}
