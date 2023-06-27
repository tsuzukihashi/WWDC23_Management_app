import Foundation

extension ItemViewData {
  static var Dive_deeper_into_SwiftData: ItemViewData {
    .init(
      id: UUID().uuidString,
      title: "Dive deeper into SwiftData",
      linkURL: URL(string: "https://developer.apple.com/wwdc23/10196"),
      firstText:"""
Nick Gillett: Hi, I'm Nick Gillett, an Engineer here at Apple on the SwiftData team
In this session, I'll examine in detail how applications built with SwiftData evolve to take advantage of this rich, powerful new framework
First, I'll examine how to configure persistence in an application
Next, I'll talk about how to use the ModelContext to track and persist changes
Finally, I'll examine how to get the most out of SwiftData when working with objects in your code
I'd like to note that this session builds on the concepts and APIs introduced in "Meet Swift Data" and "Model your Schema with SwiftData"
I highly recommend reviewing those sessions before continuing with this one
In this talk, I'll be referencing a new sample application, SampleTrips, that we built this year to demonstrate how easy it is to build applications with SwiftData
SampleTrips makes it easy to organize my ideas about where and when I want to travel
SwiftData also makes it easy to implement standard platform practices like undo and automatically saving when a user switches applications
SwiftData is a new way of persisting data in applications that use Swift
It's designed to work with the types you're already using in your code like Classes and Structs
At the core of this concept is the Model, described by a new macro, @Model, which tells SwiftData about the types you want to persist
This is the Trip class from the SampleTrips application
It has a few properties to capture information about a trip and some references to other objects used in SampleTrips
We designed SwiftData to provide a minimal distance between the code you would normally write without persistence, as I have here, and the code you have to write with persistence
With just a few changes, I've told SwiftData this Trip is a Model I want to persist and described how its relationships to the BucketListItem and LivingAccommodations should behave
Where possible, SwiftData automatically infers the structure you want to use from the code you write
But SwiftData also offers a powerful set of customizations to help you describe exactly how you want your data to be stored
You can learn all about the power of Model in "Model your Schema with SwiftData"
These annotations to the Trip class enable it to play two important roles in SwiftData
The first is to describe the object graph of the application, called the Schema, and the second is that the Trip class will be an interface that I can write code against
This duality, the ability to play both parts, makes classes annotated with the @Model macro the central point of contact in applications that use SwiftData, and there is an aligned API concept to support each of these roles.

The Schema is applied to a class called the ModelContainer to describe how data should be persisted.

The ModelContainer consumes the Schema to generate a database that can hold instances of the Model classes.

When working with instances of a Model class in code, those instances are linked to a ModelContext which tracks and manages their state in memory
This duality is at the core of SwiftData and in this section, I'll take a detailed look at the first role of the model, to describe the structure of persistence and how that works with the ModelContainer
The ModelContainer is where you describe how data is stored, or persisted, on a device
We can think of the ModelContainer as the bridge between the Schema and its persistence
It's where descriptions about how objects are stored, like whether they're in memory, or on disk, meet the operational and evolutionary semantics of that storage like versioning, migration, and graph separation
Instantiating a container with a Schema is easy
I can provide just the type I want to work with and SwiftData will figure out the rest of the Schema for me
For example, because the Trip class is related to other model types, ModelContainer actually infers this Schema, even though I only passed it a single type
ModelContainer has a number of other powerful initializers that are designed to grow with your code to enable increasingly complex configurations using a class called the ModelConfiguration.

The ModelConfiguration describes the persistence of a Schema
It controls where data is stored, like in memory for transient data or on disk for persistent data
ModelConfiguration can use a specific file URL chosen by you, or it can generate one automatically using the entitlements of your application like the group container entitlement
The configuration can also describe that a persistence file should be loaded in a read only mode, preventing writes to sensitive or template data
And finally, applications that use more than one CloudKit container can specify it as part of the ModelConfiguration for a Schema.

Let's imagine I want to add some contact information to SampleTrips using new Person and Address classes
First, the total Schema is declared containing all of the types I want to use
Next, a Configuration is declared for the SampleTrips data containing the Trip, BucketListItem, and LivingAccommodations models
It declares a URL for the file I want to use to store this specific object graph's data, and a container identifier for the CloudKit container I want to use when syncing the SampleTrips data to CloudKit
Then, the models for the new Schema with Person and Address are declared in their own configuration with a unique file URL and CloudKit container identifier to keep this data separate from the Trips graph
Finally, the Schema and configurations are combined to form the ModelContainer.

With the power of ModelConfiguration, it's easy to describe the persistence requirements of your application, no matter how complicated they may be
In addition to instantiating a container by hand, SwiftUI applications can use the new modelContainer modifiers to create the container they want to work with.

The modelContainer modifier can be added to any View or Scene in an application and it supports ModelContainers from simple to powerful and everything in between
In this section, I examined how to combine the Schema with persistence using ModelContainer
It grows with your application as you build ever more powerful features and object graphs
And I demonstrated how you can use ModelConfiguration to unlock powerful persistence capabilities
As we learned in "Meet SwiftData", the Model and ModelContext are two of the most frequently used concepts when writing user interfaces or operating on model objects
In this section, I'll take a deep dive into how the ModelContext tracks changes and persists edits through the ModelContainer.

When we use the modelContainer modifier in view or scene code, it prepares the application's environment in a specific way
The modifier binds the new modelContext key in the environment to the container's mainContext
The main context is a special MainActor-aligned model context intended for working with ModelObjects in scenes and views
By using the model context from the environment, view code has easy access to the context used by the Query here so that it can perform actions like delete here.

So model contexts are easy to use and access but what do they actually do? We can think of the ModelContext as a view over the data an application manages.

Data we want to work with is fetched into a model context as its used
In SampleTrips, when the upcoming trips view loads the data for the list, each trip object is fetched into the main context
If a trip is edited, that change is recorded by the model context as a snapshot
As other changes are made, like inserting a new Trip or deleting an existing one, the context tracks and maintains state about these changes until you call "context.save()"
This means that even though the deleted trip is no longer visible in the list, it still exists in the ModelContext until that delete is persisted by calling save.

Once save is called, the context persists changes to the ModelContainer and clears its state.

If you're still referencing the objects in the context, like displaying them in a list, they will exist in the context until you're finished with them
At which point they will be freed and the context emptied out
The ModelContext works in coordination with the ModelContainer it is bound to
It tracks the objects you fetch in your views and then propagates any changes when save executes
ModelContext also supports features like rollback or reset for clearing its cached state when needed
This makes it the ideal place to support platform features like undo and autosave.

In SwiftUI applications, the modelContainer modifier has this isUndoEnabled argument, which binds the window's undo manager to the container's mainContext
That means that as changes are made in the main context, system gestures like three finger swipe and shake can be used to undo or redo changes with no additional code
ModelContext automatically registers undo and redo actions as changes are made to model objects
The modelContainer modifier uses the environment's undoManager which is usually provided by the system as part of the window or window group
and because of this, system gestures like three finger swipe and shake will automatically work in your applications
Another standard system feature supported by the ModelContext is Autosave
When autosave is enabled the model context will save in response to system events like an application entering the foreground or background
The main context will also periodically save as an application is used
Autosave is enabled by default in applications and can be disabled if desired using the modelContainer modifier's isAutosaveEnabled argument
Autosave is disabled for model contexts created by hand
In "Meet SwiftData", we learned a lot about how to work with ModelContext in an application and how well it pairs with SwiftUI
But user interfaces aren't the only places that applications need to work with model objects
In this section, I'll examine how SwiftData makes writing powerful, scalable code easier and safer than ever.

Tasks like working with data on a background queue, syncing with a remote server or other persistence mechanism, and batch processing all work with model objects, frequently in sets or graphs.

Many of these tasks will begin by fetching a set of objects to work with via the fetch method on a ModelContext
In this example, the FetchDescriptor for the Trip model tells Swift that the trips array will be a collection of Trip objects
There's no casting or complicated result tuples to worry about.

FetchDescriptor makes it easy to craft complicated queries using the new Predicate macro
For example, what are all the trips that involve staying at a specific hotel? Or what trips still have some activities that I need to make reservations for? In SwiftData, complicated queries that support subqueries and joins can all be written in pure swift
Predicate uses the Models you create and SwiftData uses the Schema generated from those models to translate these predicates into database queries
FetchDescriptor combines the power of the new Foundation Predicate macro with the Schema to bring compiler validated queries to persistence on Apple platforms for the first time
FetchDescriptor and related classes, like SortDescriptor, use generics to form the result type and tell the compiler about the properties of the model you can use
There are a number of tuning options you've come to know and love, like offset and limit, as well as parameters for faulting and prefetching.

All of this power combines in the new enumerate function on ModelContext
It's designed to help make the foiblesome pattern of batch traversal and enumeration implicitly efficient by encapsulating the platform best practices at a single call site
Enumerate works great with FetchDescriptors regardless of their complexity, from simple to powerful and everything in between
Enumerate automatically implements platform best practices for traversals like batching and mutation guards
These are customizable to meet the needs of your specific use case
For example, the batch size that enumerate uses defaults to 5,000 objects
But I could change it to 10,000 to reduce I/O operations during the traversal at the expense of memory growth
Heavier object graphs, like those that include images, movies, or other large data blobs, may choose to use a smaller batch size
Decreasing the batch size reduces memory growth but increases I/O during the enumeration
Enumerate also includes mutation guard by default
One of the most frequent causes of performance issues with large traversals is mutations that are trapped in the context during the enumeration
allowEscapingMutations tells enumerate that this is intentional, when not set, enumerate will throw if it discovers that the ModelContext performing the enumeration is dirty, preventing it from freeing objects that were already traversed.

In this session, we learned how to create powerful persistence configurations with Schema and ModelConfiguration
We also learned how easy it is to adopt standard system practices like undo and redo with the ModelContainer and ModelContext
And you can use SwiftData today to write safe, performant code in your project like never before with FetchDescriptor, predicate, and enumerate
I can't wait to see how you push the limits of what's possible with this new framework in the months and years ahead
Thanks for watching and happy coding.
""",
      translateText: """
Nick Gillett: こんにちは、私は Apple の SwiftData チームのエンジニアである Nick Gillett です。
このセッションでは、SwiftData で構築されたアプリケーションがこのリッチで強力な新しいフレームワークを活用するためにどのように進化するかを詳しく調べます。
まず、アプリケーションで永続性を構成する方法を検討します。
次に、ModelContext を使用して変更を追跡し、保持する方法について説明します。
最後に、コード内でオブジェクトを操作するときに SwiftData を最大限に活用する方法を検討します。
このセッションは、「Swift Data の紹介」と「SwiftData でスキーマをモデル化する」で紹介された概念と API に基づいて構築されていることに注意してください。
このセッションを続行する前に、これらのセッションを確認することを強くお勧めします
この講演では、SwiftData を使用してアプリケーションを構築することがいかに簡単であるかを示すために、今年構築した新しいサンプル アプリケーション、SampleTrips を参照します。
SampleTrips を使用すると、いつどこに旅行したいかについてのアイデアを簡単に整理できます
SwiftData を使用すると、ユーザーがアプリケーションを切り替えたときに元に戻したり自動的に保存したりするなど、標準的なプラットフォームの実践も簡単に実装できます。
SwiftData は、Swift を使用するアプリケーションでデータを永続化する新しい方法です
クラスや構造体など、コード内ですでに使用している型で動作するように設計されています。
この概念の中心となるのはモデルです。これは新しいマクロ @Model で記述され、永続化したい型について SwiftData に伝えます。
これは、SampleTrips アプリケーションの Trip クラスです。
旅行に関する情報と、SampleTrips で使用される他のオブジェクトへの参照を取得するためのプロパティがいくつかあります。
私たちは、ここに示したように、永続性を持たずに通常記述するコードと、永続性を使用して記述する必要があるコードとの間に最小限の距離を提供するように SwiftData を設計しました。
ほんのいくつかの変更を加えて、この旅行は永続化したいモデルであることを SwiftData に伝え、BucketListItem および LivingAccommodations との関係がどのように動作するかを説明しました。
可能な場合、SwiftData は、作成したコードから使用する構造を自動的に推測します。
ただし、SwiftData は、データの保存方法を正確に記述するのに役立つ強力なカスタマイズ セットも提供します。
Model の機能については、「SwiftData を使用してスキーマをモデル化する」ですべて学ぶことができます。
Trip クラスへのこれらのアノテーションにより、SwiftData で 2 つの重要な役割を果たすことができます。
1 つ目は、スキーマと呼ばれるアプリケーションのオブジェクト グラフを記述することです。2 つ目は、Trip クラスがコードを作成できるインターフェイスになることです。
この二重性、つまり両方の役割を果たす機能により、@Model マクロで注釈が付けられたクラスが SwiftData を使用するアプリケーションの中心的な連絡先となり、これらの役割のそれぞれをサポートするための調整された API コンセプトが存在します。

スキーマは ModelContainer と呼ばれるクラスに適用され、データがどのように永続化されるかを記述します。

ModelContainer はスキーマを使用して、Model クラスのインスタンスを保持できるデータベースを生成します。

コードで Model クラスのインスタンスを操作する場合、それらのインスタンスは、メモリ内の状態を追跡および管理する ModelContext にリンクされます。
この二重性は SwiftData の中核です。このセクションでは、モデルの最初の役割を詳しく見て、永続化の構造とそれが ModelContainer とどのように連携するかを説明します。
ModelContainer は、デバイス上でデータがどのように保存または保持されるかを記述する場所です。
ModelContainer は、スキーマとその永続性の間のブリッジとして考えることができます。
ここでは、オブジェクトがメモリ内にあるかディスク上にあるかなど、オブジェクトの保存方法に関する記述が、バージョン管理、移行、グラフ分離などのストレージの運用セマンティクスおよび進化的セマンティクスを満たす場所です。
スキーマを使用してコンテナーをインスタンス化するのは簡単です
操作したい型だけを指定すれば、SwiftData が残りのスキーマを計算してくれます。
たとえば、Trip クラスは他のモデル タイプに関連しているため、ModelContainer に単一のタイプを渡しただけであっても、実際には ModelContainer がこのスキーマを推論します。
ModelContainer には、コードに合わせて拡張するように設計された他の強力なイニシャライザーが多数あり、ModelConfiguration と呼ばれるクラスを使用してますます複雑な構成を可能にします。

ModelConfiguration はスキーマの永続性を記述します。
一時的なデータの場合はメモリ内、永続的なデータの場合はディスク上など、データの保存場所を制御します。
ModelConfiguration は、ユーザーが選択した特定のファイル URL を使用することも、グループ コンテナー資格などのアプリケーションの資格を使用してファイル URL を自動的に生成することもできます。
構成では、永続化ファイルを読み取り専用モードでロードし、機密データやテンプレート データへの書き込みを防止する必要があることも記述できます。
最後に、複数の CloudKit コンテナを使用するアプリケーションは、それをスキーマの ModelConfiguration の一部として指定できます。

新しい Person クラスと Address クラスを使用して、SampleTrips に連絡先情報を追加したいと考えてみましょう。
まず、使用したいすべての型を含む合計スキーマが宣言されます。
次に、Trip、BucketListItem、および LivingAccommodations モデルを含む SampleTrips データの構成が宣言されます。
この特定のオブジェクト グラフのデータを保存するために使用するファイルの URL と、SampleTrips データを CloudKit に同期するときに使用する CloudKit コンテナのコンテナ識別子を宣言します。
次に、個人と住所を含む新しいスキーマのモデルが、このデータを Trips グラフから分離するために、一意のファイル URL と CloudKit コンテナ識別子を使用して独自の構成で宣言されます。
最後に、スキーマと構成を組み合わせて ModelContainer を形成します。

ModelConfiguration の機能を利用すると、アプリケーションの永続性要件がどんなに複雑であっても、簡単に記述できます。
SwiftUI アプリケーションは、手動でコンテナーをインスタンス化するだけでなく、新しい modelContainer 修飾子を使用して、操作するコンテナーを作成できます。

modelContainer モディファイアは、アプリケーション内の任意のビューまたはシーンに追加でき、シンプルなものから強力なものまで、およびその間のすべての ModelContainer をサポートします。
このセクションでは、ModelContainer を使用してスキーマと永続性を組み合わせる方法を検討しました。
より強力な機能やオブジェクト グラフを構築することで、アプリケーションとともに成長します。
そして、ModelConfiguration を使用して強力な永続化機能を利用できる方法をデモしました。
「SwiftData の紹介」で学んだように、Model と ModelContext は、ユーザー インターフェイスを作成するとき、またはモデル オブジェクトを操作するときに最も頻繁に使用される概念の 2 つです。
このセクションでは、ModelContext が変更を追跡し、ModelContainer を通じて編集を保持する方法について詳しく説明します。

ビューまたはシーン コードで modelContainer モディファイアを使用すると、特定の方法でアプリケーションの環境が準備されます。
修飾子は、環境内の新しいmodelContextキーをコンテナのmainContextにバインドします。
メイン コンテキストは、シーンおよびビューで ModelObject を操作することを目的とした特別な MainActor に調整されたモデル コンテキストです。
環境からのモデル コンテキストを使用することにより、ビュー コードはクエリで使用されるコンテキストに簡単にアクセスできるため、ここで削除などのアクションを実行できます。

モデル コンテキストは使いやすく、アクセスも簡単ですが、実際には何をするのでしょうか? ModelContext は、アプリケーションが管理するデータのビューとして考えることができます。

操作したいデータは、使用時にモデル コンテキストにフェッチされます。
SampleTrips では、今後の旅行ビューがリストのデータをロードするときに、各旅行オブジェクトがメイン コンテキストにフェッチされます。
旅行が編集されると、その変更はモデル コンテキストによってスナップショットとして記録されます。
新しい旅行の挿入や既存の旅行の削除など、他の変更が行われると、コンテキストは「context.save()」を呼び出すまでこれらの変更に関する状態を追跡および維持します。
これは、削除された旅行がリストに表示されなくなっても、save を呼び出して削除が保持されるまで、ModelContext にまだ存在することを意味します。

save が呼び出されると、コンテキストは ModelContainer への変更を保持し、その状態をクリアします。

オブジェクトをリストに表示するなど、コンテキスト内でオブジェクトをまだ参照している場合、それらは終了するまでコンテキスト内に存在します。
その時点でそれらは解放され、コンテキストは空になります。
ModelContext は、バインドされている ModelContainer と連携して動作します。
ビューでフェッチしたオブジェクトを追跡し、保存の実行時に変更を反映します。
ModelContext は、必要に応じてキャッシュされた状態をクリアするためのロールバックやリセットなどの機能もサポートしています。
これにより、元に戻すや自動保存などのプラットフォーム機能をサポートするのに理想的な場所になります。

SwiftUI アプリケーションでは、modelContainer モディファイアには isUndoEnabled 引数があり、ウィンドウのアンドゥ マネージャーをコンテナの mainContext にバインドします。
つまり、メイン コンテキストで変更が行われると、3 本指のスワイプやシェイクなどのシステム ジェスチャを使用して、追加のコードなしで変更を元に戻したりやり直したりできるようになります。
ModelContext は、モデル オブジェクトに変更が加えられると、元に戻すアクションとやり直しアクションを自動的に登録します。
modelContainer 修飾子は、通常、ウィンドウまたはウィンドウ グループの一部としてシステムによって提供される環境の undoManager を使用します。
このため、3 本指のスワイプやシェイクなどのシステム ジェスチャがアプリケーションで自動的に機能します。
ModelContext でサポートされるもう 1 つの標準システム機能は自動保存です。
自動保存が有効になっている場合、アプリケーションがフォアグラウンドまたはバックグラウンドに入るなどのシステム イベントに応答してモデル コンテキストが保存されます。
メイン コンテキストは、アプリケーションの使用時に定期的に保存されます。
自動保存はアプリケーションではデフォルトで有効になっており、必要に応じて、modelContainer モディファイアの isAutosaveEnabled 引数を使用して無効にすることができます。
手動で作成されたモデル コンテキストの自動保存は無効になっています
「Meet SwiftData」では、アプリケーション内で ModelContext を操作する方法と、ModelContext が SwiftUI とどのようにうまく連携するかについて多くのことを学びました。
しかし、アプリケーションがモデル オブジェクトを操作する必要があるのはユーザー インターフェイスだけではありません。
このセクションでは、SwiftData を使用して、強力でスケーラブルなコードをこれまで以上に簡単かつ安全に作成できるようにする方法を検討します。

バックグラウンド キュー上のデータの操作、リモート サーバーまたは他の永続化メカニズムとの同期、バッチ処理などのタスクはすべて、多くの場合セットまたはグラフでモデル オブジェクトを操作します。

これらのタスクの多くは、ModelContext の fetch メソッドを介して、操作するオブジェクトのセットをフェッチすることから始まります。
この例では、Trip モデルの FetchDescriptor が、trips 配列が Trip オブジェクトのコレクションになることを Swift に伝えます。
キャストや複雑な結果タプルについて心配する必要はありません。

FetchDescriptor により、新しい Predicate マクロを使用して複雑なクエリを簡単に作成できます
たとえば、特定のホテルに滞在する旅行とはどのようなものでしょうか?または、予約が必要なアクティビティがまだある旅行は何ですか? SwiftData では、サブクエリと結合をサポートする複雑なクエリはすべて純粋な Swift で記述できます。
Predicate は作成したモデルを使用し、SwiftData はそれらのモデルから生成されたスキーマを使用してこれらの述語をデータベース クエリに変換します。
FetchDescriptor は、新しい Foundation Predicate マクロの機能とスキーマを組み合わせて、コンパイラで検証されたクエリを Apple プラットフォームで初めて永続化します。
FetchDescriptor と SortDescriptor などの関連クラスは、ジェネリックスを使用して結果の型を形成し、使用できるモデルのプロパティについてコンパイラーに伝えます。
オフセットやリミット、フォルトやプリフェッチ用のパラメータなど、よく知られ愛用されているチューニング オプションが多数あります。

このすべての機能が ModelContext の新しい列挙関数で結合されます。
単一の呼び出しサイトでプラットフォームのベスト プラクティスをカプセル化することで、バッチ トラバーサルと列挙の厄介なパターンを暗黙的に効率化できるように設計されています。
Enumerate は、単純なものから強力なものまで、その複雑さに関係なく、FetchDescriptors とうまく連携します。
Enumerate は、バッチ処理やミューテーション ガードなどのトラバーサルに関するプラットフォームのベスト プラクティスを自動的に実装します。
これらは、特定の使用例のニーズに合わせてカスタマイズ可能です
たとえば、列挙に使用されるバッチ サイズのデフォルトは 5,000 オブジェクトです
ただし、これを 10,000 に変更して、メモリの増加を犠牲にしてトラバース中の I/O 操作を減らすこともできます。
画像、ムービー、その他の大きなデータ BLOB を含むような重いオブジェクト グラフでは、より小さいバッチ サイズの使用が選択される場合があります。
バッチ サイズを小さくするとメモリの増加は減少しますが、列挙中の I/O が増加します。
Enumerate にはデフォルトで突然変異ガードも含まれます
大規模なトラバーサルによるパフォーマンスの問題の最も一般的な原因の 1 つは、列挙中にコンテキストに閉じ込められた突然変異です。
allowEscapingMutations は、これが意図的であることを enumerate に伝えます。設定されていない場合、enumerate は、列挙を実行している ModelContext がダーティであることが判明した場合にスローされ、すでにトラバースされたオブジェクトを解放できなくなります。

このセッションでは、Schema と ModelConfiguration を使用して強力な永続性構成を作成する方法を学びました。
また、ModelContainer と ModelContext を使用すると、元に戻す、やり直すなどの標準的なシステム手法を簡単に導入できることも学びました。
そして、今すぐ SwiftData を使用して、FetchDescriptor、述語、列挙を使用して、これまでにないほど安全でパフォーマンスの高いコードをプロジェクトに記述することができます。
今後数か月、数年にわたって、この新しいフレームワークでどのように可能性の限界を押し広げていくのかを見るのが待ちきれません。
ご視聴いただきありがとうございます。コーディングを楽しんでください。
""",
      combineText: """
Nick Gillett: Hi, I'm Nick Gillett, an Engineer here at Apple on the SwiftData team
Nick Gillett: こんにちは、私は Apple の SwiftData チームのエンジニアである Nick Gillett です。

In this session, I'll examine in detail how applications built with SwiftData evolve to take advantage of this rich, powerful new framework
このセッションでは、SwiftData で構築されたアプリケーションがこのリッチで強力な新しいフレームワークを活用するためにどのように進化するかを詳しく調べます。

First, I'll examine how to configure persistence in an application
まず、アプリケーションで永続性を構成する方法を検討します。

Next, I'll talk about how to use the ModelContext to track and persist changes
次に、ModelContext を使用して変更を追跡し、保持する方法について説明します。

Finally, I'll examine how to get the most out of SwiftData when working with objects in your code
最後に、コード内でオブジェクトを操作するときに SwiftData を最大限に活用する方法を検討します。

I'd like to note that this session builds on the concepts and APIs introduced in "Meet Swift Data" and "Model your Schema with SwiftData"
このセッションは、「Swift Data の紹介」と「SwiftData でスキーマをモデル化する」で紹介された概念と API に基づいて構築されていることに注意してください。

I highly recommend reviewing those sessions before continuing with this one
このセッションを続行する前に、これらのセッションを確認することを強くお勧めします

In this talk, I'll be referencing a new sample application, SampleTrips, that we built this year to demonstrate how easy it is to build applications with SwiftData
この講演では、SwiftData を使用してアプリケーションを構築することがいかに簡単であるかを示すために、今年構築した新しいサンプル アプリケーション、SampleTrips を参照します。

SampleTrips makes it easy to organize my ideas about where and when I want to travel
SampleTrips を使用すると、いつどこに旅行したいかについてのアイデアを簡単に整理できます

SwiftData also makes it easy to implement standard platform practices like undo and automatically saving when a user switches applications
SwiftData を使用すると、ユーザーがアプリケーションを切り替えたときに元に戻したり自動的に保存したりするなど、標準的なプラットフォームの実践も簡単に実装できます。

SwiftData is a new way of persisting data in applications that use Swift
SwiftData は、Swift を使用するアプリケーションでデータを永続化する新しい方法です

It's designed to work with the types you're already using in your code like Classes and Structs
クラスや構造体など、コード内ですでに使用している型で動作するように設計されています。

At the core of this concept is the Model, described by a new macro, @Model, which tells SwiftData about the types you want to persist
この概念の中心となるのはモデルです。これは新しいマクロ @Model で記述され、永続化したい型について SwiftData に伝えます。

This is the Trip class from the SampleTrips application
これは、SampleTrips アプリケーションの Trip クラスです。

It has a few properties to capture information about a trip and some references to other objects used in SampleTrips
旅行に関する情報と、SampleTrips で使用される他のオブジェクトへの参照を取得するためのプロパティがいくつかあります。

We designed SwiftData to provide a minimal distance between the code you would normally write without persistence, as I have here, and the code you have to write with persistence
私たちは、ここに示したように、永続性を持たずに通常記述するコードと、永続性を使用して記述する必要があるコードとの間に最小限の距離を提供するように SwiftData を設計しました。

With just a few changes, I've told SwiftData this Trip is a Model I want to persist and described how its relationships to the BucketListItem and LivingAccommodations should behave
ほんのいくつかの変更を加えて、この旅行は永続化したいモデルであることを SwiftData に伝え、BucketListItem および LivingAccommodations との関係がどのように動作するかを説明しました。

Where possible, SwiftData automatically infers the structure you want to use from the code you write
可能な場合、SwiftData は、作成したコードから使用する構造を自動的に推測します。

But SwiftData also offers a powerful set of customizations to help you describe exactly how you want your data to be stored
ただし、SwiftData は、データの保存方法を正確に記述するのに役立つ強力なカスタマイズ セットも提供します。

You can learn all about the power of Model in "Model your Schema with SwiftData"
Model の機能については、「SwiftData を使用してスキーマをモデル化する」ですべて学ぶことができます。

These annotations to the Trip class enable it to play two important roles in SwiftData
Trip クラスへのこれらのアノテーションにより、SwiftData で 2 つの重要な役割を果たすことができます。

The first is to describe the object graph of the application, called the Schema, and the second is that the Trip class will be an interface that I can write code against
1 つ目は、スキーマと呼ばれるアプリケーションのオブジェクト グラフを記述することです。2 つ目は、Trip クラスがコードを作成できるインターフェイスになることです。

This duality, the ability to play both parts, makes classes annotated with the @Model macro the central point of contact in applications that use SwiftData, and there is an aligned API concept to support each of these roles.
この二重性、つまり両方の役割を果たす機能により、@Model マクロで注釈が付けられたクラスが SwiftData を使用するアプリケーションの中心的な連絡先となり、これらの役割のそれぞれをサポートするための調整された API コンセプトが存在します。

The Schema is applied to a class called the ModelContainer to describe how data should be persisted.
スキーマは ModelContainer と呼ばれるクラスに適用され、データがどのように永続化されるかを記述します。

The ModelContainer consumes the Schema to generate a database that can hold instances of the Model classes.
ModelContainer はスキーマを使用して、Model クラスのインスタンスを保持できるデータベースを生成します。

When working with instances of a Model class in code, those instances are linked to a ModelContext which tracks and manages their state in memory
コードで Model クラスのインスタンスを操作する場合、それらのインスタンスは、メモリ内の状態を追跡および管理する ModelContext にリンクされます。

This duality is at the core of SwiftData and in this section, I'll take a detailed look at the first role of the model, to describe the structure of persistence and how that works with the ModelContainer
この二重性は SwiftData の中核です。このセクションでは、モデルの最初の役割を詳しく見て、永続化の構造とそれが ModelContainer とどのように連携するかを説明します。

The ModelContainer is where you describe how data is stored, or persisted, on a device
ModelContainer は、デバイス上でデータがどのように保存または保持されるかを記述する場所です。

We can think of the ModelContainer as the bridge between the Schema and its persistence
ModelContainer は、スキーマとその永続性の間のブリッジとして考えることができます。

It's where descriptions about how objects are stored, like whether they're in memory, or on disk, meet the operational and evolutionary semantics of that storage like versioning, migration, and graph separation
ここでは、オブジェクトがメモリ内にあるかディスク上にあるかなど、オブジェクトの保存方法に関する記述が、バージョン管理、移行、グラフ分離などのストレージの運用セマンティクスおよび進化的セマンティクスを満たす場所です。

Instantiating a container with a Schema is easy
スキーマを使用してコンテナーをインスタンス化するのは簡単です

I can provide just the type I want to work with and SwiftData will figure out the rest of the Schema for me
操作したい型だけを指定すれば、SwiftData が残りのスキーマを計算してくれます。

For example, because the Trip class is related to other model types, ModelContainer actually infers this Schema, even though I only passed it a single type
たとえば、Trip クラスは他のモデル タイプに関連しているため、ModelContainer に単一のタイプを渡しただけであっても、実際には ModelContainer がこのスキーマを推論します。

ModelContainer has a number of other powerful initializers that are designed to grow with your code to enable increasingly complex configurations using a class called the ModelConfiguration.
ModelContainer には、コードに合わせて拡張するように設計された他の強力なイニシャライザーが多数あり、ModelConfiguration と呼ばれるクラスを使用してますます複雑な構成を可能にします。

The ModelConfiguration describes the persistence of a Schema
ModelConfiguration はスキーマの永続性を記述します。

It controls where data is stored, like in memory for transient data or on disk for persistent data
一時的なデータの場合はメモリ内、永続的なデータの場合はディスク上など、データの保存場所を制御します。

ModelConfiguration can use a specific file URL chosen by you, or it can generate one automatically using the entitlements of your application like the group container entitlement
ModelConfiguration は、ユーザーが選択した特定のファイル URL を使用することも、グループ コンテナー資格などのアプリケーションの資格を使用してファイル URL を自動的に生成することもできます。

The configuration can also describe that a persistence file should be loaded in a read only mode, preventing writes to sensitive or template data
構成では、永続化ファイルを読み取り専用モードでロードし、機密データやテンプレート データへの書き込みを防止する必要があることも記述できます。

And finally, applications that use more than one CloudKit container can specify it as part of the ModelConfiguration for a Schema.
最後に、複数の CloudKit コンテナを使用するアプリケーションは、それをスキーマの ModelConfiguration の一部として指定できます。

Let's imagine I want to add some contact information to SampleTrips using new Person and Address classes
新しい Person クラスと Address クラスを使用して、SampleTrips に連絡先情報を追加したいと考えてみましょう。

First, the total Schema is declared containing all of the types I want to use
まず、使用したいすべての型を含む合計スキーマが宣言されます。

Next, a Configuration is declared for the SampleTrips data containing the Trip, BucketListItem, and LivingAccommodations models
次に、Trip、BucketListItem、および LivingAccommodations モデルを含む SampleTrips データの構成が宣言されます。

It declares a URL for the file I want to use to store this specific object graph's data, and a container identifier for the CloudKit container I want to use when syncing the SampleTrips data to CloudKit
この特定のオブジェクト グラフのデータを保存するために使用するファイルの URL と、SampleTrips データを CloudKit に同期するときに使用する CloudKit コンテナのコンテナ識別子を宣言します。

Then, the models for the new Schema with Person and Address are declared in their own configuration with a unique file URL and CloudKit container identifier to keep this data separate from the Trips graph
次に、個人と住所を含む新しいスキーマのモデルが、このデータを Trips グラフから分離するために、一意のファイル URL と CloudKit コンテナ識別子を使用して独自の構成で宣言されます。

Finally, the Schema and configurations are combined to form the ModelContainer.
最後に、スキーマと構成を組み合わせて ModelContainer を形成します。

With the power of ModelConfiguration, it's easy to describe the persistence requirements of your application, no matter how complicated they may be
ModelConfiguration の機能を利用すると、アプリケーションの永続性要件がどんなに複雑であっても、簡単に記述できます。

In addition to instantiating a container by hand, SwiftUI applications can use the new modelContainer modifiers to create the container they want to work with.
SwiftUI アプリケーションは、手動でコンテナーをインスタンス化するだけでなく、新しい modelContainer 修飾子を使用して、操作するコンテナーを作成できます。

The modelContainer modifier can be added to any View or Scene in an application and it supports ModelContainers from simple to powerful and everything in between
modelContainer モディファイアは、アプリケーション内の任意のビューまたはシーンに追加でき、シンプルなものから強力なものまで、およびその間のすべての ModelContainer をサポートします。

In this section, I examined how to combine the Schema with persistence using ModelContainer
このセクションでは、ModelContainer を使用してスキーマと永続性を組み合わせる方法を検討しました。

It grows with your application as you build ever more powerful features and object graphs
より強力な機能やオブジェクト グラフを構築することで、アプリケーションとともに成長します。

And I demonstrated how you can use ModelConfiguration to unlock powerful persistence capabilities
そして、ModelConfiguration を使用して強力な永続化機能を利用できる方法をデモしました。

As we learned in "Meet SwiftData", the Model and ModelContext are two of the most frequently used concepts when writing user interfaces or operating on model objects
「SwiftData の紹介」で学んだように、Model と ModelContext は、ユーザー インターフェイスを作成するとき、またはモデル オブジェクトを操作するときに最も頻繁に使用される概念の 2 つです。

In this section, I'll take a deep dive into how the ModelContext tracks changes and persists edits through the ModelContainer.
このセクションでは、ModelContext が変更を追跡し、ModelContainer を通じて編集を保持する方法について詳しく説明します。

When we use the modelContainer modifier in view or scene code, it prepares the application's environment in a specific way
ビューまたはシーン コードで modelContainer モディファイアを使用すると、特定の方法でアプリケーションの環境が準備されます。

The modifier binds the new modelContext key in the environment to the container's mainContext
修飾子は、環境内の新しいmodelContextキーをコンテナのmainContextにバインドします。

The main context is a special MainActor-aligned model context intended for working with ModelObjects in scenes and views
メイン コンテキストは、シーンおよびビューで ModelObject を操作することを目的とした特別な MainActor に調整されたモデル コンテキストです。

By using the model context from the environment, view code has easy access to the context used by the Query here so that it can perform actions like delete here.
環境からのモデル コンテキストを使用することにより、ビュー コードはクエリで使用されるコンテキストに簡単にアクセスできるため、ここで削除などのアクションを実行できます。

So model contexts are easy to use and access but what do they actually do? We can think of the ModelContext as a view over the data an application manages.
モデル コンテキストは使いやすく、アクセスも簡単ですが、実際には何をするのでしょうか? ModelContext は、アプリケーションが管理するデータのビューとして考えることができます。

Data we want to work with is fetched into a model context as its used
操作したいデータは、使用時にモデル コンテキストにフェッチされます。

In SampleTrips, when the upcoming trips view loads the data for the list, each trip object is fetched into the main context
SampleTrips では、今後の旅行ビューがリストのデータをロードするときに、各旅行オブジェクトがメイン コンテキストにフェッチされます。

If a trip is edited, that change is recorded by the model context as a snapshot
旅行が編集されると、その変更はモデル コンテキストによってスナップショットとして記録されます。

As other changes are made, like inserting a new Trip or deleting an existing one, the context tracks and maintains state about these changes until you call "context.save()"
新しい旅行の挿入や既存の旅行の削除など、他の変更が行われると、コンテキストは「context.save()」を呼び出すまでこれらの変更に関する状態を追跡および維持します。

This means that even though the deleted trip is no longer visible in the list, it still exists in the ModelContext until that delete is persisted by calling save.
これは、削除された旅行がリストに表示されなくなっても、save を呼び出して削除が保持されるまで、ModelContext にまだ存在することを意味します。

Once save is called, the context persists changes to the ModelContainer and clears its state.
save が呼び出されると、コンテキストは ModelContainer への変更を保持し、その状態をクリアします。

If you're still referencing the objects in the context, like displaying them in a list, they will exist in the context until you're finished with them
オブジェクトをリストに表示するなど、コンテキスト内でオブジェクトをまだ参照している場合、それらは終了するまでコンテキスト内に存在します。

At which point they will be freed and the context emptied out
その時点でそれらは解放され、コンテキストは空になります。

The ModelContext works in coordination with the ModelContainer it is bound to
ModelContext は、バインドされている ModelContainer と連携して動作します。

It tracks the objects you fetch in your views and then propagates any changes when save executes
ビューでフェッチしたオブジェクトを追跡し、保存の実行時に変更を反映します。

ModelContext also supports features like rollback or reset for clearing its cached state when needed
ModelContext は、必要に応じてキャッシュされた状態をクリアするためのロールバックやリセットなどの機能もサポートしています。

This makes it the ideal place to support platform features like undo and autosave.
これにより、元に戻すや自動保存などのプラットフォーム機能をサポートするのに理想的な場所になります。

In SwiftUI applications, the modelContainer modifier has this isUndoEnabled argument, which binds the window's undo manager to the container's mainContext
SwiftUI アプリケーションでは、modelContainer モディファイアには isUndoEnabled 引数があり、ウィンドウのアンドゥ マネージャーをコンテナの mainContext にバインドします。

That means that as changes are made in the main context, system gestures like three finger swipe and shake can be used to undo or redo changes with no additional code
つまり、メイン コンテキストで変更が行われると、3 本指のスワイプやシェイクなどのシステム ジェスチャを使用して、追加のコードなしで変更を元に戻したりやり直したりできるようになります。

ModelContext automatically registers undo and redo actions as changes are made to model objects
ModelContext は、モデル オブジェクトに変更が加えられると、元に戻すアクションとやり直しアクションを自動的に登録します。

The modelContainer modifier uses the environment's undoManager which is usually provided by the system as part of the window or window group
modelContainer 修飾子は、通常、ウィンドウまたはウィンドウ グループの一部としてシステムによって提供される環境の undoManager を使用します。

and because of this, system gestures like three finger swipe and shake will automatically work in your applications
このため、3 本指のスワイプやシェイクなどのシステム ジェスチャがアプリケーションで自動的に機能します。

Another standard system feature supported by the ModelContext is Autosave
ModelContext でサポートされるもう 1 つの標準システム機能は自動保存です。

When autosave is enabled the model context will save in response to system events like an application entering the foreground or background
自動保存が有効になっている場合、アプリケーションがフォアグラウンドまたはバックグラウンドに入るなどのシステム イベントに応答してモデル コンテキストが保存されます。

The main context will also periodically save as an application is used
メイン コンテキストは、アプリケーションの使用時に定期的に保存されます。

Autosave is enabled by default in applications and can be disabled if desired using the modelContainer modifier's isAutosaveEnabled argument
自動保存はアプリケーションではデフォルトで有効になっており、必要に応じて、modelContainer モディファイアの isAutosaveEnabled 引数を使用して無効にすることができます。

Autosave is disabled for model contexts created by hand
手動で作成されたモデル コンテキストの自動保存は無効になっています

In "Meet SwiftData", we learned a lot about how to work with ModelContext in an application and how well it pairs with SwiftUI
「Meet SwiftData」では、アプリケーション内で ModelContext を操作する方法と、ModelContext が SwiftUI とどのようにうまく連携するかについて多くのことを学びました。

But user interfaces aren't the only places that applications need to work with model objects
しかし、アプリケーションがモデル オブジェクトを操作する必要があるのはユーザー インターフェイスだけではありません。

In this section, I'll examine how SwiftData makes writing powerful, scalable code easier and safer than ever.
このセクションでは、SwiftData を使用して、強力でスケーラブルなコードをこれまで以上に簡単かつ安全に作成できるようにする方法を検討します。

Tasks like working with data on a background queue, syncing with a remote server or other persistence mechanism, and batch processing all work with model objects, frequently in sets or graphs.
バックグラウンド キュー上のデータの操作、リモート サーバーまたは他の永続化メカニズムとの同期、バッチ処理などのタスクはすべて、多くの場合セットまたはグラフでモデル オブジェクトを操作します。

Many of these tasks will begin by fetching a set of objects to work with via the fetch method on a ModelContext
これらのタスクの多くは、ModelContext の fetch メソッドを介して、操作するオブジェクトのセットをフェッチすることから始まります。

In this example, the FetchDescriptor for the Trip model tells Swift that the trips array will be a collection of Trip objects
この例では、Trip モデルの FetchDescriptor が、trips 配列が Trip オブジェクトのコレクションになることを Swift に伝えます。

There's no casting or complicated result tuples to worry about.
キャストや複雑な結果タプルについて心配する必要はありません。

FetchDescriptor makes it easy to craft complicated queries using the new Predicate macro
FetchDescriptor により、新しい Predicate マクロを使用して複雑なクエリを簡単に作成できます

For example, what are all the trips that involve staying at a specific hotel? Or what trips still have some activities that I need to make reservations for? In SwiftData, complicated queries that support subqueries and joins can all be written in pure swift
たとえば、特定のホテルに滞在する旅行とはどのようなものでしょうか?または、予約が必要なアクティビティがまだある旅行は何ですか? SwiftData では、サブクエリと結合をサポートする複雑なクエリはすべて純粋な Swift で記述できます。

Predicate uses the Models you create and SwiftData uses the Schema generated from those models to translate these predicates into database queries
Predicate は作成したモデルを使用し、SwiftData はそれらのモデルから生成されたスキーマを使用してこれらの述語をデータベース クエリに変換します。

FetchDescriptor combines the power of the new Foundation Predicate macro with the Schema to bring compiler validated queries to persistence on Apple platforms for the first time
FetchDescriptor は、新しい Foundation Predicate マクロの機能とスキーマを組み合わせて、コンパイラで検証されたクエリを Apple プラットフォームで初めて永続化します。

FetchDescriptor and related classes, like SortDescriptor, use generics to form the result type and tell the compiler about the properties of the model you can use
FetchDescriptor と SortDescriptor などの関連クラスは、ジェネリックスを使用して結果の型を形成し、使用できるモデルのプロパティについてコンパイラーに伝えます。

There are a number of tuning options you've come to know and love, like offset and limit, as well as parameters for faulting and prefetching.
オフセットやリミット、フォルトやプリフェッチ用のパラメータなど、よく知られ愛用されているチューニング オプションが多数あります。

All of this power combines in the new enumerate function on ModelContext
このすべての機能が ModelContext の新しい列挙関数で結合されます。

It's designed to help make the foiblesome pattern of batch traversal and enumeration implicitly efficient by encapsulating the platform best practices at a single call site
単一の呼び出しサイトでプラットフォームのベスト プラクティスをカプセル化することで、バッチ トラバーサルと列挙の厄介なパターンを暗黙的に効率化できるように設計されています。

Enumerate works great with FetchDescriptors regardless of their complexity, from simple to powerful and everything in between
Enumerate は、単純なものから強力なものまで、その複雑さに関係なく、FetchDescriptors とうまく連携します。

Enumerate automatically implements platform best practices for traversals like batching and mutation guards
Enumerate は、バッチ処理やミューテーション ガードなどのトラバーサルに関するプラットフォームのベスト プラクティスを自動的に実装します。

These are customizable to meet the needs of your specific use case
これらは、特定の使用例のニーズに合わせてカスタマイズ可能です

For example, the batch size that enumerate uses defaults to 5,000 objects
たとえば、列挙に使用されるバッチ サイズのデフォルトは 5,000 オブジェクトです

But I could change it to 10,000 to reduce I/O operations during the traversal at the expense of memory growth
ただし、これを 10,000 に変更して、メモリの増加を犠牲にしてトラバース中の I/O 操作を減らすこともできます。

Heavier object graphs, like those that include images, movies, or other large data blobs, may choose to use a smaller batch size
画像、ムービー、その他の大きなデータ BLOB を含むような重いオブジェクト グラフでは、より小さいバッチ サイズの使用が選択される場合があります。

Decreasing the batch size reduces memory growth but increases I/O during the enumeration
バッチ サイズを小さくするとメモリの増加は減少しますが、列挙中の I/O が増加します。

Enumerate also includes mutation guard by default
Enumerate にはデフォルトで突然変異ガードも含まれます

One of the most frequent causes of performance issues with large traversals is mutations that are trapped in the context during the enumeration
大規模なトラバーサルによるパフォーマンスの問題の最も一般的な原因の 1 つは、列挙中にコンテキストに閉じ込められた突然変異です。

allowEscapingMutations tells enumerate that this is intentional, when not set, enumerate will throw if it discovers that the ModelContext performing the enumeration is dirty, preventing it from freeing objects that were already traversed.
allowEscapingMutations は、これが意図的であることを enumerate に伝えます。設定されていない場合、enumerate は、列挙を実行している ModelContext がダーティであることが判明した場合にスローされ、すでにトラバースされたオブジェクトを解放できなくなります。

In this session, we learned how to create powerful persistence configurations with Schema and ModelConfiguration
このセッションでは、Schema と ModelConfiguration を使用して強力な永続性構成を作成する方法を学びました。

We also learned how easy it is to adopt standard system practices like undo and redo with the ModelContainer and ModelContext
また、ModelContainer と ModelContext を使用すると、元に戻す、やり直すなどの標準的なシステム手法を簡単に導入できることも学びました。

And you can use SwiftData today to write safe, performant code in your project like never before with FetchDescriptor, predicate, and enumerate
そして、今すぐ SwiftData を使用して、FetchDescriptor、述語、列挙を使用して、これまでにないほど安全でパフォーマンスの高いコードをプロジェクトに記述することができます。

I can't wait to see how you push the limits of what's possible with this new framework in the months and years ahead
今後数か月、数年にわたって、この新しいフレームワークでどのように可能性の限界を押し広げていくのかを見るのが待ちきれません。

Thanks for watching and happy coding.
ご視聴いただきありがとうございます。コーディングを楽しんでください。


""",
      timestamp: Date()
    )
  }
}
