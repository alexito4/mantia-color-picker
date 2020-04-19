//
//  EyeToggle.swift
//  ColorPicker
//
//  Created by Alejandro Martinez on 03/05/2020.
//  Copyright © 2020 Alejandro Martinez. All rights reserved.
//

import SwiftUI

struct EyeToggle: View {
    @Binding var on: Bool
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.on.toggle()
            }
        }) {
            Image(self.on ? "icons8-eye-90" : "icons8-closed-eye-90")
                .renderingMode(.template)
                .resizable()
                .frame(width: 30, height: 30)
                .padding(.horizontal, 6)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EyeToggle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EyeToggle(on: .constant(true))
            EyeToggle(on: .constant(false))
        }
    }
}
