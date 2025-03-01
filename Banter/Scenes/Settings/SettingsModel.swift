// SettingsModel.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 21/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

import Sharing
import SwiftUI
import Web3

@Observable
final class SettingsModel: ObservableObject {
  @ObservationIgnored @Shared(.web3Settings) var settings
  @ObservationIgnored @Shared(.walletKeyHex) var walletKeyHex

  var isReadyToChat: Bool {
    !settings.rpcWSURL.isEmpty
      && !settings.chatListAddress.isEmpty
      && !walletKeyHex.isEmpty
      && !settings.chainId.isEmpty
      && Int(settings.chainId) != nil
  }

  var walletAddress: String? {
    let key = try? EthereumPrivateKey(hexPrivateKey: walletKeyHex)
    return key?.address.hex(eip55: true)
  }

  func copyWalletAddressTapped() {
    UIPasteboard.general.string = walletAddress
  }

  func generateNewAddressTapped() {
    guard let key = try? EthereumPrivateKey() else { return }
    $walletKeyHex.withLock { $0 = key.hex() }
  }
}
