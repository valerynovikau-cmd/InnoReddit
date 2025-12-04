//
//  MainFeedCategory.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 13.11.25.
//

enum MainFeedCategory: CaseIterable {
    case best
    case hot
    case new
    case top
    case rising
    
    var urlPath: String {
        switch self {
        case .best: return "/best"
        case .hot: return "/hot"
        case .new: return "/new"
        case .top: return "/top"
        case .rising: return "/rising"
        }
    }
    
    var titleString: String {
        switch self {
        case .best: return MainScreenStrings.bestTab
        case .hot: return MainScreenStrings.hotTab
        case .new: return MainScreenStrings.newTab
        case .top: return MainScreenStrings.topTab
        case .rising: return MainScreenStrings.risingTab
        }
    }
}
