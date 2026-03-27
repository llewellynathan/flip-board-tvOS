import SwiftUI
import Combine

class TileModel: ObservableObject, Identifiable {
    let id: Int
    let row: Int
    let col: Int

    @Published var displayChar: Character = " "
    @Published var backgroundColor: Color = Color(hex: 0x222222)
    @Published var textColor: Color = .white
    @Published var flipAngle: Double = 0

    private var currentChar: Character = " "
    private var scrambleTimer: AnyCancellable?
    private var isAnimating = false

    init(row: Int, col: Int) {
        self.row = row
        self.col = col
        self.id = row * Constants.gridCols + col
    }

    func setChar(_ char: Character) {
        currentChar = char
        displayChar = char
        backgroundColor = Color(hex: 0x222222)
        textColor = .white
    }

    func scrambleTo(_ targetChar: Character, delay: TimeInterval) {
        guard targetChar != currentChar else { return }

        scrambleTimer?.cancel()
        isAnimating = true

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }

            var scrambleCount = 0
            let maxScrambles = 10 + Int.random(in: 0..<4)

            self.scrambleTimer = Timer.publish(
                every: Constants.scrambleInterval,
                on: .main,
                in: .common
            )
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                let randChar = Constants.charset.randomElement() ?? " "
                self.displayChar = randChar

                let color = Constants.scrambleColors[scrambleCount % Constants.scrambleColors.count]
                self.backgroundColor = color

                // Adjust text color for light backgrounds
                if scrambleCount % Constants.scrambleColors.count >= 4 {
                    self.textColor = Color(hex: 0x111111)
                } else {
                    self.textColor = .white
                }

                scrambleCount += 1

                if scrambleCount >= maxScrambles {
                    self.scrambleTimer?.cancel()
                    self.scrambleTimer = nil

                    // Reset to final state
                    self.backgroundColor = Color(hex: 0x222222)
                    self.textColor = .white
                    self.displayChar = targetChar

                    // Brief flip effect
                    withAnimation(.easeInOut(duration: Constants.flipDuration)) {
                        self.flipAngle = -8
                    }

                    DispatchQueue.main.asyncAfter(
                        deadline: .now() + Constants.flipDuration / 2
                    ) { [weak self] in
                        guard let self = self else { return }
                        withAnimation(.easeInOut(duration: Constants.flipDuration)) {
                            self.flipAngle = 0
                        }
                        DispatchQueue.main.asyncAfter(
                            deadline: .now() + Constants.flipDuration
                        ) { [weak self] in
                            self?.currentChar = targetChar
                            self?.isAnimating = false
                        }
                    }
                }
            }
        }
    }
}
