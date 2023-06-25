import Foundation

enum CombineTextService {
  static func combineText(text1: String, text2: String) -> String {
    var result: String = ""
    let value1 = text1.split(separator: "\n")
    let value2 = text2.split(separator: "\n")

    (0..<value1.count).forEach { index in
        result += value1[index] + "\n" + value2[index] + "\n" + "\n"
    }

//    UIPasteboard.general.string = result
    return result
  }
}
