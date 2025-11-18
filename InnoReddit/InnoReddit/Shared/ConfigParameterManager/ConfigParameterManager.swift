//
//  ConfigParameterManager.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 18.11.25.
//

import Foundation

struct ConfigParameterManager {
    
    static let clientID: String? = Bundle.main.infoDictionary?["ClientID"] as? String
    
    static var callbackScheme: String? {
        let urlTypes = Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [[String: Any]]
        let urlSchemes = urlTypes?.first?["CFBundleURLSchemes"] as? [String]
        let callbackScheme = urlSchemes?.first
        return callbackScheme
    }
}
