import SwiftUI

// MARK: - Main ContentView
struct ContentView: View {
    @StateObject private var viewModel = GameViewModel() // Instancia o ViewModel do jogo

    var body: some View {
        VStack(spacing: 25) {
            // Título principal do app
            Text("⚡️ Pokémon TCG ML ⚡️")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 20)

            // Subtítulo explicativo
            Text("Escolha uma carta da sua mão")
                .font(.title2)
                .foregroundColor(.white.opacity(0.9))

            // Área com as cartas do jogador exibidas horizontalmente
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(viewModel.playerHand) { card in
                        Button(action: {
                            viewModel.choosePlayerCard(card) // Quando clicada, ativa a predição
                        }) {
                            CardView(card: card, isSelected: viewModel.selectedPlayerCard == card)
                        }
                        .buttonStyle(PlainButtonStyle()) // Remove estilo padrão de botão
                    }
                }
                .padding(.horizontal)
            }

            // Resultado da previsão do modelo (resposta do oponente)
            if let prediction = viewModel.predictedOpponentChoice {
                Text("🧠 Oponente deve jogar: \(prediction)")
                    .font(.title2.bold())
                    .foregroundColor(.green)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
            }

            // Botão de “Nova Partida” estilizado
            Button(action: viewModel.dealHands) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .font(.title2)
                    Text("Nova Partida")
                        .font(.headline)
                }
                .padding()
                .padding(.horizontal, 12)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.cyan, Color.purple]), startPoint: .leading, endPoint: .trailing)
                )
                .foregroundColor(.white)
                .cornerRadius(14)
                .shadow(color: .black.opacity(0.3), radius: 6, x: 2, y: 4)
            }
            .buttonStyle(PlainButtonStyle()) // Evita estilo padrão do macOS
            .onHover { hovering in
                NSCursor.pointingHand.set() // Muda o cursor ao passar por cima (macOS)
            }

        }
        .frame(minWidth: 950, minHeight: 600)
        .padding()
        .background(
            // Gradiente de fundo para a tela inteira
            LinearGradient(gradient: Gradient(colors: [.blue, .indigo]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
    }
}
