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

class NetworkTests: XCTestCase {

    func testGetNetwork() {
        let network = ArkNetwork.shared.get()
        XCTAssertEqual(network.version(), 30)
    }

    func testSetNetwork() {
        ArkNetwork.shared.set(network: Mainnet())
        let network = ArkNetwork.shared.get()
        XCTAssertEqual(network.version(), 23)

        ArkNetwork.shared.set(network: Devnet()) // Reset
    }
}
