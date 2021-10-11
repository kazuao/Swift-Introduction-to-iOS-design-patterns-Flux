#  Flux
## 処理の流れ
1. Viewからの入力
2. ActionCreatorsに渡す
3. ActionCreatorsがAPI通信、DB処理等の処理を行う
4. ActionCreatorsがDispatcherにActionを渡す
5. DispatherにActionが送信されたら、予めに登録してあるcallbackを使用し、Storeにデータを通知する
6. StoreはDispatcherから受け取った、Actionのtype/dataをもとに、自身の状態を変更する
7. 更新されたStoreをもとにViewが表示データを更新する


