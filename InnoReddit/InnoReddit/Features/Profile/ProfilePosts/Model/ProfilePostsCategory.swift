//
//  ProfilePostsCategory.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 23.12.25.
//

enum ProfilePostsCategory: CaseIterable {
    case posted
    case saved
    
    var urlPath: String {
        switch self {
        case .posted: "/submitted"
        case .saved: "/saved"
        }
    }
    
    var titleString: String {
        switch self {
        case .posted: ProfileStrings.userPostsTab
        case .saved: ProfileStrings.userSavedTab
        }
    }
}
