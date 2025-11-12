// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum TabBarLocalizableStrings {
  /// plus.circle
  internal static let createPostSFSymbolName = TabBarLocalizableStrings.tr("TabBarLocalizable", "createPostSFSymbolName", fallback: "plus.circle")
  /// plus.circle.fill
  internal static let createPostSFSymbolNameSelected = TabBarLocalizableStrings.tr("TabBarLocalizable", "createPostSFSymbolNameSelected", fallback: "plus.circle.fill")
  /// Create
  internal static let createPostTabBarTitle = TabBarLocalizableStrings.tr("TabBarLocalizable", "createPostTabBarTitle", fallback: "Create")
  /// house
  internal static let mainFeedSFSymbolName = TabBarLocalizableStrings.tr("TabBarLocalizable", "mainFeedSFSymbolName", fallback: "house")
  /// house.fill
  internal static let mainFeedSFSymbolNameSelected = TabBarLocalizableStrings.tr("TabBarLocalizable", "mainFeedSFSymbolNameSelected", fallback: "house.fill")
  /// TabBarLocalizable.strings
  ///   InnoReddit
  /// 
  ///   Created by Валерий Новиков on 11.11.25.
  internal static let mainFeedTabBarTitle = TabBarLocalizableStrings.tr("TabBarLocalizable", "mainFeedTabBarTitle", fallback: "Main")
  /// gear
  internal static let settingsSFSymbolName = TabBarLocalizableStrings.tr("TabBarLocalizable", "settingsSFSymbolName", fallback: "gear")
  /// gear
  internal static let settingsSFSymbolNameSelected = TabBarLocalizableStrings.tr("TabBarLocalizable", "settingsSFSymbolNameSelected", fallback: "gear")
  /// Settings
  internal static let settingsTabBarTitle = TabBarLocalizableStrings.tr("TabBarLocalizable", "settingsTabBarTitle", fallback: "Settings")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension TabBarLocalizableStrings {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
