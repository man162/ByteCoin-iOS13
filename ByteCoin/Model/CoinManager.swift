//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(_ coinManager: CoinManager, coinModel: CoinModel)
    func didRecievedError(error: Error)
}


struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "709489B6-B86A-4AB0-979F-50623FBC810B"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    var delegate: CoinManagerDelegate?

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performeRequest(with: urlString)
    }

    func performeRequest(with urlString: String) {
        //1. create the url
        if let url = URL(string: urlString) {
            //2. get the urlsession
            let request = URLSession(configuration: .default)
            //3. create the task
            let task = request.dataTask(with: url) { (data, urlResponse, error) in
                if error != nil {
                    self.delegate?.didRecievedError(error: error!)
                    return
                }

                if let safeData = data {
                    if let coinModel = self.parseJSON(safeData) {
                        self.delegate?.didUpdatePrice(self, coinModel: coinModel)
                    }
                }
            }
            //4. start the task
            task.resume()
        }
    }

    func parseJSON(_ data: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let coinModel = CoinModel(rate: decodedData.rate, time: decodedData.time)
            return coinModel
        } catch {
            self.delegate?.didRecievedError(error: error)
            return nil
        }

    }
}
