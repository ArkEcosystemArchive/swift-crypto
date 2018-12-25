// 
// This file is part of Ark Swift Crypto.
//
// (c) Ark Ecosystem <info@ark.io>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

// swiftlint:disable force_cast

import XCTest
@testable import Crypto

class MultiSignatureSerializerTests: XCTestCase {

    func testSerializeMultiSignature() {
        let json = readJson(file: "ms_passphrase", type: type(of: self))
        let serialized = json["serialized"] as! String
        let transaction = ArkDeserializer.deserialize(serialized: serialized)

        XCTAssertEqual(serialized, ArkSerializer.serialize(transaction: transaction))
    }
}
