import SwiftUI

struct StageView: View {
    @Environment(Mixer.self) var mixer
    @State var finger = CGPoint(x: 200, y: 200)

    var body: some View {
        let volumes = mixer.volumes
        let point = finger
        Canvas { context, size in
            for i in 0..<5 {
                let d = 20 + 100 * volumes[i]
                let box = CGRect(origin: CGPoint(x: xs[i] - d / 2, y: ys[i] - d / 2), size: CGSize(width: d, height: d))
                context.fill(Path(ellipseIn: box), with: .color(colors[i]))
                context.draw(Text(emojis[i]).font(.system(size: 32)), at: CGPoint(x: xs[i], y: ys[i]))
            }
            let center = CGRect(origin: CGPoint(x: point.x - 25, y: point.y - 25), size: CGSize(width: 50, height: 50))
            context.fill(Path(ellipseIn: center), with: .color(.white))
            context.stroke(Path(ellipseIn: center), with: .color(.gray), lineWidth: 2)
            context.draw(Text("🎶").font(.system(size: 32)), at: point)
        }
        .frame(width: 400, height: 400)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    finger = value.location
                    for i in 0..<5 {
                        let dx = value.location.x - xs[i]
                        let dy = value.location.y - ys[i]
                        let distance = sqrt(dx * dx + dy * dy)
                        var volume = 1 - distance / 200
                        if volume < 0.1 {
                            volume = 0.1
                        }
                        mixer.volumes[i] = volume
                    }
                    mixer.apply()
                }
        )
    }
}

#Preview {
    StageView()
        .environment(Mixer())
}
