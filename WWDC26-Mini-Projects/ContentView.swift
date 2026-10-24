import SwiftUI

struct ContentView: View {
    @State var music:Bool = false
    var body: some View {
        NavigationStack{
            ZStack {
                background
                
                VStack(spacing: 24) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 40))
                    
                    Text("Liquid Glass")
                        .font(.largeTitle.bold())
                    
                    Text("Simple. Clear. Beautiful.")
                        .foregroundStyle(.white.opacity(0.7))
                    
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "drop.fill")
                                .font(.title2)
                            
                            Spacer()
                            
                            Image(systemName: "arrow.up.right")
                        }
                        
                        Text("Explore something new")
                            .font(.title2.bold())
                        
                        Text("Playing with glass effects and SwiftUI.")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.75))
                        
                        Button {
                            music = true
                            print("Button tapped")
                        } label: {
                            Text("Get Started")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                        }
                        .buttonStyle(.glass)
                    }
                    .padding(24)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glassEffect(.regular, in: .rect(cornerRadius: 24))
                }
                .foregroundStyle(.white)
                .padding(24)
            }
            .navigationDestination(isPresented: $music){
                HomeView()
            }
        }
    }

    private var background: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.12, blue: 0.25),
                    Color(red: 0.24, green: 0.20, blue: 0.43),
                    Color(red: 0.08, green: 0.10, blue: 0.19)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(.cyan.opacity(0.3))
                .frame(width: 220, height: 220)
                .blur(radius: 70)
                .offset(x: -100, y: -200)

            Circle()
                .fill(.purple.opacity(0.35))
                .frame(width: 240, height: 240)
                .blur(radius: 80)
                .offset(x: 120, y: 200)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
