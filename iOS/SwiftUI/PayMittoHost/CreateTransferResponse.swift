//
//  CreateTransferResponse.swift
//  PayMittoHost
//
//  Created by Matthew Mohrman on 10/23/25.
//

import PayMittoSDK

struct CreateTransferResponse: Decodable {
    let transferId: String
}

extension CreateTransferResponse: TransferDetails { }
