import SwiftUI

struct MixerView: View {
    @Bindable var mixer: Mixer

    var body: some View {
        VStack {
            ForEach(0..<5) { i in
                HStack {
                    Text(emojis[i])
                        .font(.system(size: 32))
                    Slider(value: $mixer.volumes[i], in: 0.1...1.0)
                }
            }
        }
        .padding()
        .onChange(of: mixer.volumes) {
            mixer.apply()
        }
    }
}

#Preview {
    MixerView(mixer: Mixer())
}
