//
//  Colors.swift
//  TuneIn
//
//  Created by Tamas Bara on 25.01.22.
//

import SwiftUI

extension Color {
    
    static var text: Color {
        Color(uiColor: UIColor(named: "text") ?? UIColor.clear)
    }
    
    static var neon: Color {
        Color(uiColor: UIColor(named: "neon") ?? UIColor.clear)
    }
    
    static var button: Color {
        Color(uiColor: UIColor(named: "button") ?? UIColor.clear)
    }
    
    static var button2: Color {
        Color(uiColor: UIColor(named: "button2") ?? UIColor.clear)
    }
    
    static var navigation: Color {
        Color(uiColor: UIColor(named: "navigation") ?? UIColor.clear)
    }
}
