import SwiftUI

struct MusicListView: View {
    @State private var searchText = ""

    private let songs: [(title: String, artist: String, artwork: String)] = [
        ("Midnight City", "M83", "10"),
        ("Starboy", "The Weeknd", "8"),
        ("Blinding Lights", "The Weeknd", "7"),
        ("One Direction", "One Direction", "9"),
        ("Perfect", "Ed Sheeran", "12"),
        ("Rap God", "Eminem", "11")
    ]

    private var filteredSongs: [(title: String, artist: String, artwork: String)] {
        if searchText.isEmpty {
            return songs
        }

        return songs.filter { song in
            song.title.localizedCaseInsensitiveContains(searchText) ||
            song.artist.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.07, blue: 0.11)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Your Library")
                        .font(.system(size: 34, weight: .bold))

                    TextField("Find a song or artist", text: $searchText)
                        .padding(14)
                        .glassEffect(.regular, in: .rect(cornerRadius: 16))

                    HStack {
                        Text("All Songs")
                            .font(.title2.bold())

                        Spacer()

                        Text("\(filteredSongs.count) songs")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.6))
                    }

                    ForEach(filteredSongs, id: \.artwork) { song in
                        NavigationLink {
                            NowPlayingView(
                                songTitle: song.title,
                                artist: song.artist
                            )
                        } label: {
                            HStack(spacing: 14) {
                                Image(song.artwork)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 62, height: 62)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 12)
                                    )

                                VStack(alignment: .leading, spacing: 5) {
                                    Text(song.title)
                                        .font(.headline)

                                    Text(song.artist)
                                        .font(.subheadline)
                                        .foregroundStyle(.white.opacity(0.6))
                                }

                                Spacer()

                                Image(systemName: "play.circle")
                                    .font(.title2)
                            }
                            .foregroundStyle(.white)
                            .padding(10)
                            .contentShape(
                                RoundedRectangle(cornerRadius: 18)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
        }
        .foregroundStyle(.white)
        .toolbar(.hidden, for: .tabBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        MusicListView()
    }
    .preferredColorScheme(.dark)
}
