import SwiftUI

let defaultCover = "https://i.scdn.co/image/ab67616d0000b273dab605f154ba629b47fc24cd"

struct AlbumView: View {
    @State var typedUrl: String = defaultCover
    @AppStorage("coverUrl") var urlStr: String = defaultCover

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: urlStr)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                } else {
                    Image(systemName: "music.note")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .padding(100)
                }
            }
            Form {
                TextField("Album cover url", text: $typedUrl)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                Button("Show") {
                    urlStr = typedUrl
                }
            }
        }
    }
}

#Preview {
    AlbumView()
}
