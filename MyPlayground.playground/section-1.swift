// Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

var thingy = ["sdgfdsg"]
thingy = ["nnnn"]

thingy

var newst = "/User/me/something/really/deep/resource.jhg"
newst.lastPathComponent
newst.uppercaseString
newst.componentsSeparatedByString("/")
var elements = newst.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: "/"))
for ele in elements {
    println(ele)
    println(ele)
}

elements.sort {$0 < $1}
println(elements)

elements.append("sdfdas")
elements.append("dddd")

elements += ["ddd", "eee"]
elements

