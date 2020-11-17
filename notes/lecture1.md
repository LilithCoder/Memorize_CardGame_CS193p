## Coding
- keyword "some View" goes after variable means the type of this property is any type, as long as it behaves like a view, it might be returning a combiner(view-combining view), if it returns a combiner view, it could have tons of views that are combined
- "body" variable's value is not stored in memory, this var is computed, every time ask for value of this var, code in curly braces will be executed
almost all the arguments to all parameters of all functions are labeled, which was inherited from objective-c
- ZStack is a struct, a combiner view to build complicated views, it behaves like a view, ZStack needs parameters that is a list of view to stack on top of each other
- modifier: padding(), foregroundColor(), stroke() returns a view, fill()
- set foregroundColor() for ZStack, it will apply to all the views inside the ZStack
- ForEach(iterator, content)
- HStack arranges things horizontally, from left to right
- HStack/ForEach/ZStack is a combiner  
- for function or ForEach, if the argument is a curly-brace thing, label can be get rid of, the argument can be put outside the function parenthesis
if parenthesis after function is blank, just remove it