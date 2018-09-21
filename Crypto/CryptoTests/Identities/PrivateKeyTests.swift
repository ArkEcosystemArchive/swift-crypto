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

class PrivateKeyTests: XCTestCase {

    func testPrivateKeyFromPassphrase() {
        let privateKey = ArkPrivateKey.from(passphrase: "this is a top secret passphrase")
        XCTAssertEqual(privateKey.raw.hex, "d8839c2432bfd0a67ef10a804ba991eabba19f154a3d707917681d45822a5712")
    }

    func testPrivateKeyFromHex() {
        let privateKey = ArkPrivateKey.from(hex: "d8839c2432bfd0a67ef10a804ba991eabba19f154a3d707917681d45822a5712")
        XCTAssertEqual(privateKey.raw.hex, "d8839c2432bfd0a67ef10a804ba991eabba19f154a3d707917681d45822a5712")
    }
//
//    func testPrivateKeyFromWIF() {
//        let privateKey = try? ArkPrivateKey.from(wif: "SGq4xLgZKCGxs7bjmwnBrWcT4C1ADFEermj846KC97FSv1WFD1dA")
//        XCTAssertNotNil(privateKey)
//        XCTAssertEqual(privateKey?.raw.hex, "d8839c2432bfd0a67ef10a804ba991eabba19f154a3d707917681d45822a5712")
//    }
}
