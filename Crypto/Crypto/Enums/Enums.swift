// 
// This file is part of Ark Swift Crypto.
//
// (c) Ark Ecosystem <info@ark.io>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

import Foundation

enum TransactionType: Int {
    case transfer = 0
    case secondSignatureRegistration = 1
    case delegateRegistration = 2
    case vote = 3
    case multiSignatureRegistration = 4
    case ipfs = 5
    case timelockTransfer = 6
    case multiPayment = 7
    case delegateResignation = 8
}

struct TransactionFee {
    static let transfer = 10000000
    static let secondSignatureRegistration = 500000000
    static let delegateRegistration = 2500000000
    static let vote = 100000000
    static let multiSignatureRegistration = 500000000
    static let ipfs = 0
    static let timelockTransfer = 0
    static let multiPayment = 0
    static let delegateResignation = 0
}
