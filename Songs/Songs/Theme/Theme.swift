//
//  Theme.swift
//  Songs
//
//  Created by Dushyant Singh on 14/3/22.
//

import Foundation
import UIKit

struct Theme {
    struct Font {
        static func thinFont(with size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-Thin", size: size)!
        }
        static func boldFont(with size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-Medium", size: size)!
        }
        static func regularFont(with size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue", size: size)!
        }
    }
}
