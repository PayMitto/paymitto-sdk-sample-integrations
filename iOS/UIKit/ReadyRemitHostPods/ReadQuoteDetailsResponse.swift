//
//  ReadQuoteDetailsResponse.swift
//  ReadyRemitHost
//
//  Created by Franco Cadillo on 3/6/26.
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
