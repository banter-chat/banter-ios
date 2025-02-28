// Web3AsyncAdapter+Live.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 28/2/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
// 

import Web3

extension Web3AsyncAdapter {
  static func live(web3: Web3) -> Self {
    Self(
      getTransactionCount: { address, block in
        let result = await asyncWrapper { callback in
          web3.eth.getTransactionCount(address: address, block: block) { response in
            callback(response.status.asResult)
          }
        }

        return try result.get()
      },
      gasPrice: {
        let result = await asyncWrapper { callback in
          web3.eth.gasPrice { response in
            callback(response.status.asResult)
          }
        }

        return try result.get()
      },
      estimateGas: { invocation, from, gas, value in
        let result = await asyncWrapper { callback in
          invocation.estimateGas(from: from, gas: gas, value: value) { data, error in
            callback(getResult(data, error))
          }
        }

        return try result.get()
      },
      call: { invocation in
        let result = await asyncWrapper { callback in
          invocation.call { data, error in
            callback(getResult(data, error))
          }
        }

        return try result.get()
      },
      sendRawTransaction: { transaction in
        let result = try await throwingAsyncWrapper { callback in
          try web3.eth.sendRawTransaction(transaction: transaction) { response in
            callback(response.status.asResult)
          }
        }

        return try result.get()
      },
      getLogs: { addresses, topics, fromBlock, toBlock in
        let result = await asyncWrapper { callback in
          web3.eth.getLogs(
            addresses: addresses, topics: topics, fromBlock: fromBlock, toBlock: toBlock
          ) { response in
            callback(response.status.asResult)
          }
        }

        return try result.get()
      },
      subscribeToLogs: { addresses, topics in
        AsyncThrowingStream { continuation in
          var ongoingSubscriptionId: String?

          do {
            try web3.eth.subscribeToLogs(addresses: addresses, topics: topics) { response in
              switch response.status {
              case let .failure(error):
                continuation.finish(throwing: error)
              case let .success(subscriptionId):
                ongoingSubscriptionId = subscriptionId
              }
            } onEvent: { response in
              switch response.status {
              case let .success(log):
                continuation.yield(log)
              case let .failure(error):
                continuation.finish(throwing: error)
              }
            }
          } catch {
            continuation.finish(throwing: error)
          }

          continuation.onTermination = { [ongoingSubscriptionId] _ in
            if let ongoingSubscriptionId {
              try? web3.eth.unsubscribe(subscriptionId: ongoingSubscriptionId) { _ in }
            }
          }
        }
      }
    )
  }
}
