import SwiftUI

struct TileView: View {
    @ObservedObject var model: TileModel

    private let tileSize: CGFloat = 62
    private let tileHeight: CGFloat = 87
    private let flapRatio: CGFloat = 0.7

    private var flapHeight: CGFloat { tileHeight * flapRatio }
    private var cavityHeight: CGFloat { tileHeight * (1 - flapRatio) }

    var body: some View {
        ZStack(alignment: .top) {
            // Cavity background (full tile)
            Rectangle()
                .fill(Color(hex: 0x0D0D0D))

            // Stacked flap ridges in exposed cavity (bottom 30%)
            VStack(spacing: 3) {
                ForEach(0..<7, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.white.opacity(0.04))
                        .frame(height: 1)
                }
            }
            .padding(.horizontal, 2)
            .frame(height: cavityHeight, alignment: .center)
            .offset(y: flapHeight)

            // Flap (top 70% of cavity)
            ZStack {
                // Flap face — sharp corners
                Rectangle()
                    .fill(model.backgroundColor)
                    .overlay(
                        // Two-tone: top half lighter, bottom half darker
                        LinearGradient(
                            stops: [
                                .init(color: Color.white.opacity(0.06), location: 0),
                                .init(color: Color.white.opacity(0.04), location: 0.46),
                                .init(color: Color.black.opacity(0.04), location: 0.54),
                                .init(color: Color.black.opacity(0.08), location: 1.0)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        // Horizontal seam at flap midpoint
                        VStack(spacing: 0) {
                            Spacer()
                            Rectangle()
                                .fill(Color.black.opacity(0.6))
                                .frame(height: 1)
                            Rectangle()
                                .fill(Color.black.opacity(0.25))
                                .frame(height: 1)
                            Spacer()
                        },
                        alignment: .center
                    )
                    .overlay(
                        // Inner edge highlight (top-lit)
                        Rectangle()
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.06),
                                        Color.black.opacity(0.3),
                                        Color.black.opacity(0.15)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 1
                            )
                    )

                // Character — offset down to align visual center with seam
                Text(model.displayChar == " " ? "" : String(model.displayChar))
                    .font(.system(size: tileSize * 0.52, weight: .bold, design: .default))
                    .foregroundColor(model.textColor)
                    .textCase(.uppercase)
                    .offset(y: 2)

                // Top-center pivot notch (on the flap)
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 6, height: 3)
                    .offset(y: -(flapHeight - 1) / 2 + 1.5)
            }
            .frame(width: tileSize - 2, height: flapHeight - 1)
            .clipped()
            .offset(y: 1)
        }
        .frame(width: tileSize, height: tileHeight)
        .cornerRadius(3)
        .overlay(
            // Cavity shadow
            RoundedRectangle(cornerRadius: 3)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.7),
                            Color.black.opacity(0.3),
                            Color.black.opacity(0.15)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1.5
                )
        )
        .rotation3DEffect(
            .degrees(model.flipAngle),
            axis: (x: 1, y: 0, z: 0),
            perspective: 0.4
        )
    }
}
