import SwiftUI
import CoreML

// MARK: - Modelo de Dados da Carta
// Define uma carta Pokémon com os campos principais
struct Card: Identifiable, Codable, Equatable {
    var id = UUID() // Identificador único para uso no SwiftUI
    let name: String
    let element: String
    let type: String
    let subtype: String
    let weakness: String
}

// MARK: - ViewModel do Jogo
// Responsável por controlar o estado do jogo, carregar cartas, lidar com o modelo ML, etc.
class GameViewModel: ObservableObject {
    @Published var playerHand: [Card] = [] // Mão do jogador
    @Published var opponentHand: [Card] = [] // Mão do oponente (elementos disponíveis)
    @Published var selectedPlayerCard: Card? // Carta selecionada pelo jogador
    @Published var predictedOpponentChoice: String? // Escolha prevista pelo modelo

    private var allCards: [Card] = [] // Todas as cartas carregadas do CSV
    private var model: ModeloPokemonNew? = nil // Modelo CoreML carregado

    init() {
        loadCards()  // Carrega as cartas do arquivo CSV
        loadModel()  // Carrega o modelo CoreML
        dealHands()  // Gera cartas aleatórias para o jogador
    }

    // Carrega o modelo .mlmodel
    private func loadModel() {
        do {
            model = try ModeloPokemonNew(configuration: MLModelConfiguration())
        } catch {
            print("Erro ao carregar modelo: \(error)")
        }
    }

    // Lê o arquivo CSV e carrega as cartas em memória
    private func loadCards() {
        guard let url = Bundle.main.url(forResource: "cards", withExtension: "csv") else { return }
        do {
            let data = try String(contentsOf: url)
            let rows = data.components(separatedBy: "\n").dropFirst() // Ignora o cabeçalho
            for row in rows where !row.isEmpty {
                let columns = row.components(separatedBy: ",")
                if columns.count >= 5 {
                    let card = Card(name: columns[0], element: columns[1], type: columns[2], subtype: columns[3], weakness: columns[4])
                    allCards.append(card)
                }
            }
        } catch {
            print("Erro ao carregar cartas: \(error)")
        }
    }

    // Distribui cartas aleatórias para o jogador
    func dealHands() {
        let uniqueElements = Array(Set(allCards.map { $0.element })).shuffled()
        let playerElements = uniqueElements.prefix(5)
        let opponentElements = uniqueElements.dropFirst(5).prefix(5)

        // Monta as mãos com cartas que têm os elementos selecionados
        playerHand = playerElements.compactMap { element in
            allCards.first(where: { $0.element == element })
        }

        opponentHand = opponentElements.compactMap { element in
            allCards.first(where: { $0.element == element })
        }

        selectedPlayerCard = nil
        predictedOpponentChoice = nil
    }

    // Quando o jogador escolhe uma carta
    func choosePlayerCard(_ card: Card) {
        selectedPlayerCard = card
        predictOpponentChoice()
    }

    // Envia os dados da carta escolhida para o modelo e obtém a previsão
    private func predictOpponentChoice() {
        guard let selected = selectedPlayerCard, let model = model else { return }

        // Cria o input para o modelo CoreML com os dados da carta do jogador
        let input = ModeloPokemonNewInput(
            input_element: selected.element,
            input_weakness: selected.weakness
        )

        // Realiza a previsão usando o modelo ML
        do {
            let prediction = try model.prediction(input: input)
            predictedOpponentChoice = prediction.ideal_choice
        } catch {
            print("Erro na predição: \(error)")
        }
    }
}

// MARK: - View de uma Carta (UI)
struct CardView: View {
    let card: Card
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 10) {
            Text(card.name)
                .font(.headline)
                .foregroundColor(.white)
            Text("Elemento: \(card.element)")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.9))
            Text("Fraqueza: \(card.weakness)")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding()
        .frame(width: 160, height: 130)
        .background(isSelected ? Color.orange : Color.blue.opacity(0.85))
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.6), lineWidth: 2))
        .shadow(color: .black.opacity(0.25), radius: 6, x: 4, y: 4)
        .animation(.easeInOut(duration: 0.3), value: isSelected)
    }
}

// MARK: - App Principal (macOS)
@main
struct TCGPocketMLMacApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
