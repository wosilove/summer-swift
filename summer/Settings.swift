import UIKit
import Atributika

class Settings {
    struct Url {
        static let baseURL = URL(string: "https://www.regent-college.edu/summer")!
    }

    struct Font {
        static let headerFont = UIFont(name: "Futura-Bol", size: 18)!
        static let subHeaderFont = UIFont(name: "Futura-Bol", size: 16)!
        static let sectionHeaderFont = UIFont(name: "Futura-Lig", size: 18)!
        static let obliqueFont = UIFont(name: "Futura-LigObl", size: 16)!
    }
    
    struct Style {
        static let h1 = Atributika.Style("h1").font(Settings.Font.headerFont)
        static let h2 = Atributika.Style("h2").font(Settings.Font.headerFont)
        static let h3 = Atributika.Style("h3").font(Settings.Font.headerFont)
        static let h4 = Atributika.Style("h4").font(Settings.Font.sectionHeaderFont)
        static let em = Atributika.Style("em").font(.italicSystemFont(ofSize: 16))
        static let strong = Atributika.Style("strong").font(.boldSystemFont(ofSize: 16))
        static let body = Atributika.Style.font(.systemFont(ofSize: 16))

        static let transformers: [TagTransformer] = [
            TagTransformer(tagName: "h2", tagType: .end, replaceValue: "\n"),
            TagTransformer(tagName: "h3", tagType: .end, replaceValue: "\n"),
            TagTransformer(tagName: "h4", tagType: .end, replaceValue: "\n"),
            TagTransformer(tagName: "p", tagType: .end, replaceValue: "\n"),
            TagTransformer(tagName: "ul", tagType: .start, replaceValue: "\n"),
            TagTransformer(tagName: "li", tagType: .start, replaceValue: "- "),
            TagTransformer(tagName: "li", tagType: .end, replaceValue: "\n")
        ]
    }
    
    struct Color {
        static let red = "fa3737".hexColor
        static let orange = "ff690e".hexColor
        static let blue = "00b3d4".hexColor
        static let purple = "64006b".hexColor
    }
    
    static var currentDate: Date {
        return Date()
    }
}
