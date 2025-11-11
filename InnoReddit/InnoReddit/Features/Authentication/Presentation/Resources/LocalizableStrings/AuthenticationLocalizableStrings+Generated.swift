// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum AuthenticationLocalizableStrings {
  /// Access denied. Cannot continue without user permission.
  internal static let accessDeniedErrorMessage = AuthenticationLocalizableStrings.tr("AuthenticationLocalizable", "accessDeniedErrorMessage", fallback: "Access denied. Cannot continue without user permission.")
  /// Authentication error. Please try again.
  internal static let authenticationErrorMessage = AuthenticationLocalizableStrings.tr("AuthenticationLocalizable", "authenticationErrorMessage", fallback: "Authentication error. Please try again.")
  /// Error
  internal static let errorMessageTitle = AuthenticationLocalizableStrings.tr("AuthenticationLocalizable", "errorMessageTitle", fallback: "Error")
  /// Join thousands of communities and discuss anything that interests you
  internal static let inforamtionLabelText = AuthenticationLocalizableStrings.tr("AuthenticationLocalizable", "inforamtionLabelText", fallback: "Join thousands of communities and discuss anything that interests you")
  /// AuthenticationLocalizable.strings
  ///   InnoReddit
  /// 
  ///   Created by Валерий Новиков on 3.11.25.
  internal static let logInWithRedditButtonText = AuthenticationLocalizableStrings.tr("AuthenticationLocalizable", "logInWithRedditButtonText", fallback: "Log In with Reddit")
  /// Server error. Please try again.
  internal static let serverErrorMessage = AuthenticationLocalizableStrings.tr("AuthenticationLocalizable", "serverErrorMessage", fallback: "Server error. Please try again.")
  /// By clicking "Login", you agree to the terms of use and privacy policy
  internal static let termsOfServiceInfoLabelText = AuthenticationLocalizableStrings.tr("AuthenticationLocalizable", "termsOfServiceInfoLabelText", fallback: "By clicking \"Login\", you agree to the terms of use and privacy policy")
  /// Welcome to InnoReddit
  internal static let welcomeToInnoRedditLabelText = AuthenticationLocalizableStrings.tr("AuthenticationLocalizable", "welcomeToInnoRedditLabelText", fallback: "Welcome to InnoReddit")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension AuthenticationLocalizableStrings {
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
