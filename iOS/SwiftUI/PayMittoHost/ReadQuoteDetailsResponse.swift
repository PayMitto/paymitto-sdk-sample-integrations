//
//  ReadQuoteDetailsResponse.swift
//  PayMittoHost
//
//  Created by Matthew Mohrman on 10/23/25.
//

struct ReadQuoteDetailsResponse: Decodable {
    struct SendAmount: Decodable {
        let value: Int
    }
    
    let destinationCountryISO3Code: String
    let destinationCurrencyISO3Code: String
    let sendAmount: SendAmount
    let sourceCurrencyIso3Code: String
    let transferMethod: String
}
