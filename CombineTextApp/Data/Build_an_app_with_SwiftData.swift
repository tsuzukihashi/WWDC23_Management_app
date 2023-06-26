import Foundation

extension ItemViewData {
  static var Build_an_app_with_SwiftData: ItemViewData {
    .init(
      id: UUID().uuidString,
      title: "Build an app with SwiftData",
      linkURL: URL(string: "https://developer.apple.com/wwdc23/10154"),
      firstText:"""
Julia: Hello! My name is Julia.
I'm a SwiftUI Engineer.
Recently, we've introduced SwiftData, a new way to persist your model layer in Swift.
In today's session, let's see how to seamlessly integrate SwiftData in a SwiftUI app.
We will discuss the new SwiftUI features that allow for smooth integration with SwiftData models.
To cover your basics, watch the "Meet SwiftData" session first if you haven’t already.
To see how SwiftData and SwiftUI play together, let’s build a flashcards app.
For some time, I’ve wanted to make a tool that can help me remember dates and authors of great inventions, and SwiftData is perfect for this task.
It will help to persist the flashcard decks, so I can open and click through them whenever I got a minute.
I want this app to work everywhere: on Mac, iPhone, Watch, and TV, and SwiftData has my back.
It is available across all the platforms.
This is a code-along.
During this session, I will be building an app with you.
Hit pause now, and download the companion Xcode projects: an archive with the prepared starting point, and the finished one.
Open the starter project, and go to the ContentView file.
Throughout this session, we will leverage a new Xcode feature, embedded interactive live Previews for Mac.
In the Previews section, there's a grid with some flash cards.
A click on any card transitions into a view where we can scroll the cards one by one.
Do you remember who invented the compiler? Click the card.
It flips and gives an answer! The app is populated with sample cards stored in memory, and if we run the app and add new ones, they will disappear when we close the app.
This is where SwiftData comes in.
We will use it to persist the flashcards we create.
Today, we will talk about everything you need to know to start using SwiftData, checking off one item after another in this to-do list that I put together for us.
You have just met the app we will build.
Next, we’ll take a look at the starter project and its model class.
Then, step by step, we will convert and amend it to use SwiftData as its storage.
We’ll learn how to expand the model class to become SwiftData model, how to query the data and update the view on every change in the model layer, create and save models, and conveniently bind UI elements to them.
And at the end, as a bonus, we’ll see how easy it is to create a document-based app when SwiftData takes care of the storage.
In the starter project, I defined a Card model that represents a single flash card, some views, and supporting files to save us time.
Every card stores the text for the front and back sides and the creation date.
It is a pretty typical model.
Let’s update it so that SwiftData can store it for us.
First, import SwiftData into this file.
And next, the main change that we need to make is adding the @Model macro to the definition.
And now, the class is fully persistable with SwiftData.
No more typing.
That’s it! And even more: with @Model, the Card gets conformance to the Observable protocol, and we will use it instead of ObservableObject.
Remove the conformance to the Observable object as well as @Published property wrappers.
We previously used the ObservedObject conformance to edit the card directly from the UI in the CardEditorView file.
To adopt Observable here, we replace the "ObservedObject" property wrapper with "Bindable." It allows the text fields to bind directly to the card's front...
and back text.
Done! New Observable macro and Bindable property wrapper allow to effortlessly set up the data flow in an application with even less code than before.
When a View uses a property of an Observable type in its body, it will be updated automatically when the given property changes.
And it has never been that easy to bind a model's mutable state to UI elements! I encourage you to watch the WWDC23 session, "Discover Observation with SwiftUI." You'll be surprised how Observable simplifies the data flow code with or without SwiftData.
And that’s all you need to know about the models.
Nothing more.
How cool is that? Next, to query models from SwiftData and display them in the UI, let’s switch to ContentView.
Instead of the SampleDeck.contents, we will display the cards that SwiftData has.

And there’s a single change that I need to make to bind the cards array to SwiftData storage: replace @State property wrapper with @Query.
That’s it! As we can see in the preview, there are no more cards to display, probably because we haven’t saved any.
Use @Query whenever you want to display models, managed by SwiftData, in the UI.
@Query is a new property wrapper that queries the models from SwiftData.
It also triggers the view updated on every change of the models, similarly to how @State would do that.
Every view can have as many queried properties as it needs.
Query offers lightweight syntax to configure sorting, ordering, filtering, and even animating changes.
Under the hood, it uses a model context of the view as the data source.
How do we provide @Query with a model context? We'll get one from a model container.
SwiftUI vends a new view and scene modifier for a convenient setup of the view’s ModelContainer.
To use SwiftData, any application has to set up at least one ModelContainer.
It creates the whole storage stack, including the context that @Query will use.
A View has a single model container, but an application can create and use as many containers as it needs for different view hierarchies.
If the application does not set up its modelContainer, its windows and the views it creates can not save or query models via SwiftData.
Many applications need a single model container.
In this case, you can set it up for the whole window group scene.
The window and its views will inherit the container, as well as any other windows created from the same group.
All of these views will write and read from a single container.
Some apps need a few storage stacks, and they can set up several model containers for different windows.
SwiftUI also allows for a granular setup on a view level.
Different views in the same window can have separate containers, and saving in one container won’t affect another.
Now, let's set up the modelContainer to provide the Query with a source of data.
I open the app definition...

And set a model container for app's windows.
Note that the subviews can create, read, update, and delete only the model types listed in the view modifier.
And we are done with the setup! Although, I want to take one extra step: provide my previews with sample data.
In the app, I have defined an in-memory container with sample cards.
Let's open the "PreviewSampleData" file and include it in the target.
This file contains the definition of a container with the sample data.
I will use it in the ContentView to fill my preview with sample cards.
 Now that @Query has a source of data, the preview displays the cards! And this is all the setup that’s required to have SwiftData stack ready and generate a preview.
Next, I want to make sure that SwiftData tracks and saves the new cards that I create, as well as the changes made to the existing ones.
To do that, I will use the model context of the view.
To access the model context, SwiftUI offers a new environment variable.
Similarly to model container, each view has a single context, but an application, in general, can have as many as it needs.
In our app, the context is already configured.
This environment variable was populated automatically when we set the model container earlier.
Let’s switch back to Xcode.
We will need to access the modelContext to save and update the cards.
  We insert the newly created card in the model context to make SwiftData aware of the model we want to store.

You might think that after inserting the model, you need to save the context, calling "modelContext.save()," but you don't need to do that.
A nice detail about SwiftData is that it autosaves the model context.
The autosaves are triggered by UI-related events and user input.
We don’t need to worry about saving because SwiftData does it for us.
There are only a few cases when you want to make sure that all the changes are persisted immediately, for example, before sharing the SwiftData storage or sending it over.
In these cases, call "save()" explicitly.
Now that our app can save and query the cards, let’s create one! I run the app...
and press plus button to create a card.
Let's add that Compiler card that we saw before.
 Now, let’s quit the app, launch it again, and see if our new card is there.

And here it is! Now you know how to access the model context of the view and add cards.
Done! Let’s open a new window.
It displays the same deck as the first one, which makes sense, since both windows use the same model container and access the same data.
It would be nice, though, if the app could open different flash card decks in different windows.
Essentially, it means that I want to treat every deck as a separate document.
Then, I can share these documents with friends.
Document-based apps is a concept used on macOS, iOS, and iPadOS.
It describes the certain types of applications that allow users to create, open, view, or edit different types of documents.
Every document is a file, and users can store, copy, and share them.
And I am excited to let you know that SwiftUI supports SwiftData-backed document apps.
Let’s try this approach.
I open the FlashCardApp file.
Document-based apps exist on iOS and macOS, and on these platforms, we'll switch to using the DocumentGroup initializer.

  I will be passing in the model type Card.self, content type, and a view builder.
  Let's take a short detour and talk about the second parameter, content type, in more detail! SwiftData Document-based apps need to declare custom content types.
  Each SwiftData document is built from a unique set of models and so has a unique representation on disk.
  In the context of documents, you can think of a content type as of a binary file format, like JPEG.
  Another type of documents, a package, is a directory with a fixed structure on disk, like an Xcode project.
  For example, all the JPEG images have the same binary structure.
  Otherwise, photo editors wouldn’t know how to read them.
  Similarly, all the Xcode projects contain certain directories and files.
  When the user opens the deck, we need the operating system to associate the deck format and file extension with our app.
  That’s why we need to declare the content type.
  SwiftData documents are packages: if you mark some properties of a SwiftData model with the “externalStorage” attribute, all the externally stored items will be a part of the document package.
  In the UTType+FlashCards file, I have a definition of the new content type, so we can conveniently use it in code.
  We'll put the same definition in the Info.plist.

We are about to declare a new content type in the operating system.
We need to specify the file extension to help to distinguish the card decks created by our app from any other documents.
For this sample app, we’ll use “sampledeck” as an extension.

I will also add a short description, like Flash Cards Deck.

The identifier should be exactly the same as the one in the code.

Because SwiftData documents are packages, we have to make sure our type conforms to com.apple.package.
And now, let’s use the content type that we declared.
I am returning to the app definition and passing the content type to the DocumentGroup.
The view builder looks identical.

Notably, we don’t set up the model container.
The document infrastructure will set up one for each document.
Let's run the application and see how it looks now! The app launches with the open panel.
Standard behavior for Document-based applications.
I'll create a new document and add a card there.
The document now has a toolbar subtitle indicating that it has unsaved changes.
I press Command+S, and the save dialog appears.
Note that the deck will be saved with the same file extension that we put in the Info.plist earlier.
I'll save the new deck, and here it is, my first flashcards deck, on the Desktop.
I can also press Command+N to create a new deck, or Command+O to open one.
These shortcuts, as well as many other features, Document-based applications get automatically.
Just to recap, today, we’ve learned how to use SwiftData storage in SwiftUI apps.
We talked about the new @Model macro, @Query property wrapper, and the new Environment variable for model context, and saw how easy it is to use SwiftData as a storage for your documents.
Thanks for joining me today, and have fun building apps!
""",
      translateText: """
ジュリア：こんにちは！私の名前はジュリアです。
SwiftUIエンジニアです。
最近、Swift でモデル レイヤーを永続化する新しい方法である SwiftData を導入しました。
今日のセッションでは、SwiftData を SwiftUI アプリにシームレスに統合する方法を見てみましょう。
SwiftData モデルとのスムーズな統合を可能にする新しい SwiftUI 機能について説明します。
基本をカバーするには、「Meet SwiftData」セッションをまだ視聴していない場合は、まず視聴してください。
SwiftData と SwiftUI がどのように連携するかを確認するために、フラッシュカード アプリを構築してみましょう。
しばらくの間、私は偉大な発明の日付と作者を思い出すのに役立つツールを作りたいと思っていました。SwiftData はこのタスクに最適です。
フラッシュカード デッキを保存しておくのに役立つので、時間があればいつでも開いてクリックできます。
私はこのアプリを Mac、iPhone、Watch、TV などどこでも動作させたいと思っていますが、SwiftData が私をサポートしてくれます。
すべてのプラットフォームで利用できます。
これはコードアロングです。
このセッションでは、あなたと一緒にアプリを構築します。
今すぐ一時停止を押して、コンパニオン Xcode プロジェクト (準備された開始点と完成したプロジェクトを含むアーカイブ) をダウンロードします。
スターター プロジェクトを開き、ContentView ファイルに移動します。
このセッションでは、Xcode の新しい機能である、Mac 用の埋め込まれたインタラクティブなライブ プレビューを活用します。
[プレビュー] セクションには、いくつかのフラッシュ カードを含むグリッドがあります。
任意のカードをクリックすると、カードを 1 枚ずつスクロールできるビューに遷移します。
コンパイラを誰が発明したか覚えていますか?カードをクリックします。
ひっくり返して答えを出します！アプリにはメモリに保存されたサンプル カードが読み込まれており、アプリを実行して新しいカードを追加すると、アプリを閉じるとそれらのカードは消えます。
ここで SwiftData が登場します。
これを使用して、作成したフラッシュカードを永続化します。
今日は、SwiftData の使用を開始するために知っておくべきことすべてについて説明し、私が作成したこの To Do リストの項目を 1 つずつチェックしていきます。
これから構築するアプリに出会ったばかりです。
次に、スターター プロジェクトとそのモデル クラスを見ていきます。
次に、段階的に、SwiftData をストレージとして使用するように変換および修正します。
モデル クラスを拡張して SwiftData モデルにする方法、データをクエリしてモデル レイヤーのすべての変更に応じてビューを更新する方法、モデルを作成して保存する方法、UI 要素をモデルに簡単にバインドする方法を学びます。
最後に、おまけとして、SwiftData がストレージを処理する場合、ドキュメント ベースのアプリを作成するのがいかに簡単かを確認します。
スターター プロジェクトでは、時間を節約するために、1 つのフラッシュ カード、いくつかのビュー、およびサポート ファイルを表すカード モデルを定義しました。
すべてのカードには、表と裏のテキストと作成日が保存されます。
かなり典型的なモデルです。
SwiftData がそれを保存できるように更新しましょう。
まず、SwiftData をこのファイルにインポートします。
次に、行う必要がある主な変更は、@Model マクロを定義に追加することです。
そして今、クラスは SwiftData で完全に永続化可能です。
もう入力する必要はありません。
それでおしまい！さらに、@Model を使用すると、カードは Observable プロトコルに準拠し、ObservableObject の代わりにそれを使用します。
Observable オブジェクトおよび @Published プロパティ ラッパーへの準拠を削除します。
以前は、ObservedObject 準拠を使用して、CardEditorView ファイルの UI からカードを直接編集していました。
ここで Observable を採用するには、「ObservedObject」プロパティ ラッパーを「Bindable」に置き換えます。これにより、テキスト フィールドをカードの前面に直接バインドできるようになります。
そしてバックテキスト。
終わり！新しい Observable マクロと Bindable プロパティ ラッパーを使用すると、以前よりもさらに少ないコードでアプリケーション内のデータ フローを簡単にセットアップできます。
ビューがその本体で Observable タイプのプロパティを使用する場合、指定されたプロパティが変更されると自動的に更新されます。
そして、モデルの可変状態を UI 要素にバインドするのがこれまでになく簡単になりました。 WWDC23 セッション「Discover Observation with SwiftUI」をぜひご覧ください。 SwiftData の有無にかかわらず、Observable がデータ フロー コードをいかに簡素化するかに驚かれるでしょう。
モデルについて知っておくべきことはこれだけです。
これ以上何もない。
なんてクールなんでしょう？次に、SwiftData からモデルをクエリして UI に表示するために、ContentView に切り替えましょう。
SampleDeck.contents の代わりに、SwiftData が持つカードを表示します。

そして、カード配列を SwiftData ストレージにバインドするために必要な変更が 1 つあります。それは、@State プロパティ ラッパーを @Query に置き換えることです。
それでおしまい！プレビューでわかるように、これ以上表示するカードはありません。おそらく何も保存していないためです。
SwiftData によって管理されるモデルを UI に表示する場合は、常に @Query を使用します。
@Query は、SwiftData からモデルをクエリする新しいプロパティ ラッパーです。
また、@State の場合と同様に、モデルが変更されるたびにビューの更新もトリガーされます。
すべてのビューには、必要なだけクエリされたプロパティを含めることができます。
クエリは、並べ替え、順序付け、フィルタリング、さらにはアニメーション化する変更を構成する軽量の構文を提供します。
内部では、ビューのモデル コンテキストをデータ ソースとして使用します。
@Query にモデル コンテキストを提供するにはどうすればよいでしょうか?モデル コンテナから 1 つを取得します。
SwiftUI は、ビューの ModelContainer を便利にセットアップできるように、新しいビューとシーン修飾子を提供します。
SwiftData を使用するには、どのアプリケーションでも少なくとも 1 つの ModelContainer をセットアップする必要があります。
@Query が使用するコンテキストを含む、ストレージ スタック全体を作成します。
ビューには単一のモデル コンテナーがありますが、アプリケーションはさまざまなビュー階層に必要な数のコンテナーを作成して使用できます。
アプリケーションがmodelContainerを設定しない場合、アプリケーションのウィンドウとアプリケーションが作成するビューは、SwiftData経由でモデルを保存したりクエリしたりすることができません。
多くのアプリケーションは単一のモデル コンテナーを必要とします。
この場合、ウィンドウグループシーン全体に設定できます。
ウィンドウとそのビューは、同じグループから作成された他のウィンドウと同様に、コンテナを継承します。
これらのビューはすべて、単一のコンテナーから書き込みと読み取りを行います。
一部のアプリはいくつかのストレージ スタックを必要とし、さまざまなウィンドウに複数のモデル コンテナーをセットアップできます。
SwiftUI では、ビュー レベルでの詳細なセットアップも可能です。
同じウィンドウ内の異なるビューには個別のコンテナーを含めることができ、1 つのコンテナーに保存しても他のコンテナーには影響しません。
次に、クエリにデータのソースを提供するようにmodelContainerを設定しましょう。
アプリ定義を開くと…

そしてアプリのウィンドウにモデルコンテナを設定します。
サブビューは、ビュー修飾子にリストされているモデル タイプのみを作成、読み取り、更新、削除できることに注意してください。
これでセットアップは完了です。ただし、もう 1 つ追加の手順を実行して、プレビューにサンプル データを提供したいと思います。
アプリでは、サンプル カードを含むメモリ内コンテナーを定義しました。
「PreviewSampleData」ファイルを開いてターゲットに含めてみましょう。
このファイルには、サンプル データを含むコンテナーの定義が含まれています。
これを ContentView で使用して、プレビューにサンプル カードを入力します。
 @Query にデータのソースがあるので、プレビューにカードが表示されます。 SwiftData スタックを準備してプレビューを生成するために必要な設定はこれですべてです。
次に、作成した新しいカードと既存のカードに加えた変更が SwiftData で追跡および保存されることを確認したいと思います。
これを行うには、ビューのモデル コンテキストを使用します。
モデル コンテキストにアクセスするために、SwiftUI は新しい環境変数を提供します。
モデル コンテナーと同様に、各ビューには 1 つのコンテキストがありますが、アプリケーションは一般に、必要なだけコンテキストを持つことができます。
私たちのアプリでは、コンテキストはすでに構成されています。
この環境変数は、前にモデル コンテナーを設定したときに自動的に設定されました。
Xcode に戻りましょう。
カードを保存して更新するには、modelContext にアクセスする必要があります。
  新しく作成したカードをモデル コンテキストに挿入して、保存したいモデルを SwiftData に認識させます。

モデルを挿入した後、「modelContext.save()」を呼び出してコンテキストを保存する必要があると思われるかもしれませんが、その必要はありません。
SwiftData の優れた点は、モデル コンテキストを自動保存することです。
自動保存は、UI 関連のイベントとユーザー入力によってトリガーされます。
保存については SwiftData が自動的に実行してくれるため、心配する必要はありません。
たとえば、SwiftData ストレージを共有したり送信したりする前など、すべての変更が即座に永続化されていることを確認したい場合は、ほとんどありません。
このような場合は、「save()」を明示的に呼び出してください。
アプリがカードを保存してクエリできるようになったので、カードを作成してみましょう。アプリを実行します...
プラスボタンを押してカードを作成します。
前に見たコンパイラー カードを追加しましょう。
 次に、アプリを終了し、再度起動して、新しいカードが存在するかどうかを確認してみましょう。

そしてここにあります！これで、ビューのモデル コンテキストにアクセスしてカードを追加する方法がわかりました。
終わり！新しいウィンドウを開いてみましょう。
最初のデッキと同じデッキが表示されます。これは、両方のウィンドウが同じモデル コンテナーを使用し、同じデータにアクセスするため、当然のことです。
ただし、アプリが別のウィンドウで別のフラッシュ カード デッキを開くことができれば素晴らしいでしょう。
本質的に、これはすべてのデッキを別個のドキュメントとして扱いたいことを意味します。
そうすれば、これらのドキュメントを友人と共有できます。
ドキュメントベースのアプリは、macOS、iOS、iPadOS で使用される概念です。
ここでは、ユーザーがさまざまな種類のドキュメントを作成、開く、表示、または編集できるようにする特定の種類のアプリケーションについて説明します。
すべてのドキュメントはファイルであり、ユーザーはドキュメントを保存、コピー、共有できます。
そして、SwiftUI が SwiftData を利用したドキュメント アプリをサポートしていることをお知らせできることを嬉しく思います。
このアプローチを試してみましょう。
FlashCardApp ファイルを開きます。
ドキュメントベースのアプリは iOS と macOS に存在します。これらのプラットフォームでは、DocumentGroup 初期化子の使用に切り替えます。

  モデル タイプ Card.self、コンテンツ タイプ、およびビュー ビルダーを渡します。
  少し寄り道して、2 番目のパラメーターであるコンテンツ タイプについて詳しく説明しましょう。 SwiftData ドキュメントベースのアプリでは、カスタム コンテンツ タイプを宣言する必要があります。
  各 SwiftData ドキュメントは一意のモデル セットから構築されているため、ディスク上で一意の表現を持ちます。
  ドキュメントのコンテキストでは、コンテンツ タイプは JPEG などのバイナリ ファイル形式と考えることができます。
  もう 1 つのタイプのドキュメントであるパッケージは、Xcode プロジェクトのようなディスク上の固定構造を持つディレクトリです。
  たとえば、すべての JPEG 画像は同じバイナリ構造を持っています。
  そうしないと、写真編集者は写真の読み方がわかりません。
  同様に、すべての Xcode プロジェクトには特定のディレクトリとファイルが含まれています。
  ユーザーがデッキを開くとき、オペレーティング システムがデッキの形式とファイル拡張子をアプリに関連付ける必要があります。
  そのため、コンテンツ タイプを宣言する必要があります。
  SwiftData ドキュメントはパッケージです。SwiftData モデルの一部のプロパティを「externalStorage」属性でマークすると、外部に保存されたすべてのアイテムがドキュメント パッケージの一部になります。
  UTType+FlashCards ファイルには、新しいコンテンツ タイプの定義があるため、コードで便利に使用できます。
  同じ定義を Info.plist に入れます。

オペレーティング システムで新しいコンテンツ タイプを宣言しようとしています。
アプリで作成したカードデッキを他のドキュメントと区別しやすくするために、ファイル拡張子を指定する必要があります。
このサンプルアプリでは、拡張機能として「sampledeck」を使用します。

Flash Cards Deck などの簡単な説明も追加します。

識別子はコード内の識別子とまったく同じである必要があります。

SwiftData ドキュメントはパッケージであるため、型が com.apple.package に準拠していることを確認する必要があります。
それでは、宣言したコンテンツ タイプを使用してみましょう。
アプリ定義に戻り、コンテンツ タイプを DocumentGroup に渡します。
ビュービルダーは同じように見えます。

特に、モデル コンテナーはセットアップしません。
ドキュメント インフラストラクチャは、ドキュメントごとに 1 つをセットアップします。
アプリケーションを実行して、どのように表示されるかを見てみましょう。アプリが起動し、パネルが開いた状態になります。
ドキュメントベースのアプリケーションの標準動作。
新しいドキュメントを作成し、そこにカードを追加します。
ドキュメントには、未保存の変更があることを示すツールバーのサブタイトルが表示されます。
Command+S を押すと、保存ダイアログが表示されます。
デッキは、前に Info.plist に入れたのと同じファイル拡張子で保存されることに注意してください。
新しいデッキをデスクトップに保存します。これが最初のフラッシュカード デッキです。
Command+N を押して新しいデッキを作成したり、Command+O を押してデッキを開くこともできます。
これらのショートカットや他の多くの機能は、ドキュメントベースのアプリケーションに自動的に追加されます。
要約すると、今日は SwiftUI アプリで SwiftData ストレージを使用する方法を学びました。
新しい @Model マクロ、@Query プロパティ ラッパー、モデル コンテキストの新しい環境変数について説明し、SwiftData をドキュメントのストレージとして使用することがいかに簡単であるかを確認しました。
本日はご参加いただきありがとうございます。アプリの構築を楽しんでください。
""",
      combineText: """
Julia: Hello! My name is Julia.
ジュリア：こんにちは！私の名前はジュリアです。

I'm a SwiftUI Engineer.
SwiftUIエンジニアです。

Recently, we've introduced SwiftData, a new way to persist your model layer in Swift.
最近、Swift でモデル レイヤーを永続化する新しい方法である SwiftData を導入しました。

In today's session, let's see how to seamlessly integrate SwiftData in a SwiftUI app.
今日のセッションでは、SwiftData を SwiftUI アプリにシームレスに統合する方法を見てみましょう。

We will discuss the new SwiftUI features that allow for smooth integration with SwiftData models.
SwiftData モデルとのスムーズな統合を可能にする新しい SwiftUI 機能について説明します。

To cover your basics, watch the "Meet SwiftData" session first if you haven’t already.
基本をカバーするには、「Meet SwiftData」セッションをまだ視聴していない場合は、まず視聴してください。

To see how SwiftData and SwiftUI play together, let’s build a flashcards app.
SwiftData と SwiftUI がどのように連携するかを確認するために、フラッシュカード アプリを構築してみましょう。

For some time, I’ve wanted to make a tool that can help me remember dates and authors of great inventions, and SwiftData is perfect for this task.
しばらくの間、私は偉大な発明の日付と作者を思い出すのに役立つツールを作りたいと思っていました。SwiftData はこのタスクに最適です。

It will help to persist the flashcard decks, so I can open and click through them whenever I got a minute.
フラッシュカード デッキを保存しておくのに役立つので、時間があればいつでも開いてクリックできます。

I want this app to work everywhere: on Mac, iPhone, Watch, and TV, and SwiftData has my back.
私はこのアプリを Mac、iPhone、Watch、TV などどこでも動作させたいと思っていますが、SwiftData が私をサポートしてくれます。

It is available across all the platforms.
すべてのプラットフォームで利用できます。

This is a code-along.
これはコードアロングです。

During this session, I will be building an app with you.
このセッションでは、あなたと一緒にアプリを構築します。

Hit pause now, and download the companion Xcode projects: an archive with the prepared starting point, and the finished one.
今すぐ一時停止を押して、コンパニオン Xcode プロジェクト (準備された開始点と完成したプロジェクトを含むアーカイブ) をダウンロードします。

Open the starter project, and go to the ContentView file.
スターター プロジェクトを開き、ContentView ファイルに移動します。

Throughout this session, we will leverage a new Xcode feature, embedded interactive live Previews for Mac.
このセッションでは、Xcode の新しい機能である、Mac 用の埋め込まれたインタラクティブなライブ プレビューを活用します。

In the Previews section, there's a grid with some flash cards.
[プレビュー] セクションには、いくつかのフラッシュ カードを含むグリッドがあります。

A click on any card transitions into a view where we can scroll the cards one by one.
任意のカードをクリックすると、カードを 1 枚ずつスクロールできるビューに遷移します。

Do you remember who invented the compiler? Click the card.
コンパイラを誰が発明したか覚えていますか?カードをクリックします。

It flips and gives an answer! The app is populated with sample cards stored in memory, and if we run the app and add new ones, they will disappear when we close the app.
ひっくり返して答えを出します！アプリにはメモリに保存されたサンプル カードが読み込まれており、アプリを実行して新しいカードを追加すると、アプリを閉じるとそれらのカードは消えます。

This is where SwiftData comes in.
ここで SwiftData が登場します。

We will use it to persist the flashcards we create.
これを使用して、作成したフラッシュカードを永続化します。

Today, we will talk about everything you need to know to start using SwiftData, checking off one item after another in this to-do list that I put together for us.
今日は、SwiftData の使用を開始するために知っておくべきことすべてについて説明し、私が作成したこの To Do リストの項目を 1 つずつチェックしていきます。

You have just met the app we will build.
これから構築するアプリに出会ったばかりです。

Next, we’ll take a look at the starter project and its model class.
次に、スターター プロジェクトとそのモデル クラスを見ていきます。

Then, step by step, we will convert and amend it to use SwiftData as its storage.
次に、段階的に、SwiftData をストレージとして使用するように変換および修正します。

We’ll learn how to expand the model class to become SwiftData model, how to query the data and update the view on every change in the model layer, create and save models, and conveniently bind UI elements to them.
モデル クラスを拡張して SwiftData モデルにする方法、データをクエリしてモデル レイヤーのすべての変更に応じてビューを更新する方法、モデルを作成して保存する方法、UI 要素をモデルに簡単にバインドする方法を学びます。

And at the end, as a bonus, we’ll see how easy it is to create a document-based app when SwiftData takes care of the storage.
最後に、おまけとして、SwiftData がストレージを処理する場合、ドキュメント ベースのアプリを作成するのがいかに簡単かを確認します。

In the starter project, I defined a Card model that represents a single flash card, some views, and supporting files to save us time.
スターター プロジェクトでは、時間を節約するために、1 つのフラッシュ カード、いくつかのビュー、およびサポート ファイルを表すカード モデルを定義しました。

Every card stores the text for the front and back sides and the creation date.
すべてのカードには、表と裏のテキストと作成日が保存されます。

It is a pretty typical model.
かなり典型的なモデルです。

Let’s update it so that SwiftData can store it for us.
SwiftData がそれを保存できるように更新しましょう。

First, import SwiftData into this file.
まず、SwiftData をこのファイルにインポートします。

And next, the main change that we need to make is adding the @Model macro to the definition.
次に、行う必要がある主な変更は、@Model マクロを定義に追加することです。

And now, the class is fully persistable with SwiftData.
そして今、クラスは SwiftData で完全に永続化可能です。

No more typing.
もう入力する必要はありません。

That’s it! And even more: with @Model, the Card gets conformance to the Observable protocol, and we will use it instead of ObservableObject.
それでおしまい！さらに、@Model を使用すると、カードは Observable プロトコルに準拠し、ObservableObject の代わりにそれを使用します。

Remove the conformance to the Observable object as well as @Published property wrappers.
Observable オブジェクトおよび @Published プロパティ ラッパーへの準拠を削除します。

We previously used the ObservedObject conformance to edit the card directly from the UI in the CardEditorView file.
以前は、ObservedObject 準拠を使用して、CardEditorView ファイルの UI からカードを直接編集していました。

To adopt Observable here, we replace the "ObservedObject" property wrapper with "Bindable." It allows the text fields to bind directly to the card's front...
ここで Observable を採用するには、「ObservedObject」プロパティ ラッパーを「Bindable」に置き換えます。これにより、テキスト フィールドをカードの前面に直接バインドできるようになります。

and back text.
そしてバックテキスト。

Done! New Observable macro and Bindable property wrapper allow to effortlessly set up the data flow in an application with even less code than before.
終わり！新しい Observable マクロと Bindable プロパティ ラッパーを使用すると、以前よりもさらに少ないコードでアプリケーション内のデータ フローを簡単にセットアップできます。

When a View uses a property of an Observable type in its body, it will be updated automatically when the given property changes.
ビューがその本体で Observable タイプのプロパティを使用する場合、指定されたプロパティが変更されると自動的に更新されます。

And it has never been that easy to bind a model's mutable state to UI elements! I encourage you to watch the WWDC23 session, "Discover Observation with SwiftUI." You'll be surprised how Observable simplifies the data flow code with or without SwiftData.
そして、モデルの可変状態を UI 要素にバインドするのがこれまでになく簡単になりました。 WWDC23 セッション「Discover Observation with SwiftUI」をぜひご覧ください。 SwiftData の有無にかかわらず、Observable がデータ フロー コードをいかに簡素化するかに驚かれるでしょう。

And that’s all you need to know about the models.
モデルについて知っておくべきことはこれだけです。

Nothing more.
これ以上何もない。

How cool is that? Next, to query models from SwiftData and display them in the UI, let’s switch to ContentView.
なんてクールなんでしょう？次に、SwiftData からモデルをクエリして UI に表示するために、ContentView に切り替えましょう。

Instead of the SampleDeck.contents, we will display the cards that SwiftData has.
SampleDeck.contents の代わりに、SwiftData が持つカードを表示します。

And there’s a single change that I need to make to bind the cards array to SwiftData storage: replace @State property wrapper with @Query.
そして、カード配列を SwiftData ストレージにバインドするために必要な変更が 1 つあります。それは、@State プロパティ ラッパーを @Query に置き換えることです。

That’s it! As we can see in the preview, there are no more cards to display, probably because we haven’t saved any.
それでおしまい！プレビューでわかるように、これ以上表示するカードはありません。おそらく何も保存していないためです。

Use @Query whenever you want to display models, managed by SwiftData, in the UI.
SwiftData によって管理されるモデルを UI に表示する場合は、常に @Query を使用します。

@Query is a new property wrapper that queries the models from SwiftData.
@Query は、SwiftData からモデルをクエリする新しいプロパティ ラッパーです。

It also triggers the view updated on every change of the models, similarly to how @State would do that.
また、@State の場合と同様に、モデルが変更されるたびにビューの更新もトリガーされます。

Every view can have as many queried properties as it needs.
すべてのビューには、必要なだけクエリされたプロパティを含めることができます。

Query offers lightweight syntax to configure sorting, ordering, filtering, and even animating changes.
クエリは、並べ替え、順序付け、フィルタリング、さらにはアニメーション化する変更を構成する軽量の構文を提供します。

Under the hood, it uses a model context of the view as the data source.
内部では、ビューのモデル コンテキストをデータ ソースとして使用します。

How do we provide @Query with a model context? We'll get one from a model container.
@Query にモデル コンテキストを提供するにはどうすればよいでしょうか?モデル コンテナから 1 つを取得します。

SwiftUI vends a new view and scene modifier for a convenient setup of the view’s ModelContainer.
SwiftUI は、ビューの ModelContainer を便利にセットアップできるように、新しいビューとシーン修飾子を提供します。

To use SwiftData, any application has to set up at least one ModelContainer.
SwiftData を使用するには、どのアプリケーションでも少なくとも 1 つの ModelContainer をセットアップする必要があります。

It creates the whole storage stack, including the context that @Query will use.
@Query が使用するコンテキストを含む、ストレージ スタック全体を作成します。

A View has a single model container, but an application can create and use as many containers as it needs for different view hierarchies.
ビューには単一のモデル コンテナーがありますが、アプリケーションはさまざまなビュー階層に必要な数のコンテナーを作成して使用できます。

If the application does not set up its modelContainer, its windows and the views it creates can not save or query models via SwiftData.
アプリケーションがmodelContainerを設定しない場合、アプリケーションのウィンドウとアプリケーションが作成するビューは、SwiftData経由でモデルを保存したりクエリしたりすることができません。

Many applications need a single model container.
多くのアプリケーションは単一のモデル コンテナーを必要とします。

In this case, you can set it up for the whole window group scene.
この場合、ウィンドウグループシーン全体に設定できます。

The window and its views will inherit the container, as well as any other windows created from the same group.
ウィンドウとそのビューは、同じグループから作成された他のウィンドウと同様に、コンテナを継承します。

All of these views will write and read from a single container.
これらのビューはすべて、単一のコンテナーから書き込みと読み取りを行います。

Some apps need a few storage stacks, and they can set up several model containers for different windows.
一部のアプリはいくつかのストレージ スタックを必要とし、さまざまなウィンドウに複数のモデル コンテナーをセットアップできます。

SwiftUI also allows for a granular setup on a view level.
SwiftUI では、ビュー レベルでの詳細なセットアップも可能です。

Different views in the same window can have separate containers, and saving in one container won’t affect another.
同じウィンドウ内の異なるビューには個別のコンテナーを含めることができ、1 つのコンテナーに保存しても他のコンテナーには影響しません。

Now, let's set up the modelContainer to provide the Query with a source of data.
次に、クエリにデータのソースを提供するようにmodelContainerを設定しましょう。

I open the app definition...
アプリ定義を開くと…

And set a model container for app's windows.
そしてアプリのウィンドウにモデルコンテナを設定します。

Note that the subviews can create, read, update, and delete only the model types listed in the view modifier.
サブビューは、ビュー修飾子にリストされているモデル タイプのみを作成、読み取り、更新、削除できることに注意してください。

And we are done with the setup! Although, I want to take one extra step: provide my previews with sample data.
これでセットアップは完了です。ただし、もう 1 つ追加の手順を実行して、プレビューにサンプル データを提供したいと思います。

In the app, I have defined an in-memory container with sample cards.
アプリでは、サンプル カードを含むメモリ内コンテナーを定義しました。

Let's open the "PreviewSampleData" file and include it in the target.
「PreviewSampleData」ファイルを開いてターゲットに含めてみましょう。

This file contains the definition of a container with the sample data.
このファイルには、サンプル データを含むコンテナーの定義が含まれています。

I will use it in the ContentView to fill my preview with sample cards.
これを ContentView で使用して、プレビューにサンプル カードを入力します。

 Now that @Query has a source of data, the preview displays the cards! And this is all the setup that’s required to have SwiftData stack ready and generate a preview.
 @Query にデータのソースがあるので、プレビューにカードが表示されます。 SwiftData スタックを準備してプレビューを生成するために必要な設定はこれですべてです。

Next, I want to make sure that SwiftData tracks and saves the new cards that I create, as well as the changes made to the existing ones.
次に、作成した新しいカードと既存のカードに加えた変更が SwiftData で追跡および保存されることを確認したいと思います。

To do that, I will use the model context of the view.
これを行うには、ビューのモデル コンテキストを使用します。

To access the model context, SwiftUI offers a new environment variable.
モデル コンテキストにアクセスするために、SwiftUI は新しい環境変数を提供します。

Similarly to model container, each view has a single context, but an application, in general, can have as many as it needs.
モデル コンテナーと同様に、各ビューには 1 つのコンテキストがありますが、アプリケーションは一般に、必要なだけコンテキストを持つことができます。

In our app, the context is already configured.
私たちのアプリでは、コンテキストはすでに構成されています。

This environment variable was populated automatically when we set the model container earlier.
この環境変数は、前にモデル コンテナーを設定したときに自動的に設定されました。

Let’s switch back to Xcode.
Xcode に戻りましょう。

We will need to access the modelContext to save and update the cards.
カードを保存して更新するには、modelContext にアクセスする必要があります。

  We insert the newly created card in the model context to make SwiftData aware of the model we want to store.
  新しく作成したカードをモデル コンテキストに挿入して、保存したいモデルを SwiftData に認識させます。

You might think that after inserting the model, you need to save the context, calling "modelContext.save()," but you don't need to do that.
モデルを挿入した後、「modelContext.save()」を呼び出してコンテキストを保存する必要があると思われるかもしれませんが、その必要はありません。

A nice detail about SwiftData is that it autosaves the model context.
SwiftData の優れた点は、モデル コンテキストを自動保存することです。

The autosaves are triggered by UI-related events and user input.
自動保存は、UI 関連のイベントとユーザー入力によってトリガーされます。

We don’t need to worry about saving because SwiftData does it for us.
保存については SwiftData が自動的に実行してくれるため、心配する必要はありません。

There are only a few cases when you want to make sure that all the changes are persisted immediately, for example, before sharing the SwiftData storage or sending it over.
たとえば、SwiftData ストレージを共有したり送信したりする前など、すべての変更が即座に永続化されていることを確認したい場合は、ほとんどありません。

In these cases, call "save()" explicitly.
このような場合は、「save()」を明示的に呼び出してください。

Now that our app can save and query the cards, let’s create one! I run the app...
アプリがカードを保存してクエリできるようになったので、カードを作成してみましょう。アプリを実行します...

and press plus button to create a card.
プラスボタンを押してカードを作成します。

Let's add that Compiler card that we saw before.
前に見たコンパイラー カードを追加しましょう。

 Now, let’s quit the app, launch it again, and see if our new card is there.
 次に、アプリを終了し、再度起動して、新しいカードが存在するかどうかを確認してみましょう。

And here it is! Now you know how to access the model context of the view and add cards.
そしてここにあります！これで、ビューのモデル コンテキストにアクセスしてカードを追加する方法がわかりました。

Done! Let’s open a new window.
終わり！新しいウィンドウを開いてみましょう。

It displays the same deck as the first one, which makes sense, since both windows use the same model container and access the same data.
最初のデッキと同じデッキが表示されます。これは、両方のウィンドウが同じモデル コンテナーを使用し、同じデータにアクセスするため、当然のことです。

It would be nice, though, if the app could open different flash card decks in different windows.
ただし、アプリが別のウィンドウで別のフラッシュ カード デッキを開くことができれば素晴らしいでしょう。

Essentially, it means that I want to treat every deck as a separate document.
本質的に、これはすべてのデッキを別個のドキュメントとして扱いたいことを意味します。

Then, I can share these documents with friends.
そうすれば、これらのドキュメントを友人と共有できます。

Document-based apps is a concept used on macOS, iOS, and iPadOS.
ドキュメントベースのアプリは、macOS、iOS、iPadOS で使用される概念です。

It describes the certain types of applications that allow users to create, open, view, or edit different types of documents.
ここでは、ユーザーがさまざまな種類のドキュメントを作成、開く、表示、または編集できるようにする特定の種類のアプリケーションについて説明します。

Every document is a file, and users can store, copy, and share them.
すべてのドキュメントはファイルであり、ユーザーはドキュメントを保存、コピー、共有できます。

And I am excited to let you know that SwiftUI supports SwiftData-backed document apps.
そして、SwiftUI が SwiftData を利用したドキュメント アプリをサポートしていることをお知らせできることを嬉しく思います。

Let’s try this approach.
このアプローチを試してみましょう。

I open the FlashCardApp file.
FlashCardApp ファイルを開きます。

Document-based apps exist on iOS and macOS, and on these platforms, we'll switch to using the DocumentGroup initializer.
ドキュメントベースのアプリは iOS と macOS に存在します。これらのプラットフォームでは、DocumentGroup 初期化子の使用に切り替えます。

  I will be passing in the model type Card.self, content type, and a view builder.
  モデル タイプ Card.self、コンテンツ タイプ、およびビュー ビルダーを渡します。

  Let's take a short detour and talk about the second parameter, content type, in more detail! SwiftData Document-based apps need to declare custom content types.
  少し寄り道して、2 番目のパラメーターであるコンテンツ タイプについて詳しく説明しましょう。 SwiftData ドキュメントベースのアプリでは、カスタム コンテンツ タイプを宣言する必要があります。

  Each SwiftData document is built from a unique set of models and so has a unique representation on disk.
  各 SwiftData ドキュメントは一意のモデル セットから構築されているため、ディスク上で一意の表現を持ちます。

  In the context of documents, you can think of a content type as of a binary file format, like JPEG.
  ドキュメントのコンテキストでは、コンテンツ タイプは JPEG などのバイナリ ファイル形式と考えることができます。

  Another type of documents, a package, is a directory with a fixed structure on disk, like an Xcode project.
  もう 1 つのタイプのドキュメントであるパッケージは、Xcode プロジェクトのようなディスク上の固定構造を持つディレクトリです。

  For example, all the JPEG images have the same binary structure.
  たとえば、すべての JPEG 画像は同じバイナリ構造を持っています。

  Otherwise, photo editors wouldn’t know how to read them.
  そうしないと、写真編集者は写真の読み方がわかりません。

  Similarly, all the Xcode projects contain certain directories and files.
  同様に、すべての Xcode プロジェクトには特定のディレクトリとファイルが含まれています。

  When the user opens the deck, we need the operating system to associate the deck format and file extension with our app.
  ユーザーがデッキを開くとき、オペレーティング システムがデッキの形式とファイル拡張子をアプリに関連付ける必要があります。

  That’s why we need to declare the content type.
  そのため、コンテンツ タイプを宣言する必要があります。

  SwiftData documents are packages: if you mark some properties of a SwiftData model with the “externalStorage” attribute, all the externally stored items will be a part of the document package.
  SwiftData ドキュメントはパッケージです。SwiftData モデルの一部のプロパティを「externalStorage」属性でマークすると、外部に保存されたすべてのアイテムがドキュメント パッケージの一部になります。

  In the UTType+FlashCards file, I have a definition of the new content type, so we can conveniently use it in code.
  UTType+FlashCards ファイルには、新しいコンテンツ タイプの定義があるため、コードで便利に使用できます。

  We'll put the same definition in the Info.plist.
  同じ定義を Info.plist に入れます。

We are about to declare a new content type in the operating system.
オペレーティング システムで新しいコンテンツ タイプを宣言しようとしています。

We need to specify the file extension to help to distinguish the card decks created by our app from any other documents.
アプリで作成したカードデッキを他のドキュメントと区別しやすくするために、ファイル拡張子を指定する必要があります。

For this sample app, we’ll use “sampledeck” as an extension.
このサンプルアプリでは、拡張機能として「sampledeck」を使用します。

I will also add a short description, like Flash Cards Deck.
Flash Cards Deck などの簡単な説明も追加します。

The identifier should be exactly the same as the one in the code.
識別子はコード内の識別子とまったく同じである必要があります。

Because SwiftData documents are packages, we have to make sure our type conforms to com.apple.package.
SwiftData ドキュメントはパッケージであるため、型が com.apple.package に準拠していることを確認する必要があります。

And now, let’s use the content type that we declared.
それでは、宣言したコンテンツ タイプを使用してみましょう。

I am returning to the app definition and passing the content type to the DocumentGroup.
アプリ定義に戻り、コンテンツ タイプを DocumentGroup に渡します。

The view builder looks identical.
ビュービルダーは同じように見えます。

Notably, we don’t set up the model container.
特に、モデル コンテナーはセットアップしません。

The document infrastructure will set up one for each document.
ドキュメント インフラストラクチャは、ドキュメントごとに 1 つをセットアップします。

Let's run the application and see how it looks now! The app launches with the open panel.
アプリケーションを実行して、どのように表示されるかを見てみましょう。アプリが起動し、パネルが開いた状態になります。

Standard behavior for Document-based applications.
ドキュメントベースのアプリケーションの標準動作。

I'll create a new document and add a card there.
新しいドキュメントを作成し、そこにカードを追加します。

The document now has a toolbar subtitle indicating that it has unsaved changes.
ドキュメントには、未保存の変更があることを示すツールバーのサブタイトルが表示されます。

I press Command+S, and the save dialog appears.
Command+S を押すと、保存ダイアログが表示されます。

Note that the deck will be saved with the same file extension that we put in the Info.plist earlier.
デッキは、前に Info.plist に入れたのと同じファイル拡張子で保存されることに注意してください。

I'll save the new deck, and here it is, my first flashcards deck, on the Desktop.
新しいデッキをデスクトップに保存します。これが最初のフラッシュカード デッキです。

I can also press Command+N to create a new deck, or Command+O to open one.
Command+N を押して新しいデッキを作成したり、Command+O を押してデッキを開くこともできます。

These shortcuts, as well as many other features, Document-based applications get automatically.
これらのショートカットや他の多くの機能は、ドキュメントベースのアプリケーションに自動的に追加されます。

Just to recap, today, we’ve learned how to use SwiftData storage in SwiftUI apps.
要約すると、今日は SwiftUI アプリで SwiftData ストレージを使用する方法を学びました。

We talked about the new @Model macro, @Query property wrapper, and the new Environment variable for model context, and saw how easy it is to use SwiftData as a storage for your documents.
新しい @Model マクロ、@Query プロパティ ラッパー、モデル コンテキストの新しい環境変数について説明し、SwiftData をドキュメントのストレージとして使用することがいかに簡単であるかを確認しました。

Thanks for joining me today, and have fun building apps!
本日はご参加いただきありがとうございます。アプリの構築を楽しんでください。


""",
      timestamp: Date()
    )
  }
}
