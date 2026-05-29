//
//  ViewModel.swift
//  ReadyRemitHost
//
//  Created by Franco Cadillo on 3/6/26.
//

import ReadyRemitSDK
import SwiftUI

@Observable
class ViewModel {
    struct ReadyRemitItem: Identifiable {
        let id = UUID()
        let view: any View
    }
    
    var readyRemitItem: ReadyRemitItem?
    
    private var authorizationValue: String?
    
    func showReadyRemitSDK() {
        ReadyRemit.shared.startSDK(
            configuration: .init(environment: .sandbox),
            fetchAccessTokenDetails: fetchAccessTokenDetails,
            verifyFundsAndCreateTransfer: verifyFundsAndCreateTransfer,
            onDismiss: { [weak self] in
                guard let self else { return }
                self.readyRemitItem = nil
            }
        ) { [weak self] readyRemitSDKView in
            guard let self else { return }
            self.readyRemitItem = .init(view: readyRemitSDKView)
        }
    }
    
    private func fetchAccessTokenDetails() async throws -> AccessTokenDetails {
        guard let url = URL(string: "https://sandbox-api.readyremit.com/v1/oauth/token") else {
            throw URLError(.badURL)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try JSONSerialization.data(
            withJSONObject: [
                "audience": "https://sandbox-api.readyremit.com",
                "client_id": "CLIENT_ID",
                "client_secret": "CLIENT_SECRET",
                "grant_type": "client_credentials",
                "sender_id": "SENDER_ID"
            ]
        )
        
        let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        switch httpURLResponse.statusCode {
        case 200...299:
            let response = try JSONDecoder().decode(CreateOAuthTokenResponse.self, from: data)
            authorizationValue = "\(response.tokenType) \(response.accessToken)"
            return response
        default:
            throw ReadyRemitError(code: .none, message: "Failed to fetch access token details")
        }
    }
    
    private func verifyFundsAndCreateTransfer(
        transferRequest: TransferRequest
    ) async throws(ReadyRemitError) -> TransferDetails {
        do {
            guard let url = URL(string: "https://sandbox-api.readyremit.com/v1/quote/\(transferRequest.quoteHistoryId)") else {
                throw URLError(.badURL)
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("en-US", forHTTPHeaderField: "accept-language")
            if let authorizationValue {
                request.addValue(authorizationValue, forHTTPHeaderField: "authorization")
            }
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            
            var (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  200...299 ~= httpResponse.statusCode
            else {
                throw ReadyRemitError(code: .none, message: "Failed to fetch quote details")
            }
            
            let readQuoteDetailsResponse = try JSONDecoder().decode(ReadQuoteDetailsResponse.self, from: data)
            
            guard let url = URL(string: "https://sandbox-api.readyremit.com/v1/transfers") else {
                throw URLError(.badURL)
            }
            
            var jsonObject: [String: Any] = [
                "nonce": transferRequest.nonce,
                "quoteBy": transferRequest.quoteBy,
                "quoteHistoryId": transferRequest.quoteHistoryId,
                "recipientId": transferRequest.recipientId,
                "amount": readQuoteDetailsResponse.sendAmount.value,
                "dstCountryISO3Code": readQuoteDetailsResponse.destinationCountryISO3Code,
                "dstCurrencyISO3Code": readQuoteDetailsResponse.destinationCurrencyISO3Code,
                "srcCurrencyIso3Code": readQuoteDetailsResponse.sourceCurrencyIso3Code,
                "transferMethod": readQuoteDetailsResponse.transferMethod
            ]
            if let fields = transferRequest.fields {
                jsonObject["fields"] = fields.map { field -> [String: Any] in
                    [
                        "id": field.id,
                        "type": field.type,
                        "value": field.value
                    ]
                }
            }
            if let recipientAccountId = transferRequest.recipientAccountId {
                jsonObject["recipientAccountId"] = recipientAccountId
            }
            if let sourceAccountId = transferRequest.sourceAccountId {
                jsonObject["sourceAccountId"] = sourceAccountId
            }
            
            request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonObject)
            request.addValue("en-US", forHTTPHeaderField: "accept-language")
            if let authorizationValue {
                request.addValue(authorizationValue, forHTTPHeaderField: "authorization")
            }
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            
            (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  200...299 ~= httpResponse.statusCode
            else {
                throw ReadyRemitError(code: .none, message: "Failed to create transfer")
            }
            
            return try JSONDecoder().decode(CreateTransferResponse.self, from: data)
        } catch let error as ReadyRemitError {
            throw error
        } catch {
            throw ReadyRemitError(code: .none, message: "Error: \(error.localizedDescription)")
        }
    }
}
