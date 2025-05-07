//
//  Slider.swift
//  PixelApp
//
//  Created by Logan on 5/5/25.
//

import SwiftUI

struct VerticleSlider: View {
    @Binding var value: Double
    var range: ClosedRange<Double> = 0...1
    var trackThickness: CGFloat = 20
    var knobSize: CGFloat = 28
    let knobColor: Color = Color.gray
    let trackColor: Color = Color.gray.opacity(0.3)

    var body: some View {
        GeometryReader { geo in
            let height = geo.size.height
            let clampedValue = min(max(value, range.lowerBound), range.upperBound)
            let progress = CGFloat((clampedValue - range.lowerBound) / (range.upperBound - range.lowerBound))
            let yPosition = height * (1 - progress)

            ZStack {
                // Track
                RoundedRectangle(cornerRadius: trackThickness / 2)
                    .fill(trackColor)
                    .frame(width: trackThickness)

                // Filled Track
                VStack {
                    Spacer(minLength: 0)
                    RoundedRectangle(cornerRadius: trackThickness / 2)
                        .fill(Color.gray)
                        .frame(width: trackThickness, height: height * progress - knobSize / 2)
                }

                // Draggable Knob
                Circle()
                    .fill(knobColor)
                    .frame(width: knobSize, height: knobSize)
                    .position(x: geo.size.width / 2, y: yPosition)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                let location = gesture.location.y
                                let percent = 1 - min(max(location / height, 0), 1)
                                let newValue = Double(percent) * (range.upperBound - range.lowerBound) + range.lowerBound
                                value = newValue
                            }
                    )
            }
        }
        .frame(width: trackThickness) // adjust as needed
    }
}


private struct PreviewVerticalSlider: View {
    @State private var value = 0.0

    var body: some View {
        HStack() {
            VerticleSlider(value: $value)
        }
    }
}

#Preview {
    PreviewVerticalSlider()
}


