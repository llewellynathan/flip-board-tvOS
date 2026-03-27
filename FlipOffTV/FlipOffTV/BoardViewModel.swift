import SwiftUI
import Combine

class BoardViewModel: ObservableObject {
    let tiles: [[TileModel]]
    let soundEngine = SoundEngine()

    @Published var accentColor: Color = Constants.accentColors[0]
    @Published var toastMessage: String?

    private var currentGrid: [[Character]]
    private var isTransitioning = false
    private var currentMessageIndex = -1
    private var accentIndex = 0
    private var rotationTimer: AnyCancellable?
    private var toastTimer: DispatchWorkItem?

    init() {
        var tileRows: [[TileModel]] = []
        var charRows: [[Character]] = []
        for r in 0..<Constants.gridRows {
            var row: [TileModel] = []
            var charRow: [Character] = []
            for c in 0..<Constants.gridCols {
                let tile = TileModel(row: r, col: c)
                tile.setChar(" ")
                row.append(tile)
                charRow.append(" ")
            }
            tileRows.append(row)
            charRows.append(charRow)
        }
        self.tiles = tileRows
        self.currentGrid = charRows
    }

    func start() {
        next()
        rotationTimer = Timer.publish(
            every: Constants.messageInterval + Constants.totalTransition,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { [weak self] _ in
            guard let self = self, !self.isTransitioning else { return }
            self.next()
        }
    }

    func next() {
        currentMessageIndex = (currentMessageIndex + 1) % Constants.messages.count
        displayMessage(Constants.messages[currentMessageIndex])
        resetAutoRotation()
    }

    func prev() {
        currentMessageIndex = (currentMessageIndex - 1 + Constants.messages.count) % Constants.messages.count
        displayMessage(Constants.messages[currentMessageIndex])
        resetAutoRotation()
    }

    func toggleMute() {
        let muted = soundEngine.toggleMute()
        showToast(muted ? "Sound off" : "Sound on")
    }

    // MARK: - Private

    private func displayMessage(_ lines: [[Character]]) {
        guard !isTransitioning else { return }
        isTransitioning = true

        let newGrid = formatToGrid(lines)
        var hasChanges = false

        for r in 0..<Constants.gridRows {
            for c in 0..<Constants.gridCols {
                let newChar = newGrid[r][c]
                let oldChar = currentGrid[r][c]
                if newChar != oldChar {
                    let delay = Double(r * Constants.gridCols + c) * Constants.staggerDelay
                    tiles[r][c].scrambleTo(newChar, delay: delay)
                    hasChanges = true
                }
            }
        }

        if hasChanges {
            soundEngine.playTransition()
        }

        accentIndex += 1
        accentColor = Constants.accentColors[accentIndex % Constants.accentColors.count]
        currentGrid = newGrid

        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.totalTransition + 0.2) { [weak self] in
            self?.isTransitioning = false
        }
    }

    private func formatToGrid(_ lines: [[Character]]) -> [[Character]] {
        var grid: [[Character]] = []
        for r in 0..<Constants.gridRows {
            let line = r < lines.count ? lines[r] : []
            let padTotal = Constants.gridCols - line.count
            let padLeft = max(0, padTotal / 2)
            let padRight = max(0, Constants.gridCols - padLeft - line.count)
            let padded = Array(repeating: Character(" "), count: padLeft) + line + Array(repeating: Character(" "), count: padRight)
            grid.append(Array(padded.prefix(Constants.gridCols)))
        }
        return grid
    }

    private func resetAutoRotation() {
        rotationTimer?.cancel()
        rotationTimer = Timer.publish(
            every: Constants.messageInterval + Constants.totalTransition,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { [weak self] _ in
            guard let self = self, !self.isTransitioning else { return }
            self.next()
        }
    }

    private func showToast(_ message: String) {
        toastMessage = message
        toastTimer?.cancel()
        let work = DispatchWorkItem { [weak self] in
            self?.toastMessage = nil
        }
        toastTimer = work
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: work)
    }
}
