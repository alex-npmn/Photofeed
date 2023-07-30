//
//  Color+Hex.swift
//  Photofeed
//
//  Created by Alexey Nepomnyashchikh on 30.07.2023.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let hexFormatted: String = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        var int = UInt64()
        Scanner(string: hexFormatted).scanHexInt64(&int)
        let red, green, blue, alpha: UInt64

        switch hexFormatted.count {
        case 3: // RGB (12-bit)
            (red, green, blue, alpha) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17, 255)
        case 6: // RGB (24-bit)
            (red, green, blue, alpha) = (int >> 16, int >> 8 & 0xFF, int & 0xFF, 255)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (red, green, blue, alpha) = (0, 0, 0, 255)
        }

        self.init(.sRGB,
                  red: Double(red) / 255.0,
                  green: Double(green) / 255.0,
                  blue: Double(blue) / 255.0,
                  opacity: Double(alpha) / 255.0)
    }
}
