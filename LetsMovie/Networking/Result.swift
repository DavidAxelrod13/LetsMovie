//
//  ViewController.swift
//  LetsMovie
//
//  Created by David on 07/01/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

enum Result<T, U> where U: Error {
    case success(T)
    case failure(error: U?)
}
