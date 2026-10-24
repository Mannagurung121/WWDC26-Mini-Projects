import SwiftUI

struct NowPlayingView: View {
    let songTitle: String
    let artist: String

    @Environment(\.dismiss) private var dismiss

    @State private var progress: Double = 0.35
    @State private var isPlaying = true
    @State private var isFavourite = false

    var body: some View {
        ZStack {
            // MARK: - Full Screen Animated Background

            ZStack {
                Color.black

                GeometryReader { geometry in
                    AnimatedGIFView(name: artworkName)
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height
                        )
                        .clipped()
                }

                // Keep text and controls readable over the GIF.
                LinearGradient(
                    stops: [
                        .init(color: .black.opacity(0.30), location: 0.0),
                        .init(color: .black.opacity(0.05), location: 0.25),
                        .init(color: .black.opacity(0.15), location: 0.45),
                        .init(color: .black.opacity(0.68), location: 0.72),
                        .init(color: .black.opacity(0.96), location: 1.0)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .ignoresSafeArea()

            // MARK: - Player Layout

            VStack(spacing: 0) {

                // Top navigation stays at the top.
                topBar

                // Push the player controls towards the bottom.
                Spacer(minLength: 30)

                // All playback information stays together.
                VStack(spacing: 0) {
                    songInformation

                    progressSection
                        .padding(.top, 22)

                    playbackControls
                        .padding(.top, 24)

                    bottomActions
                        .padding(.top, 26)
                }

            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 12)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .foregroundStyle(.white)
        .toolbar(.hidden, for: .navigationBar)
        .preferredColorScheme(.dark)
    }

    // MARK: - GIF Selection

    private var artworkName: String {
        switch songTitle {
        case "Blinding Lights":
            return "1"
        case "Starboy":
            return "2"
        case "Night Changes":
            return "4"
        case "Perfect":
            return "5"
        case "Rap God":
            return "6"
        default:
            return "1"
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.down")
                    .font(.system(size: 15, weight: .semibold))
                    .frame(width: 44, height: 44)
                    .glassEffect(.regular, in: .circle)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Close player")

            Spacer()

            VStack(spacing: 4) {
                Text("NOW PLAYING")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(2.5)

                Text("YOUR MUSIC")
                    .font(.system(size: 9, weight: .medium))
                    .tracking(1.5)
                    .foregroundStyle(.white.opacity(0.7))
            }

            Spacer()

            Menu {
                Button("Add to Library", systemImage: "plus") {
                    isFavourite = true
                }

                ShareLink(item: "\(songTitle) — \(artist)") {
                    Label(
                        "Share Song",
                        systemImage: "square.and.arrow.up"
                    )
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(width: 44, height: 44)
                    .glassEffect(.regular, in: .circle)
            }
        }
    }

    // MARK: - Song Information

    private var songInformation: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 7) {
                Text(songTitle)
                    .font(
                        .system(
                            size: 28,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .tracking(-0.5)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                Text(artist)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white.opacity(0.75))
                    .lineLimit(1)
            }

            Spacer(minLength: 4)

            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.55)) {
                    isFavourite.toggle()
                }
            } label: {
                Image(
                    systemName: isFavourite ? "heart.fill" : "heart"
                )
                .font(.system(size: 21))
                .foregroundStyle(isFavourite ? .pink : .white)
                .frame(width: 46, height: 46)
                .glassEffect(.regular, in: .circle)
                .scaleEffect(isFavourite ? 1.08 : 1)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Progress

    private var progressSection: some View {
        VStack(spacing: 7) {
            Slider(value: $progress, in: 0...1)
                .tint(.white)

            HStack {
                Text(timeString(progress * 228))

                Spacer()

                Text("-\(timeString((1 - progress) * 228))")
            }
            .font(.system(size: 11, weight: .medium))
            .foregroundStyle(.white.opacity(0.7))
        }
    }

    // MARK: - Playback Controls

    private var playbackControls: some View {
        HStack(spacing: 0) {
            Spacer()

            Button {
                progress = 0
            } label: {
                Image(systemName: "backward.end.fill")
                    .font(.system(size: 22))
                    .frame(width: 48, height: 52)
            }
            .buttonStyle(.plain)

            Spacer()

            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPlaying.toggle()
                }
            } label: {
                Image(
                    systemName: isPlaying ? "pause.fill" : "play.fill"
                )
                .font(.system(size: 24, weight: .bold))
                .contentTransition(.symbolEffect(.replace))
                .foregroundStyle(.black)
                .frame(width: 74, height: 74)
                .background(.white, in: .circle)
            }
            .buttonStyle(.plain)

            Spacer()

            Button {
                progress = 0
            } label: {
                Image(systemName: "forward.end.fill")
                    .font(.system(size: 22))
                    .frame(width: 48, height: 52)
            }
            .buttonStyle(.plain)

            Spacer()
        }
    }

    // MARK: - Liquid Glass Actions

    private var bottomActions: some View {
        HStack(spacing: 10) {
            glassAction("Lyrics", icon: "quote.opening")
            glassAction("Queue", icon: "list.bullet")
            glassAction("AirPlay", icon: "airplay.audio")
        }
    }

    private func glassAction(
        _ title: String,
        icon: String
    ) -> some View {
        Button {
            // Connect the feature later.
        } label: {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12))

                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .glassEffect(.regular, in: .capsule)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Time Formatting

    private func timeString(_ seconds: Double) -> String {
        let total = max(0, Int(seconds))

        return String(
            format: "%d:%02d",
            total / 60,
            total % 60
        )
    }
}

#Preview {
    NavigationStack {
        NowPlayingView(
            songTitle: "Blinding Lights",
            artist: "The Weeknd"
        )
    }
}
