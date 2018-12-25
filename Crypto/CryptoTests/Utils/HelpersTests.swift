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

class HelpersTests: XCTestCase {

    func testPackUnpackInt() {
        let original = 5
        let packed = pack(original)
        let unpacked = unpack(packed, to: Int.self)
        XCTAssertEqual(original, unpacked)
    }

    func testPackUnpackUInt32() {
        let original = UInt32(32)
        let packed = pack(original)
        let unpacked = unpack(packed, to: UInt32.self)
        XCTAssertEqual(original, unpacked)
    }

    func testPackUnpackString() {
        let original = "hello"
        let packed = pack(original)
        let unpacked = unpack(packed, to: String.self)
        XCTAssertEqual(original, unpacked)
    }
}
