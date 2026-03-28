import SwiftUI

struct BoardView: View {
    @ObservedObject var viewModel: BoardViewModel

    private let tileSize: CGFloat = 62
    private let tileGap: CGFloat = 5
    private let rowGap: CGFloat = 24

    var body: some View {
        ZStack {
            // Board background
            Color(hex: 0x1A1A1A)

            HStack(spacing: 0) {
                // Left accent squares
                accentBar
                    .padding(.leading, 18)

                Spacer()

                // Tile grid
                VStack(spacing: rowGap) {
                    ForEach(0..<Constants.gridRows, id: \.self) { row in
                        HStack(spacing: tileGap) {
                            ForEach(viewModel.tiles[row]) { tile in
                                TileView(model: tile)
                            }
                        }
                    }
                }

                Spacer()

                // Right accent squares
                accentBar
                    .padding(.trailing, 18)
            }
            .padding(.vertical, 40)
        }
        .overlay(
            // Board edge highlight
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.04),
                            Color.clear,
                            Color.black.opacity(0.2)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1
                )
        )
    }

    private var accentBar: some View {
        VStack(spacing: 3) {
            ForEach(0..<2, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 2)
                    .fill(viewModel.accentColor)
                    .frame(width: 14, height: 14)
            }
        }
    }
}
