import Foundation

extension ItemViewData {
  static var Meet_SwiftData: ItemViewData {
    .init(
      id: UUID().uuidString,
      title: "Meet SwiftData!",
      linkURL: URL(string: "https://developer.apple.com/videos/play/wwdc2023/10187/"),
      firstText:"""
Ben: Hi, I'm Ben Trumbull, and I'm excited to introduce SwiftData to you.

SwiftData is a powerful framework for data modeling and management and enhances your modern Swift app.
Like SwiftUI, it focuses entirely on code with no external file formats and uses Swift's new macro system to create a seamless API experience.

SwiftData relies on the expressivity provided by the new Swift language macros in order to create a seamless API experience.
And it is naturally integrated with SwiftUI and works with other platform features, like CloudKit and Widgets.
In this session, we'll look at the new @Model macro and its power to model your data directly from Swift code, I'll introduce you to fetching and modifying your data with SwiftData, then I'll finish up by providing you with an overview of some of the other platform frameworks that work seamlessly with SwiftData.

Now we'll look more into @Model.

@Model is a new Swift macro that helps to define your model's schema from your Swift code.
SwiftData schemas are normal Swift code, but when needed, you can annotate your properties with additional metadata.
Using this schema, SwiftData adds powerful functionality to your model objects.
It’s as simple as decorating your class with @Model, and the schema is generated.
Models in SwiftData are the source of truth for your application's schema and drive the persistence experience.
Part of this experience will transform the class' stored properties and turns them into persisted properties.
Adding @Model to your model opens up a world of possibilities.
SwiftData natively adapts your value type properties to be used as attributes right away.
These properties include basic value types, like string, int, and float.
They can also include more complex value types, such as structs, enums, and codable types too, including collections.
SwiftData models reference types as relationships.
You can create links between your model types with relationships and collections of model types.
@Model will modify all the stored properties on your type.
You can influence how SwiftData builds your schema using metadata on your properties.
With @Attribute, you can add uniqueness constraints.
You can use @Relationship to control the choice of inverses and specify delete propagation rules.
These change the behaviors of links between models.
You can tell SwiftData not to include specific properties with the Transient macro.
Here is our previous Trip example.
I'll adjust SwiftData's schema generation by adding metadata to our stored properties.

I can add @Attribute to name and specify that it should be unique.
I can also decorate our bucket list relationship with @Relationship and instruct Swift Data to delete all the related bucket list items whenever this trip is deleted.
To learn more about SwiftData modeling, check out the "Model your schema with SwiftData" session.
Now I'll cover how you can work with your model types and the two key objects you'll use to drive your operations: SwiftData's ModelContainer and ModelContext.
The model container provides the persistent backend for your model types.
You can use the default settings just by specifying your schema, or you can customize it with configurations and migration options.
You can create a model container just by specifying the list of model types you want stored.
If you want to customize your container further, you can use a configuration to change your URL, CloudKit and group container identifiers, and migration options With your container set up, you're ready to fetch and save data with model contexts.
You can also use SwiftUI's view and scene modifiers to set up container and have it automatically established in the view's environment.
Model contexts observe all the changes to your models and provide many of the actions to operate on them.
They are your interface to tracking updates, fetching data, saving changes, and even undoing those changes.

In SwiftUI, you'll generally get the modelContext from your view's environment after you create your model container.

Outside the view hierarchy, you can ask the model container to give you a shared main actor bound context, or you can simply instantiate new contexts for a given model container.
Once you have a context, you're ready to fetch data.
SwiftData benefits from new Swift native types like predicate and fetch descriptor, as well as significant improvements to Swift's native sort descriptor.

New in iOS 17, predicate works with native Swift types and uses Swift macros for strongly typed construction.
It's a fully type checked modern replacement for NSPredicate.
Implementing your predicates is easy, too, with Xcode support, like autocomplete.
Here are a few examples of building predicates for our Sample Trip app.
First, I can specify all the trips whose destination is New York.
I can narrow our query down to just trips about birthdays, and I can specify we're only interested in trips planned for the future, as opposed to any of our past adventures.
Once we've decided which trips we're interested in fetching, we can use the new FetchDescriptor type and instruct our ModelContext to fetch those trips.
Working together with FetchDescriptor, Swift SortDescriptor is getting some updates to support native Swift types and keypaths, and we can use SortDescriptor to specify the order in which we'd like our fetched Trips to be organized.
FetchDescriptor offers many other ways to tailor your SwiftData queries.
In addition to predicates and sorting, you can specify related objects to prefetch, limiting the result count, excluding unsaved changes from the results, and much more.
SwiftData also makes it easy to create, delete, and change your data by using the ModelContext to drive these operations.
After creating your model objects like any other Swift classes, you can insert them into the context and begin using SwiftData features, like change tracking and persistence.
Deleting persistent objects is as easy as telling the ModelContext to mark them for deletion, and you can save these and other pending changes by asking the ModelContext to save them and commit them to the persistent container.
Changing property values on your model objects is as simple as using the property setters as you normally would.
The Model macro modifies your stored properties to help the ModelContext track your changes automatically and include them in your next save operation.

To learn more about SwiftData containers and contexts and driving its operations, check out the "Dive Deeper into SwiftData" session.
SwiftData was built with SwiftUI in mind, and using them together couldn't be easier.
SwiftUI is the easiest way to get started using SwiftData.
Whether its setting up your SwiftData container, fetching data, or driving your view updates, we've built APIs directly integrating these frameworks.
The new SwiftUI scene and view modifiers are the easiest way to get started building a SwiftData application.
With SwiftUI, you can configure your data store, change your options, enable undo, and toggle autosaving.
SwiftUI will propagate your model context in its environment.
Once you've set up, the easiest way to start using your data is the new @Query property wrapper.
You can easily load and filter anything stored in your database with a single line of code.
SwiftData supports the all-new observable feature for your modeled properties.
SwiftUI will automatically refresh changes on any of the observed properties.
SwiftUI and SwiftData work hand in hand to help you build engaging and powerful apps.
Learn more about using these frameworks together in our "Build an app with SwiftData" session.

SwiftData is a powerful new solution to data management, designed with first-class support for Swift's features.
It uses Swift's new macro system to focus entirely on your code.
Set up your schema using @model, and configure your persistence experience with the model container.
You can easily enable persistence, undo and redo, iCloud synchronization, widget development, and more.
Start building SwiftData into your apps right away by leveraging SwiftUI's seamless integration.
We're excited to see what you build with SwiftData, and thanks for watching.
""",
      translateText: """
Ben: こんにちは、私は Ben Trumbull です。SwiftData を紹介できることを楽しみにしています。

SwiftData は、データのモデリングと管理のための強力なフレームワークであり、最新の Swift アプリを強化します。
SwiftUI と同様に、外部ファイル形式を使用しないコードに完全に焦点を当てており、Swift の新しいマクロ システムを使用してシームレスな API エクスペリエンスを作成します。

SwiftData は、シームレスな API エクスペリエンスを作成するために、新しい Swift 言語マクロによって提供される表現力に依存しています。
また、SwiftUI と自然に統合されており、CloudKit やウィジェットなどの他のプラットフォーム機能と連携します。
このセッションでは、新しい @Model マクロと、Swift コードからデータを直接モデル化するその機能について説明します。次に、SwiftData を使用してデータを取得して変更する方法を紹介します。最後に、以下を提供します。 SwiftData とシームレスに連携する他のプラットフォーム フレームワークの概要。

ここで、@Model について詳しく見ていきます。

@Model は、Swift コードからモデルのスキーマを定義するのに役立つ新しい Swift マクロです。
SwiftData スキーマは通常の Swift コードですが、必要に応じて、追加のメタデータでプロパティに注釈を付けることができます。
このスキーマを使用して、SwiftData はモデル オブジェクトに強力な機能を追加します。
クラスを @Model で装飾するだけで簡単にスキーマが生成されます。
SwiftData のモデルは、アプリケーションのスキーマの信頼できる情報源であり、永続性エクスペリエンスを推進します。
このエクスペリエンスの一部として、クラスの保存されたプロパティが変換され、永続化されたプロパティに変わります。
@Model をモデルに追加すると、可能性の世界が広がります。
SwiftData は、値型プロパティをネイティブに適応させて、属性としてすぐに使用できるようにします。
これらのプロパティには、string、int、float などの基本的な値の型が含まれます。
また、構造体、列挙型、およびコレクションを含むコード化可能な型など、より複雑な値型を含めることもできます。
SwiftData モデルは、型を関係として参照します。
モデル タイプの関係およびコレクションを使用して、モデル タイプ間のリンクを作成できます。
@Model は、型に保存されているすべてのプロパティを変更します。
プロパティのメタデータを使用して、SwiftData がスキーマを構築する方法に影響を与えることができます。
@Attribute を使用すると、一意性制約を追加できます。
@Relationship を使用して、逆の選択を制御し、削除伝播ルールを指定できます。
これらにより、モデル間のリンクの動作が変更されます。
Transient マクロに特定のプロパティを含めないように SwiftData に指示できます。
前回の旅行の例は次のとおりです。
保存されたプロパティにメタデータを追加して、SwiftData のスキーマ生成を調整します。

@Attribute を名前に追加して、一意であるように指定できます。
バケット リストの関係を @Relationship で装飾し、この旅行が削除されるたびに関連するバケット リストの項目をすべて削除するように Swift Data に指示することもできます。
SwiftData モデリングの詳細については、「SwiftData を使用してスキーマをモデル化する」セッションを確認してください。
次に、モデル タイプと、操作を実行するために使用する 2 つの主要なオブジェクト (SwiftData の ModelContainer と ModelContext) を操作する方法について説明します。
モデル コンテナーは、モデル タイプの永続的なバックエンドを提供します。
スキーマを指定するだけでデフォルト設定を使用することも、構成と移行オプションを使用してカスタマイズすることもできます。
保存したいモデル タイプのリストを指定するだけで、モデル コンテナを作成できます。
コンテナをさらにカスタマイズしたい場合は、構成を使用して URL、CloudKit およびグループ コンテナ識別子、移行オプションを変更できます。コンテナがセットアップされたら、モデル コンテキストを使用してデータをフェッチして保存する準備が整います。
SwiftUI のビューおよびシーン修飾子を使用してコンテナをセットアップし、それをビューの環境に自動的に確立することもできます。
モデル コンテキストはモデルへのすべての変更を監視し、それらを操作するための多くのアクションを提供します。
これらは、更新の追跡、データの取得、変更の保存、さらにはそれらの変更の取り消しを行うためのインターフェイスです。

SwiftUI では、通常、モデル コンテナーを作成した後、ビューの環境から modelContext を取得します。

ビュー階層の外では、モデル コンテナーに共有のメイン アクター バインドされたコンテキストを提供するように要求することも、特定のモデル コンテナーの新しいコンテキストを単純にインスタンス化することもできます。
コンテキストを取得したら、データをフェッチする準備が整います。
SwiftData は、述語やフェッチ記述子などの新しい Swift ネイティブ型と、Swift のネイティブ ソート記述子の大幅な改善の恩恵を受けています。

iOS 17 の新機能、述語はネイティブの Swift 型で動作し、厳密に型指定された構築に Swift マクロを使用します。
これは、NSPredicate の完全に型チェックされた最新の代替品です。
オートコンプリートなどの Xcode サポートを使用すると、述語の実装も簡単になります。
以下に、Sample Trip アプリの述語を構築する例をいくつか示します。
まず、目的地がニューヨークであるすべての旅行を指定できます。
クエリを誕生日に関する旅行だけに絞り込むこともできますし、過去の冒険ではなく、将来計画されている旅行のみに興味があると指定することもできます。
どの旅行を取得するかを決定したら、新しい FetchDescriptor タイプを使用して、それらの旅行を取得するように ModelContext に指示できます。
FetchDescriptor と連携して、Swift SortDescriptor はネイティブの Swift タイプとキーパスをサポートするためにいくつかの更新を取得しています。また、SortDescriptor を使用して、取得した旅行を整理する順序を指定できます。
FetchDescriptor は、SwiftData クエリを調整するための他の多くの方法を提供します。
述語と並べ替えに加えて、プリフェッチする関連オブジェクトを指定したり、結果の数を制限したり、結果から未保存の変更を除外したりすることもできます。
SwiftData では、ModelContext を使用してこれらの操作を実行することにより、データの作成、削除、変更も簡単に行えます。
他の Swift クラスと同様にモデル オブジェクトを作成した後、それらをコンテキストに挿入し、変更追跡や永続化などの SwiftData 機能の使用を開始できます。
永続オブジェクトの削除は、ModelContext に削除対象のマークを付けるように指示するだけで簡単です。これらの変更やその他の保留中の変更を保存し、永続コンテナにコミットするように ModelContext に要求することで保存できます。
モデル オブジェクトのプロパティ値の変更は、通常のようにプロパティ セッターを使用するのと同じくらい簡単です。
Model マクロは、保存されたプロパティを変更して、ModelContext が変更を自動的に追跡し、次回の保存操作にその変更を含められるようにします。

SwiftData コンテナーとコンテキスト、およびその操作の推進について詳しくは、「SwiftData の詳細」セッションをご覧ください。
SwiftData は SwiftUI を念頭に置いて構築されており、これらを組み合わせて使用​​するのはこれ以上に簡単ではありません。
SwiftUI は、SwiftData の使用を開始する最も簡単な方法です。
SwiftData コンテナーのセットアップ、データのフェッチ、ビューの更新の駆動など、これらのフレームワークを直接統合する API を構築しました。
新しい SwiftUI シーンおよびビュー修飾子は、SwiftData アプリケーションの構築を開始する最も簡単な方法です。
SwiftUI を使用すると、データ ストアの構成、オプションの変更、元に戻すの有効化、自動保存の切り替えを行うことができます。
SwiftUI は、モデルのコンテキストをその環境に伝播します。
セットアップが完了したら、新しい @Query プロパティ ラッパーを使用してデータの使用を開始する最も簡単な方法です。
データベースに保存されているものはすべて、1 行のコードで簡単にロードしてフィルタリングできます。
SwiftData は、モデル化されたプロパティのまったく新しい監視可能な機能をサポートします。
SwiftUI は、監視されたプロパティの変更を自動的に更新します。
SwiftUI と SwiftData は連携して機能し、魅力的で強力なアプリの構築を支援します。
これらのフレームワークの併用について詳しくは、「SwiftData を使用したアプリの構築」セッションをご覧ください。

SwiftData は、Swift の機能に対する最上級のサポートを備えて設計された、データ管理の強力な新しいソリューションです。
Swift の新しいマクロ システムを使用して、コードに完全に焦点を当てます。
@model を使用してスキーマを設定し、モデル コンテナーを使用して永続性エクスペリエンスを構成します。
永続化、元に戻すとやり直し、iCloud 同期、ウィジェット開発などを簡単に有効にすることができます。
SwiftUI のシームレスな統合を活用して、アプリへの SwiftData の構築をすぐに開始できます。
私たちは、皆さんが SwiftData を使って何を構築するかを見るのを楽しみにしています。ご覧いただきありがとうございます。
""",
      combineText: """
Ben: Hi, I'm Ben Trumbull, and I'm excited to introduce SwiftData to you.
Ben: こんにちは、私は Ben Trumbull です。SwiftData を紹介できることを楽しみにしています。

SwiftData is a powerful framework for data modeling and management and enhances your modern Swift app.
SwiftData は、データのモデリングと管理のための強力なフレームワークであり、最新の Swift アプリを強化します。

Like SwiftUI, it focuses entirely on code with no external file formats and uses Swift's new macro system to create a seamless API experience.
SwiftUI と同様に、外部ファイル形式を使用しないコードに完全に焦点を当てており、Swift の新しいマクロ システムを使用してシームレスな API エクスペリエンスを作成します。

SwiftData relies on the expressivity provided by the new Swift language macros in order to create a seamless API experience.
SwiftData は、シームレスな API エクスペリエンスを作成するために、新しい Swift 言語マクロによって提供される表現力に依存しています。

And it is naturally integrated with SwiftUI and works with other platform features, like CloudKit and Widgets.
また、SwiftUI と自然に統合されており、CloudKit やウィジェットなどの他のプラットフォーム機能と連携します。

In this session, we'll look at the new @Model macro and its power to model your data directly from Swift code, I'll introduce you to fetching and modifying your data with SwiftData, then I'll finish up by providing you with an overview of some of the other platform frameworks that work seamlessly with SwiftData.
このセッションでは、新しい @Model マクロと、Swift コードからデータを直接モデル化するその機能について説明します。次に、SwiftData を使用してデータを取得して変更する方法を紹介します。最後に、以下を提供します。 SwiftData とシームレスに連携する他のプラットフォーム フレームワークの概要。

Now we'll look more into @Model.
ここで、@Model について詳しく見ていきます。

@Model is a new Swift macro that helps to define your model's schema from your Swift code.
@Model は、Swift コードからモデルのスキーマを定義するのに役立つ新しい Swift マクロです。

SwiftData schemas are normal Swift code, but when needed, you can annotate your properties with additional metadata.
SwiftData スキーマは通常の Swift コードですが、必要に応じて、追加のメタデータでプロパティに注釈を付けることができます。

Using this schema, SwiftData adds powerful functionality to your model objects.
このスキーマを使用して、SwiftData はモデル オブジェクトに強力な機能を追加します。

It’s as simple as decorating your class with @Model, and the schema is generated.
クラスを @Model で装飾するだけで簡単にスキーマが生成されます。

Models in SwiftData are the source of truth for your application's schema and drive the persistence experience.
SwiftData のモデルは、アプリケーションのスキーマの信頼できる情報源であり、永続性エクスペリエンスを推進します。

Part of this experience will transform the class' stored properties and turns them into persisted properties.
このエクスペリエンスの一部として、クラスの保存されたプロパティが変換され、永続化されたプロパティに変わります。

Adding @Model to your model opens up a world of possibilities.
@Model をモデルに追加すると、可能性の世界が広がります。

SwiftData natively adapts your value type properties to be used as attributes right away.
SwiftData は、値型プロパティをネイティブに適応させて、属性としてすぐに使用できるようにします。

These properties include basic value types, like string, int, and float.
これらのプロパティには、string、int、float などの基本的な値の型が含まれます。

They can also include more complex value types, such as structs, enums, and codable types too, including collections.
また、構造体、列挙型、およびコレクションを含むコード化可能な型など、より複雑な値型を含めることもできます。

SwiftData models reference types as relationships.
SwiftData モデルは、型を関係として参照します。

You can create links between your model types with relationships and collections of model types.
モデル タイプの関係およびコレクションを使用して、モデル タイプ間のリンクを作成できます。

@Model will modify all the stored properties on your type.
@Model は、型に保存されているすべてのプロパティを変更します。

You can influence how SwiftData builds your schema using metadata on your properties.
プロパティのメタデータを使用して、SwiftData がスキーマを構築する方法に影響を与えることができます。

With @Attribute, you can add uniqueness constraints.
@Attribute を使用すると、一意性制約を追加できます。

You can use @Relationship to control the choice of inverses and specify delete propagation rules.
@Relationship を使用して、逆の選択を制御し、削除伝播ルールを指定できます。

These change the behaviors of links between models.
これらにより、モデル間のリンクの動作が変更されます。

You can tell SwiftData not to include specific properties with the Transient macro.
Transient マクロに特定のプロパティを含めないように SwiftData に指示できます。

Here is our previous Trip example.
前回の旅行の例は次のとおりです。

I'll adjust SwiftData's schema generation by adding metadata to our stored properties.
保存されたプロパティにメタデータを追加して、SwiftData のスキーマ生成を調整します。

I can add @Attribute to name and specify that it should be unique.
@Attribute を名前に追加して、一意であるように指定できます。

I can also decorate our bucket list relationship with @Relationship and instruct Swift Data to delete all the related bucket list items whenever this trip is deleted.
バケット リストの関係を @Relationship で装飾し、この旅行が削除されるたびに関連するバケット リストの項目をすべて削除するように Swift Data に指示することもできます。

To learn more about SwiftData modeling, check out the "Model your schema with SwiftData" session.
SwiftData モデリングの詳細については、「SwiftData を使用してスキーマをモデル化する」セッションを確認してください。

Now I'll cover how you can work with your model types and the two key objects you'll use to drive your operations: SwiftData's ModelContainer and ModelContext.
次に、モデル タイプと、操作を実行するために使用する 2 つの主要なオブジェクト (SwiftData の ModelContainer と ModelContext) を操作する方法について説明します。

The model container provides the persistent backend for your model types.
モデル コンテナーは、モデル タイプの永続的なバックエンドを提供します。

You can use the default settings just by specifying your schema, or you can customize it with configurations and migration options.
スキーマを指定するだけでデフォルト設定を使用することも、構成と移行オプションを使用してカスタマイズすることもできます。

You can create a model container just by specifying the list of model types you want stored.
保存したいモデル タイプのリストを指定するだけで、モデル コンテナを作成できます。

If you want to customize your container further, you can use a configuration to change your URL, CloudKit and group container identifiers, and migration options With your container set up, you're ready to fetch and save data with model contexts.
コンテナをさらにカスタマイズしたい場合は、構成を使用して URL、CloudKit およびグループ コンテナ識別子、移行オプションを変更できます。コンテナがセットアップされたら、モデル コンテキストを使用してデータをフェッチして保存する準備が整います。

You can also use SwiftUI's view and scene modifiers to set up container and have it automatically established in the view's environment.
SwiftUI のビューおよびシーン修飾子を使用してコンテナをセットアップし、それをビューの環境に自動的に確立することもできます。

Model contexts observe all the changes to your models and provide many of the actions to operate on them.
モデル コンテキストはモデルへのすべての変更を監視し、それらを操作するための多くのアクションを提供します。

They are your interface to tracking updates, fetching data, saving changes, and even undoing those changes.
これらは、更新の追跡、データの取得、変更の保存、さらにはそれらの変更の取り消しを行うためのインターフェイスです。

In SwiftUI, you'll generally get the modelContext from your view's environment after you create your model container.
SwiftUI では、通常、モデル コンテナーを作成した後、ビューの環境から modelContext を取得します。

Outside the view hierarchy, you can ask the model container to give you a shared main actor bound context, or you can simply instantiate new contexts for a given model container.
ビュー階層の外では、モデル コンテナーに共有のメイン アクター バインドされたコンテキストを提供するように要求することも、特定のモデル コンテナーの新しいコンテキストを単純にインスタンス化することもできます。

Once you have a context, you're ready to fetch data.
コンテキストを取得したら、データをフェッチする準備が整います。

SwiftData benefits from new Swift native types like predicate and fetch descriptor, as well as significant improvements to Swift's native sort descriptor.
SwiftData は、述語やフェッチ記述子などの新しい Swift ネイティブ型と、Swift のネイティブ ソート記述子の大幅な改善の恩恵を受けています。

New in iOS 17, predicate works with native Swift types and uses Swift macros for strongly typed construction.
iOS 17 の新機能、述語はネイティブの Swift 型で動作し、厳密に型指定された構築に Swift マクロを使用します。

It's a fully type checked modern replacement for NSPredicate.
これは、NSPredicate の完全に型チェックされた最新の代替品です。

Implementing your predicates is easy, too, with Xcode support, like autocomplete.
オートコンプリートなどの Xcode サポートを使用すると、述語の実装も簡単になります。

Here are a few examples of building predicates for our Sample Trip app.
以下に、Sample Trip アプリの述語を構築する例をいくつか示します。

First, I can specify all the trips whose destination is New York.
まず、目的地がニューヨークであるすべての旅行を指定できます。

I can narrow our query down to just trips about birthdays, and I can specify we're only interested in trips planned for the future, as opposed to any of our past adventures.
クエリを誕生日に関する旅行だけに絞り込むこともできますし、過去の冒険ではなく、将来計画されている旅行のみに興味があると指定することもできます。

Once we've decided which trips we're interested in fetching, we can use the new FetchDescriptor type and instruct our ModelContext to fetch those trips.
どの旅行を取得するかを決定したら、新しい FetchDescriptor タイプを使用して、それらの旅行を取得するように ModelContext に指示できます。

Working together with FetchDescriptor, Swift SortDescriptor is getting some updates to support native Swift types and keypaths, and we can use SortDescriptor to specify the order in which we'd like our fetched Trips to be organized.
FetchDescriptor と連携して、Swift SortDescriptor はネイティブの Swift タイプとキーパスをサポートするためにいくつかの更新を取得しています。また、SortDescriptor を使用して、取得した旅行を整理する順序を指定できます。

FetchDescriptor offers many other ways to tailor your SwiftData queries.
FetchDescriptor は、SwiftData クエリを調整するための他の多くの方法を提供します。

In addition to predicates and sorting, you can specify related objects to prefetch, limiting the result count, excluding unsaved changes from the results, and much more.
述語と並べ替えに加えて、プリフェッチする関連オブジェクトを指定したり、結果の数を制限したり、結果から未保存の変更を除外したりすることもできます。

SwiftData also makes it easy to create, delete, and change your data by using the ModelContext to drive these operations.
SwiftData では、ModelContext を使用してこれらの操作を実行することにより、データの作成、削除、変更も簡単に行えます。

After creating your model objects like any other Swift classes, you can insert them into the context and begin using SwiftData features, like change tracking and persistence.
他の Swift クラスと同様にモデル オブジェクトを作成した後、それらをコンテキストに挿入し、変更追跡や永続化などの SwiftData 機能の使用を開始できます。

Deleting persistent objects is as easy as telling the ModelContext to mark them for deletion, and you can save these and other pending changes by asking the ModelContext to save them and commit them to the persistent container.
永続オブジェクトの削除は、ModelContext に削除対象のマークを付けるように指示するだけで簡単です。これらの変更やその他の保留中の変更を保存し、永続コンテナにコミットするように ModelContext に要求することで保存できます。

Changing property values on your model objects is as simple as using the property setters as you normally would.
モデル オブジェクトのプロパティ値の変更は、通常のようにプロパティ セッターを使用するのと同じくらい簡単です。

The Model macro modifies your stored properties to help the ModelContext track your changes automatically and include them in your next save operation.
Model マクロは、保存されたプロパティを変更して、ModelContext が変更を自動的に追跡し、次回の保存操作にその変更を含められるようにします。

To learn more about SwiftData containers and contexts and driving its operations, check out the "Dive Deeper into SwiftData" session.
SwiftData コンテナーとコンテキスト、およびその操作の推進について詳しくは、「SwiftData の詳細」セッションをご覧ください。

SwiftData was built with SwiftUI in mind, and using them together couldn't be easier.
SwiftData は SwiftUI を念頭に置いて構築されており、これらを組み合わせて使用​​するのはこれ以上に簡単ではありません。

SwiftUI is the easiest way to get started using SwiftData.
SwiftUI は、SwiftData の使用を開始する最も簡単な方法です。

Whether its setting up your SwiftData container, fetching data, or driving your view updates, we've built APIs directly integrating these frameworks.
SwiftData コンテナーのセットアップ、データのフェッチ、ビューの更新の駆動など、これらのフレームワークを直接統合する API を構築しました。

The new SwiftUI scene and view modifiers are the easiest way to get started building a SwiftData application.
新しい SwiftUI シーンおよびビュー修飾子は、SwiftData アプリケーションの構築を開始する最も簡単な方法です。

With SwiftUI, you can configure your data store, change your options, enable undo, and toggle autosaving.
SwiftUI を使用すると、データ ストアの構成、オプションの変更、元に戻すの有効化、自動保存の切り替えを行うことができます。

SwiftUI will propagate your model context in its environment.
SwiftUI は、モデルのコンテキストをその環境に伝播します。

Once you've set up, the easiest way to start using your data is the new @Query property wrapper.
セットアップが完了したら、新しい @Query プロパティ ラッパーを使用してデータの使用を開始する最も簡単な方法です。

You can easily load and filter anything stored in your database with a single line of code.
データベースに保存されているものはすべて、1 行のコードで簡単にロードしてフィルタリングできます。

SwiftData supports the all-new observable feature for your modeled properties.
SwiftData は、モデル化されたプロパティのまったく新しい監視可能な機能をサポートします。

SwiftUI will automatically refresh changes on any of the observed properties.
SwiftUI は、監視されたプロパティの変更を自動的に更新します。

SwiftUI and SwiftData work hand in hand to help you build engaging and powerful apps.
SwiftUI と SwiftData は連携して機能し、魅力的で強力なアプリの構築を支援します。

Learn more about using these frameworks together in our "Build an app with SwiftData" session.
これらのフレームワークの併用について詳しくは、「SwiftData を使用したアプリの構築」セッションをご覧ください。

SwiftData is a powerful new solution to data management, designed with first-class support for Swift's features.
SwiftData は、Swift の機能に対する最上級のサポートを備えて設計された、データ管理の強力な新しいソリューションです。

It uses Swift's new macro system to focus entirely on your code.
Swift の新しいマクロ システムを使用して、コードに完全に焦点を当てます。

Set up your schema using @model, and configure your persistence experience with the model container.
@model を使用してスキーマを設定し、モデル コンテナーを使用して永続性エクスペリエンスを構成します。

You can easily enable persistence, undo and redo, iCloud synchronization, widget development, and more.
永続化、元に戻すとやり直し、iCloud 同期、ウィジェット開発などを簡単に有効にすることができます。

Start building SwiftData into your apps right away by leveraging SwiftUI's seamless integration.
SwiftUI のシームレスな統合を活用して、アプリへの SwiftData の構築をすぐに開始できます。

We're excited to see what you build with SwiftData, and thanks for watching.
私たちは、皆さんが SwiftData を使って何を構築するかを見るのを楽しみにしています。ご覧いただきありがとうございます。


""",
      timestamp: Date()
    )
  }
}
