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

class ArkBuilderTests: XCTestCase {

    let passphrase = "this is a top secret passphrase"
    let secondPassphrase = "this is a top secret passphrase too"
    let publicKey = "034151a3ec46b5670a682b0a63394f863587d1bc97483b1b6c70eb58e7f0aed192"
    let delegatePublicKey = "03d3fdad9c5b25bf8880e6b519eb3611a5c0b31adebc8455f0e096175b28321aff"
    let recipientAddress = "D6Z26L69gdk9qYmTv5uzk3uGepigtHY4ax"
    let vendorField = "this is a tx from Swift"

    func testTransfer() {
        let transaction = ArkBuilder.buildTransfer(passphrase, secondPassphrase: nil, to: recipientAddress, amount: 100000000, vendorField: vendorField)

        XCTAssertNotNil(transaction.fee)
        XCTAssertEqual(transaction.amount, 100000000)
        XCTAssertEqual(transaction.senderPublicKey!, publicKey)
        XCTAssertNotNil(transaction.signature)
        XCTAssertNil(transaction.signSignature)
        XCTAssertEqual(transaction.vendorField!, vendorField)
    }

    func testTransferSecondSignature() {
        let transaction = ArkBuilder.buildTransfer(passphrase, secondPassphrase: secondPassphrase, to: recipientAddress, amount: 100000000, vendorField: vendorField)

        XCTAssertNotNil(transaction.fee)
        XCTAssertEqual(transaction.amount, 100000000)
        XCTAssertEqual(transaction.senderPublicKey!, publicKey)
        XCTAssertNotNil(transaction.signature)
        XCTAssertNotNil(transaction.signSignature)
        XCTAssertEqual(transaction.vendorField!, vendorField)
    }

    func testDelegateRegistration() {
        let transaction = ArkBuilder.buildDelegateRegistration(passphrase, secondPassphrase: nil, username: "genesis")

        XCTAssertNotNil(transaction.fee)
        XCTAssertNotNil(transaction.asset)
        let asset = transaction.asset!["delegate"] as! [String: String]
        XCTAssertEqual(asset["username"], "genesis")
        XCTAssertNotNil(transaction.signature)
        XCTAssertNil(transaction.signSignature)
    }

    func testDelegateRegistrationSecondSignature() {
        let transaction = ArkBuilder.buildDelegateRegistration(passphrase, secondPassphrase: secondPassphrase, username: "genesis")

        XCTAssertNotNil(transaction.fee)
        XCTAssertNotNil(transaction.asset)
        let asset = transaction.asset!["delegate"] as! [String: String]
        XCTAssertEqual(asset["username"], "genesis")
        XCTAssertNotNil(transaction.signature)
        XCTAssertNotNil(transaction.signSignature)
    }

    func testSecondSignature() {
        let transaction = ArkBuilder.buildSecondSignature(passphrase, secondPassphrase: secondPassphrase)

        XCTAssertNotNil(transaction.fee)
        XCTAssertNotNil(transaction.asset)
        let asset = transaction.asset!["signature"] as! [String: String]
        XCTAssertEqual(asset["publicKey"], "027d5eedd83f588d6c5e8cfaa2272470566d1c2cfcf22fae086a22e06f395bc167")
        XCTAssertNotNil(transaction.signature)
        XCTAssertNil(transaction.signSignature)
    }

    func testVote() {
        let transaction = ArkBuilder.buildVote(passphrase, secondPassphrase: nil, vote: delegatePublicKey)

        XCTAssertNotNil(transaction.fee)
        XCTAssertNotNil(transaction.asset)
        let asset = transaction.asset!["votes"] as! [String]
        XCTAssertEqual(asset[0], "+" + delegatePublicKey)
        XCTAssertNotNil(transaction.signature)
        XCTAssertNil(transaction.signSignature)
    }

    func testUnvote() {
        let transaction = ArkBuilder.buildUnvote(passphrase, secondPassphrase: nil, vote: delegatePublicKey)

        XCTAssertNotNil(transaction.fee)
        XCTAssertNotNil(transaction.asset)
        let asset = transaction.asset!["votes"] as! [String]
        XCTAssertEqual(asset[0], "-" + delegatePublicKey)
        XCTAssertNotNil(transaction.signature)
        XCTAssertNil(transaction.signSignature)
    }

    func testVoteSecondSignature() {
        let transaction = ArkBuilder.buildVote(passphrase, secondPassphrase: secondPassphrase, vote: delegatePublicKey)

        XCTAssertNotNil(transaction.fee)
        XCTAssertNotNil(transaction.asset)
        let asset = transaction.asset!["votes"] as! [String]
        XCTAssertEqual(asset[0], "+" + delegatePublicKey)
        XCTAssertNotNil(transaction.signature)
        XCTAssertNotNil(transaction.signSignature)
    }

    func testUnvoteSecondSignature() {

        let transaction = ArkBuilder.buildUnvote(passphrase, secondPassphrase: secondPassphrase, vote: delegatePublicKey)

        XCTAssertNotNil(transaction.fee)
        XCTAssertNotNil(transaction.asset)
        let asset = transaction.asset!["votes"] as! [String]
        XCTAssertEqual(asset[0], "-" + delegatePublicKey)
        XCTAssertNotNil(transaction.signature)
        XCTAssertNotNil(transaction.signSignature)
    }
}
