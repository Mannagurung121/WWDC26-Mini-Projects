import SwiftUI

struct HomeView: View {
    @State private var selectedSong = 0
    @State private var showPlayer = false
    @State private var appeared = false

    private let songs: [(title: String, artist: String, artwork: String)] = [
        ("Blinding Lights", "The Weeknd", "7"),
        ("Starboy", "The Weeknd", "8"),
        ("One Direction", "One Direction", "9"),
        ("Midnight City", "M83", "10"),
        ("Rap God", "Eminem", "11"),
        ("Perfect", "Ed Sheeran", "12")
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                background

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 30) {
                        header

                        featuredAlbum

                        librarySection

                        recentlyPlayed
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 18)
                    .padding(.bottom, 35)
                }
            }
            .foregroundStyle(.white)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(isPresented: $showPlayer) {
                NowPlayingView(
                    songTitle: songs[selectedSong].title,
                    artist: songs[selectedSong].artist
                )
            }
            .onAppear {
                withAnimation(
                    .spring(response: 0.7, dampingFraction: 0.85)
                ) {
                    appeared = true
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 8) {
                Text("YOUR MUSIC")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(2.5)
                    .foregroundStyle(.white.opacity(0.55))

                Text("Listen again.")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .tracking(-1)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
            }

            Spacer(minLength: 12)

            WaveformView()
                .frame(width: 48, height: 48)
                .glassEffect(.regular, in: .circle)
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 15)
    }

    // MARK: - Featured Album

    private var featuredAlbum: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("FEATURED FOR YOU")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(2)

                Spacer()

                Image(systemName: "sparkle")
            }
            .foregroundStyle(.white.opacity(0.6))

            Button {
                openPlayer(index: 0)
            } label: {
                GeometryReader { geometry in
                    ZStack(alignment: .bottomLeading) {
                        // Keep the original featured GIF unchanged.
                        AnimatedGIFView(name: "1")
                            .frame(
                                width: geometry.size.width,
                                height: geometry.size.height
                            )
                            .clipped()

                        LinearGradient(
                            stops: [
                                .init(color: .clear, location: 0.25),
                                .init(
                                    color: .black.opacity(0.35),
                                    location: 0.55
                                ),
                                .init(
                                    color: .black.opacity(0.88),
                                    location: 1
                                )
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )

                        VStack(alignment: .leading, spacing: 9) {
                            Text("NOW IN YOUR ROTATION")
                                .font(.system(size: 9, weight: .bold))
                                .tracking(1.8)
                                .foregroundStyle(.white.opacity(0.75))

                            Text("Blinding Lights")
                                .font(
                                    .system(
                                        size: 29,
                                        weight: .bold,
                                        design: .rounded
                                    )
                                )
                                .tracking(-0.7)
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)

                            HStack {
                                Text("The Weeknd")
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.75))

                                Spacer()

                                Image(systemName: "play.fill")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(.black)
                                    .frame(width: 48, height: 48)
                                    .background(.white, in: .circle)
                            }
                        }
                        .padding(20)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .overlay {
                        RoundedRectangle(cornerRadius: 25)
                            .strokeBorder(.white.opacity(0.12), lineWidth: 1)
                    }
                }
                .frame(height: 340)
            }
            .buttonStyle(.plain)
            .shadow(color: .black.opacity(0.25), radius: 18, y: 10)
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
    }

    // MARK: - Library

    private var librarySection: some View {
        NavigationLink {
            MusicListView()
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "square.stack.3d.up")
                    .font(.title3)
                    .frame(width: 42, height: 42)
                    .glassEffect(.regular, in: .circle)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Library")
                        .font(.headline)

                    Text("\(songs.count) songs · Your collection")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.55))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white.opacity(0.55))
            }
            .padding(14)
            .background(
                .white.opacity(0.045),
                in: RoundedRectangle(cornerRadius: 22)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 22)
                    .strokeBorder(.white.opacity(0.07), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 24)
    }

    // MARK: - Recently Played

    private var recentlyPlayed: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Recently played")
                        .font(
                            .system(
                                size: 23,
                                weight: .bold,
                                design: .rounded
                            )
                        )

                    Text("Your recent favourites")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.5))
                }

                Spacer()

                NavigationLink {
                    MusicListView()
                } label: {
                    Image(systemName: "arrow.up.right")
                        .font(.subheadline.weight(.semibold))
                        .frame(width: 42, height: 42)
                        .glassEffect(.regular, in: .circle)
                }
                .buttonStyle(.plain)
            }

            VStack(spacing: 18) {
                ForEach(songs.indices, id: \.self) { index in
                    Button {
                        openPlayer(index: index)
                    } label: {
                        HStack(spacing: 14) {
                            // Numbered image for each song.
                            Image(songs[index].artwork)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 62, height: 62)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 14)
                                )

                            VStack(alignment: .leading, spacing: 6) {
                                Text(songs[index].title)
                                    .font(
                                        .system(size: 15, weight: .semibold)
                                    )
                                    .foregroundStyle(.white)
                                    .lineLimit(1)

                                Text(songs[index].artist)
                                    .font(.system(size: 13))
                                    .foregroundStyle(.white.opacity(0.55))
                                    .lineLimit(1)
                            }

                            Spacer(minLength: 8)

                            Image(systemName: "play")
                                .font(
                                    .system(size: 13, weight: .semibold)
                                )
                                .foregroundStyle(.white.opacity(0.85))
                                .frame(width: 38, height: 38)
                                .glassEffect(.regular, in: .circle)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 28)
    }

    // MARK: - Background

    private var background: some View {
        ZStack {
            Color(red: 0.035, green: 0.04, blue: 0.065)

            RadialGradient(
                colors: [
                    Color(red: 0.25, green: 0.17, blue: 0.34)
                        .opacity(0.65),
                    .clear
                ],
                center: .topTrailing,
                startRadius: 0,
                endRadius: 390
            )

            LinearGradient(
                colors: [
                    .clear,
                    Color(red: 0.08, green: 0.11, blue: 0.17)
                        .opacity(0.6)
                ],
                startPoint: .center,
                endPoint: .bottom
            )
        }
        .ignoresSafeArea()
    }

    // MARK: - Actions

    private func openPlayer(index: Int) {
        selectedSong = index

        withAnimation(
            .spring(response: 0.4, dampingFraction: 0.85)
        ) {
            showPlayer = true
        }
    }
}

// MARK: - Waveform

private struct WaveformView: View {
    @State private var isAnimating = false

    private let heights: [CGFloat] = [12, 22, 16, 27, 13]

    var body: some View {
        HStack(spacing: 3) {
            ForEach(heights.indices, id: \.self) { index in
                Capsule()
                    .fill(.white)
                    .frame(
                        width: 3,
                        height: isAnimating
                            ? heights[index]
                            : heights[index] * 0.5
                    )
            }
        }
        .frame(width: 48, height: 48)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 0.65)
                    .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
        }
        .accessibilityLabel("Animated music waveform")
    }
}

#Preview {
    HomeView()
}
