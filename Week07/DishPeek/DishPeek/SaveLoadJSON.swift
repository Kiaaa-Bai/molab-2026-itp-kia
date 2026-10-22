import Foundation

func saveJSON<T: Encodable>(fileName: String, val: T) throws {
    let filePath = try documentPath(fileName: fileName);

    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted

    let jsonData = try encoder.encode(val)
    let str = String(data: jsonData, encoding: .utf8)!

    try str.write(to: filePath, atomically: true, encoding: .utf8)
}

func loadJSON<T :Decodable>(_ type: T.Type, fileName: String) throws -> T {
    let filePath = try documentPath(fileName: fileName);
    let filePathExists = FileManager.default.fileExists(atPath: filePath.path)
    if !filePathExists {
        throw FileError.missing;
    }

    let jsonData = try String(contentsOfFile: filePath.path, encoding: .utf8).data(using: .utf8)

    let decoder = JSONDecoder()
    return try decoder.decode(type, from: jsonData!)
}

enum FileError: Error {
    case missing
}

func documentPath(fileName: String, create: Bool = false) throws -> URL {
    let directory = try FileManager.default.url(
        for: .documentDirectory,
        in: .userDomainMask,
        appropriateFor: nil,
        create: create)
    return directory.appendingPathComponent(fileName);
}
