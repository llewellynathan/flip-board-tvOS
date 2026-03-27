import SwiftUI
import UIKit

/// A transparent UIKit view that captures the Siri Remote Select (click) button press.
/// On tvOS, UITapGestureRecognizer with allowedPressTypes = [.select] is the reliable
/// way to detect the click without introducing a visible focused Button.
struct SelectPressHandler: UIViewRepresentable {
    let action: () -> Void

    func makeUIView(context: Context) -> UIView {
        let view = FocusableView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap))
        tap.allowedPressTypes = [NSNumber(value: UIPress.PressType.select.rawValue)]
        view.addGestureRecognizer(tap)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }

    class Coordinator: NSObject {
        let action: () -> Void
        init(action: @escaping () -> Void) { self.action = action }

        @objc func handleTap() {
            action()
        }
    }
}

private class FocusableView: UIView {
    override var canBecomeFocused: Bool { true }
}
