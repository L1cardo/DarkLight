//
//  LocalizedUtils.swift
//  DarkLight
//
//  Created by Licardo on 2019/11/2.
//  Copyright © 2019 Licardo. All rights reserved.
//

import Foundation

// localization
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}
