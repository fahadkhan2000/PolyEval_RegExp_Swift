// Playground - noun: a place where people can play

import UIKit

import Foundation

class regExpPol
{
    class func evaluateTerm(singleTerm: String , x: Double) -> Double
    {
     return 0
    }
    
    class func determineTypeOfTermForSplit(singleTerm: String) -> [String]
    {
        var localString: String = singleTerm.stringByReplacingOccurrencesOfString("+", withString: "")
        var reformedSingleTerm: String
        
        if(localString.rangeOfString("^") != nil)
        {
            println("term with power\n")
            if(localString.hasPrefix("x") || localString.hasPrefix("-x") || localString.hasPrefix("+x"))
            {
                reformedSingleTerm = localString.stringByReplacingOccurrencesOfString("x", withString: "1x")
            }
            else
            {
                reformedSingleTerm = localString.stringByReplacingOccurrencesOfString("x", withString: "x")
            }
            
        }
        else
        {
            print("term without power\n")
            if(localString.rangeOfString("x") != nil)
            {
                reformedSingleTerm = localString.stringByReplacingOccurrencesOfString("x", withString: "x^1")
            }
            else
            {
                println("constant term without power\n")
                var appender = "x^0"
                reformedSingleTerm = localString + appender
            }
        }
        return (splitTermIntoCoeffAndPower(reformedSingleTerm))
    }
    
    class func splitTermIntoCoeffAndPower(reformedSingleTerm: String) -> [String]
    {
        var splittedCoeffAndPower: [String]
        var localString = reformedSingleTerm
        
        if (localString == "x^1" || localString == "-x^1" || localString == "+x^1")
        {
            localString = localString.stringByReplacingOccurrencesOfString("x", withString: "1")
            splittedCoeffAndPower = split(localString) {$0 == "^"}
            print(splittedCoeffAndPower)
        }
        else
        {
            localString = localString.stringByReplacingOccurrencesOfString("x", withString: "")
            splittedCoeffAndPower = split(localString) {$0 == "^"}
            print(splittedCoeffAndPower)
        }
        return splittedCoeffAndPower
    }
}


regExpPol.determineTypeOfTermForSplit("+1x^1")

regExpPol.splitTermIntoCoeffAndPower("-3x^3")

