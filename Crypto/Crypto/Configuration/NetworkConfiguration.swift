// 
// This file is part of Ark Swift Crypto.
//
// (c) Ark Ecosystem <info@ark.io>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

import Foundation

class ArkNetwork {

    static let shared = ArkNetwork(network: Devnet())

    var network: ProtocolNetwork

    private init(network: ProtocolNetwork) {
        self.network = network
    }

    func get() -> ProtocolNetwork {
        return network
    }

    func set(network: ProtocolNetwork) {
        self.network = network
    }
}
