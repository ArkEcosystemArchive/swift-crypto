// 
// This file is part of Ark Swift Crypto.
//
// (c) Ark Ecosystem <info@ark.io>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

import Foundation

class Fee {

    static let shared = Fee()

    var fees: [TransactionType: UInt64]

    private init() {
        self.fees = [
            TransactionType.transfer: TransactionFee.transfer,
            TransactionType.secondSignatureRegistration: TransactionFee.secondSignatureRegistration,
            TransactionType.delegateRegistration: TransactionFee.delegateRegistration,
            TransactionType.vote: TransactionFee.vote,
            TransactionType.multiSignatureRegistration: TransactionFee.multiSignatureRegistration,
            TransactionType.ipfs: TransactionFee.ipfs,
            TransactionType.timelockTransfer: TransactionFee.timelockTransfer,
            TransactionType.multiPayment: TransactionFee.multiPayment,
            TransactionType.delegateResignation: TransactionFee.delegateResignation
        ]
    }

    func get(forType: TransactionType) -> UInt64 {
        return fees[forType]!
    }

    func set(forType: TransactionType, fee: UInt64) {
        self.fees[forType] = fee
    }
}
