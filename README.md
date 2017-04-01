# RuntimeKit

[![Build Status](https://travis-ci.org/lukaskollmer/RuntimeKit.svg?branch=master)](https://travis-ci.org/lukaskollmer/RuntimeKit)
![](https://img.shields.io/badge/Swift-3.1-orange.svg)
![CocoaPods](https://img.shields.io/cocoapods/v/RuntimeKit.svg)
![CocoaPods](https://img.shields.io/cocoapods/l/RuntimeKit.svg)

RuntimeKit is a Swift library for accessing the Objective-C runtime.
In addition to providing wrappers around features like method swizzling or associated values, it also provides some type safety.

As of right now, RuntimeKit supports method swizzling, replacing a methods implementation with a block, setting associated objects, looking up an object's properties, adding new methods to existing classes and creating new classes and protocols. More features will be added over time.


## Installation

**CocoaPods** (recommended)

```
pod 'RuntimeKit'
```

**Build from source**

Just copy everything in [`RuntimeKit/Sources`](https://github.com/lukaskollmer/RuntimeKit/tree/master/RuntimeKit/Sources) into your Xcode project


## Features:
1. [Method swizzling](#method-swizzling)
2. [Associated objects](#associated-objects)
3. [Creating new classes](#creating-new-classes)
4. [Creating new protocols](#creating-new-protocols)
5. [Performing ObjC Selectors w/ some additional type safety](performing-objective-c-selectors-with-some-additional-type-safety)


### Method Swizzling

**Switching two method's implementations**

```swift
extension NSDate {
    func xxx_addingTimeInterval(_ ti: TimeInterval) -> NSDate {
        print("will add \(ti)")
        return self.xxx_addingTimeInterval(ti)
    }   
}

try! NSDate.swizzle(#selector(NSDate.addingTimeInterval(_:)), with: #selector(NSDate.xxx_addingTimeInterval(_:)))

NSDate().addingTimeInterval(100) // prints "will add 100"
```

**Replacing a method's implementation with a block**

```swift
let systemFontOfSize_block: @convention(block) (UIFont, Selector, CGFloat) -> UIFont = { (self, sel, size) in
    return UIFont(name: "Avenir-Book", size: size)!
}

try! UIFont.replace(#selector(UIFont.systemFont(ofSize:)), withBlock: systemFontOfSize_block, methodType: .class)

let systemFont = UIFont.systemFont(ofSize: 15) // -> <UICTFont: 0x7fddc5703150> font-family: "Avenir-Book"; font-weight: normal; font-style: normal; font-size: 15.00pt>
```


### Associated objects

```swift

extension AssociatedObjectKeys {
    static let name = AssociatedObjectKey<String>("name")
    static let age  = AssociatedObjectKey<Int>("age")
}

class Person: NSObject {}

let me = Person()
me.setAssociatedObject("Lukas", forKey: .name)
me.setAssociatedObject(18, forKey: .age)

let name = me.getAssociatedObject(forKey: .name) // Optional("Lukas")
let age  = me.getAssociatedObject(forKey: .age)  // Optional(18)

```


### Creating new classes

```swift
let LKGreeter = try! Runtime.createClass("LKGreeter")

let greetMethod_block: @convention(block) (NSObject, Selector, String) -> String = { (_self, _sel, name) in
    return "Hello, \(name)"
}

try! LKGreeter.addMethod("greet", implementation: greetMethod_block, methodType: .class, returnType: .object, argumentTypes: [.object, .selector, .object])

LKGreeter.perform("greet", with: "Lukas").takeRetainedValue() // result: "Hello, Lukas"
```



### Creating new protocols

```swift
let methods = [
    ObjCMethodDescription("greet", returnType: .object, argumentTypes: [.object, .selector, .object], methodType: .class, isRequired: true)
]

let GreeterProtocol = try! Runtime.createProtocol("Greeter", methods: methods)
let LKGreeter = try! Runtime.createClass("LKGreeter", superclass: NSObject.self, protocols: [GreeterProtocol])
```


### Performing Objective-C Selectors with some additional type safety

```swift


let formatBlock: @convention(block) (NSDate, Selector, String) -> String = { (_self, _sel, format) in
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: _self as Date)
}
try! NSDate.addMethod("customFormat:", implementation: formatBlock, methodType: .instance, returnType: .object, argumentTypes: [.object, .selector, .object])

extension ObjCMethodCallRequests {
    static let customFormat = ObjCMethodCallRequest<String>("customFormat:")
}

let now = NSDate()
let formatString: String = try! now.perform(.customFormat, "EEEE MMM d, yyyy") // -> "Saturday Apr 1, 2017"
```
