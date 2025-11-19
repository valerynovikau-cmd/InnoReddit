//
//  AppRouterDI.swift
//  InnoReddit
//
//  Created by Валерий Новиков on 11.11.25.
//

import Factory
import UIKit

extension Container {
    var appRouter: ParameterFactory<UIWindow?, AppRouterProtocol> {
        self { @MainActor window in
            AppRouter(window: window)
        }.singleton
    }
}
