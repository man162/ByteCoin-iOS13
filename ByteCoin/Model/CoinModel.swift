//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Manpreet Singh on 2020-02-10.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {

    var rate: Double
    var time: String

    var rateString: String {
        return String(format: "%.2f", rate)
    }
}
