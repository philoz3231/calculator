//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 준호 김 on 2016. 7. 19..
//  Copyright © 2016년 JunhoKim. All rights reserved.
//

enum Optional<T> {
    case None
    case Some(T)
}

import Foundation

class CalculatorBrain {
    private var accumulator = 0.0
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Clear
        case Equals
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "±" : Operation.UnaryOperation({-$0}),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "×" : Operation.BinaryOperation({ $0 * $1}),
        "÷" : Operation.BinaryOperation({ $0 / $1}),
        "+" : Operation.BinaryOperation({ $0 + $1}),
        "−" : Operation.BinaryOperation({ $0 - $1}),
        //"%" : Operation.BinaryOperation({ $0 % $1}),
        "10^x" : Operation.UnaryOperation({ (op: Double) -> Double in
            var count = Int(op)
            var sum = 1
            while(count > 0){
                sum *= 10
                count -= 1
            }
            return Double(sum)
        }),
        "x^2" : Operation.UnaryOperation({ $0 * $0}),
        "log" : Operation.UnaryOperation({ log10($0)}),
        "x!" : Operation.UnaryOperation({ (op: Double) -> Double in
            var count = Int(op)
            var number = count
            var sum = 1
            while(count > 1){
                sum *= number
                number -= 1
                count -= 1
            }
            return Double(sum)
        }),
        "c" : Operation.Clear,
        "=" : Operation.Equals
    ]
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var description = " "
    var isPartialResult = false
    
    func setOperand(operand: Double) {
        accumulator = operand
        description = description + String(accumulator)
        print(description)
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
                description = description + symbol
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
                let result = symbol.rangeOfString("x")
                if result != nil {
                    description = description + symbol.stringByReplacingOccurrencesOfString("x", withString:" ")
                    //edit in case of log or x behind the symbol
                } else{
                    description = description + symbol
                }
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                description = description + symbol
                isPartialResult = true
                print(description)
            case .Clear:
                accumulator = 0.0
                pending = nil
                description = " "
                isPartialResult = false
            case .Equals:
                executePendingBinaryOperation()
                description = " "
                isPartialResult = false
                print(description)
                
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        if pending != nil{
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    
    var result: Double {
        get{
            return accumulator
        }
    }
}