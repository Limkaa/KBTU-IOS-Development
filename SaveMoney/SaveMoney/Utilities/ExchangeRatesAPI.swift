//
//  ExchangeRatesAPI.swift
//  SaveMoney
//
//  Created by Alim on 13.05.2021.
//

import Foundation

struct ExchangeRates: Codable {
    var conversion_rates: [String: Double]
}

//class ExchangeRatesAPI {
//    var rates = Dictionary<String, Double>()
//    var currencies = ["USD", "RUB", "EUR"]
//    
//    func fetchJSON() {
//        guard let url = URL(string: "https://v6.exchangerate-api.com/v6/9edc345fe97bb51a40ddd1d4/latest/KZT") else { return }
//        URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
//            if error != nil { return }
//            guard let safeData = data else { return }
//            
//            do {
//                let results = try JSONDecoder().decode(ExchangeRates.self, from: safeData)
//                currencies.forEach { (currency) in
//                    rates[currency] = results.conversion_rates[currency]!
//                }
//            } catch {
//                
//            }
//        }
//    }
//}
