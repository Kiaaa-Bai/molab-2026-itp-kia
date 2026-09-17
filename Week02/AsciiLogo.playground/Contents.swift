import Foundation

func load(_ file: String) -> String {
  let path = Bundle.main.path(forResource: file, ofType: nil)
  let str = try? String(contentsOfFile: path!, encoding: .utf8)
  return str!
}

func lines(_ text: String) -> [String] {
  return text.split(separator: "\n").map { String($0) }
}

let logo = lines(load("logo.txt"))

for index in 0..<logo.count {
  print(logo[index])
}
