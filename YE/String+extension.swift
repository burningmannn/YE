//
//  String+extension.swift
//  YE
//
//  Created by Daniil Shutkin on 09.06.2024.
//

import Foundation

extension String {
    
    var localized: String {
        NSLocalizedString(
            self,
            comment: "\(self) could not be found in Locsalizable.strings"
        )
    }
    
    func localizedPlural(_ arg: Int ) -> String {
        let formatString = NSLocalizedString(
            self,
            comment: "\(self) could not be found in Locsalizable.strings"
        )
        return Self.localizedStringWithFormat(formatString, arg)
    }
}
