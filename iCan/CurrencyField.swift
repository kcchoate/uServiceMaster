//
//  CurrencyField.swift
//  iCan
//
//  Created by Kendrick Choate on 9/29/16.
//  Copyright © 2016 Kendrick Choate. All rights reserved.
//

import UIKit

class CurrencyField: UITextField {
    var string: String { return text ?? "" }
    var percentage: Double { return Double(integer) / 100 }
    var integer: Int    { return Int(numbers) ?? 0 }
    var currency: String { return Formatter.currency.string(from: NSNumber(value: percentage)) ?? "" }
    var numbers: String { return string.components(separatedBy: CharacterSet(charactersIn: "0123456789").inverted).joined() }
    override func awakeFromNib() {
        super.awakeFromNib()
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        keyboardType = .numberPad
        textAlignment = .right
        text = currency
    }
    func editingChanged() { text = currency }
}

extension NumberFormatter {
    convenience init(numberStyle: NumberFormatter.Style) {
        self.init()
        self.numberStyle = numberStyle
    }
}

struct Formatter {
    static let currency = NumberFormatter(numberStyle: .currency)
}
