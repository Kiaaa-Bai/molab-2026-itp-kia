import SwiftUI

let hcell = 8.0
let hearts = ["❤️", "🧡", "💛", "💚", "💙", "💜", "🖤", "🤍"]

struct HeartsView: View {
    var body: some View {
        Canvas { context, size in
            let cell = size.width / hcell
            var x = 0.0
            var y = 0.0
            while y < size.height {
                let heart = Text(hearts.randomElement()!).font(.system(size: cell * 0.8))
                context.draw(heart, at: CGPoint(x: x + cell / 2, y: y + cell / 2))
                x += cell
                if x >= size.width {
                    x = 0
                    y += cell
                }
            }
        }
        .padding()
    }
}

#Preview {
    HeartsView()
}
