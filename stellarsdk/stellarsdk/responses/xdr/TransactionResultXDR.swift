//
//  TransactionResult.swift
//  stellarsdk
//
//  Created by Razvan Chelemen on 12/02/2018.
//  Copyright © 2018 Soneso. All rights reserved.
//

import UIKit

enum TransactionResultCode: Int {
    case success = 0
    case failed = -1
    case tooEarly = -2
    case tooLate = -3
    case missingOperation = -4
    case badSeq = -5
    case badAuth = -6
    case insufficientBalance = -7
    case noAccount = -8
    case insufficientFee = -9
    case badAuthExtra = -10
    case internalError = -11
}

enum TransactionResultBody {
    case success([OperationResultXDR])
    case failed
}

struct TransactionResultXDR: XDRCodable {
    public var feeCharged:Int64
    public var resultBody:TransactionResultBody?
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        feeCharged = try container.decode(Int64.self)
        let type = TransactionResultCode(rawValue: try container.decode(Int.self))!
        switch type {
        case .success:
            fallthrough
        case .failed:
            resultBody = .success(try container.decode([OperationResultXDR].self))
        default:
            break
        }
        
        _ = try container.decode(Int.self)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(feeCharged)
        try container.encode(resultBody)
    }
    
}