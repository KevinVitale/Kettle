public protocol MneumonicWordList {
    var words: [String] { get }
}

public enum WordList: MneumonicWordList {
    case chinese
    case english
    case japanese
    
    public var words: [String] {
        switch self {
        case .chinese  :return MneumonicWordList_Chinese
        case .english  :return MneumonicWordList_English
        case .japanese :return MneumonicWordList_Japanese
        }
    }
}
