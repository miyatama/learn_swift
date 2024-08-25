immersive app

+ new project
  + Initial Scene: Window
  + Immersive Space Render: RealityKit
  + Immersive Sppace: Mixed


learn

+ `@Environment`: ビューの環境値を取得する
+ `Task`: 非同期で実行
+ `fallthrough`
+ `error.localizedDescription`
+ イマーシブスペースを開いた時の原点は足元
+ イマーシブスペースは左手系Y-up
+ `SpatialTapGesture`: 3次元空間のタップ検知
  + エンティティにはコンポーネントをつけて反応させる
    + InputTargetComponent: 入力の検出
    + CollisionComponent: 衝突の検出(UnityのCollisionと同じ)
+ ECS: Entity, Component, System
  + Entity: 3Dモデル及び親子関係
  + Component: 挙動とそのデータ
  + System: updateメソッドとかの提供
+ `EntityQuery`
+ `Component.registerComponent()`
+ `System.registerSystem()`
+ `attachments`: RealityView内にSwiftUIを表示する機能