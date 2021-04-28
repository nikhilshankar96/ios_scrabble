import Foundation

class Words{
    
    static let shared = Words()
    var words = [String]();

    private init() {
        // parse the txt file here to words
//        Words.shared.words
        self.words = Words.getWords()
    }
    
    static func checkIfWord(_ word: String) -> Bool {
        let w = word.lowercased()
        let b = shared.words.contains(w)
        print("checking: ",w,b)
        return b
    }
    
    static func getWords() -> [String]{
        let path = Bundle.main.path(forResource: "words_alpha", ofType: "txt")!
        var words = [String]()
        do {
//            let path: String = "words_alpha.txt"
            print("Getting words from: ",path)
            let file = try String(contentsOfFile: path)
            let text: [String] = file.components(separatedBy: "\n")
            print(text.count)
            words = text.map({ $0.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)})
        } catch let error {
            Swift.print("Fatal Error: \(error.localizedDescription)")
        }
        return words
    }
}
