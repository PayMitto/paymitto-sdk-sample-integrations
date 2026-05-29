//
//  CreateTransferResponse.swift
//  ReadyRemitHost
//
//  Created by Franco Cadillo on 3/6/26.
//

import ReadyRemitSDK

struct CreateTransferResponse: Decodable {
    let transferId: String
}

extension CreateTransferResponse: TransferDetails { }
