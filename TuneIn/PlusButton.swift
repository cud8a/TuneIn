//
//  PlusButton.swift
//  TuneIn
//
//  Created by Tamas Bara on 26.01.22.
//

import SwiftUI

struct PlusButton: View {
    
    var body: some View {
        Image(systemName: "plus")
            .font(.system(size: 44, weight: .bold))
            .foregroundColor(.neon)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            .background() {
                Circle()
                    .foregroundColor(.button)
            }
            .background() {
                Circle()
                    .stroke(Color.button2, lineWidth: 5)
            }
    }
}
