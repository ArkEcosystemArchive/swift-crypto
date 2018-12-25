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

class SlotTests: XCTestCase {

    func testSlotTime() {
        let time = Slot.time()

        let epoch = UInt32(1490101200) // 21 March 2017 13:00:00
        let now = UInt32(NSDate().timeIntervalSince1970)

        XCTAssertGreaterThanOrEqual(now - epoch, time)
    }

    func testSlotEpoch() {
        let epoch = Slot.epoch()
        XCTAssertEqual(epoch, 1490101200)
    }
}
