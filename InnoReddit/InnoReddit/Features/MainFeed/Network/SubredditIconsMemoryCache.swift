//
//  SubredditIconsMemoryCache.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 19.11.25.
//

import Foundation

actor SubredditIconsMemoryCache {
    private var cache = NSCache<NSString, NSString>()
    
    func getItem(key: String) -> String? {
        return cache.object(forKey: NSString(string: key)) as String?
    }
    
    func setItem(key: String, value: String) {
        cache.setObject(NSString(string: value), forKey: NSString(string: key))
    }
}
