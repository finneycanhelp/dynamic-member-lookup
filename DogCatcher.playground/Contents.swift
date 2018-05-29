/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.
import Foundation

// Dog

@dynamicMemberLookup
class Dog {
  
  enum Direction: String { case left, right, motionless }
  
  subscript(dynamicMember member: String) -> Direction {
    
    if member == "moving" || member == "directionOfMovement" {
      // Here's where one would call the tracking software library
      // that's in another programming language
      return randomBool() ? .right : .left
    }
    
    return .motionless
  }
  
  subscript(dynamicMember member: String) -> Int {
    
    if member == "speed" {
      // Here's where one would call the speed calculator
      // that's in another programming language
      return 12
    }
    
    return 0
  }
  
  private func randomBool() -> Bool {
    return arc4random_uniform(2) == 0
  }
}

let dog = Dog()

let direction1: Dog.Direction = dog.directionOfMovement
print("Dog's direction of movement is \(direction1).")

let direction2: Dog.Direction = dog.moving
print("Dog is moving \(direction2).")

let speed: Int = dog.speed
print("Dog's speed is \(speed).")

// Dog Catcher

@dynamicMemberLookup
struct JSONDogCatcher {
  
  private var storedStr: String?
  private var storedInt: Int?
  private var storedDict:[String: Any]?
  
  init(string: String) {
    storedStr = string
  }
  
  init(int: Int) {
    storedInt = int
  }
  
  init(dictionary: [String: Any]) {
    storedDict = dictionary
  }
  
  subscript(dynamicMember member: String) -> JSONDogCatcher? {
    
    let value = storedDict?[member]
    
    if let dictionary = value as? [String: Any] {
      return JSONDogCatcher.init(dictionary: dictionary)
    }
    if let string = value as? String {
      return JSONDogCatcher.init(string: string)
    }
    if let int = value as? Int {
      return JSONDogCatcher.init(int: int)
    }
    
    return nil
  }
  
  subscript(key: String) -> JSONDogCatcher? {
    
    let value = storedDict?[key]
    
    if let dictionary = value as? [String: Any] {
      return JSONDogCatcher.init(dictionary: dictionary)
    }
    if let string = value as? String {
      return JSONDogCatcher.init(string: string)
    }
    if let int = value as? Int {
      return JSONDogCatcher.init(int: int)
    }
    
    return nil
  }
  
  func value() -> String? {
    return storedStr
  }
  
  func value() -> Int? {
    return storedInt
  }
}

let catchAString = JSONDogCatcher.init(string: "Rover").value() ?? ""
print("Caught \(catchAString)")

let catchAnInt = JSONDogCatcher.init(int: 3).value() ?? 0
print("Caught \(catchAnInt)")

// ----

let json: [String:Any] = ["name":"Rover","speed":10,
                          "owner": ["name":"Ms. Simpson", "age":36]]

let catcher = JSONDogCatcher.init(dictionary: json)

let messyName: String = catcher["owner"]?["name"]?.value() ?? ""
print("Owner's name extracted in a less readable way is \(messyName).")

let ownerName: String = catcher.owner?.name?.value() ?? ""
print("Owner's name is \(ownerName).")

let dogSpeed: Int = catcher.speed?.value() ?? 0
print("Dog's speed is \(dogSpeed).")



