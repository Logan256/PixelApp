//
//  ColorPicker.swift
//  PixelApp
//
//  Created by Logan on 5/4/25.
//

import SwiftUI

struct ColorPicker: View {
    @Binding var hue: CGFloat
    @Binding var saturation: CGFloat
    @Binding var brightness: CGFloat
    let setCurrentColor: (Color) -> Void
    
    let size: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        let colorGradient = LinearGradient(
            gradient: Gradient(colors: [
                Color(hue: hue, saturation: 0, brightness: 1),
                Color(hue: hue, saturation: 1, brightness: 1)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
        
        let backgroundGradient = LinearGradient(
            gradient: Gradient(colors: [
                Color(hue: hue, saturation: 0, brightness: 0).opacity(0),
                Color(hue: hue, saturation: 0, brightness: 0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        
        let rect = CGRect(x: .zero, y: .zero, width: size, height: size)
        let pointerX = saturation
        let pointerY = brightness
        
        ZStack {
            Rectangle()
                .fill(colorGradient)
                .frame(width: size, height: size)
                
            Rectangle()
                .fill(backgroundGradient)
                .frame(width: size, height: size)
            
            Circle()
                .fill(.gray)
                .frame(width: 50)
                .offset(x: (pointerX * size) - (size/2), y: -((pointerY * size) - (size/2)))
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let location = value.location
                    let sb = saturationBrightnessAtPoint(location, in: rect, hue: hue)
                    saturation = sb.saturation
                    brightness = sb.brightness
                    let selectedColor = Color(hue: hue, saturation: saturation, brightness: brightness)
                    setCurrentColor(selectedColor)
                }
        )
        
    }
    
    private func saturationBrightnessAtPoint(_ point: CGPoint, in rect: CGRect, hue: CGFloat) -> (saturation: CGFloat, brightness: CGFloat) {
        let saturation = max(0, min(1, point.x / rect.width))
        let brightness = max(0, min(1, 1 - (point.y / rect.height)))
        return (saturation, brightness)
    }
}

struct DraggableColorPicker: View {
    @State private var hue: CGFloat = 0.75
    @State private var saturation: CGFloat = 0.75
    @State private var brightness: CGFloat = 0.75
    
    @State private var dragAmount: CGSize = .zero
    @State private var currentDragAmount: CGSize = .zero
    
    let setCurrentColor: (_ color: Color) -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                .fill(.white)
            VStack(spacing: 20) {
                ColorPicker(
                    hue: $hue,
                    saturation: $saturation,
                    brightness: $brightness,
                    setCurrentColor: setCurrentColor
                )
                
                ColorSlidersView(
                    hue: $hue,
                    saturation: $saturation,
                    brightness: $brightness,
                    setCurrentColor: setCurrentColor
                )
                
                Image(systemName: "line.3.horizontal")
                    .font(.title)
            }
        }
        .offset(
            x: dragAmount.width + currentDragAmount.width,
            y: dragAmount.height + currentDragAmount.height
        )
        .gesture (
            DragGesture()
                .onChanged { value in
                    currentDragAmount = value.translation
                }
                .onEnded{ value in
                    dragAmount.width += value.translation.width
                    dragAmount.height += value.translation.height
                    currentDragAmount = .zero
                }
        )
    }
}

struct PreviewColorPicker : View {
    @State private var hue: CGFloat = 1.0
    @State private var saturation: CGFloat = 1.0
    @State private var brightness: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 50) {
            DraggableColorPicker(
                setCurrentColor: {color in}
            )
        }
        .padding(10)
        .scaledToFit()
    }
}

#Preview {
    PreviewColorPicker()
}
