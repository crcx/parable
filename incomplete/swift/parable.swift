/*
* Parable in Swift
*/


import Cocoa


/* Parable's Data Types */
enum FWStackTypes: Float {
    case NUMBER = 100
    case STRING = 200
    case CHARACTER = 300
    case FUNCTION = 400
    case FLAG = 500
}


/* Parable's Memory Model */
class FWMemory {
    var slices: Float[][]
    
    init() {
        slices = Float[][]()
        var i = 0
        var s = Float[]()
        while i < 2049 {
            s.append(0)
            i++
        }
        i = 0
        while i < 2049 {
            slices.append(s)
            i++
        }
    }
    
    /* Ensure that an address is valid */
    func checkBounds(offset: Float) -> Bool {
        if (offset >= 0 && offset <= 2048) {
            return true
        }
        else {
            return false
        }
    }
    
    /* Fetch a value stored in this slice */
    func fetch(slice: Float, offset: Float) -> Float {
        if checkBounds(offset) {
            return slices[Int(slice)][Int(offset)]
        }
        else {
            return 0
        }
    }
    
    /* Record a value into this slice */
    func store(value: Float, slice: Float, offset: Float) {
        if checkBounds(offset) {
            slices[Int(slice)][Int(offset)] = value
        }
    }
    
    func sliceToString(slice: Float) -> String {
        var i = 0
        var c: Float
        var s: String
        s = ""
        do {
            c = fetch(slice, offset: Float(i))
            s += NSString(format: "%c", Int(c))
            i++
            if c == 0 {
                i = 2049
            }
        } while i < 2048
        return s
    }
}



/* Data Stack */
struct FWStackElement {
    var value: Float
    var type: Float
}

class FWStack {
    var elements: FWStackElement[]
    
    init() {
        elements = FWStackElement[]()
    }
    
    /* Push a value to the stack */
    func push(value: Float, type: Float) -> Int {
        if elements.count > 1 {
            elements = elements.reverse()
        }
        elements.append(FWStackElement(value: value, type: type))
        if elements.count > 1 {
            elements = elements.reverse()
        }
        return elements.count
    }
    
    /* Return the last element pushed to the stack */
    func pop() -> (Float, Float) {
        let last: FWStackElement = elements.removeLast()
        return (last.value, last.type)
    }
    
    /* Return the top item on the stack */
    func tos() -> (Float, Float) {
        let tos = elements.removeLast()
        elements.append(tos)
        return (tos.value, tos.type)
    }
    
    /* Swap the top items on the stack */
    func swap() {
        var (tos, tosType) = pop()
        var (nos, nosType) = pop()
        push(tos, type: tosType)
        push(nos, type: nosType)
    }
    
    /* Drop second value on stack */
    func nip() {
        swap()
        pop()
    }
    
    /* Duplicate top value */
    func dup() {
        var (tos, tosType) = pop()
        push(tos, type: tosType)
        push(tos, type: tosType)
    }
    
    /* Change the type identifier for a stack element */
    func changeType(type: Float) {
        var (tos, tosType) = pop()
        push(tos, type: type)
    }
    
    func depth() -> (Float) {
        return Float(elements.count)
    }
}


/* Top Level */
var stack = FWStack()
var mem = FWMemory()


stack.push(100, type: FWStackTypes.NUMBER.toRaw())
stack.push(100, type: FWStackTypes.NUMBER.toRaw())
stack.push(100, type: FWStackTypes.NUMBER.toRaw())
stack.depth()

mem.store(97, slice: 0, offset: 0)
mem.store(98, slice: 0, offset: 1)
mem.store(99, slice: 0, offset: 2)
mem.store(100, slice: 0, offset: 3)
mem.store(101, slice: 0, offset: 4)
mem.store(102, slice: 0, offset: 5)
var v = mem.fetch(0, offset: 2)
let s = mem.sliceToString(0)
mem.fetch(0, offset: 0)
mem.fetch(0, offset: 1)
mem.fetch(0, offset: 2)
mem.fetch(0, offset: 3)
mem.fetch(0, offset: 4)
mem.fetch(0, offset: 5)
mem.fetch(0, offset: 6)

println(s)
