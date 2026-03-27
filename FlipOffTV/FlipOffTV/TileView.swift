import SwiftUI

struct TileView: View {
    @ObservedObject var model: TileModel

    private let tileSize: CGFloat = 62

    var body: some View {
        ZStack {
            // Tile face
            RoundedRectangle(cornerRadius: 2)
                .fill(model.backgroundColor)
                .overlay(
                    // Horizontal split line (mechanical seam)
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .frame(height: 1)
                        .offset(y: 0),
                    alignment: .center
                )
                .overlay(
                    // Inner shadow
                    RoundedRectangle(cornerRadius: 2)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.black.opacity(0.5),
                                    Color.clear,
                                    Color.white.opacity(0.02)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                )

            // Character
            Text(model.displayChar == " " ? "" : String(model.displayChar))
                .font(.system(size: tileSize * 0.52, weight: .bold, design: .default))
                .foregroundColor(model.textColor)
                .textCase(.uppercase)
        }
        .frame(width: tileSize, height: tileSize)
        .background(Color(hex: 0x111111))
        .cornerRadius(3)
        .rotation3DEffect(
            .degrees(model.flipAngle),
            axis: (x: 1, y: 0, z: 0),
            perspective: 0.4
        )
    }
}
