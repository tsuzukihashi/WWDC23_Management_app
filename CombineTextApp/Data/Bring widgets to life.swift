import Foundation

extension ItemViewData {
  static var Bring_widgets_to_life: ItemViewData {
    .init(
      id: UUID().uuidString,
      title: "Bring widgets to life",
      linkURL: URL(string: "https://developer.apple.com/videos/play/wwdc2023/10028/"),
      firstText:"""
Luca: Hi! My name is Luca and I’m an engineer on the SwiftUI team.
Today we are going to discuss how you can bring widgets to life with some new, exciting capabilities.
Widgets are a beloved part of the iOS and macOS experience and now, with interactivity and animations, they are even more powerful.

Interactivity allows your user to directly manipulate the data in your widget, creating powerful interaction to execute the most important actions in your app.
And animations bring widgets to life by helping users get a sense of how the content has changed and what’s the result of their actions.
I’m super excited about all of these new capabilities, so let’s get started.
First, we are going to cover animations and how easy it is to make your widget look great.
After that, I’m going to walk you through how to add interactivity to your widgets.
Let’s start with animations.
Throughout this talk, we are going to use an app that my friend Nils has been working on to keep track of the caffeine intake during the day.
It already has a widget that shows the total amount of caffeine and the last drink I had today.
If I recompile my widget with the latest SDK, every time the content of the widget changes, the system is going to animate the transition between the entries with a default animation.
We are going to add some tweaks here to make it look even better, but before we jump into Xcode, let me briefly talk about how animations work with widgets.
In a regular SwiftUI app, you use state to drive changes to your view.
And animations are driven by state mutations using modifiers like withAnimation.
But Widgets work slightly differently.
Widget don't have state.
Instead, they create a timeline made of entries, which correspond to different views rendered at specific times.
SwiftUI determines what is the same and what is different between the entries, and animates the parts that have changed.
By default, widgets get an implicit spring animation and various implicit content transitions, but you can use all the transition, animation, and content transition APIs that SwiftUI provides out of the box to customize how your widget animates.
I won’t go into more details about how all the animation primitives of SwiftUI work.
For that, there is a fantastic talk called “Explore SwiftUI Animation.” Okay, time to open up Xcode and show you how, with a few tweaks, your widget can be as fancy as latte art on your morning cappuccino and how the new Xcode Preview API can help you iterate quickly on these animations.

Here we have all the views that comprised my widget.
The main view has a VStack with two views, the first showing the total amount of caffeine and the second, the last drink I had today, if present.
Note how I am using the containerBackground modifier here to define the background for my widget.
This allows it to show up in all the new supported locations on the Mac and iPad.
Normally, to be able to see your widget animating, you would need to have a bunch of entries and wait for their moment to appear on screen, but that can be tedious and would slow you down, but luckily we have a great solution with the new Preview API we are introducing this year.
I can define a new preview for a widget in systemSmall and pass the type defining my widget.
and now I can specify how to render a timeline with some entries I've defined earlier.
When I do that in the canvas, I can now see a preview of my timeline and how every entry would look like.
But check this out! When I click through the preview, I can see how my widget will animate when transitioning between entries.
This is pretty cool! And this is only scratching the surface of what this new Preview API is capable of.
Make sure to check out the session "Build programmatic UI with Xcode Previews" to learn more about this new powerful API.
Okay, time to start tweaking these animations.
The first thing I want to do is start with the text for the caffeine amount.
Right now it is just cross-fading with the next value, but I really want to add some drama to the value going up.
In this case, the view is not changing, but only the text content is, and to animated that, we can use a content transition.
And I'm going to choose add a numeric text with the value of my caffeine.
This is a content transition that is made specifically for important numeric value that we want to give prominence when they change.
I think its looking great! Now, I want to focus on the view showing the last drink.
I want to add a transition to emphasize that a new drink is coming in.
The first thing I want to do is to use the ID modifier to associate the identity of this view with specific log it is rendering.
This will inform SwiftUI that whenever this log changes, this is a new view and we need to transition to the new one.
And now I can specify a transition.
I think a push will be good.
From which edge? I think from bottom is a good choice.
Okay, you already know what to do now.
Back to the preview canvas.

And yeah, I like this transition from the bottom.
One last tweak.
I get a little jittery when I drink that much coffee, and I want that reflected with the animation curve for this transition.
What's great is that, like in a regular SwiftUI app, I can use the animation modifier and choose a smooth spring with a shorter duration and bind that animation to my log value.
And now, the animation would match my caffeination.
I feel pretty good about what we have now, so let's switch our attention to interactivity.
With interactivity, you can execute actions right from the widget! Before we jump into Xcode, I want to take a moment to discuss the architecture of how widgets work.
This will allow you to create a better mental model for how interactivity works.
When you create a widget, you define a widget extension, which is discovered by the system and run as an independent process.
Widgets define a timeline provider that returns a series of entries, which are effectively the widget’s model.
If a widget is visible, the system launches the widget extension process and asks its timeline provider for entries.
These entries are fed back into the view builder that is part of your widget configuration and used to generate a series of views based on these entries.
After that, the system generates a representation of these views and archives it on disk.
When its time to display a specific entry, the system decodes and renders the archived representation of your widget in its process.
Let me pause for a second and reiterate this last point.
Your view code only runs during archiving.
A separate representation of that view is rendered by the system process.
But if your data is not static, you might want to update those entries.
You can do that by calling the reloadTimelines function in your app whenever you are updating data that is displayed by your widget.
This will repeat the process I've just described, regenerate new entries, and archive new copies of the views on disk.
There are three important takeaways with this architecture.
First, when your widget is visible, your code is not running.
You drive changes to the widget content by updating its timeline entries, and this is also true of interactive widgets.
Typically, updates to widgets are done on a best effort basis, but importantly, reloads initiated from an interaction are always guaranteed to occur.
With this out of the way, let’s look at how to add interactivity.
What’s great is that you can use controls that you are already familiar with, like Button and Toggle, to make part of your widget interactive.
But remember, since widgets are rendered in a different process, SwiftUI won’t execute your closure, nor mutate your bindings, in your process space.
So we need a way to represent actions that can be executed by the widget extension and be invoked by the system.
Thankfully, there is already a solution to this problem: App Intents.
You might have used app intents to expose actions for your app to Shortcuts or Siri.
And now, the same intents can be used to represent the actions in your widget.
At its very core, AppIntent is a protocol that allows you to define, in code, actions that can be executed by the system.
For example, here, I’m defining an app intent to toggle a todo item in a todo app.
An intent defines a number of parameters as inputs and an async function called perform, where you will have the business logic to run your intent.
App Intents are very powerful, and there is a lot more to know about them, so be sure to checkout the “Dive into App Intents” and "Explore enhancements to App Intents” sessions from WWDC22 and 23.
And to support the ability to execute App Intent right from the UI, when you import both SwiftUI and AppIntents, There is a new family of initializers on Button and Toggle that accept an AppIntent as an argument and will execute that intent when these controls are interacted with.
Note that only Button and Toggle using AppIntent are supported in interactive widgets.
Other controls won’t work.
And of course, those initializers work in apps as well, which is cool because you can share the app intent logic between your widget and your app.
Let’s go back to Xcode and our coffee tracker app and add some interactivity.
Currently, the user can log a new drink only by opening the app, but where interactive widget shines is as accelerator to surface the most important actions in your app, and for my app, this is definitely the logging of a new drink.
So lets add that to a file I've already created.
The first thing I want to do is to define a type that conforms to AppIntent to log a new drink.
We'll give it a human-readable title that can be used by the system, and then implement the perform requirements by logging an espresso to our store and returning an empty intent result.
Something that I want to call your attention to is that perform is an async function and you should take full advantage of it if you are doing any asynchronous work, such as writing to a database exactly like I'm doing here when I'm awaiting the log writing operation.
As soon as your perform returns, the system will immediately initiate a reload of your widget timeline, giving you the opportunity to update the content of your widget.
So again, make sure to have persisted all the information necessary to reload your updated widget before returning from perform.
I've hard coded the drink to be an espresso, but, of course, we want to be able to pass the specific drink to log.
To do that we can add a stored property with the @Parameter property wrapper and an initializer that populates the all parameters.
It is important that I use this property wrapper because only the stored properties that are annotated with it are going to be persisted and will be available when the intent is performed in your widget extension.
Before we add the button to invoke this intent, I want to highlight an important ecosystem benefit of using App Intents here.
This app intent I've just defined is going to be available in Shortcut and Siri, so the investment in defining it here will pay dividend to your user experience beyond widgets.
And now we are ready to add the button to the widget.
Let's create a new view holding our buttons.
In this view I'm using this button initializer that take an app intent, so we can pass the one we just defined.
And let's add this view to the rest of the widget with some spacers.
Now we have everything in place, let's see how this is working out on the widget by building and running.
A little tip here: you can actually have directly build the target for the widget extension and Xcode will install the widget right on the home screen for you.
My widget now has the button I've just defined.
If I tap on it, I can log this last cup of espresso.
But there is also one additional change I want to make so that my widget provides the best user experience possible.
When your app intent finishes to perform, it will cause a widget to reload its timeline.
This can introduce a small latency from the action, to the resulting change in the UI.
But this latency can become more pronounced with iPhone widget on Mac so we are providing a solution out of the box for it.
For example, in my widget, the value showing the total amount of caffeine won't update until an updated entry arrived.
We can annotate this view with the invalidatableContent modifier.
I've added this widget from my iPhone to my Mac.
Let's tap on the button.
The view showing the caffeine amount shows a system effect to indicate that its value is invalidated until an update comes in.
We just saw Button in action and how with the invalidatableContent modifier, you can help users improve the perception of latency.
Use this modifier judiciously.
You don't need to annotate every single view that might change.
You should use this modifier with views that are meaningful to set the right expectation with your users.
Toggle goes one step further and will optimistically update its presentation when interacted with without having to wait for a roundtrip to the widget extension and back.
This is done automatically, on your behalf, at archive time, by pre-rendering the toggle style in both configurations.
Make sure, if you define your own toggle style, to check the configuration isOn property from the style and use that to switch the appearance.
This concludes our overview for interactivity and animations.
With animations and interactivity, you have the opportunity to infuse new life into your widgets and with widgets now in all these new locations, you can bring these little, delightful interactions to your users wherever they are.
So make sure to fine tune the animations for your widgets with the help of the new Xcode Preview APIs and look out for the most important actions in your app and surface them in your widget, giving your user powerful interactions whenever and wherever they need them.
Thanks you!
""",
      translateText: """
ルカ：こんにちは！私の名前は Luca です。SwiftUI チームのエンジニアです。
今日は、新しいエキサイティングな機能を使ってウィジェットを実現する方法について説明します。
ウィジェットは iOS および macOS エクスペリエンスの一部として愛されていますが、インタラクティブ性とアニメーションにより、さらに強力になりました。

インタラクティブ性により、ユーザーはウィジェット内のデータを直接操作できるようになり、アプリ内で最も重要なアクションを実行するための強力なインタラクションが作成されます。
また、アニメーションは、ユーザーがコンテンツがどのように変化したのか、自分のアクションの結果がどうなったのかを理解するのに役立ち、ウィジェットに命を吹き込みます。
これらすべての新機能にとても興奮していますので、早速始めてみましょう。
まず、アニメーションと、ウィジェットの見栄えを簡単にする方法について説明します。
その後、ウィジェットにインタラクティブ性を追加する方法を説明します。
アニメーションから始めましょう。
この講演では、友人のニルスが 1 日のカフェイン摂取量を記録するために開発したアプリを使用します。
カフェインの総量と今日最後に飲んだ飲み物を表示するウィジェットがすでにあります。
最新の SDK を使用してウィジェットを再コンパイルすると、ウィジェットのコンテンツが変更されるたびに、システムはデフォルトのアニメーションでエントリ間の遷移をアニメーション化します。
見た目をさらに良くするためにここに微調整を加えますが、Xcode に入る前に、アニメーションがウィジェットでどのように動作するかについて簡単に説明させてください。
通常の SwiftUI アプリでは、状態を使用してビューに変更を加えます。
また、アニメーションは、withAnimation などの修飾子を使用した状態の突然変異によって駆動されます。
ただし、ウィジェットの動作は少し異なります。
ウィジェットには状態がありません。
代わりに、特定の時間にレンダリングされるさまざまなビューに対応するエントリで構成されるタイムラインを作成します。
SwiftUI はエントリ間で何が同じで何が異なるかを判断し、変更された部分をアニメーション化します。
デフォルトでは、ウィジェットは暗黙的なスプリング アニメーションとさまざまな暗黙的なコンテンツ トランジションを取得しますが、SwiftUI が提供するすべてのトランジション、アニメーション、およびコンテンツ トランジション API をそのまま使用して、ウィジェットのアニメーション方法をカスタマイズできます。
SwiftUI のすべてのアニメーション プリミティブがどのように機能するかについては、これ以上詳しくは説明しません。
そのために、「SwiftUI アニメーションの探索」という素晴らしい講演があります。さて、Xcode を開いて、いくつかの調整でウィジェットを朝のカプチーノのラテアートのように豪華にする方法と、新しい Xcode プレビュー API がこれらのアニメーションを迅速に反復するのにどのように役立つかを説明します。

ここには、ウィジェットを構成するすべてのビューがあります。
メイン ビューには 2 つのビューを含む VStack があり、1 つ目はカフェインの総量を表示し、2 つ目は今日最後に飲んだ飲み物 (存在する場合) を表示します。
ここでウィジェットの背景を定義するために、containerBackground 修飾子をどのように使用しているかに注目してください。
これにより、Mac および iPad 上で新しくサポートされるすべての場所に表示されるようになります。
通常、ウィジェットのアニメーションを確認できるようにするには、大量のエントリを用意して、それらが画面に表示される瞬間を待つ必要がありますが、それは面倒で速度が遅くなる可能性がありますが、幸いなことに、今年導入する新しいプレビュー API。
systemSmall でウィジェットの新しいプレビューを定義し、ウィジェットを定義するタイプを渡すことができます。
これで、以前に定義したいくつかのエントリを使用してタイムラインをレンダリングする方法を指定できるようになりました。
キャンバスでこれを行うと、タイムラインのプレビューとすべてのエントリがどのように表示されるかが表示されます。
でも、これをチェックしてください！プレビューをクリックすると、エントリ間を遷移するときにウィジェットがどのようにアニメーションするかを確認できます。
これはかなりカッコいいですね！これは、この新しいプレビュー API ができることのほんの表面をなぞっただけです。
この新しい強力な API の詳細については、セッション「Xcode プレビューを使用してプログラムによる UI を構築する」を必ずチェックしてください。
さて、これらのアニメーションの調整を開始します。
まずカフェイン量のテキストから始めたいと思います。
現時点では次の値とクロスフェードしているだけですが、値の上昇にドラマチックを加えたいと考えています。
この場合、ビューは変化せず、テキスト コンテンツのみが変化します。これをアニメーション化するには、コンテンツ トランジションを使用できます。
そして、カフェインの値を示す数値テキストを追加することを選択します。
これは、変更時に目立つようにしたい重要な数値に対して特別に作成されたコンテンツの遷移です。
見た目は素晴らしいと思います!さて、ここで注目したいのは、最後のドリンクを示すビューです。
新しいドリンクが登場することを強調するためにトランジションを追加したいと考えています。
最初に行うことは、ID 修飾子を使用して、このビューの ID を、レンダリングされている特定のログに関連付けることです。
これにより、このログが変更されるたびに、これは新しいビューであり、新しいビューに移行する必要があることが SwiftUI に通知されます。
これで、トランジションを指定できるようになりました。
一押しが良いと思います。
どの端からですか？下からというのが良い選択だと思います。
さて、あなたはもう何をすべきか知っています。
プレビュー キャンバスに戻ります。

そして、ええ、私はこの下からの移行が好きです。
最後にもう 1 つ調整します。
コーヒーをたくさん飲むと少しイライラするので、それをこのトランジションのアニメーション カーブに反映させたいと考えています。
素晴らしいのは、通常の SwiftUI アプリと同様に、アニメーション モディファイアを使用して、より短い持続時間のスムーズなスプリングを選択し、そのアニメーションをログ値にバインドできることです。
そして今、アニメーションは私のカフェイン摂取と一致するでしょう。
今あるものについてはかなり満足しているので、インタラクティブ性に注意を切り替えましょう。
インタラクティブ機能により、ウィジェットから直接アクションを実行できます。 Xcode の説明に入る前に、ウィジェットがどのように機能するかのアーキテクチャについて少し説明したいと思います。
これにより、インタラクティブ性がどのように機能するかについて、より優れたメンタル モデルを作成できるようになります。
ウィジェットを作成するときは、システムによって検出され、独立したプロセスとして実行されるウィジェット拡張機能を定義します。
ウィジェットは、事実上ウィジェットのモデルである一連のエントリを返すタイムライン プロバイダーを定義します。
ウィジェットが表示されている場合、システムはウィジェット拡張プロセスを起動し、タイムライン プロバイダーにエントリを要求します。
これらのエントリは、ウィジェット構成の一部であるビュー ビルダーにフィードバックされ、これらのエントリに基づいて一連のビューを生成するために使用されます。
その後、システムはこれらのビューの表現を生成し、ディスク上にアーカイブします。
特定のエントリを表示するとき、システムはそのプロセスでウィジェットのアーカイブされた表現をデコードしてレンダリングします。
少し立ち止まって、この最後の点を繰り返したいと思います。
ビュー コードはアーカイブ中にのみ実行されます。
そのビューの別の表現がシステム プロセスによってレンダリングされます。
ただし、データが静的でない場合は、それらのエントリを更新する必要があるかもしれません。
これを行うには、ウィジェットによって表示されるデータを更新するたびに、アプリで reloadTimelines 関数を呼び出します。
これにより、今説明したプロセスが繰り返され、新しいエントリが再生成され、ビューの新しいコピーがディスクにアーカイブされます。
このアーキテクチャには 3 つの重要な点があります。
まず、ウィジェットが表示されているときは、コードは実行されていません。
タイムライン エントリを更新することでウィジェット コンテンツに変更を加えます。これはインタラクティブ ウィジェットにも当てはまります。
通常、ウィジェットの更新はベスト エフォート ベースで行われますが、重要なのは、インタラクションから開始されるリロードが常に発生することが保証されているということです。
これで、インタラクティブ性を追加する方法を見てみましょう。
素晴らしいのは、ボタンやトグルなどの使い慣れたコントロールを使用して、ウィジェットの一部をインタラクティブにできることです。
ただし、ウィジェットは別のプロセスでレンダリングされるため、SwiftUI はプロセス空間でクロージャを実行したり、バインディングを変更したりしないことに注意してください。
したがって、ウィジェット拡張機能によって実行でき、システムによって呼び出されるアクションを表す方法が必要です。
ありがたいことに、この問題にはすでにアプリ インテントという解決策があります。
アプリのインテントを使用して、アプリのアクションをショートカットまたは Siri に公開した可能性があります。
そして、同じインテントを使用してウィジェット内のアクションを表すことができるようになりました。
AppIntent の核心は、システムによって実行できるアクションをコードで定義できるようにするプロトコルです。
たとえば、ここでは、ToDo アプリ内の ToDo アイテムを切り替えるアプリ インテントを定義しています。
インテントは、入力としての多数のパラメーターと、インテントを実行するためのビジネス ロジックを持つ Perform と呼ばれる非同期関数を定義します。
アプリ インテントは非常に強力であり、アプリ インテントについてはさらに知るべきことがたくさんあるため、WWDC22 および 23 の「アプリ インテントの詳細」セッションと「アプリ インテントの機能強化の探索」セッションを必ずチェックしてください。
また、SwiftUI と AppIntents の両方をインポートするときに、UI から App Intent を直接実行する機能をサポートするために、AppIntent を引数として受け入れ、これらのコントロールが操作されたときにそのインテントを実行する新しい初期化子ファミリーが Button と Toggle にあります。と。
インタラクティブ ウィジェットでは、AppIntent を使用したボタンとトグルのみがサポートされていることに注意してください。
他のコントロールは機能しません。
そしてもちろん、これらのイニシャライザーはアプリ内でも機能します。これは、ウィジェットとアプリ間でアプリ インテント ロジックを共有できるため、優れています。
Xcode とコーヒー トラッカー アプリに戻って、対話機能を追加しましょう。
現在、ユーザーはアプリを開くだけで新しい飲み物を記録できますが、インタラクティブなウィジェットが輝くのは、アプリ内で最も重要なアクションを表示するためのアクセラレーターとしてであり、私のアプリの場合、これは間違いなく新しい飲み物の記録です。
それでは、それをすでに作成したファイルに追加してみましょう。
最初に行うことは、新しい飲み物を記録するために AppIntent に準拠する型を定義することです。
システムで使用できる人間が読めるタイトルを付けてから、エスプレッソをストアに記録し、空のインテント結果を返すことで実行要件を実装します。
注意していただきたいのは、perform は非同期関数であり、待機中にここで行っているのとまったく同じようにデータベースに書き込むなど、非同期作業を行う場合には、この関数を最大限に活用する必要があるということです。ログ書き込み操作。
パフォーマンスが戻るとすぐに、システムはウィジェット タイムラインのリロードを開始し、ウィジェットのコンテンツを更新する機会を与えます。
したがって、繰り返しになりますが、実行から戻る前に、更新されたウィジェットをリロードするために必要なすべての情報を永続化していることを確認してください。
ドリンクをエスプレッソになるようにハードコードしましたが、もちろん、特定のドリンクをログに渡すことができるようにしたいと考えています。
これを行うには、@Parameter プロパティ ラッパーを使用して保存されたプロパティと、すべてのパラメーターを設定するイニシャライザーを追加します。
このプロパティ ラッパーを使用することが重要です。これは、このプロパティ ラッパーで注釈が付けられた保存されたプロパティのみが永続化され、ウィジェット拡張機能でインテントが実行されるときに使用できるためです。
このインテントを呼び出すボタンを追加する前に、ここでアプリ インテントを使用することによるエコシステムの重要な利点を強調したいと思います。
私が定義したこのアプリ インテントは、ショートカットと Siri で利用できるようになるため、ここでの定義への投資は、ウィジェットを超えたユーザー エクスペリエンスに利益をもたらすでしょう。
これで、ウィジェットにボタンを追加する準備が整いました。
ボタンを押したまま新しいビューを作成しましょう。
このビューでは、アプリのインテントを受け取るこのボタン初期化子を使用しているため、定義したばかりのインテントを渡すことができます。
そして、いくつかのスペーサーを使用して、このビューをウィジェットの残りの部分に追加しましょう。
これですべてが整ったので、ウィジェットを構築して実行して、これがどのように機能するかを見てみましょう。
ここでちょっとしたヒント: 実際にウィジェット拡張機能のターゲットを直接ビルドすることができ、Xcode がウィジェットをホーム画面に直接インストールします。
ウィジェットには、先ほど定義したボタンが追加されました。
これをタップすると、エスプレッソの最後の一杯を記録できます。
ただし、ウィジェットが可能な限り最高のユーザー エクスペリエンスを提供できるように、追加の変更を 1 つ加えたいと思います。
アプリのインテントの実行が完了すると、ウィジェットがタイムラインを再読み込みします。
これにより、アクションから UI の変更が生じるまでにわずかな遅延が発生する可能性があります。
ただし、この遅延は Mac 上の iPhone ウィジェットではさらに顕著になる可能性があるため、私たちはそれに対するすぐに使えるソリューションを提供しています。
たとえば、私のウィジェットでは、カフェインの総量を示す値は、更新されたエントリが到着するまで更新されません。
このビューには、invalidatableContent 修飾子を使用して注釈を付けることができます。
このウィジェットを iPhone から Mac に追加しました。
ボタンをタップしてみましょう。
カフェイン量を示すビューには、更新が行われるまでその値が無効であることを示すシステム効果が表示されます。
Button の動作と、invalidatableContent 修飾子を使用して、ユーザーのレイテンシーの認識を改善する方法を確認しました。
この修飾子は慎重に使用してください。
変更される可能性のあるすべてのビューに注釈を付ける必要はありません。
この修飾子は、ユーザーに適切な期待を与えるために意味のあるビューで使用する必要があります。
Toggle はさらに一歩進んで、ウィジェット拡張機能との往復を待つことなく、操作されたときにプレゼンテーションを楽観的に更新します。
これは、両方の構成でトグル スタイルを事前レンダリングすることにより、アーカイブ時にユーザーに代わって自動的に行われます。
独自の切り替えスタイルを定義する場合は、そのスタイルから構成 isOn プロパティを確認し、それを使用して外観を切り替えてください。
これで、インタラクティブ性とアニメーションの概要は終わりです。
アニメーションとインタラクティブ性を使用すると、ウィジェットに新しい命を吹き込む機会が得られ、これらすべての新しい場所にウィジェットが配置されるようになり、ユーザーがどこにいても、これらの小さな楽しいインタラクションをユーザーに提供できるようになります。
したがって、新しい Xcode プレビュー API を利用してウィジェットのアニメーションを微調整し、アプリ内で最も重要なアクションを探してウィジェットに表示し、いつでもどこでも必要なときにユーザーに強力なインタラクションを提供できるようにしてください。
ありがとうございます！
""",
      combineText: """
Luca: Hi! My name is Luca and I’m an engineer on the SwiftUI team.
ルカ：こんにちは！私の名前は Luca です。SwiftUI チームのエンジニアです。

Today we are going to discuss how you can bring widgets to life with some new, exciting capabilities.
今日は、新しいエキサイティングな機能を使ってウィジェットを実現する方法について説明します。

Widgets are a beloved part of the iOS and macOS experience and now, with interactivity and animations, they are even more powerful.
ウィジェットは iOS および macOS エクスペリエンスの一部として愛されていますが、インタラクティブ性とアニメーションにより、さらに強力になりました。

Interactivity allows your user to directly manipulate the data in your widget, creating powerful interaction to execute the most important actions in your app.
インタラクティブ性により、ユーザーはウィジェット内のデータを直接操作できるようになり、アプリ内で最も重要なアクションを実行するための強力なインタラクションが作成されます。

And animations bring widgets to life by helping users get a sense of how the content has changed and what’s the result of their actions.
また、アニメーションは、ユーザーがコンテンツがどのように変化したのか、自分のアクションの結果がどうなったのかを理解するのに役立ち、ウィジェットに命を吹き込みます。

I’m super excited about all of these new capabilities, so let’s get started.
これらすべての新機能にとても興奮していますので、早速始めてみましょう。

First, we are going to cover animations and how easy it is to make your widget look great.
まず、アニメーションと、ウィジェットの見栄えを簡単にする方法について説明します。

After that, I’m going to walk you through how to add interactivity to your widgets.
その後、ウィジェットにインタラクティブ性を追加する方法を説明します。

Let’s start with animations.
アニメーションから始めましょう。

Throughout this talk, we are going to use an app that my friend Nils has been working on to keep track of the caffeine intake during the day.
この講演では、友人のニルスが 1 日のカフェイン摂取量を記録するために開発したアプリを使用します。

It already has a widget that shows the total amount of caffeine and the last drink I had today.
カフェインの総量と今日最後に飲んだ飲み物を表示するウィジェットがすでにあります。

If I recompile my widget with the latest SDK, every time the content of the widget changes, the system is going to animate the transition between the entries with a default animation.
最新の SDK を使用してウィジェットを再コンパイルすると、ウィジェットのコンテンツが変更されるたびに、システムはデフォルトのアニメーションでエントリ間の遷移をアニメーション化します。

We are going to add some tweaks here to make it look even better, but before we jump into Xcode, let me briefly talk about how animations work with widgets.
見た目をさらに良くするためにここに微調整を加えますが、Xcode に入る前に、アニメーションがウィジェットでどのように動作するかについて簡単に説明させてください。

In a regular SwiftUI app, you use state to drive changes to your view.
通常の SwiftUI アプリでは、状態を使用してビューに変更を加えます。

And animations are driven by state mutations using modifiers like withAnimation.
また、アニメーションは、withAnimation などの修飾子を使用した状態の突然変異によって駆動されます。

But Widgets work slightly differently.
ただし、ウィジェットの動作は少し異なります。

Widget don't have state.
ウィジェットには状態がありません。

Instead, they create a timeline made of entries, which correspond to different views rendered at specific times.
代わりに、特定の時間にレンダリングされるさまざまなビューに対応するエントリで構成されるタイムラインを作成します。

SwiftUI determines what is the same and what is different between the entries, and animates the parts that have changed.
SwiftUI はエントリ間で何が同じで何が異なるかを判断し、変更された部分をアニメーション化します。

By default, widgets get an implicit spring animation and various implicit content transitions, but you can use all the transition, animation, and content transition APIs that SwiftUI provides out of the box to customize how your widget animates.
デフォルトでは、ウィジェットは暗黙的なスプリング アニメーションとさまざまな暗黙的なコンテンツ トランジションを取得しますが、SwiftUI が提供するすべてのトランジション、アニメーション、およびコンテンツ トランジション API をそのまま使用して、ウィジェットのアニメーション方法をカスタマイズできます。

I won’t go into more details about how all the animation primitives of SwiftUI work.
SwiftUI のすべてのアニメーション プリミティブがどのように機能するかについては、これ以上詳しくは説明しません。

For that, there is a fantastic talk called “Explore SwiftUI Animation.” Okay, time to open up Xcode and show you how, with a few tweaks, your widget can be as fancy as latte art on your morning cappuccino and how the new Xcode Preview API can help you iterate quickly on these animations.
そのために、「SwiftUI アニメーションの探索」という素晴らしい講演があります。さて、Xcode を開いて、いくつかの調整でウィジェットを朝のカプチーノのラテアートのように豪華にする方法と、新しい Xcode プレビュー API がこれらのアニメーションを迅速に反復するのにどのように役立つかを説明します。

Here we have all the views that comprised my widget.
ここには、ウィジェットを構成するすべてのビューがあります。

The main view has a VStack with two views, the first showing the total amount of caffeine and the second, the last drink I had today, if present.
メイン ビューには 2 つのビューを含む VStack があり、1 つ目はカフェインの総量を表示し、2 つ目は今日最後に飲んだ飲み物 (存在する場合) を表示します。

Note how I am using the containerBackground modifier here to define the background for my widget.
ここでウィジェットの背景を定義するために、containerBackground 修飾子をどのように使用しているかに注目してください。

This allows it to show up in all the new supported locations on the Mac and iPad.
これにより、Mac および iPad 上で新しくサポートされるすべての場所に表示されるようになります。

Normally, to be able to see your widget animating, you would need to have a bunch of entries and wait for their moment to appear on screen, but that can be tedious and would slow you down, but luckily we have a great solution with the new Preview API we are introducing this year.
通常、ウィジェットのアニメーションを確認できるようにするには、大量のエントリを用意して、それらが画面に表示される瞬間を待つ必要がありますが、それは面倒で速度が遅くなる可能性がありますが、幸いなことに、今年導入する新しいプレビュー API。

I can define a new preview for a widget in systemSmall and pass the type defining my widget.
systemSmall でウィジェットの新しいプレビューを定義し、ウィジェットを定義するタイプを渡すことができます。

and now I can specify how to render a timeline with some entries I've defined earlier.
これで、以前に定義したいくつかのエントリを使用してタイムラインをレンダリングする方法を指定できるようになりました。

When I do that in the canvas, I can now see a preview of my timeline and how every entry would look like.
キャンバスでこれを行うと、タイムラインのプレビューとすべてのエントリがどのように表示されるかが表示されます。

But check this out! When I click through the preview, I can see how my widget will animate when transitioning between entries.
でも、これをチェックしてください！プレビューをクリックすると、エントリ間を遷移するときにウィジェットがどのようにアニメーションするかを確認できます。

This is pretty cool! And this is only scratching the surface of what this new Preview API is capable of.
これはかなりカッコいいですね！これは、この新しいプレビュー API ができることのほんの表面をなぞっただけです。

Make sure to check out the session "Build programmatic UI with Xcode Previews" to learn more about this new powerful API.
この新しい強力な API の詳細については、セッション「Xcode プレビューを使用してプログラムによる UI を構築する」を必ずチェックしてください。

Okay, time to start tweaking these animations.
さて、これらのアニメーションの調整を開始します。

The first thing I want to do is start with the text for the caffeine amount.
まずカフェイン量のテキストから始めたいと思います。

Right now it is just cross-fading with the next value, but I really want to add some drama to the value going up.
現時点では次の値とクロスフェードしているだけですが、値の上昇にドラマチックを加えたいと考えています。

In this case, the view is not changing, but only the text content is, and to animated that, we can use a content transition.
この場合、ビューは変化せず、テキスト コンテンツのみが変化します。これをアニメーション化するには、コンテンツ トランジションを使用できます。

And I'm going to choose add a numeric text with the value of my caffeine.
そして、カフェインの値を示す数値テキストを追加することを選択します。

This is a content transition that is made specifically for important numeric value that we want to give prominence when they change.
これは、変更時に目立つようにしたい重要な数値に対して特別に作成されたコンテンツの遷移です。

I think its looking great! Now, I want to focus on the view showing the last drink.
見た目は素晴らしいと思います!さて、ここで注目したいのは、最後のドリンクを示すビューです。

I want to add a transition to emphasize that a new drink is coming in.
新しいドリンクが登場することを強調するためにトランジションを追加したいと考えています。

The first thing I want to do is to use the ID modifier to associate the identity of this view with specific log it is rendering.
最初に行うことは、ID 修飾子を使用して、このビューの ID を、レンダリングされている特定のログに関連付けることです。

This will inform SwiftUI that whenever this log changes, this is a new view and we need to transition to the new one.
これにより、このログが変更されるたびに、これは新しいビューであり、新しいビューに移行する必要があることが SwiftUI に通知されます。

And now I can specify a transition.
これで、トランジションを指定できるようになりました。

I think a push will be good.
一押しが良いと思います。

From which edge? I think from bottom is a good choice.
どの端からですか？下からというのが良い選択だと思います。

Okay, you already know what to do now.
さて、あなたはもう何をすべきか知っています。

Back to the preview canvas.
プレビュー キャンバスに戻ります。

And yeah, I like this transition from the bottom.
そして、ええ、私はこの下からの移行が好きです。

One last tweak.
最後にもう 1 つ調整します。

I get a little jittery when I drink that much coffee, and I want that reflected with the animation curve for this transition.
コーヒーをたくさん飲むと少しイライラするので、それをこのトランジションのアニメーション カーブに反映させたいと考えています。

What's great is that, like in a regular SwiftUI app, I can use the animation modifier and choose a smooth spring with a shorter duration and bind that animation to my log value.
素晴らしいのは、通常の SwiftUI アプリと同様に、アニメーション モディファイアを使用して、より短い持続時間のスムーズなスプリングを選択し、そのアニメーションをログ値にバインドできることです。

And now, the animation would match my caffeination.
そして今、アニメーションは私のカフェイン摂取と一致するでしょう。

I feel pretty good about what we have now, so let's switch our attention to interactivity.
今あるものについてはかなり満足しているので、インタラクティブ性に注意を切り替えましょう。

With interactivity, you can execute actions right from the widget! Before we jump into Xcode, I want to take a moment to discuss the architecture of how widgets work.
インタラクティブ機能により、ウィジェットから直接アクションを実行できます。 Xcode の説明に入る前に、ウィジェットがどのように機能するかのアーキテクチャについて少し説明したいと思います。

This will allow you to create a better mental model for how interactivity works.
これにより、インタラクティブ性がどのように機能するかについて、より優れたメンタル モデルを作成できるようになります。

When you create a widget, you define a widget extension, which is discovered by the system and run as an independent process.
ウィジェットを作成するときは、システムによって検出され、独立したプロセスとして実行されるウィジェット拡張機能を定義します。

Widgets define a timeline provider that returns a series of entries, which are effectively the widget’s model.
ウィジェットは、事実上ウィジェットのモデルである一連のエントリを返すタイムライン プロバイダーを定義します。

If a widget is visible, the system launches the widget extension process and asks its timeline provider for entries.
ウィジェットが表示されている場合、システムはウィジェット拡張プロセスを起動し、タイムライン プロバイダーにエントリを要求します。

These entries are fed back into the view builder that is part of your widget configuration and used to generate a series of views based on these entries.
これらのエントリは、ウィジェット構成の一部であるビュー ビルダーにフィードバックされ、これらのエントリに基づいて一連のビューを生成するために使用されます。

After that, the system generates a representation of these views and archives it on disk.
その後、システムはこれらのビューの表現を生成し、ディスク上にアーカイブします。

When its time to display a specific entry, the system decodes and renders the archived representation of your widget in its process.
特定のエントリを表示するとき、システムはそのプロセスでウィジェットのアーカイブされた表現をデコードしてレンダリングします。

Let me pause for a second and reiterate this last point.
少し立ち止まって、この最後の点を繰り返したいと思います。

Your view code only runs during archiving.
ビュー コードはアーカイブ中にのみ実行されます。

A separate representation of that view is rendered by the system process.
そのビューの別の表現がシステム プロセスによってレンダリングされます。

But if your data is not static, you might want to update those entries.
ただし、データが静的でない場合は、それらのエントリを更新する必要があるかもしれません。

You can do that by calling the reloadTimelines function in your app whenever you are updating data that is displayed by your widget.
これを行うには、ウィジェットによって表示されるデータを更新するたびに、アプリで reloadTimelines 関数を呼び出します。

This will repeat the process I've just described, regenerate new entries, and archive new copies of the views on disk.
これにより、今説明したプロセスが繰り返され、新しいエントリが再生成され、ビューの新しいコピーがディスクにアーカイブされます。

There are three important takeaways with this architecture.
このアーキテクチャには 3 つの重要な点があります。

First, when your widget is visible, your code is not running.
まず、ウィジェットが表示されているときは、コードは実行されていません。

You drive changes to the widget content by updating its timeline entries, and this is also true of interactive widgets.
タイムライン エントリを更新することでウィジェット コンテンツに変更を加えます。これはインタラクティブ ウィジェットにも当てはまります。

Typically, updates to widgets are done on a best effort basis, but importantly, reloads initiated from an interaction are always guaranteed to occur.
通常、ウィジェットの更新はベスト エフォート ベースで行われますが、重要なのは、インタラクションから開始されるリロードが常に発生することが保証されているということです。

With this out of the way, let’s look at how to add interactivity.
これで、インタラクティブ性を追加する方法を見てみましょう。

What’s great is that you can use controls that you are already familiar with, like Button and Toggle, to make part of your widget interactive.
素晴らしいのは、ボタンやトグルなどの使い慣れたコントロールを使用して、ウィジェットの一部をインタラクティブにできることです。

But remember, since widgets are rendered in a different process, SwiftUI won’t execute your closure, nor mutate your bindings, in your process space.
ただし、ウィジェットは別のプロセスでレンダリングされるため、SwiftUI はプロセス空間でクロージャを実行したり、バインディングを変更したりしないことに注意してください。

So we need a way to represent actions that can be executed by the widget extension and be invoked by the system.
したがって、ウィジェット拡張機能によって実行でき、システムによって呼び出されるアクションを表す方法が必要です。

Thankfully, there is already a solution to this problem: App Intents.
ありがたいことに、この問題にはすでにアプリ インテントという解決策があります。

You might have used app intents to expose actions for your app to Shortcuts or Siri.
アプリのインテントを使用して、アプリのアクションをショートカットまたは Siri に公開した可能性があります。

And now, the same intents can be used to represent the actions in your widget.
そして、同じインテントを使用してウィジェット内のアクションを表すことができるようになりました。

At its very core, AppIntent is a protocol that allows you to define, in code, actions that can be executed by the system.
AppIntent の核心は、システムによって実行できるアクションをコードで定義できるようにするプロトコルです。

For example, here, I’m defining an app intent to toggle a todo item in a todo app.
たとえば、ここでは、ToDo アプリ内の ToDo アイテムを切り替えるアプリ インテントを定義しています。

An intent defines a number of parameters as inputs and an async function called perform, where you will have the business logic to run your intent.
インテントは、入力としての多数のパラメーターと、インテントを実行するためのビジネス ロジックを持つ Perform と呼ばれる非同期関数を定義します。

App Intents are very powerful, and there is a lot more to know about them, so be sure to checkout the “Dive into App Intents” and "Explore enhancements to App Intents” sessions from WWDC22 and 23.
アプリ インテントは非常に強力であり、アプリ インテントについてはさらに知るべきことがたくさんあるため、WWDC22 および 23 の「アプリ インテントの詳細」セッションと「アプリ インテントの機能強化の探索」セッションを必ずチェックしてください。

And to support the ability to execute App Intent right from the UI, when you import both SwiftUI and AppIntents, There is a new family of initializers on Button and Toggle that accept an AppIntent as an argument and will execute that intent when these controls are interacted with.
また、SwiftUI と AppIntents の両方をインポートするときに、UI から App Intent を直接実行する機能をサポートするために、AppIntent を引数として受け入れ、これらのコントロールが操作されたときにそのインテントを実行する新しい初期化子ファミリーが Button と Toggle にあります。と。

Note that only Button and Toggle using AppIntent are supported in interactive widgets.
インタラクティブ ウィジェットでは、AppIntent を使用したボタンとトグルのみがサポートされていることに注意してください。

Other controls won’t work.
他のコントロールは機能しません。

And of course, those initializers work in apps as well, which is cool because you can share the app intent logic between your widget and your app.
そしてもちろん、これらのイニシャライザーはアプリ内でも機能します。これは、ウィジェットとアプリ間でアプリ インテント ロジックを共有できるため、優れています。

Let’s go back to Xcode and our coffee tracker app and add some interactivity.
Xcode とコーヒー トラッカー アプリに戻って、対話機能を追加しましょう。

Currently, the user can log a new drink only by opening the app, but where interactive widget shines is as accelerator to surface the most important actions in your app, and for my app, this is definitely the logging of a new drink.
現在、ユーザーはアプリを開くだけで新しい飲み物を記録できますが、インタラクティブなウィジェットが輝くのは、アプリ内で最も重要なアクションを表示するためのアクセラレーターとしてであり、私のアプリの場合、これは間違いなく新しい飲み物の記録です。

So lets add that to a file I've already created.
それでは、それをすでに作成したファイルに追加してみましょう。

The first thing I want to do is to define a type that conforms to AppIntent to log a new drink.
最初に行うことは、新しい飲み物を記録するために AppIntent に準拠する型を定義することです。

We'll give it a human-readable title that can be used by the system, and then implement the perform requirements by logging an espresso to our store and returning an empty intent result.
システムで使用できる人間が読めるタイトルを付けてから、エスプレッソをストアに記録し、空のインテント結果を返すことで実行要件を実装します。

Something that I want to call your attention to is that perform is an async function and you should take full advantage of it if you are doing any asynchronous work, such as writing to a database exactly like I'm doing here when I'm awaiting the log writing operation.
注意していただきたいのは、perform は非同期関数であり、待機中にここで行っているのとまったく同じようにデータベースに書き込むなど、非同期作業を行う場合には、この関数を最大限に活用する必要があるということです。ログ書き込み操作。

As soon as your perform returns, the system will immediately initiate a reload of your widget timeline, giving you the opportunity to update the content of your widget.
パフォーマンスが戻るとすぐに、システムはウィジェット タイムラインのリロードを開始し、ウィジェットのコンテンツを更新する機会を与えます。

So again, make sure to have persisted all the information necessary to reload your updated widget before returning from perform.
したがって、繰り返しになりますが、実行から戻る前に、更新されたウィジェットをリロードするために必要なすべての情報を永続化していることを確認してください。

I've hard coded the drink to be an espresso, but, of course, we want to be able to pass the specific drink to log.
ドリンクをエスプレッソになるようにハードコードしましたが、もちろん、特定のドリンクをログに渡すことができるようにしたいと考えています。

To do that we can add a stored property with the @Parameter property wrapper and an initializer that populates the all parameters.
これを行うには、@Parameter プロパティ ラッパーを使用して保存されたプロパティと、すべてのパラメーターを設定するイニシャライザーを追加します。

It is important that I use this property wrapper because only the stored properties that are annotated with it are going to be persisted and will be available when the intent is performed in your widget extension.
このプロパティ ラッパーを使用することが重要です。これは、このプロパティ ラッパーで注釈が付けられた保存されたプロパティのみが永続化され、ウィジェット拡張機能でインテントが実行されるときに使用できるためです。

Before we add the button to invoke this intent, I want to highlight an important ecosystem benefit of using App Intents here.
このインテントを呼び出すボタンを追加する前に、ここでアプリ インテントを使用することによるエコシステムの重要な利点を強調したいと思います。

This app intent I've just defined is going to be available in Shortcut and Siri, so the investment in defining it here will pay dividend to your user experience beyond widgets.
私が定義したこのアプリ インテントは、ショートカットと Siri で利用できるようになるため、ここでの定義への投資は、ウィジェットを超えたユーザー エクスペリエンスに利益をもたらすでしょう。

And now we are ready to add the button to the widget.
これで、ウィジェットにボタンを追加する準備が整いました。

Let's create a new view holding our buttons.
ボタンを押したまま新しいビューを作成しましょう。

In this view I'm using this button initializer that take an app intent, so we can pass the one we just defined.
このビューでは、アプリのインテントを受け取るこのボタン初期化子を使用しているため、定義したばかりのインテントを渡すことができます。

And let's add this view to the rest of the widget with some spacers.
そして、いくつかのスペーサーを使用して、このビューをウィジェットの残りの部分に追加しましょう。

Now we have everything in place, let's see how this is working out on the widget by building and running.
これですべてが整ったので、ウィジェットを構築して実行して、これがどのように機能するかを見てみましょう。

A little tip here: you can actually have directly build the target for the widget extension and Xcode will install the widget right on the home screen for you.
ここでちょっとしたヒント: 実際にウィジェット拡張機能のターゲットを直接ビルドすることができ、Xcode がウィジェットをホーム画面に直接インストールします。

My widget now has the button I've just defined.
ウィジェットには、先ほど定義したボタンが追加されました。

If I tap on it, I can log this last cup of espresso.
これをタップすると、エスプレッソの最後の一杯を記録できます。

But there is also one additional change I want to make so that my widget provides the best user experience possible.
ただし、ウィジェットが可能な限り最高のユーザー エクスペリエンスを提供できるように、追加の変更を 1 つ加えたいと思います。

When your app intent finishes to perform, it will cause a widget to reload its timeline.
アプリのインテントの実行が完了すると、ウィジェットがタイムラインを再読み込みします。

This can introduce a small latency from the action, to the resulting change in the UI.
これにより、アクションから UI の変更が生じるまでにわずかな遅延が発生する可能性があります。

But this latency can become more pronounced with iPhone widget on Mac so we are providing a solution out of the box for it.
ただし、この遅延は Mac 上の iPhone ウィジェットではさらに顕著になる可能性があるため、私たちはそれに対するすぐに使えるソリューションを提供しています。

For example, in my widget, the value showing the total amount of caffeine won't update until an updated entry arrived.
たとえば、私のウィジェットでは、カフェインの総量を示す値は、更新されたエントリが到着するまで更新されません。

We can annotate this view with the invalidatableContent modifier.
このビューには、invalidatableContent 修飾子を使用して注釈を付けることができます。

I've added this widget from my iPhone to my Mac.
このウィジェットを iPhone から Mac に追加しました。

Let's tap on the button.
ボタンをタップしてみましょう。

The view showing the caffeine amount shows a system effect to indicate that its value is invalidated until an update comes in.
カフェイン量を示すビューには、更新が行われるまでその値が無効であることを示すシステム効果が表示されます。

We just saw Button in action and how with the invalidatableContent modifier, you can help users improve the perception of latency.
Button の動作と、invalidatableContent 修飾子を使用して、ユーザーのレイテンシーの認識を改善する方法を確認しました。

Use this modifier judiciously.
この修飾子は慎重に使用してください。

You don't need to annotate every single view that might change.
変更される可能性のあるすべてのビューに注釈を付ける必要はありません。

You should use this modifier with views that are meaningful to set the right expectation with your users.
この修飾子は、ユーザーに適切な期待を与えるために意味のあるビューで使用する必要があります。

Toggle goes one step further and will optimistically update its presentation when interacted with without having to wait for a roundtrip to the widget extension and back.
Toggle はさらに一歩進んで、ウィジェット拡張機能との往復を待つことなく、操作されたときにプレゼンテーションを楽観的に更新します。

This is done automatically, on your behalf, at archive time, by pre-rendering the toggle style in both configurations.
これは、両方の構成でトグル スタイルを事前レンダリングすることにより、アーカイブ時にユーザーに代わって自動的に行われます。

Make sure, if you define your own toggle style, to check the configuration isOn property from the style and use that to switch the appearance.
独自の切り替えスタイルを定義する場合は、そのスタイルから構成 isOn プロパティを確認し、それを使用して外観を切り替えてください。

This concludes our overview for interactivity and animations.
これで、インタラクティブ性とアニメーションの概要は終わりです。

With animations and interactivity, you have the opportunity to infuse new life into your widgets and with widgets now in all these new locations, you can bring these little, delightful interactions to your users wherever they are.
アニメーションとインタラクティブ性を使用すると、ウィジェットに新しい命を吹き込む機会が得られ、これらすべての新しい場所にウィジェットが配置されるようになり、ユーザーがどこにいても、これらの小さな楽しいインタラクションをユーザーに提供できるようになります。

So make sure to fine tune the animations for your widgets with the help of the new Xcode Preview APIs and look out for the most important actions in your app and surface them in your widget, giving your user powerful interactions whenever and wherever they need them.
したがって、新しい Xcode プレビュー API を利用してウィジェットのアニメーションを微調整し、アプリ内で最も重要なアクションを探してウィジェットに表示し、いつでもどこでも必要なときにユーザーに強力なインタラクションを提供できるようにしてください。

Thanks you!
ありがとうございます！


""",
      timestamp: Date()
    )
  }
}
