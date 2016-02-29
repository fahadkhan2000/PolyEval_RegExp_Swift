import UIKit
import Foundation
class regExpPol {
    class func createTermsByRegExp(poly: String) -> [String] {
        var localPoly = poly.stringByReplacingOccurrencesOfString(" " , withString: "")
        var regexp = "([+-]?\\d*(?:\\.?\\d+))?x(\\^(\\d*))?|([+-]?\\d*(?:\\.?\\d+))"
        var monomialsArray:[String] = []
        
        if ((localPoly.rangeOfString(regexp, options: .RegularExpressionSearch)) != nil) {
            monomialsArray = findAllStringsInRegexp(regexp, poly: localPoly)
        }
        return (monomialsArray)
    }
    
    class func findAllStringsInRegexp(regex: String, poly:String) -> [String] {
        if(poly.rangeOfString("-x") != nil) {
            return ["-x"]
        }
        var regex = NSRegularExpression(pattern: regex, options: nil, error: nil)
        var polyNSString = poly as NSString
        var matches = regex.matchesInString(poly, options: nil, range: NSMakeRange(0, polyNSString.length)) as [NSTextCheckingResult]
        return (map(matches) {polyNSString.substringWithRange($0.range)})
    }
    
    class func determineTypeOfTermForSplit(singleTerm: String) -> [String] {
        var localString: String = singleTerm.stringByReplacingOccurrencesOfString("+", withString: "")
        var reformedSingleTerm: String
        
        if(localString.rangeOfString("^") != nil) {
            if(localString.hasPrefix("x") || localString.hasPrefix("-x") || localString.hasPrefix("+x"))
            {
                reformedSingleTerm = localString.stringByReplacingOccurrencesOfString("x", withString: "1x")
            }
            else {
                reformedSingleTerm = localString.stringByReplacingOccurrencesOfString("x", withString: "x")
            }
            
        }
        else {
            if(localString.rangeOfString("x") != nil) {
                reformedSingleTerm = localString.stringByReplacingOccurrencesOfString("x", withString: "x^1")
            }
            else {
                var appender = "x^0"
                reformedSingleTerm = localString + appender
            }
        }
        return (splitTermIntoCoeffAndPower(reformedSingleTerm))
    }
    
    class func splitTermIntoCoeffAndPower(reformedSingleTerm: String) -> [String] {
        var splittedCoeffAndPower:[String]
        var localString = reformedSingleTerm
        
        if (localString == "x^1" || localString == "-x^1" || localString == "+x^1") {
            localString = localString.stringByReplacingOccurrencesOfString("x", withString: "1")
            splittedCoeffAndPower = split(localString) {$0 == "^"}
        }
        else {
            localString = localString.stringByReplacingOccurrencesOfString("x", withString: "")
            splittedCoeffAndPower = split(localString) {$0 == "^"}
        }
        return splittedCoeffAndPower
    }
    
    class func convertTermFromStringToDouble(splittedCoeffAndPower:[String]) -> (Double, Double) {
        var localArray:[String] = splittedCoeffAndPower
        var coeffAndExpDoubleArray:[Double] = []
        
        for(index, value) in enumerate(localArray) {
            coeffAndExpDoubleArray.append((localArray[index] as NSString).doubleValue)
        }
        return(coeffAndExpDoubleArray[0], coeffAndExpDoubleArray[1])
    }
    
    class func evaluateTerm(singleTerm: String , val: Double) -> Double {
        var splittedCoeffAndPower = determineTypeOfTermForSplit(singleTerm)
        var (coeff, exp) = convertTermFromStringToDouble(splittedCoeffAndPower)
        return (coeff * (pow(val, exp)))
    }
    
    class func calculateFinalResult(monomialsArray:[String] , val:Double) -> Double {
        var finalRes:Double = 0.0
        
        for(index, value) in enumerate(monomialsArray) {
            finalRes = finalRes + evaluateTerm(value , val: val)
        }
        return finalRes
    }
    
    class func run(poly: String, val:Double) -> Double {
        var monomialsArray = createTermsByRegExp(poly)
        return calculateFinalResult(monomialsArray, val: val)
    }
}

/*
Test Case
*/
func testCase() {
    var testVal = 2.0
    var res:Double = 0.0
    var polyArray: [String] = ["-x",
                               "x^1",
                               "x^11",
                               "+x^12",
                               "-2x^10",
                               "+100",
                               "-100.001",
                               "0.2x^3 + 0.2x + 0.2",
                               "-2x^3-2x-2",
                               "+1x^2 + 3x^3 + 5x^5 + 7x^7 + 1.17",
                               "1x^2+3x^3+5x^5+7x^7+1.17+0",
                               "- 40x^4 + 30x^3 + x^5 -20x^2 +10x+81.3"]
    
    var results: [Double] = [-2.0,
                              2.0,
                              2048.0,
                              4096.0,
                             -2048.0,
                              100.0,
                             -100.001,
                              2.2,
                             -22.0,
                              1085.17,
                              1085.17,
                             -346.7]
    
    for (index, value) in  enumerate(polyArray) {
        res = regExpPol.run(value, val: testVal)
        
        if (results[index] != res) {
            println("\nERROR: VALUES NOT MATCHED\n")
            return
        }
    }
    println("\nTest passed : Everything is OK\n")
}

testCase()

