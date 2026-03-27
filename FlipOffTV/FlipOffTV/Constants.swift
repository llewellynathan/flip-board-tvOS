import SwiftUI

enum Constants {
    static let gridCols = 22
    static let gridRows = 8

    static let scrambleInterval: TimeInterval = 0.07
    static let flipDuration: TimeInterval = 0.3
    static let staggerDelay: TimeInterval = 0.025
    static let totalTransition: TimeInterval = 3.8
    static let messageInterval: TimeInterval = 4.0

    static let charset: [Character] = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,-!?'/: ")

    static let scrambleColors: [Color] = [
        Color(hex: 0x00AAFF),
        Color(hex: 0x00FFCC),
        Color(hex: 0xAA00FF),
        Color(hex: 0xFF2D00),
        Color(hex: 0xFFCC00),
        .white
    ]

    static let accentColors: [Color] = [
        Color(hex: 0x00FF7F),
        Color(hex: 0xFF4D00),
        Color(hex: 0xAA00FF),
        Color(hex: 0x00AAFF),
        Color(hex: 0x00FFCC)
    ]

    static let messages: [[[Character]]] = [
        [
            Array(""),
            Array(""),
            Array("GOD IS IN"),
            Array("THE DETAILS ."),
            Array(""),
            Array("- LUDWIG MIES"),
            Array(""),
            Array("")
        ],
        [
            Array(""),
            Array(""),
            Array("STAY HUNGRY"),
            Array("STAY FOOLISH"),
            Array(""),
            Array("- STEVE JOBS"),
            Array(""),
            Array("")
        ],
        [
            Array(""),
            Array(""),
            Array("GOOD DESIGN IS"),
            Array("GOOD BUSINESS"),
            Array(""),
            Array("- THOMAS WATSON"),
            Array(""),
            Array("")
        ],
        [
            Array(""),
            Array(""),
            Array("LESS IS MORE"),
            Array(""),
            Array(""),
            Array("- MIES VAN DER ROHE"),
            Array(""),
            Array("")
        ],
        [
            Array(""),
            Array(""),
            Array("MAKE IT SIMPLE"),
            Array("BUT SIGNIFICANT"),
            Array(""),
            Array("- DON DRAPER"),
            Array(""),
            Array("")
        ],
        [
            Array(""),
            Array(""),
            Array("HAVE NO FEAR OF"),
            Array("PERFECTION"),
            Array(""),
            Array("- SALVADOR DALI"),
            Array(""),
            Array("")
        ]
    ]
}

extension Color {
    init(hex: UInt32, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}
