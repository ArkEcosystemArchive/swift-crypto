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

class WIFTests: XCTestCase {

    func testWIFFromPassphrase() {
        let wif = WIF.from(passphrase: "this is a top secret passphrase")
        XCTAssertEqual(wif, "SGq4xLgZKCGxs7bjmwnBrWcT4C1ADFEermj846KC97FSv1WFD1dA")
    }
}
