// 
// This file is part of Ark Swift Crypto.
//
// (c) Ark Ecosystem <info@ark.io>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

import XCTest
@testable import Crypto

class FeeTests: XCTestCase {

    func testGetFee() {
        let fee = Fee.shared.get(forType: .delegateRegistration)
        XCTAssertEqual(fee, 2500000000)
    }

    func testSetFee() {
        Fee.shared.set(forType: .delegateRegistration, fee: 100000000)
        let fee = Fee.shared.get(forType: .delegateRegistration)
        XCTAssertEqual(fee, 100000000)
    }

    func testTransactionType() {
        XCTAssertEqual(TransactionType.transfer.rawValue, 0)
        XCTAssertEqual(TransactionType.delegateRegistration.rawValue, 2)
    }
}
