//
//  ColorInfo.swift
//  ColorPicker
//
//  Created by Alejandro Martinez on 03/05/2020.
//  Copyright © 2020 Alejandro Martinez. All rights reserved.
//

import SwiftUI

/// Because SwiftUI color can't get the values
struct ColorInfo: Equatable {
    let hue: Int // 0...360
    let saturation: Int // 0...100
    let brightness: Int // 0...100
    
    var color: Color {
        Color(
            hue: Double(hue)/360.0,
            saturation: Double(saturation)/100.0,
            brightness: Double(brightness)/100.0
        )
    }
    
    var rgb: (r: Int, g: Int, b: Int) {
        let hueV = Double(hue)/360.0*6
        let redH, greenH, blueH: Double
        
        if(hueV <= 1.0){
            redH = 1.0
            greenH = hueV
            blueH = 0.0
        } else if (hueV<2.0){
            redH = (2.0-hueV)
            greenH = 1.0
            blueH = 0.0
        } else if (hueV < 3.0){
            redH=0.0
            greenH=1.0
            blueH=(hueV-2.0)
        } else if (hueV < 4.0){
            redH=0.0
            greenH=4.0-hueV
            blueH=1.0
        } else if (hueV < 5.0){
            redH=hueV-4.0
            greenH=0.0
            blueH=1.0
        } else {
            redH=1.0
            greenH=0.0
            blueH=6.0-hueV
        }
        
        func colorValue(huePart: Double) -> Double {
            let saturationValue = Double(saturation)/100.0
            let brightnessValue = Double(brightness)/100.0
            return 255 * ((1 - saturationValue) * brightnessValue + saturationValue * brightnessValue * huePart) + 0.1;
        }
        
        let redValue = colorValue(huePart: redH)
        let greenValue = colorValue(huePart: greenH);
        let blueValue = colorValue(huePart: blueH);
        
        return (r: Int(redValue), g: Int(greenValue), b: Int(blueValue))
    }
    
    var hex: String {
        let rgbValues = self.rgb
        let rgb: Int = rgbValues.r << 16 | rgbValues.g << 8 | rgbValues.b << 0
        return "#\(String(rgb, radix: 16, uppercase: true))"
    }
}
