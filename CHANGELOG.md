### v0.5.0 (2017-05-07)
- Added support for osx, watchos and tvos
- Added `Runtime.getClass(_:)`
- Added a `unknown(String)` case to `ObjCTypeEncoding`
- Added `NSObject.getProperty<T>(_:)` to get a property's value
- `ObjCTypeEncoding` how has a `struct(String)` case
- `ObjCPropertyDescription` contains a lot more information about a property:
  - `typeEncoding: ObjCTypeEncoding`
  - `type: NSObject.Type`
  - `isCopy: Bool`
  - `isRetain: Bool`
  - `isNonatomic: Bool`
  - `customGetter: String?`
  - `customSetter: String?`
  - `isDynamic: Bool`
  - `isWeak: Bool`
  - `isConst: Bool`
  - `isEligibleForGarbageCollection: Bool`
  - `oldStyleTypeEncoding: String?`
- `NSObject.perform(_:, _:)` now returns a wrapper so that the user can decide whether he (or she) wants to take the retained or unretained value

### v0.4.2 (2017-04-14)
- Added `NSObject.removeAssociatedObject`: Remove a single associated object from an object
- Added `NSObject.removeAllAssociatedObjects`: Remove all associated objects from an object

### v0.4.0 (2017-04-01)
- Added `NSObject.perform`: Perform ObjC selectors w/ some additional type safety

### v0.3.0 (2017-03-31)
- Added some documentation

### v0.2.0 (2017-03-31)
- Added `Runtime.allClasses`
- Added `Runtime.classExists`
- Added `Runtime.createClass`
- Added `Runtime.createProtocol` and `Runtime.getProtocol`
- Added `NSObject.addMethod`
- Added `NSObject.classMethods` and `NSObject.instanceMethods`
- Added `NSObject.properties`
- Added the `ObjCTypeEncoding` enum

### v0.1.0 (2017-03-30)
- Initial release
