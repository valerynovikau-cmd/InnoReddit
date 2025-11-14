// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum MainScreenStrings {
  /// MainScreenLocalizable.strings
  ///   InnoReddit
  /// 
  ///   Created by Валерий Новиков on 14.11.25.
  internal static let bestTab = MainScreenStrings.tr("MainScreenLocalizable", "bestTab", fallback: "Best")
  /// Hot
  internal static let hotTab = MainScreenStrings.tr("MainScreenLocalizable", "hotTab", fallback: "Hot")
  /// New
  internal static let newTab = MainScreenStrings.tr("MainScreenLocalizable", "newTab", fallback: "New")
  /// Rising
  internal static let risingTab = MainScreenStrings.tr("MainScreenLocalizable", "risingTab", fallback: "Rising")
  /// Search
  internal static let searchBarPlaceholder = MainScreenStrings.tr("MainScreenLocalizable", "searchBarPlaceholder", fallback: "Search")
  /// Top
  internal static let topTab = MainScreenStrings.tr("MainScreenLocalizable", "topTab", fallback: "Top")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension MainScreenStrings {
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
