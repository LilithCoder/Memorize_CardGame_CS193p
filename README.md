# Memorize CardGame
这是一个来自课程Stanford CS193p Developing Apps for iOS 2020 Spring 的翻转卡牌的iOS游戏, 运用了SwiftUI, 通过翻转卡牌来消除相同emoji的一对卡牌来获得分数, 整个应用的设计架构是MVVM(Model-View-ViewModel)，结合了reactive programming使UI始终与模型保持同步并且实现游戏背后的逻辑，利用GeometryReader自动分配卡片大小，比例和摆放位置。利用ViewModifier和ViewBuilder重构views，添加了一些animation

---
## 项目Code：[链接🔗](/Memorize)

## Demo录屏：[视频演示链接🔗](https://www.bilibili.com/video/BV1tV411a7Je/)


## 关于课程
课程网站: [link](https://cs193p.sites.stanford.edu/)
|     Lecture     |     Title    |    Slides    |     Notes    |     Video    |
| :-------------: | :----------: | :----------: | :----------: | :----------: |
| #1 | Course Logistics and Intro to SwiftUI | [slide](slides/l1.pdf) | [note](notes/lecture1.md) | [link](https://www.youtube.com/watch?v=jbtqIBpUG7g&feature=youtu.be) |
| #2 | MVVM and the Swift Type System | [slide](slides/l2.pdf) | [note](notes/lecture2.md) | [link](https://www.youtube.com/watch?v=4GjXq2Sr55Q&feature=youtu.be) |
| #3 | Reactive UI Protocols Layout | [slide](slides/l3.pdf) | [note](notes/lecture3.md) | [link](https://www.youtube.com/watch?v=SIYdYpPXil4&list=PLpGHT1n4-mAtTj9oywMWoBx0dCGd51_yG&index=3) |
| #4 | Grid enum Optionals | [slide](slides/l4.pdf) | [note](notes/lecture4.md) | [link](https://www.youtube.com/watch?v=eHEeWzFP6O4&list=PLpGHT1n4-mAtTj9oywMWoBx0dCGd51_yG&index=4) |
| #5 | ViewBuilder Shape ViewModifier | [slide](slides/l5.pdf) | [note](notes/lecture5.md) | [link](https://www.youtube.com/watch?v=eHEeWzFP6O4&list=PLpGHT1n4-mAtTj9oywMWoBx0dCGd51_yG&index=5) |
| #6 | Animation | [slide](slides/l6.pdf) | [note](notes/lecture6.md) | [link](https://www.youtube.com/watch?v=eHEeWzFP6O4&list=PLpGHT1n4-mAtTj9oywMWoBx0dCGd51_yG&index=6) |

Lec1:
- 使用SwiftUI的声明性方法(declarative approach)来构成用户界面。

Lec2:
- 建立了MVVM基础框架
- View提供declarative的views
- ViewModel提供访问Model的数据，以及Intent functions使得View可以调用Model的函数。View可以共享ViewModel的intent函数，ViewModel的类型为class便于共享, ViewModel建立了Model的实例，因为Model是generic type。
- Model提供游戏的数据和逻辑，包括了卡牌是否match，是否翻转，选择卡牌的操作

Lec3:
- ViewModel里的model变量包装成@Published，一旦观察到Model有变化，就publish有变化了，调用objectWillChange.send(), View里的ViewModel变量有ObservedObject，一旦viewModel publish了，就重新画view
- 根据上面的理论实现了reactive programming, 一旦点击卡牌，卡牌会有翻转效果
- 通过ViewModel更新模型以及使UI始终与模型保持同步来使卡翻转。

Lec4:
- 建立了Grid将每个view放置每个特定的row和column, 利用GridLayout和GeometryReader自动分配卡片大小和比例, 确定每个card的摆放位置
- extension Array firstIndex()
- 用 optional解决firstIndex()的bug
- 实现了游戏matching逻辑：
    1. 一开始卡牌都是face-down，点击一张卡牌，再点击第二张卡牌，再点击第三张时候，另外两张需要face-down，第三张face-up
    2. 需要matching的情景是只有一张卡片face-up，然后点击另一张，如果两张卡牌content相同，则matched，如果match了，就让卡牌消失
    3. 点击卡片时，如果0个或者大于1个卡牌face-up，把所有卡牌都face-down，把点击的卡片face-up
    4. 只点击unfaceup和unmatched的卡牌
- 优化代码indexOfTheOneAndOnlyFaceUpCard: get & set

Lec5:
- 修改access-control
- 建立custom shape每张卡牌画个pie
- 重构views by ViewModifier and ViewBuilder, 建立custom的ViewModifier
- @ViewBuilder construct for expressing a conditional list of Views
- the Shape protocol for custom drawing and ViewModifier (mechanism for making incremental modifications to Views)

Lec6:
- 添加了match后翻筋斗的animation
- animating the appearance/disappearance of Views by specifying ViewModifiers
- 翻转卡牌 via their ViewModifiers which can implement the Animatable protocol