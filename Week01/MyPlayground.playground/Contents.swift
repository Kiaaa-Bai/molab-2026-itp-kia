import UIKit

let str = "⚫️⚪️"

func generateLine(_ n: Int) {
    var line = ""

    for _ in 0..<n {
        let idx = str.index(str.startIndex, offsetBy: Int.random(in: 0..<str.count))
        let char = str[idx]
        line += String(char)
    }

    print(line)
}

for _ in 0..<19 {
    generateLine(19)
}

