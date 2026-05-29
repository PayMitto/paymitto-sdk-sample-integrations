//
//  ViewModel.swift
//  PayMittoHost
//
//  Created by Franco Cadillo on 3/6/26.
//

import PayMittoSDK
import SwiftUI

@Observable
class ViewModel {
    struct PayMittoItem: Identifiable {
        let id = UUID()
        let view: any View
    }
    
    var payMittoItem: PayMittoItem?
    
    private var authorizationValue: String?
    
    func showPayMittoSDK() {
        PayMitto.shared.startSDK(
            configuration: .init(environment: .sandbox),
            fetchAccessTokenDetails: fetchAccessTokenDetails,
            verifyFundsAndCreateTransfer: verifyFundsAndCreateTransfer,
            onDismiss: { [weak self] in
                guard let self else { return }
                self.payMittoItem = nil
            }
        ) { [weak self] payMittoSDKView in
            guard let self else { return }
            self.payMittoItem = .init(view: payMittoSDKView)
        }
    }
    
    private func fetchAccessTokenDetails() async throws -> AccessTokenDetails {
        guard let url = URL(string: "\(Secrets.Sandbox.baseURL)/v1/oauth/token") else {
            throw URLError(.badURL)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = try JSONSerialization.data(
            withJSONObject: [
                "audience": Secrets.Sandbox.audience,
                "client_id": Secrets.Sandbox.clientId,
                "client_secret": Secrets.Sandbox.clientSecret,
                "grant_type": "client_credentials",
                "sender_id": Secrets.Sandbox.senderId
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
            throw PayMittoError(code: .none, message: "Failed to fetch access token details")
        }
    }
    
    private func verifyFundsAndCreateTransfer(
        transferRequest: TransferRequest
    ) async throws(PayMittoError) -> TransferDetails {
        do {
            guard let url = URL(string: "\(Secrets.Sandbox.baseURL)/v1/quote/\(transferRequest.quoteHistoryId)") else {
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
                throw PayMittoError(code: .none, message: "Failed to fetch quote details")
            }
            
            let readQuoteDetailsResponse = try JSONDecoder().decode(ReadQuoteDetailsResponse.self, from: data)
            
            guard let url = URL(string: "\(Secrets.Sandbox.baseURL)/v1/transfers") else {
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
                throw PayMittoError(code: .none, message: "Failed to create transfer")
            }
            
            return try JSONDecoder().decode(CreateTransferResponse.self, from: data)
        } catch let error as PayMittoError {
            throw error
        } catch {
            throw PayMittoError(code: .none, message: "Error: \(error.localizedDescription)")
        }
    }
}
