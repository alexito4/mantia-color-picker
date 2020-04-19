//
//  ColorGrid.swift
//  ColorPicker
//
//  Created by Alejandro Martinez on 03/05/2020.
//  Copyright © 2020 Alejandro Martinez. All rights reserved.
//

import SwiftUI

struct ColorGrid: View {
    
    let baseHue: Double
    let saturations: [Int]
    let brightnesses: [Int]
    
    @Binding var selectedSquare: SquareIndex
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(self.brightnesses, id: \.self) { brightness in
                HStack(spacing: 0) {
                    ForEach(self.saturations, id: \.self) { saturation in
                        ColoredSquare(
                            hue: Int(self.baseHue),
                            saturation: saturation,
                            brightness: brightness,
                            selectedSquare: self.$selectedSquare
                        )
                    }
                }
            }
        }
    }
}

struct SquareIndex: Equatable {
    let saturationIndex: Int
    let brightnessIndex: Int
}

struct ColoredSquare: View {
    let hue: Int // 0...360
    let saturation: Int // 0...100
    let brightness: Int // 0...100
    
    @Binding var selectedSquare: SquareIndex
    @State var hover = false
    
    var body: some View {
        let squareIndex = SquareIndex( // treating sat and brightness as index :(
            saturationIndex: saturation,
            brightnessIndex: brightness
        )
        let color = ColorInfo(
            hue: hue,
            saturation: saturation,
            brightness: brightness
        ).color
        let selectedColor = ColorInfo(
            hue: (hue + 180) % 360,
            saturation: 88,
            brightness: 88
        ).color
        
        let isSelected = selectedSquare == squareIndex
        
        return Rectangle()
            .foregroundColor(color)
            .border(
                hover && !isSelected ? selectedColor.opacity(0.4) : .clear,
                width: 2
            )
            .border(
                isSelected ? selectedColor : .clear,
                width: 4
            )
            .onTapGesture {
                self.selectedSquare = squareIndex
            }
            .onHover { hover in
                self.hover = hover
            }
    }
}

struct ColorGrid_Previews: PreviewProvider {
    static var previews: some View {
        ColorGrid(
            baseHue: 45,
            saturations: [0, 50, 100],
            brightnesses: [0, 50, 100],
            selectedSquare: .constant(SquareIndex(saturationIndex: 50, brightnessIndex: 50))
        )
    }
}
