# outline

YouTube見てると蚊が寄ってくるアプリ。

ざっくりとした挙動

+ Windowで能動的にスタートさせる
+ YouTube見れる画面的なのが前に出る
+ 30秒毎に蚊が放出される
+ 蚊は頭の周りをぐるぐる回る(1周8秒ペースぐらい)

## プロジェクト情報

| name | value | description |
| :---- | :---- | :---- |
| Initial Screen | Window | |
| Immersive Space Render | RealityKit | |
| Immersive Space | Mixed | |

## CodePiece

| code | behavior |
| :---- | :----- |
| MosquiTubeApp | ContentView, ImmersiveViewの切り替え |
| ContentView | スタートボタンの設置。ImmersiveViewへの切り替え |
| ImmersiveView | YouTube画面、蚊の配置 |
| WorldTracking | ヘッドセット位置の収集 |
| MosquitoManager | 蚊の実装, ヘッドセット位置をもらう。 |


## need resource

+ background image
+ mosquito 3d model
+ mosquito flying noize

