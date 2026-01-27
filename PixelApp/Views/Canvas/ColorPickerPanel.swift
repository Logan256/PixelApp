//
//  ColorPickerPanel.swift
//  PixelApp
//
//  Created by Logan on 5/4/25.
//

import SwiftUI

struct SaturationBrightnessPicker: View {
    @Binding var hue: CGFloat
    @Binding var saturation: CGFloat
    @Binding var brightness: CGFloat
    let setCurrentColor: (Color) -> Void
    
    let size: CGFloat = min(UIScreen.main.bounds.width / 2, UIScreen.main.bounds.height / 2)
    
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
                .frame(width: 25)
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

struct ColorPickerPanel: View {
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
                SaturationBrightnessPicker(
                    hue: $hue,
                    saturation: $saturation,
                    brightness: $brightness,
                    setCurrentColor: setCurrentColor
                )
                
                HueSlidersView(
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
                .onEnded { value in
                    dragAmount.width += value.translation.width
                    dragAmount.height += value.translation.height
                    currentDragAmount = .zero
                }
        )
    }
}

struct ColorPickerPanelPreview: View {
    @State private var hue: CGFloat = 1.0
    @State private var saturation: CGFloat = 1.0
    @State private var brightness: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 50) {
            ColorPickerPanel(
                setCurrentColor: {color in}
            )
        }
        .padding(10)
        .scaledToFit()
    }
}

#Preview {
    ColorPickerPanelPreview()
}

struct HueSlidersView: View {
    @Binding var hue: CGFloat
    @Binding var saturation: CGFloat
    @Binding var brightness: CGFloat
    let setCurrentColor: (_ color: Color) -> Void
    
    var body: some View {
        let sliderWidth: CGFloat = min(UIScreen.main.bounds.width / 2, UIScreen.main.bounds.height / 2)
        let sliderHeight: CGFloat = min(UIScreen.main.bounds.width / 2, UIScreen.main.bounds.height / 2) / 32
        
        VStack(spacing: 20) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 1, green: 0, blue: 0),
                        Color(red: 1, green: 1, blue: 0),
                        Color(red: 0, green: 1, blue: 0),
                        Color(red: 0, green: 1, blue: 1),
                        Color(red: 0, green: 0, blue: 1),
                        Color(red: 1, green: 0, blue: 1),
                        Color(red: 1, green: 0, blue: 0)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: sliderWidth, height: sliderHeight)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                DraggableCircle(bounds: sliderWidth / 2, colorValue: $hue) { position in
                    hue = normalizeSliderPosition(of: position, from: sliderWidth)
                    updateColor()
                }
            }
            
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hue: hue, saturation: 0, brightness: brightness),
                        Color(hue: hue, saturation: saturation, brightness: brightness),
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: sliderWidth, height: sliderHeight)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                DraggableCircle(bounds: sliderWidth / 2, colorValue: $saturation) { position in
                    saturation = normalizeSliderPosition(of: position, from: sliderWidth)
                    updateColor()
                }
            }
            
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(hue: hue, saturation: saturation, brightness: 0),
                        Color(hue: hue, saturation: saturation, brightness: brightness)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: sliderWidth, height: sliderHeight)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                DraggableCircle(bounds: sliderWidth / 2, colorValue: $brightness) { position in
                    brightness = normalizeSliderPosition(of: position, from: sliderWidth)
                    updateColor()
                }
            }
        }
    }
    
    private func normalizeSliderPosition(of slider: CGFloat, from width: CGFloat) -> CGFloat {
        (slider + (width / 2)) / width
    }
    
    private func updateColor() {
        setCurrentColor(Color(hue: hue, saturation: saturation, brightness: brightness))
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
                        if abs(dragAmount + currentDrag) <= bounds {
                            dragAmount += value.translation.width
                        } else if (dragAmount + currentDrag) > bounds {
                            dragAmount = bounds
                        } else if (dragAmount + currentDrag) < bounds {
                            dragAmount = -1 * bounds
                        }
                        currentDrag = .zero
                        onDrag(dragAmount)
                    }
            )
            .onChange(of: colorValue) { _ in
                dragAmount = calculateNewPosition(of: colorValue, in: bounds)
            }
    }
    
    private func calculateNewPosition(of colorValue: CGFloat, in bounds: CGFloat) -> CGFloat {
        (colorValue - 0.5) * (bounds * 2)
    }
}
