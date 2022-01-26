//
//  View+Extension.swift
//  TuneIn
//
//  Created by Tamas Bara on 25.01.22.
//

import SwiftUI

extension Date {
    
    var stringify: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: self)
    }
    
    var title: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_DE")
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: self)
    }
}

extension String {
    
    var shorten: String {
        String(uppercased().prefix(upTo: index(startIndex, offsetBy: 2)))
    }
}

struct DarkModeInverter: ViewModifier {
    
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        switch colorScheme {
        case .dark: content
        default:
            content
                .colorInvert()
        }
    }
}

struct PinModifier: ViewModifier {

    enum Mode {
        case left
        case right
    }
    
    var mode = Mode.left
    
    func body(content: Content) -> some View {
        HStack {
            switch mode {
            case .left:
                content
                Spacer()
            default:
                Spacer()
                content
            }
        }
    }
}

extension View {
    
    func invertDark() -> some View {
        modifier(DarkModeInverter())
    }
    
    func pinLeft() -> some View {
        modifier(PinModifier())
    }
    
    func pinRight() -> some View {
        modifier(PinModifier(mode: .right))
    }
}
