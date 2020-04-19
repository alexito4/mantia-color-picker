//
//  HueSlider.swift
//  ColorPicker
//
//  Created by Alejandro Martinez on 19/04/2020.
//  Copyright © 2020 Alejandro Martinez. All rights reserved.
//

import SwiftUI

struct HueSlider: View {
    @Binding var baseHue: Double
    
    @State private var sliderHeight: CGFloat = 0
    
    var body: some View {
        ZStack {            
            LinearGradient(
                gradient: Gradient(colors:
                    stride(from: 0, to: 355, by: 5)
                    .map({
                        ColorInfo(
                            hue: $0,
                            saturation: 100,
                            brightness: 100
                        ).color
                    })
                ),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: sliderHeight)
            
            Slider(value: $baseHue, in: 0...360, step: 5)
                .padding(.vertical, 2)
                .background(Color.black.opacity(0.4))
                .background(GeometryReader { proxy in
                    return Rectangle()
                        .fill(Color.clear)
                        .preference(
                            key: SliderHeightPreferenceKey.self,
                            value: proxy.size.height
                        )
                })
            
        }
        .onPreferenceChange(SliderHeightPreferenceKey.self) { height in
            self.sliderHeight = height
        }
    }
}

private struct SliderHeightPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: Value = 0
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        let next = nextValue()
        if next != defaultValue {
            value = next
        }
    }
}

struct HueSlider_Previews: PreviewProvider {
    static var previews: some View {
        HueSlider(baseHue: .constant(15))
    }
}
