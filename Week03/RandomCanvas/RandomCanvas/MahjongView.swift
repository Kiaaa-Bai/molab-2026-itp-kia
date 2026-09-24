import SwiftUI

let mcell = 8.0
let tiles = ["🀀", "🀁", "🀂", "🀃", "🀄︎", "🀅", "🀆",
             "🀇", "🀈", "🀉", "🀊", "🀋", "🀌", "🀍", "🀎", "🀏",
             "🀐", "🀑", "🀒", "🀓", "🀔", "🀕", "🀖", "🀗", "🀘",
             "🀙", "🀚", "🀛", "🀜", "🀝", "🀞", "🀟", "🀠", "🀡"]

struct MahjongView: View {
    var body: some View {
        Canvas { context, size in
            let cell = size.width / mcell
            var x = 0.0
            var y = 0.0
            while y < size.height {
                let tile = Text(tiles.randomElement()!).font(.system(size: cell * 0.8))
                context.draw(tile, at: CGPoint(x: x + cell / 2, y: y + cell / 2))
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
    MahjongView()
}
