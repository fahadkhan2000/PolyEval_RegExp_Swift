// Playground - noun: a place where people can play

import UIKit

import Foundation

class regExpPol
{
    class func createTermsByRegExp(poly: String) -> [String]
    {
        var localPoly = poly.stringByReplacingOccurrencesOfString(" " , withString: "")
        var regexp = "([+-]?\\d*(?:\\.?\\d*))x(\\^(\\d*))?|([+-]\\d*(?:\\.?\\d*))"
        var monomialsArray:[String] = []
        
        if ((localPoly.rangeOfString(regexp, options: .RegularExpressionSearch)) != nil)
        {
            println("matched..........")
            monomialsArray = findAllStringsInRegexp(regexp, poly: poly)
            
        }
        println(monomialsArray)
        return (monomialsArray)
    }
    
    class func findAllStringsInRegexp(regex: String, poly:String) -> [String]
    {
        var regex = NSRegularExpression(pattern: regex, options: nil, error: nil)
        var polyNSString = poly as NSString
        var matches = regex.matchesInString(poly, options: nil, range: NSMakeRange(0, polyNSString.length)) as [NSTextCheckingResult]
        return (map(matches) {polyNSString.substringWithRange($0.range)})
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
        var splittedCoeffAndPower:[String]
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
    
    class func convertTermFromStringToDouble(splittedCoeffAndPower:[String]) -> (Double, Double)
    {
        var localArray:[String] = splittedCoeffAndPower
        var coeffAndExpDoubleArray:[Double] = []
        
        for(index, value) in enumerate(localArray)
        {
            coeffAndExpDoubleArray.append((localArray[index] as NSString).doubleValue)
        }
        println(coeffAndExpDoubleArray)
        return(coeffAndExpDoubleArray[0], coeffAndExpDoubleArray[1])
    }
    
    class func evaluateTerm(singleTerm: String , val: Double) -> Double
    {
        var splittedCoeffAndPower = determineTypeOfTermForSplit(singleTerm)
        var (coeff, exp) = convertTermFromStringToDouble(splittedCoeffAndPower)
        return (coeff * (pow(val, exp)))
    }
    
    class func calculateFinalResult(monomialsArray:[String] , val:Double) -> Double
    {
        var finalRes:Double = 0.0
        
        for(index, value) in enumerate(monomialsArray)
        {
            finalRes = finalRes + evaluateTerm(value , val: val)
        }
        return finalRes
    }
    
    class func run()
    {
        var poly = "100x^2 + x^3"
        var val = 3.0
        var monomialsArray = createTermsByRegExp(poly)
        //calculateFinalResult(monomialsArray, val: val)
    }

}


regExpPol.determineTypeOfTermForSplit("+1x^1")

regExpPol.splitTermIntoCoeffAndPower("-3x^3")

regExpPol.convertTermFromStringToDouble(["-1.1", "-1.1"])

regExpPol.evaluateTerm("+2x^11", val: 2)

regExpPol.run()

