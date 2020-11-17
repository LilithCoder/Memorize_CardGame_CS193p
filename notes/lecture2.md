## MVVM
- MVVM 与"reactive" user-interfaces的概念一致, cannot do SwiftUI without it

- M: Model, V: View, VM: ViewModel

- Model encapsulate data and logic, it's UI-independent

- Data always flows from model to view. View reflects the model, and view is stateless (only model has the state) and declarative (declarative[陈述式] means declare the view looks this way and only change anything on screen when the model changes)

- no calling function(imperative) to put things in places, just create those views e.g Text..(declarative)

- Structs are read-only by default, no one is allowed to call a function that would change it, you can sure the view is always gonna look like exactly what you see in the code that you've declared right in front of you, and declarative is time-independent, this is a big improvement over imperative[命令式] models for UI

- imperative的劣势: hard to manage all function to be called and prove UI really works

- View is reactive, anytime the model changes, it's going to automatically update the view

- ViewModel binds View to Model, once one change has happened in the model, the view get reflected. ViewModel interprets the Model for the View, converting the data from one data type to another, it can simplify data to some simpler data structures that it can pass to the View, it will let the View be simple code that draws it. So ViewModel also acts as an interpreter of Model data

- ViewModel: notices changes in the Model, it might interpret data when data changes, and then publishes something changed, ViewModel does not have any pointers to any Views

- The view subscribes to that publication and when it sees something changed, it goes back to the ViewModel and asks: what's the current state of the world, it pulls the data from ViewModel, then the View draw itself to match the state of the world

- ![](l2-1.png)

- When View wants to change the Model, add "Processes Intent" to the ViewModel. When the use is going to have the intent of some action, it's up to the ViewModel to process these intents and it does this by making functions available to the View to call to make the intent clear. View is going to call an intent function in the ViewModel. When the ViewModel receives the function called on them, they will modify the model, the ViewModel knows all about the Model and it's represented, if the Model is SQL, it's gonna be issuing sql commands to change the Model. if the Model is struct, then it's just setting vars or calling function in the Model to modify. All what ViewModel do is to express user's intent in changing the Model

- Then ViewModel notices changes the Model made, ViewModel pulishes something changed, then the View sees something changed, and it automatically redraws itself.

- ![](l2-2.png)

## Type System in Swift
|     struct     |     class    |    protocol    |     "Don't Care" (generics)    |    enum    |    functions    
| :-------------: | :----------: | :----------: | :----------: | :----------: | :----------: |

### struct & class
相同：

stored vars / computed vars / constant lets / functions / initializers

不同：

struct: 
1. value type, copied when passed or assigned, when you are passing a struct to a function as an argument
2. Swift is not copying the bits of structs, Swift is sharing structs until you try to write to structs, it's called copy-on-write. So if you pass an array to a function, it might copy that into another variable, and then it wants to add something to that array, then it's gonna make a copy, an actual bitwise copy of the array that you can add to it. When you write to a struct, it makes a copy. But sementically, every time u pass struct around, it's getting copied. 
3. Arrays, dictionaries, ints, bools, doubles are all structs
4. Struct is built to support functional programming, functional programming focuses on functionality of things
5. struct has no inheritance
6. "Free" init initializes ALL vars
7. In value type programming, we're copying things around mutability, mutability has to be explicitly stated with a struct, you do that by using var versus let. if you say let constant_name = struct.., then you can't mutate it.
8. Everything you've seen so far is a struct, except View which is a protocol

class: 
1. reference type, pass around via pointers, reference type live in the heap. 
2. Automatically reference counted, seeing how many pointers there are to this thing. When finally no one is left pointing to the classes in the heap, then the memory gets freed out of the heap
3. classes are built for object-oriented programming, object-oriented programming are focusing on encapsulating data and functionality into some container and object
4. class has inheritance, but single inheritance, class can only inherit from one class
5. "Free" init initializes NO vars, it's always init() with no arguments, it means all vars have var assignments after init(), or you have to provide your own init in class. So in classes, we always provide inits
6. class is always mutable, there is no control of mutability in a class. anyone who has a pointer to a class can just go mutate it
7. The ViewModel in MVVM is always a class, ViewModel needs to be shared amongst a lot of Views, ViewModel is kind of the portal on to the Model, A lot of Views might look at that Model, they wanna share that portal, classes are great for sharing because we all have a pointer to them. also UIKit(old-style iOS) is class-based

Generics(泛型, 通用类型):
1. we may want to manipulate data structures that we are "type agnostic"(类型不可知) about, we don't know what type something is and we don't care. But in SwiftUI, we do not use untyped variables, so how do we specify the type of something when we don't care what type it is, we use a "don't care" type, we call this feature "generics"
2. Example of a user of "don't care" type: Array, array contains a bunch of things and it does not care at all what type they are. also array has functions and vars on it, they will let you do things like add to the array or get the values of array, so how are those going to declare their return types and their argument types, the answer is "GENERICS"
3. Array example
    ```
    struct Array<Element> {
        ...
        func append(_ element: Element) { ... }
    }
    ```
    the type of argument to append( ... ) is Element. A "don't care" type. Array’s implementation of append knows nothing about that argument and it does not care.
