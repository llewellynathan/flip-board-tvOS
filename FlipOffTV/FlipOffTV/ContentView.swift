import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BoardViewModel()

    var body: some View {
        ZStack {
            Color(hex: 0x111111)
                .ignoresSafeArea()

            BoardView(viewModel: viewModel)

            // Capture Siri Remote Select (click) without a visible focus chrome
            SelectPressHandler { viewModel.next() }
                .ignoresSafeArea()

            // Toast overlay
            if let toast = viewModel.toastMessage {
                VStack {
                    Spacer()
                    Text(toast)
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(16)
                        .padding(.bottom, 80)
                }
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.3), value: viewModel.toastMessage)
            }
        }
        .onAppear {
            viewModel.start()
        }
        .onMoveCommand { direction in
            switch direction {
            case .left:
                viewModel.prev()
            case .right:
                viewModel.next()
            default:
                break
            }
        }
        .onPlayPauseCommand {
            viewModel.toggleMute()
        }
    }
}
