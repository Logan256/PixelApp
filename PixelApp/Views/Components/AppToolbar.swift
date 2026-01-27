//
//  AppToolbar.swift
//  PixelApp
//
//  Created by Logan on 5/5/25.
//

import SwiftUI

struct AppToolbar: View {
    let title: String
    let navigationAction: () -> Void
    let rightButtons: [(icon: String?, action: (() -> Void)?)]
    
    init(
        title: String,
        navigationAction: @escaping () -> Void,
        rightButtons: [(icon: String, action: (() -> Void))] = []
    ) {
        self.title = title
        self.navigationAction = navigationAction
        self.rightButtons = rightButtons
    }

    var body: some View {
        HStack {
            // Left navigation/action button
            Button(action: {
                navigationAction()
            }) {
                Image(systemName: "arrow.left")
            }

            Spacer()

            // Title
            Text(title)
                .font(.headline)

            Spacer()

            // Right tool icons
            HStack(spacing: 16) {
                ForEach(Array(rightButtons.enumerated()), id: \.offset) { _, button in
                    if let action = button.action, let icon = button.icon {
                        Button(action: {
                            action()
                        }) {
                            Image(systemName: icon)
                        }
                    }
                }
            }
            
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .foregroundColor(.primary)
    }
}

#Preview {
    VStack {
        AppToolbar(
            title: "My Drawing",
            navigationAction: { print("Back tapped") },
            rightButtons: [
                (icon: "paintbrush", action: { print("Brush") }),
                (icon: "eyedropper", action: { print("Eyedropper") }),
                (icon: "trash", action: { print("Delete") }),
                (icon: "square.and.arrow.up", action: { print("Share") })
            ]
        )
        
        AppToolbar(title: "Untitled", navigationAction: {})
    }
}
