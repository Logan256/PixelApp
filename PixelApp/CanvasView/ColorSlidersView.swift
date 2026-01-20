//
//  ColorSlidersView.swift
//  PixelApp
//
//  Created by Logan on 5/4/25.
//

import SwiftUI

struct ColorSlidersView: View {
    @Binding var hue: CGFloat
    @Binding var saturation: CGFloat
    @Binding var brightness: CGFloat
    let setCurrentColor: (_ color: Color) -> Void
    
    var body: some View {
        let sliderWidth: CGFloat = min(UIScreen.main.bounds.width / 2, UIScreen.main.bounds.height / 2)
        
        let sliderHeight: CGFloat = min(UIScreen.main.bounds.width / 2, UIScreen.main.bounds.height / 2) / 32
        
        VStack(spacing: 20) {
            // hue
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 1, green: 0, blue: 0), // Red
                        Color(red: 1, green: 1, blue: 0), // Yellow
                        Color(red: 0, green: 1, blue: 0), // Green
                        Color(red: 0, green: 1, blue: 1), // Cyan
                        Color(red: 0, green: 0, blue: 1), // Blue
                        Color(red: 1, green: 0, blue: 1), // Magenta
                        Color(red: 1, green: 0, blue: 0) // red
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: sliderWidth, height: sliderHeight)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                DraggableCircle(bounds: sliderWidth/2, colorValue: $hue) {position in
                    hue = normalizeSliderPosition(of: position, from: sliderWidth)
                    print(hue)
                }
            }
            
            //saturation
            ZStack {
                
                LinearGradient (
                    gradient: Gradient(colors: [
                        Color(hue: hue, saturation: 0, brightness: brightness),
                        Color(hue: hue, saturation: saturation, brightness: brightness),
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: sliderWidth, height: sliderHeight)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                DraggableCircle(bounds: sliderWidth/2, colorValue: $saturation) {position in
                    saturation = normalizeSliderPosition(of: position, from: sliderWidth)
                    print(saturation)
                }
            }
            
            // brightness
            ZStack {
                LinearGradient (
                    gradient: Gradient(colors: [
                        Color(hue: hue, saturation: saturation, brightness: 0),
                        Color(hue: hue, saturation: saturation, brightness: brightness)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: sliderWidth, height: sliderHeight)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                DraggableCircle(bounds: sliderWidth/2, colorValue: $brightness) {position in
                    brightness = normalizeSliderPosition(of: position, from: sliderWidth)
                    print(brightness)
                }
            }
        }
    }
    
    private func normalizeSliderPosition(of slider: CGFloat, from width: CGFloat) -> CGFloat {
        return (slider + (width / 2)) / width
    }
}

struct DraggableCircle: View {
    let bounds: CGFloat
    @State private var dragAmount: CGFloat = .zero
    @State private var currentDrag: CGFloat = .zero
    @Binding var colorValue: CGFloat
    
    var onDrag: (CGFloat) -> Void
    
    var body: some View {
        
        Circle()
            .fill(.gray)
            .frame(width: 25)
            .offset(x: dragAmount + currentDrag, y: 0)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        currentDrag = value.translation.width
                    }
                    .onEnded { value in
                        if (abs(dragAmount + currentDrag) <= bounds) {
                            dragAmount += value.translation.width
                        }
                        else if ((dragAmount + currentDrag) > bounds) {
                            dragAmount = bounds
                        }
                        else if (((dragAmount + currentDrag) < bounds)) {
                            dragAmount = -1 * bounds
                        }
                        currentDrag = .zero
                        onDrag(dragAmount) // send info back to parent
                        
                    }
                
            )
            .onChange(of: colorValue) {
                dragAmount = calculateNewPosition(of: colorValue, in: bounds)
            }
    }
    
    private func calculateNewPosition(of colorValue: CGFloat, in bounds: CGFloat) -> CGFloat {
        return (colorValue - 0.5) * (bounds * 2)
    }
}

struct PreviewSliders: View {
    @State private var hue: CGFloat = 0.75
    @State private var saturation: CGFloat = 0.75
    @State private var brightness: CGFloat = 0.75
    
    var body: some View {
        VStack {
            ColorSlidersView(
                hue: $hue,
                saturation: $saturation,
                brightness: $brightness,
                setCurrentColor: {color in }
            )
            Text("Hue: \(hue)")
            Text("Saturation: \(saturation)")
            Text("Brightness: \(brightness)")
        }
    }
}


#Preview {
    VStack {
        PreviewSliders()
    }
}
