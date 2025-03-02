// RemoteChatSourceFactory.swift is a part of Banter project
//
// Created by Andrei Chenchik (andrei@chenchik.me), 2/3/25
// Copyright © 2025 Andrei Chenchik, Inc. All rights reserved.
// Unauthorized copying of this file, via any medium is strictly prohibited
// Proprietary and confidential
//

/// Factory for creating properly configured remote chat data sources.
///
/// - Note: Use this factory to create data sources that respect user settings
///   like preferred servers, authentication tokens, or communication preferences.
protocol RemoteChatSourceFactory {
  /// Creates a remote data source configured with user settings.
  ///
  /// - Parameter with: The user settings to apply to the data source.
  /// - Returns: A configured remote data source.
  /// - Throws: some `Error` if the creation was not a success.
  ///
  /// Example:
  /// ```swift
  /// do {
  ///     let dataSource = try factory.makeChatSource(with: currentUserSettings)
  ///     let repository = ChatRepositoryImpl(remoteSource: dataSource)
  ///     // Use repository...
  /// } catch {
  ///     // Handle  errors
  ///     showErrorAlert(error)
  /// }
  /// ```
  func makeChatSource(with: UserSettings) throws -> RemoteChatSource
}
