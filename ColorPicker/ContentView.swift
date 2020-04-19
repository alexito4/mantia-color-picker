//
//  ContentView.swift
//  ColorPicker
//
//  Created by Alejandro Martinez on 19/04/2020.
//  Copyright © 2020 Alejandro Martinez. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var baseHue: Double = 50
    
    // 0, 12, 25, 38, 50, 63, 75, 88, 100
    let saturations: [Int] = (0...8).reduce([], { $0 + [ Int((100.0/8.0*Double($1)).rounded()) ] })
    let brightnesses: [Int] = (0...8).reduce([], { $0 + [ Int((100.0/8.0*Double($1)).rounded()) ] })
    
    @State var selectedSquare: SquareIndex = SquareIndex(
        // Must use a number resulting from saturations/brightnesses
        saturationIndex: 88,
        brightnessIndex: 88
    )
    
    var selectedColorInfo: ColorInfo {
        ColorInfo(
            hue: Int(baseHue),
            saturation: selectedSquare.saturationIndex,
            brightness: selectedSquare.brightnessIndex
        )
    }
    
    @State var previewColor: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            ColorGrid(
                baseHue: baseHue,
                saturations: saturations,
                brightnesses: brightnesses,
                selectedSquare: $selectedSquare
            )
            VStack(spacing: 10) {
                
                Spacer()
                
                VStack {
                    /// TODO: Make this text a field that autoformats to increments of 5.
                    InfoRow(title: "Base Hue", value: "\(Int(self.baseHue))")
                    HueSlider(baseHue: $baseHue)
                        .cornerRadius(4)
                }
                .boxed()
                
                VStack(alignment: .leading, spacing: 10) {
                    // these should index from the brightnesses and saturations arrays in case it changes
                    InfoRow(
                        title: "HSB",
                        value: "\(Int(self.baseHue)), \(selectedSquare.saturationIndex), \(selectedSquare.brightnessIndex)",
                        enablePasteboard: true
                    )
                    InfoRow(
                        title: "RGB",
                        value: "\(selectedColorInfo.rgb.r), \(selectedColorInfo.rgb.g), \(selectedColorInfo.rgb.b)",
                        enablePasteboard: true
                    )
                    InfoRow(
                        title: "Hex",
                        value: "\(selectedColorInfo.hex)",
                        enablePasteboard: true
                    )
                }
                .boxed()
                
                Spacer()
            }
            .padding()
            .overlay(
                EyeToggle(on: self.$previewColor),
                alignment: .topTrailing
            )
        }
        .frame(minWidth: 600, maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundForPreview())
    }
    
    private func backgroundForPreview() -> some View {
        if previewColor {
            return selectedColorInfo.color
        } else {
            return ColorInfo(
                hue: selectedColorInfo.hue,
                saturation: 38,
                brightness: 75
            ).color
        }
    }
}

private let defaultTooltipText = "Click to copy"
struct InfoRow: View {
    let title: String
    let value: String
    let enablePasteboard: Bool
    
    @State var showTooltip = false
    @State var tooltipText: String = defaultTooltipText
    
    init(title: String, value: String, enablePasteboard: Bool = false) {
        self.title = title
        self.value = value
        self.enablePasteboard = enablePasteboard
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            Text(value)
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity)
        }
        .padding()
        .contentShape(Rectangle())
        .overlay(
            tooltipView(),
            alignment: .topTrailing
        )
        .border(showTooltip ? Color.primary : .clear, width: 2)
        .cornerRadius(4)
        .onHover { hover in
            self.showTooltip = self.enablePasteboard && hover
        }
        .onTapGesture {
            guard self.enablePasteboard else { return }
            self.sendToPasteboard()
        }
    }
    
    private func tooltipView() -> some View {
        Group {
            if showTooltip {
                Text(self.tooltipText)
                    .padding(4)
                    .cornerRadius(4)
                    .background(Color.primary.colorInvert())
            }
        }
    }
    
    private func sendToPasteboard() {
        NSPasteboard.general.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        NSPasteboard.general.setString(value, forType: .string)
        self.tooltipText = "Copied!"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tooltipText = defaultTooltipText
        }
    }
}

private extension View {
    func boxed() -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.primary.colorInvert())
            .cornerRadius(4)
            .shadow(color: Color.primary.opacity(0.4), radius: 4, x: 0, y: 0)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environment(\.colorScheme, .dark)
                .previewDisplayName("Dark")
            
            ContentView()
                .environment(\.colorScheme, .light)
                .previewDisplayName("Light")
        }
    }
}
