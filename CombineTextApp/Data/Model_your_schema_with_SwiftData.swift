import Foundation

extension ItemViewData {
  static var Model_your_schema_with_SwiftData: ItemViewData {
    .init(
      id: UUID().uuidString,
      title: "Model your schema with SwiftData",
      linkURL: URL(string: "https://developer.apple.com/wwdc23/10195"),
      firstText:"""
Rishi: Hello, my name is Rishi Verma, and this session covers how to code your models to build a schema for SwiftData.
I'll begin by covering how you can utilize schema macros to their fullest potential and how you can evolve your schema with schema migrations as your app changes.
Before getting started, please watch "Meet SwiftData" and "Build an app with SwiftData," as this content will develop upon the concepts introduced in those videos.
SwiftData is a powerful framework for data modeling and management and enhances your modern Swift app.
Like SwiftUI, it focuses entirely on code, with no external file formats, and uses Swift's new macro system to create a seamless API experience.

I am working on the SampleTrips app, which allows users to plan out some upcoming trips.
Each trip is to be created with a name, a destination, as well as start and end dates.
A trip can also contain relationships for bucket list items and where the travelers will stay.
Adding SwiftData is as simple as adding the import and decorating the Trip with @Model.
That's it.
The @Model macro conforms my Trip class to PersistentModel and generates a descriptive schema.
The code defining my model is now the source of truth for my application's schema.
The default behavior of my trip model is good, but I think I can fine-tune it a little.
SwiftData's schema macros allow me to customize the behavior of the persistence experience to work perfectly for my app.
When I published my app with the original schema, I did not ensure each trip name was unique.
This caused a few conflicts between trips with the same name that I now need to resolve.
This can be fixed with the @Attribute schema macro and using the unique option.
SwiftData will generate a schema for my trip's model that now ensures any trip that I save to the persistent back end will have a unique name.
If a trip already exists with that name, then the persistent back end will update to the latest values.
This is called an upsert.
An upsert starts as an insert.
If the insert collides with existing data, it becomes an update and updates the properties of the existing data.
I can apply unique constraints on other properties as well, so long as they are primitive value types such as numerics, string, or UUID, or I can even decorate a to-one relationship.
My schema needs a bit more work.
I want to remove these pesky underscores from my start_date and end_date that I originally specified.
If I just rename the variables, this would be seen as a new property in my generated schema.
I don't want SwiftData to create these new properties.
Instead, I want to preserve the existing data as is.
I can do so by simply mapping the original name to the property name using @Attribute and specifying the originalName: parameter.
By mapping these from the original name, I can avoid data loss.
This also ensures my schema update will be a simple migration for the next release of the SampleTrips app.
And the @Attribute macro can do so much more, including store large data externally and provide support for transformables.

My trips are shaping up nicely, but now I want to work on the relationships.
When I add a new bucket list item or a living accommodation to my trip, SwiftData will implicitly discover the inverses between my models and set them for me.
The implicit inverses do not require any annotations.
They just work.
Implicit inverses use a default delete rule that will nullify the bucket list items and living accommodation properties when a trip is deleted.
However, I want my bucket list items and living accommodation to be deleted along with the trip.
I can easily do that by adding the @Relationship macro with a cascade delete rule.
Now when I delete my trip, it will delete those relationships as well.
And the @Relationship macro does so much more, including the originalName modifier and the ability to specify the minimum and maximum count on a to-many relationship.
The SampleTrips app is shaping up nicely, but I still have an update to do.
Now, I want to add a way to track how many times I view a trip.
This way I can gauge how excited I am about taking a vacation.
I can't wait! I do not want this view count to be persisted by SwiftData, however, and I can easily do that with the @Transient macro.
I simply decorate my property with @Transient, and this particular property will not be persisted.
It's just that easy.
The @Transient macro helps you avoid persisting unnecessary data.
Make sure you provide a default value for transient properties.
This ensures they have logical values when fetched from SwiftData.
For more information on utilizing these schema macros, check out the SwiftData documentation.
The SampleTrips app schema has gone through several evolutions as I tailored the persistence experience.
I need to ensure that my app can handle those updates from release to release.
And when you make a change to your schema, like adding or removing a property, a data migration occurs.
These migrations can be tricky scenarios, but SwiftData makes it easy.
VersionedSchema and SchemaMigrationPlan are here to help you with that.
Whenever you prepare to release a new version of your app with changes to your SwiftData models, define a VersionedSchema that encapsulates your previously released schema.
Each distinct version of your schema should be defined as a VersionedSchema so that SwiftData knows what changes occurred between them.
Then, use your total ordering of VersionedSchemas to create a SchemaMigrationPlan.
This will allow SwiftData to perform the needed migrations in order.
Once you've laid out your ordered schemas in the migration plan, you can begin to define each migration stage.
There are two different types of migration stages available to you.
The first is a lightweight migration stage.
Lightweight migrations do not require any additional code to migrate the existing data for my next app release.
Modifications like adding originalName to my date properties or specifying the delete rules on my relationships are lightweight migration eligible.
However, making the name of a trip unique is not eligible for a lightweight migration.
I need to create a custom migration stage for this change, in which I can deduplicate my trips, before their names are made unique.
I start by taking the original schema from my first release and encapsulating it in a VersionedSchema.
I name this versioned schema SampleTripsSchemaV1.
Each of my versioned schemas list the model classes they define.
Version 2 of my schema is where I added the uniqueness constraint on trip names.
I create another versioned schema that also encapsulates the changes I made to the Trip model class.
I do the same for version 3 of my schema, capturing the name changes made to start and end date.
Now that I have all of my VersionedSchemas, I construct a SchemaMigrationPlan to describe how to handle the migrations from release to release.
It's rather simple.
I just provide the total ordering of my application's schemas.
Then, I need to annotate which migrations are lightweight or custom.
For V1 to V2, I need a custom stage where I can perform an operation before the data is migrated.
In the willMigrate closure, I can deduplicate my trips before the migration happens.
SwiftData will detect when a migration from V1 to V2 will occur and will perform this closure for me.
The other migration for originalName is lightweight, so I can add that stage in as well.
Now that I've defined all of the details about my migration plans, it's time to perform the migrations.
I setup my ModelContainer with my current schema and the migration plan, and I'm done.
My users can upgrade from any version to the latest release, and I have ensured the data will be preserved.
I can't wait to use the SampleTrips app to plan my upcoming vacation.
Harness schema macros to convey additional metadata for your schema, and as your application evolves, capture those evolutions in a VersionedSchema so your app can migrate from any previous release.
Check out these other talks, and we look forward to seeing the amazing things you all make with SwiftData.
It has been an honor.
""",
      translateText: """
Rishi: こんにちは、私の名前は Rishi Verma です。このセッションでは、モデルをコーディングして SwiftData のスキーマを構築する方法を説明します。
まず、スキーマ マクロを最大限に活用する方法と、アプリの変更に応じてスキーマを移行してスキーマを進化させる方法について説明します。
このコンテンツはこれらのビデオで紹介されている概念に基づいて展開されているため、始める前に「SwiftData の紹介」と「SwiftData を使用してアプリを構築する」をご覧ください。
SwiftData は、データのモデリングと管理のための強力なフレームワークであり、最新の Swift アプリを強化します。
SwiftUI と同様に、外部ファイル形式を使用せずに完全にコードに焦点を当て、Swift の新しいマクロ システムを使用してシームレスな API エクスペリエンスを作成します。

私は、ユーザーが今後の旅行を計画できるようにする SampleTrips アプリの開発に取り組んでいます。
各旅行は、名前、目的地、開始日と終了日を指定して作成されます。
旅行には、やりたいことリストの項目と旅行者の滞在場所の関係も含めることができます。
SwiftData の追加は、インポートを追加して @Model で Trip を装飾するのと同じくらい簡単です。
それでおしまい。
@Model マクロは、Trip クラスを PersistentModel に準拠させ、記述的なスキーマを生成します。
モデルを定義するコードが、アプリケーションのスキーマの信頼できる情報源になりました。
私の旅行モデルのデフォルトの動作は良好ですが、少し微調整できると思います。
SwiftData のスキーマ マクロを使用すると、永続化エクスペリエンスの動作をカスタマイズして、アプリで完全に動作させることができます。
元のスキーマを使用してアプリを公開したとき、各旅行名が一意であることを確認しませんでした。
これにより、同じ名前の旅行間でいくつかの競合が発生しましたが、現在解決する必要があります。
これは、@Attribute スキーマ マクロと独自のオプションを使用して修正できます。
SwiftData は旅行のモデルのスキーマを生成します。これにより、永続的なバックエンドに保存する旅行には必ず一意の名前が付けられます。
その名前の旅行がすでに存在する場合、永続的なバックエンドは最新の値に更新されます。
これはアップサートと呼ばれます。
UPSERT は挿入として開始されます。
挿入が既存のデータと衝突する場合、それは更新となり、既存のデータのプロパティが更新されます。
数値、文字列、UUID などのプリミティブな値タイプである限り、他のプロパティにも一意の制約を適用したり、1 対 1 の関係を装飾したりすることもできます。
私のスキーマにはもう少し作業が必要です。
最初に指定した start_date と end_date からこれらの厄介なアンダースコアを削除したいと考えています。
変数の名前を変更するだけであれば、これは生成されたスキーマ内の新しいプロパティとして認識されます。
SwiftData にこれらの新しいプロパティを作成させたくありません。
代わりに、既存のデータをそのまま保存したいと考えています。
これを行うには、@Attribute を使用して元の名前をプロパティ名にマッピングし、originalName: パラメーターを指定するだけです。
これらを元の名前からマッピングすることで、データの損失を回避できます。
これにより、スキーマの更新が SampleTrips アプリの次のリリースへの簡単な移行になることも保証されます。
また、@Attribute マクロは、大規模なデータを外部に保存したり、変換可能ファイルのサポートを提供したりするなど、さらに多くのことを行うことができます。

旅行は順調に進んでいますが、今は人間関係に取り組みたいと思っています。
新しいバケット リストの項目や宿泊施設を旅行に追加すると、SwiftData は暗黙的にモデル間の逆数を検出し、それらを設定します。
暗黙的な逆関数には注釈は必要ありません。
彼らはただ働くだけです。
暗黙的な反転では、旅行が削除されたときにバケット リストの項目と宿泊施設のプロパティを無効にするデフォルトの削除ルールが使用されます。
ただし、旅行に合わせて、やりたいことリストの項目と宿泊施設を削除したいと考えています。
@Relationship マクロとカスケード削除ルールを追加することで、これを簡単に行うことができます。
旅行を削除すると、それらの関係も削除されます。
また、@Relationship マクロは、originalName 修飾子や、対多関係の最小数と最大数を指定する機能など、さらに多くの機能を備えています。
SampleTrips アプリは順調に仕上がってきていますが、まだ更新する必要があります。
次に、旅行を表示した回数を追跡する方法を追加したいと思います。
こうすることで、自分が休暇を取ることにどれだけ興奮しているかを知ることができます。
待ってられない！ただし、このビュー数を SwiftData によって保持されることは望ましくありません。これは @Transient マクロを使用して簡単に実行できます。
プロパティを @Transient で装飾するだけです。この特定のプロパティは永続化されません。
それはとても簡単です。
@Transient マクロは、不要なデータの永続化を避けるのに役立ちます。
一時プロパティには必ずデフォルト値を指定してください。
これにより、SwiftData からフェッチされたときに論理値が確実に得られます。
これらのスキーマ マクロの利用方法の詳細については、SwiftData のドキュメントを参照してください。
SampleTrips アプリのスキーマは、永続性エクスペリエンスを調整するにつれていくつかの進化を遂げてきました。
アプリがリリースごとにこれらの更新を処理できることを確認する必要があります。
また、プロパティの追加や削除など、スキーマに変更を加えると、データの移行が発生します。
これらの移行は難しいシナリオになる可能性がありますが、SwiftData を使用すると簡単になります。
VersionedSchema と SchemaMigrationPlan は、これを支援するためにここにあります。
SwiftData モデルに変更を加えてアプリの新しいバージョンをリリースする準備をするときは常に、以前にリリースされたスキーマをカプセル化する VersionedSchema を定義します。
SwiftData がそれらの間でどのような変更が発生したかを認識できるように、スキーマの個別のバージョンをそれぞれ VersionedSchema として定義する必要があります。
次に、VersionedSchemas の合計順序を使用して SchemaMigrationPlan を作成します。
これにより、SwiftData は必要な移行を順番に実行できるようになります。
移行計画で順序付けされたスキーマをレイアウトしたら、各移行段階の定義を開始できます。
利用できる移行ステージには 2 つの異なるタイプがあります。
1 つ目は軽量の移行ステージです。
軽量移行では、次のアプリのリリースに向けて既存のデータを移行するための追加のコードは必要ありません。
日付プロパティにoriginalNameを追加したり、関係に削除ルールを指定したりするような変更は、軽量移行の対象となります。
ただし、旅行の名前を一意にすることは、軽量移行の対象にはなりません。
この変更に対してカスタム移行ステージを作成する必要があります。このステージでは、旅行の名前が一意になる前に、旅行の重複を排除できます。
まず、最初のリリースから元のスキーマを取得し、それを VersionedSchema にカプセル化します。
このバージョン管理されたスキーマに SampleTripsSchemaV1 という名前を付けます。
バージョン管理された各スキーマには、定義されているモデル クラスがリストされています。
私のスキーマのバージョン 2 では、旅行名の一意性制約を追加しました。
Trip モデル クラスに加えた変更もカプセル化する、別のバージョン管理されたスキーマを作成します。
スキーマのバージョン 3 に対しても同じことを行い、開始日と終了日に加えられた名前の変更をキャプチャします。
VersionedSchemas をすべて取得したので、リリース間の移行を処理する方法を説明する SchemaMigrationPlan を構築します。
それはかなり単純です。
アプリケーションのスキーマの全体的な順序を指定するだけです。
次に、どの移行が軽量またはカスタムであるかに注釈を付ける必要があります。
V1 から V2 への場合、データを移行する前に操作を実行できるカスタム ステージが必要です。
willMigrate クロージャでは、移行が行われる前に旅行の重複を排除できます。
SwiftData は、V1 から V2 への移行がいつ発生するかを検出し、このクロージャを実行します。
originalName のもう 1 つの移行は軽量なので、そのステージも追加できます。
移行計画に関する詳細をすべて定義したので、移行を実行します。
現在のスキーマと移行計画を使用して ModelContainer をセットアップしたら、完了です。
ユーザーはどのバージョンからでも最新リリースにアップグレードでき、データは確実に保持されます。
SampleTrips アプリを使用して次の休暇の計画を立てるのが待ちきれません。
スキーマ マクロを利用してスキーマの追加メタデータを伝達し、アプリケーションが進化するにつれて、それらの進化を VersionedSchema にキャプチャして、アプリを以前のリリースから移行できるようにします。
これらの他の講演もチェックしてください。皆さんが SwiftData を使って素晴らしいものを作るのを楽しみにしています。
とても光栄なことです。
""",
      combineText: """
Rishi: Hello, my name is Rishi Verma, and this session covers how to code your models to build a schema for SwiftData.
Rishi: こんにちは、私の名前は Rishi Verma です。このセッションでは、モデルをコーディングして SwiftData のスキーマを構築する方法を説明します。

I'll begin by covering how you can utilize schema macros to their fullest potential and how you can evolve your schema with schema migrations as your app changes.
まず、スキーマ マクロを最大限に活用する方法と、アプリの変更に応じてスキーマを移行してスキーマを進化させる方法について説明します。

Before getting started, please watch "Meet SwiftData" and "Build an app with SwiftData," as this content will develop upon the concepts introduced in those videos.
このコンテンツはこれらのビデオで紹介されている概念に基づいて展開されているため、始める前に「SwiftData の紹介」と「SwiftData を使用してアプリを構築する」をご覧ください。

SwiftData is a powerful framework for data modeling and management and enhances your modern Swift app.
SwiftData は、データのモデリングと管理のための強力なフレームワークであり、最新の Swift アプリを強化します。

Like SwiftUI, it focuses entirely on code, with no external file formats, and uses Swift's new macro system to create a seamless API experience.
SwiftUI と同様に、外部ファイル形式を使用せずに完全にコードに焦点を当て、Swift の新しいマクロ システムを使用してシームレスな API エクスペリエンスを作成します。

I am working on the SampleTrips app, which allows users to plan out some upcoming trips.
私は、ユーザーが今後の旅行を計画できるようにする SampleTrips アプリの開発に取り組んでいます。

Each trip is to be created with a name, a destination, as well as start and end dates.
各旅行は、名前、目的地、開始日と終了日を指定して作成されます。

A trip can also contain relationships for bucket list items and where the travelers will stay.
旅行には、やりたいことリストの項目と旅行者の滞在場所の関係も含めることができます。

Adding SwiftData is as simple as adding the import and decorating the Trip with @Model.
SwiftData の追加は、インポートを追加して @Model で Trip を装飾するのと同じくらい簡単です。

That's it.
それでおしまい。

The @Model macro conforms my Trip class to PersistentModel and generates a descriptive schema.
@Model マクロは、Trip クラスを PersistentModel に準拠させ、記述的なスキーマを生成します。

The code defining my model is now the source of truth for my application's schema.
モデルを定義するコードが、アプリケーションのスキーマの信頼できる情報源になりました。

The default behavior of my trip model is good, but I think I can fine-tune it a little.
私の旅行モデルのデフォルトの動作は良好ですが、少し微調整できると思います。

SwiftData's schema macros allow me to customize the behavior of the persistence experience to work perfectly for my app.
SwiftData のスキーマ マクロを使用すると、永続化エクスペリエンスの動作をカスタマイズして、アプリで完全に動作させることができます。

When I published my app with the original schema, I did not ensure each trip name was unique.
元のスキーマを使用してアプリを公開したとき、各旅行名が一意であることを確認しませんでした。

This caused a few conflicts between trips with the same name that I now need to resolve.
これにより、同じ名前の旅行間でいくつかの競合が発生しましたが、現在解決する必要があります。

This can be fixed with the @Attribute schema macro and using the unique option.
これは、@Attribute スキーマ マクロと独自のオプションを使用して修正できます。

SwiftData will generate a schema for my trip's model that now ensures any trip that I save to the persistent back end will have a unique name.
SwiftData は旅行のモデルのスキーマを生成します。これにより、永続的なバックエンドに保存する旅行には必ず一意の名前が付けられます。

If a trip already exists with that name, then the persistent back end will update to the latest values.
その名前の旅行がすでに存在する場合、永続的なバックエンドは最新の値に更新されます。

This is called an upsert.
これはアップサートと呼ばれます。

An upsert starts as an insert.
UPSERT は挿入として開始されます。

If the insert collides with existing data, it becomes an update and updates the properties of the existing data.
挿入が既存のデータと衝突する場合、それは更新となり、既存のデータのプロパティが更新されます。

I can apply unique constraints on other properties as well, so long as they are primitive value types such as numerics, string, or UUID, or I can even decorate a to-one relationship.
数値、文字列、UUID などのプリミティブな値タイプである限り、他のプロパティにも一意の制約を適用したり、1 対 1 の関係を装飾したりすることもできます。

My schema needs a bit more work.
私のスキーマにはもう少し作業が必要です。

I want to remove these pesky underscores from my start_date and end_date that I originally specified.
最初に指定した start_date と end_date からこれらの厄介なアンダースコアを削除したいと考えています。

If I just rename the variables, this would be seen as a new property in my generated schema.
変数の名前を変更するだけであれば、これは生成されたスキーマ内の新しいプロパティとして認識されます。

I don't want SwiftData to create these new properties.
SwiftData にこれらの新しいプロパティを作成させたくありません。

Instead, I want to preserve the existing data as is.
代わりに、既存のデータをそのまま保存したいと考えています。

I can do so by simply mapping the original name to the property name using @Attribute and specifying the originalName: parameter.
これを行うには、@Attribute を使用して元の名前をプロパティ名にマッピングし、originalName: パラメーターを指定するだけです。

By mapping these from the original name, I can avoid data loss.
これらを元の名前からマッピングすることで、データの損失を回避できます。

This also ensures my schema update will be a simple migration for the next release of the SampleTrips app.
これにより、スキーマの更新が SampleTrips アプリの次のリリースへの簡単な移行になることも保証されます。

And the @Attribute macro can do so much more, including store large data externally and provide support for transformables.
また、@Attribute マクロは、大規模なデータを外部に保存したり、変換可能ファイルのサポートを提供したりするなど、さらに多くのことを行うことができます。

My trips are shaping up nicely, but now I want to work on the relationships.
旅行は順調に進んでいますが、今は人間関係に取り組みたいと思っています。

When I add a new bucket list item or a living accommodation to my trip, SwiftData will implicitly discover the inverses between my models and set them for me.
新しいバケット リストの項目や宿泊施設を旅行に追加すると、SwiftData は暗黙的にモデル間の逆数を検出し、それらを設定します。

The implicit inverses do not require any annotations.
暗黙的な逆関数には注釈は必要ありません。

They just work.
彼らはただ働くだけです。

Implicit inverses use a default delete rule that will nullify the bucket list items and living accommodation properties when a trip is deleted.
暗黙的な反転では、旅行が削除されたときにバケット リストの項目と宿泊施設のプロパティを無効にするデフォルトの削除ルールが使用されます。

However, I want my bucket list items and living accommodation to be deleted along with the trip.
ただし、旅行に合わせて、やりたいことリストの項目と宿泊施設を削除したいと考えています。

I can easily do that by adding the @Relationship macro with a cascade delete rule.
@Relationship マクロとカスケード削除ルールを追加することで、これを簡単に行うことができます。

Now when I delete my trip, it will delete those relationships as well.
旅行を削除すると、それらの関係も削除されます。

And the @Relationship macro does so much more, including the originalName modifier and the ability to specify the minimum and maximum count on a to-many relationship.
また、@Relationship マクロは、originalName 修飾子や、対多関係の最小数と最大数を指定する機能など、さらに多くの機能を備えています。

The SampleTrips app is shaping up nicely, but I still have an update to do.
SampleTrips アプリは順調に仕上がってきていますが、まだ更新する必要があります。

Now, I want to add a way to track how many times I view a trip.
次に、旅行を表示した回数を追跡する方法を追加したいと思います。

This way I can gauge how excited I am about taking a vacation.
こうすることで、自分が休暇を取ることにどれだけ興奮しているかを知ることができます。

I can't wait! I do not want this view count to be persisted by SwiftData, however, and I can easily do that with the @Transient macro.
待ってられない！ただし、このビュー数を SwiftData によって保持されることは望ましくありません。これは @Transient マクロを使用して簡単に実行できます。

I simply decorate my property with @Transient, and this particular property will not be persisted.
プロパティを @Transient で装飾するだけです。この特定のプロパティは永続化されません。

It's just that easy.
それはとても簡単です。

The @Transient macro helps you avoid persisting unnecessary data.
@Transient マクロは、不要なデータの永続化を避けるのに役立ちます。

Make sure you provide a default value for transient properties.
一時プロパティには必ずデフォルト値を指定してください。

This ensures they have logical values when fetched from SwiftData.
これにより、SwiftData からフェッチされたときに論理値が確実に得られます。

For more information on utilizing these schema macros, check out the SwiftData documentation.
これらのスキーマ マクロの利用方法の詳細については、SwiftData のドキュメントを参照してください。

The SampleTrips app schema has gone through several evolutions as I tailored the persistence experience.
SampleTrips アプリのスキーマは、永続性エクスペリエンスを調整するにつれていくつかの進化を遂げてきました。

I need to ensure that my app can handle those updates from release to release.
アプリがリリースごとにこれらの更新を処理できることを確認する必要があります。

And when you make a change to your schema, like adding or removing a property, a data migration occurs.
また、プロパティの追加や削除など、スキーマに変更を加えると、データの移行が発生します。

These migrations can be tricky scenarios, but SwiftData makes it easy.
これらの移行は難しいシナリオになる可能性がありますが、SwiftData を使用すると簡単になります。

VersionedSchema and SchemaMigrationPlan are here to help you with that.
VersionedSchema と SchemaMigrationPlan は、これを支援するためにここにあります。

Whenever you prepare to release a new version of your app with changes to your SwiftData models, define a VersionedSchema that encapsulates your previously released schema.
SwiftData モデルに変更を加えてアプリの新しいバージョンをリリースする準備をするときは常に、以前にリリースされたスキーマをカプセル化する VersionedSchema を定義します。

Each distinct version of your schema should be defined as a VersionedSchema so that SwiftData knows what changes occurred between them.
SwiftData がそれらの間でどのような変更が発生したかを認識できるように、スキーマの個別のバージョンをそれぞれ VersionedSchema として定義する必要があります。

Then, use your total ordering of VersionedSchemas to create a SchemaMigrationPlan.
次に、VersionedSchemas の合計順序を使用して SchemaMigrationPlan を作成します。

This will allow SwiftData to perform the needed migrations in order.
これにより、SwiftData は必要な移行を順番に実行できるようになります。

Once you've laid out your ordered schemas in the migration plan, you can begin to define each migration stage.
移行計画で順序付けされたスキーマをレイアウトしたら、各移行段階の定義を開始できます。

There are two different types of migration stages available to you.
利用できる移行ステージには 2 つの異なるタイプがあります。

The first is a lightweight migration stage.
1 つ目は軽量の移行ステージです。

Lightweight migrations do not require any additional code to migrate the existing data for my next app release.
軽量移行では、次のアプリのリリースに向けて既存のデータを移行するための追加のコードは必要ありません。

Modifications like adding originalName to my date properties or specifying the delete rules on my relationships are lightweight migration eligible.
日付プロパティにoriginalNameを追加したり、関係に削除ルールを指定したりするような変更は、軽量移行の対象となります。

However, making the name of a trip unique is not eligible for a lightweight migration.
ただし、旅行の名前を一意にすることは、軽量移行の対象にはなりません。

I need to create a custom migration stage for this change, in which I can deduplicate my trips, before their names are made unique.
この変更に対してカスタム移行ステージを作成する必要があります。このステージでは、旅行の名前が一意になる前に、旅行の重複を排除できます。

I start by taking the original schema from my first release and encapsulating it in a VersionedSchema.
まず、最初のリリースから元のスキーマを取得し、それを VersionedSchema にカプセル化します。

I name this versioned schema SampleTripsSchemaV1.
このバージョン管理されたスキーマに SampleTripsSchemaV1 という名前を付けます。

Each of my versioned schemas list the model classes they define.
バージョン管理された各スキーマには、定義されているモデル クラスがリストされています。

Version 2 of my schema is where I added the uniqueness constraint on trip names.
私のスキーマのバージョン 2 では、旅行名の一意性制約を追加しました。

I create another versioned schema that also encapsulates the changes I made to the Trip model class.
Trip モデル クラスに加えた変更もカプセル化する、別のバージョン管理されたスキーマを作成します。

I do the same for version 3 of my schema, capturing the name changes made to start and end date.
スキーマのバージョン 3 に対しても同じことを行い、開始日と終了日に加えられた名前の変更をキャプチャします。

Now that I have all of my VersionedSchemas, I construct a SchemaMigrationPlan to describe how to handle the migrations from release to release.
VersionedSchemas をすべて取得したので、リリース間の移行を処理する方法を説明する SchemaMigrationPlan を構築します。

It's rather simple.
それはかなり単純です。

I just provide the total ordering of my application's schemas.
アプリケーションのスキーマの全体的な順序を指定するだけです。

Then, I need to annotate which migrations are lightweight or custom.
次に、どの移行が軽量またはカスタムであるかに注釈を付ける必要があります。

For V1 to V2, I need a custom stage where I can perform an operation before the data is migrated.
V1 から V2 への場合、データを移行する前に操作を実行できるカスタム ステージが必要です。

In the willMigrate closure, I can deduplicate my trips before the migration happens.
willMigrate クロージャでは、移行が行われる前に旅行の重複を排除できます。

SwiftData will detect when a migration from V1 to V2 will occur and will perform this closure for me.
SwiftData は、V1 から V2 への移行がいつ発生するかを検出し、このクロージャを実行します。

The other migration for originalName is lightweight, so I can add that stage in as well.
originalName のもう 1 つの移行は軽量なので、そのステージも追加できます。

Now that I've defined all of the details about my migration plans, it's time to perform the migrations.
移行計画に関する詳細をすべて定義したので、移行を実行します。

I setup my ModelContainer with my current schema and the migration plan, and I'm done.
現在のスキーマと移行計画を使用して ModelContainer をセットアップしたら、完了です。

My users can upgrade from any version to the latest release, and I have ensured the data will be preserved.
ユーザーはどのバージョンからでも最新リリースにアップグレードでき、データは確実に保持されます。

I can't wait to use the SampleTrips app to plan my upcoming vacation.
SampleTrips アプリを使用して次の休暇の計画を立てるのが待ちきれません。

Harness schema macros to convey additional metadata for your schema, and as your application evolves, capture those evolutions in a VersionedSchema so your app can migrate from any previous release.
スキーマ マクロを利用してスキーマの追加メタデータを伝達し、アプリケーションが進化するにつれて、それらの進化を VersionedSchema にキャプチャして、アプリを以前のリリースから移行できるようにします。

Check out these other talks, and we look forward to seeing the amazing things you all make with SwiftData.
これらの他の講演もチェックしてください。皆さんが SwiftData を使って素晴らしいものを作るのを楽しみにしています。

It has been an honor.
とても光栄なことです。


""",
      timestamp: Date()
    )
  }
}
