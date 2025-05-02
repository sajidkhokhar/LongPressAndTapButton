//
//  LongPressButton.swift
//  Translate AI
//
//  Created by Sajid on 02/05/25.
//


import SwiftUI

/// A control that initiates action on tap or long press.
public struct LongPressButton<Label: View>: View {
    private let minimumDuration: TimeInterval
    private let maximumDistance: CGFloat
    private let action: (() -> Void)?
    private let longPressAction: () -> Void
    private let longPressEndAction: (() -> Void)?
    private let label: Label

    @State private var didLongPress = false
    @State private var longPressTask: Task<Void, Never>?

    public var body: some View {
        Button(action: performActionIfNeeded) {
            label
        }
        .buttonStyle(PlainButtonStyle()) 
        .onLongPressGesture(
            maximumDistance: maximumDistance,
            perform: {},
            onPressingChanged: handleLongPress(isPressing:)
        )
    }

    private func performActionIfNeeded() {
        longPressTask?.cancel()
        if didLongPress {
            didLongPress = false
        } else {
            action?()
        }
    }

    private func handleLongPress(isPressing: Bool) {
        if isPressing {
            didLongPress = false
            longPressTask?.cancel()
            longPressTask = Task {
                do {
                    try await Task.sleep(nanoseconds: UInt64(minimumDuration * 1_000_000_000))
                } catch {
                    return
                }
                await MainActor.run {
                    didLongPress = true
                    longPressAction()
                }
            }
        } else {
            longPressTask?.cancel()
            longPressEndAction?()
        }
    }
}

// MARK: - Initialization

extension LongPressButton {

    /// Creates a long press button that displays a custom label.
    ///
    /// - Parameters:
    ///   - minimumDuration: The minimum duration of the long press that must elapse before the gesture succeeds.
    ///   - maximumDistance: The maximum distance that the fingers or cursor performing the long press can move before the gesture fails.
    ///   - action: The action to perform when the user taps the button.
    ///   - longPressAction: The action to perform when the user long presses the button.
    ///   - longPressEndAction: The action to perform when the long press ends.
    ///   - label: A view that describes the purpose of the button’s action.
    public init(
        minimumDuration: TimeInterval = 0.1,
        maximumDistance: CGFloat = 10,
        action: @escaping () -> Void,
        longPressAction: @escaping () -> Void,
        longPressEndAction: (() -> Void)? = nil,
        @ViewBuilder label: () -> Label
    ) {
        self.minimumDuration = minimumDuration
        self.maximumDistance = maximumDistance
        self.action = action
        self.longPressAction = longPressAction
        self.longPressEndAction = longPressEndAction
        self.label = label()
    }

    /// Creates a long press button that generates its label from a localized string key.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the button’s localized title.
    ///   - minimumDuration: The minimum duration of the long press.
    ///   - maximumDistance: The maximum distance allowed during the gesture.
    ///   - action: The action to perform on tap.
    ///   - longPressAction: The action to perform on long press.
    ///   - longPressEndAction: The action to perform when the long press ends.
    public init(
        _ titleKey: LocalizedStringKey,
        minimumDuration: TimeInterval = 0.1,
        maximumDistance: CGFloat = 10,
        action: @escaping () -> Void,
        longPressAction: @escaping () -> Void,
        longPressEndAction: (() -> Void)? = nil
    ) where Label == Text {
        self.init(
            minimumDuration: minimumDuration,
            maximumDistance: maximumDistance,
            action: action,
            longPressAction: longPressAction,
            longPressEndAction: longPressEndAction
        ) {
            Text(titleKey)
        }
    }

    /// Creates a long press button that generates its label from a string.
    ///
    /// - Parameters:
    ///   - title: A string that describes the purpose of the button’s action.
    ///   - minimumDuration: The minimum duration of the long press.
    ///   - maximumDistance: The maximum distance allowed during the gesture.
    ///   - action: The action to perform on tap.
    ///   - longPressAction: The action to perform on long press.
    ///   - longPressEndAction: The action to perform when the long press ends.
    public init<S: StringProtocol>(
        _ title: S,
        minimumDuration: TimeInterval = 0.1,
        maximumDistance: CGFloat = 10,
        action: @escaping () -> Void,
        longPressAction: @escaping () -> Void,
        longPressEndAction: (() -> Void)? = nil
    ) where Label == Text {
        self.init(
            minimumDuration: minimumDuration,
            maximumDistance: maximumDistance,
            action: action,
            longPressAction: longPressAction,
            longPressEndAction: longPressEndAction
        ) {
            Text(title)
        }
    }
}
