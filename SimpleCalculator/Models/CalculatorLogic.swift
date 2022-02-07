//
//  CalculatorLogic.swift
//  SimpleCalculator
//
//  Created by Admin on 07.02.2022.
//

import Foundation

enum CalcActions: String {
    case plus = "+"
    case minus = "-"
    case divide = "÷"
    case multiply = "×"
    case percent = "%"
    case invert = "+/-"
    case equal = "="
    case clear = "C"
    case point = "."
    case none
}

struct CalculatorLogic {
    
    private var result: Double? = nil
    private var currentNumber: String? = nil
    private var lastAction = CalcActions.none
    
    private var typeAfterPoint = false
    private var endTyping = true {
        willSet {
            if newValue {
                typeAfterPoint = false
                if let number = currentNumber,
                   number.last == "."{
                    currentNumber = String(number.dropLast())
                }
            }
        }
    }
    
    mutating private func getTextToDisplay() -> String {
        var output = "0"
        if let result = result, lastAction != .none {
            if result == result.rounded(.down) {
                output = String(format: "%.0f", result)
            } else {
                output = String(result)
            }
            
        } else if let currentNumber = currentNumber {
            output = currentNumber
        }
        if lastAction == .equal {
            lastAction = .none
            return output
        } else if lastAction != .none {
            output += lastAction.rawValue
            if let currentNumber = currentNumber {
                output += currentNumber
            }
        }
        return output
    }
    
    mutating func calcButtonPressed(value: String?) -> String {
        
        guard let value = value else { fatalError() }
        
        switch value {
        case CalcActions.invert.rawValue:
            if let number = currentNumber {
                if lastAction == .plus {
                    lastAction = .minus
                } else if lastAction == .minus {
                    lastAction = .plus
                } else {
                    if number.first != "-" {
                        currentNumber = "-" + number
                    } else {
                        currentNumber!.removeFirst()
                    }
                }
            }
        case CalcActions.percent.rawValue:
            endTyping = true
            
            if let number = currentNumber,
               let safeNumber = Double(number) {
                if let result = result {
                    currentNumber = String(result * safeNumber / 100)
                } else {
                    currentNumber = String(safeNumber / 100)
                }
            }
        case CalcActions.clear.rawValue:
            endTyping = true
            result = nil
            currentNumber = nil
            lastAction = .none
        case CalcActions.point.rawValue:
            if !typeAfterPoint {
                typeAfterPoint = true
                if let number = currentNumber {
                    currentNumber = number + "."
                } else {
                    currentNumber = "0."
                }
                endTyping = false
            }
        default:
            endTyping = true
            if result == nil { result = 0.0 }
            if let safeCurrent = currentNumber,
               let safeNumber = Double(safeCurrent),
               let safeResult = result {
                switch lastAction {
                case .plus:
                    result = safeResult + safeNumber
                case .minus:
                    result = safeResult - safeNumber
                case .multiply:
                    result = safeResult * safeNumber
                case .divide:
                    result = safeResult / safeNumber
                case .none:
                    result = safeNumber
                default:
                    print("Nothing to do here")
                }
            }
            lastAction = CalcActions(rawValue: value) ?? .none
            currentNumber = nil
        }
        return getTextToDisplay()
    }
    
    mutating func numButtonPressed(value: String?) -> String {
        
        guard let value = value else { fatalError() }
        
        if endTyping || currentNumber == "0" {
            currentNumber = value
            endTyping = false
        } else if let number = currentNumber {
            currentNumber = number + value
        }
        return getTextToDisplay()
    }
}
