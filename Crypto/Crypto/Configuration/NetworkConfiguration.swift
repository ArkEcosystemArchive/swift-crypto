// 
// This file is part of Ark Swift Crypto.
//
// (c) Ark Ecosystem <info@ark.io>
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//

import Foundation

public class ArkNetwork {

    public static let shared = ArkNetwork(network: Devnet())

    var network: ProtocolNetwork

    private init(network: ProtocolNetwork) {
        self.network = network
    }

    public func get() -> ProtocolNetwork {
        return network
    }

    public func set(network: ProtocolNetwork) {
        self.network = network
    }
}
