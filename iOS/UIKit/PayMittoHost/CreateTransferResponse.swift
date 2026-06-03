//
//  CreateTransferResponse.swift
//  PayMittoHost
//
//  Created by Franco Cadillo on 3/6/26.
//

import PayMittoSDK

struct CreateTransferResponse: Decodable {
    let transferId: String
}

extension CreateTransferResponse: TransferDetails { }