Element is not any known struct or class or protocol, it’s just a placeholder for a type.
    ```
    The code for using an Array looks something like this …
    var a = Array<Int>()
    a.append(5)
    a.append(22)
    When someone uses Array, that’s when Element gets determined (by Array<Int>).
    when the code in Array is being written, it all don't care, it just uses the type Element
    ```
    Note that Array has to let the world know the names of all of its “don’t care” types in its API.
    It does this with the < > notation on its struct declaration Array<Element> above.
    That’s how users of Array know that they have to say what type Element actually is.
    ```
    var a = Array<Int>()
    ```
    It is perfectly legal to have multiple “don’t care” types in the above (e.g. <Element, Foo>
    a “don’t care” type's actual name is Type Parameter

Functions:
1. You can declare a variable (or parameter to a func or whatever) to be of type “function”. The syntax for this includes the types of the arguments and return value.

    Example:
    ```
    (Int, Int) -> Bool // takes two Ints and returns a Bool
    (Double) -> Void // takes a Double and returns nothing
    () -> Array<String> // takes no arguments and returns an Array of Strings
    () -> Void // takes no arguments and returns nothing (this is a common one)

    All of the above a just types. No different than Bool or View or Array<Int>. All are types.

    var foo: (Double) -> Void // foo’s type: “function that takes a Double, returns nothing”
    func doSomething(what: () -> Bool) // what’s type: “function, takes nothing, returns Bool”
    ```
    Example:
    ```
    var operation: (Double) -> Double
    This is a var called operation.
    It is of type “function that takes a Double and returns a Double”.

    Here’s a simple function that takes a Double and returns a Double …
    func square(operand: Double) -> Double {
    return operand * operand
    }

    operation = square // just assigning a value to the operation var, nothing more
    let result1 = operation(4) // result1 would equal 16
    Note that we don’t use argument labels (e.g. operand:) when executing function types.
    operation = sqrt // sqrt is a built-in function which happens to take and return a Double
    let result2 = operation(4) // result2 would be 2
    ```
2. Closures, closure is inlining(内联) a function, taking a function that you're passing to another function as a parameter and you're inlining it instead of having it be separately declared somewhere.  It’s so common to pass functions around that we are very often “inlining” them, “functions as types” is a very important concept 

## Coding
- Foundation has Array, Dictionary, String, Int, Bool and all basic types, does not have UI thins, e.g View, Text, RoundedRectangle

- ViewModel is a portal between Views and Model

- why we use class in ViewModel: class is easy to share, class lives in the heap and it has pointers to it, all of our views could have pointers to this one portal onto the Model

- Bad thing using class in ViewModel here is ViewModel is wide open, ViewModel has var "model", one bad view could ruin the whole game for all the other views sharing the same ViewModel, so we can mark the model var private in ViewModel, this model now can only be accessed by EmojiMemoryGame ViewModel, 
    ```
    private var model: MemoryGame<String>
    ```
    none of the views can see the Model anymore. So we need a middle ground here, we use private(set), 
    ```
    private(set) var model: MemoryGame<String>
    ```
    private(set) means only EmojiMemoryGame can modify the Model but everyone else can still see the Model, let people have a glass door and see the Model

- Now views cannot go through the glass door to choose a Card, so that's where these intents come in, ViewModel is to interpret user intent

- We could also be restrictive
    ```
    private var model: MemoryGame<String>
    ```
    we can provide vars and funcs that let people look at this Model in constricted way
    ```
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    ```
    ViewModel might be doing some interpretation here, convert Model data into some form that is more consumable by the View, we want our views to be simple, so it's ViewModel's job to present the Model to Views
    
    Intent(s): letting all views know people who are writing View code, here is the thing you can do to change the Model
    ```
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    ```

- Inlining of function is called closure because it captures information from the surroundings that it needs to work, write functions in curly braces
    ```
    MemoryGame<String>(numberOfPairsOfCards: 2, cardContentFactory: {(pairIndex: Int) -> String in
        return "💩"
    })
    ```
    Closures, closure is inlining(内联) a function, taking a function that you're passing to another function as a parameter and you're inlining it instead of having it be separately declared somewhere. It’s so common to pass functions around that we are very often “inlining” them

- for function, if the argument is a curly-brace thing, label can be get rid of, the argument can be put outside the function parenthesis
    
    From
    ```
    MemoryGame<String>(numberOfPairsOfCards: 2, cardContentFactory: { pairIndex in "💩" })
    ```
    To
    ```
    MemoryGame<String>(numberOfPairsOfCards: 2) { _ in "💩" }
    ```
    underbar here means that I know there is an argument, but I do not need it

- We cannot use any functions on our class or struct utill properties are initialized
    ```
    private var model: MemoryGame<String> = createMemoryGame()

    func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["👻", "🎃"]
        return MemoryGame<String>(numberOfPairsOfCards: 2) { pairIndex in
            return emojis[pairIndex]
        }
    }
    ```
    so what we do is mark createMemoryGame() static, instead of return function of an instance, static function createMemoryGame() return a function on a type(EmojiMemoryGame)
    ```
    private var model: MemoryGame<String> = createMemoryGame()

    static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["👻", "🎃"]
        return MemoryGame<String>(numberOfPairsOfCards: 2) { pairIndex in
            return emojis[pairIndex]
        }
    }
    ```
    Code below creates a ContentView to show in preview canvas
    ```
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    ```
- forEach(iterator): iterator thing needs to be identifiable
- attach Model to View through viewModel
- viewModel provides a window or a portal on to Model through 
    ```
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    ```
- View is always drawing whatever is in the Model through ViewModel