# RuntimeKit

![](https://img.shields.io/badge/Swift-3.1-orange.svg)
![CocoaPods](https://img.shields.io/cocoapods/v/RuntimeKit.svg)
![CocoaPods](https://img.shields.io/cocoapods/l/RuntimeKit.svg)

RuntimeKit is a Swift library for accessing the Objective-C runtime.
In addition to providing wrappers around features like method swizzling or associated values, it also provides some type safety.

As of right now, RuntimeKit only supports method swizzling, replacing a methods implementation with a block and setting associated objects. More features will be added over time.


## Installation

**CocoaPods** (recommended)

```
pod 'RuntimeKit'
```

<br>

**Build from source**

Just copy everything in `RuntimeKit/Sources` into your Xcode project


## Features:
1. [Method swizzling](#method-swizzling)
2. [Associated objects](#associated-objects)


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
