# LongPressButton for SwiftUI

A customizable SwiftUI button that supports both tap and long-press gestures with separate actions. This component is useful when you need to distinguish between a quick tap and a longer hold, such as for secondary actions or previews.

## ✨ Features

- Supports both **tap** and **long press** interactions.
- Optional **long press end** handler.
- Fully configurable duration and gesture distance.
- Multiple initializers for text or custom label views.

## 📦 Installation

Copy the `LongPressButton.swift` file into your SwiftUI project.

## 🧠 Usage

### 1. With Custom Label

```swift
LongPressButton(
    minimumDuration: 0.5,
    maximumDistance: 20,
    action: {
        print("Tapped")
    },
    longPressAction: {
        print("Long Press Started")
    },
    longPressEndAction: {
        print("Long Press Ended")
    }
) {
    Image(systemName: "star.fill")
        .font(.largeTitle)
        .foregroundColor(.yellow)
}
