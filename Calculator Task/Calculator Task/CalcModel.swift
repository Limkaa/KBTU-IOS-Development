//
//  CalcModel.swift
//  Calculator Task
//
//  Created by Alim on 03.02.2021.
//

import Foundation
enum Operation{
    case unaryOperaion((Double) -> Double)
    case binaryOperation((Double, Double) -> Double)
    case clear
    case equals
}

struct CalculatorModel {
    var my_operation: Dictionary<String, Operation> =
        [
            "+": Operation.binaryOperation({$0 + $1}),
            "-": Operation.binaryOperation({$0 - $1}),
            "×": Operation.binaryOperation({$0 * $1}),
            "÷": Operation.binaryOperation({$0 / $1}),
            "%": Operation.unaryOperaion({$0 / 100}),
            "+/-": Operation.unaryOperaion({$0 * (-1)}),
            "AC": Operation.clear,
            "=": Operation.equals
        ]
    
    private var result: Double?
    
    mutating func setOperand(_ value: Double) {
        result = value
    }
    
    mutating func performOperation(_ operation: String) {
        switch my_operation[operation]! {
        case .unaryOperaion(let function):
            result = function(result!)
            
        case .binaryOperation(let function):
            if operationPressed{
                result = saving?.performOperationWith(secondOperand: result!)
            }
            saving = SaveFirstOperandAndOperation(firstOperand:result!, operation:function)
            operationPressed = true
            
        case .clear:
            result = 0
            saving?.firstOperand = 0
            operationPressed = false
            
        case .equals:
            if operationPressed {
                result = saving?.performOperationWith(secondOperand: result!)
            }
            operationPressed = false
        }
    }
    
    func getResult() -> Double? {
        return result
    }
    
    private var operationPressed: Bool = false
    private var saving: SaveFirstOperandAndOperation?
    struct SaveFirstOperandAndOperation {
        var firstOperand: Double
        var operation: (Double, Double) -> Double
        
        mutating func performOperationWith(secondOperand op2: Double) -> Double {
            return operation(firstOperand, op2)
        }
    }
}
