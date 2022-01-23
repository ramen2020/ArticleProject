## Overview
Projects that follow the kickstarter MVVM + Flux + RxSwift architecture. 
Use RxMoya for the API connection. 
RxSwift / MVVM / Flux / RXMoya

kickstarterのMVVM + Flux + RxSwiftのアーキテクチャを踏襲したプロジェクト。
API接続にはRxMoyaを使用します。


## Architecture
![project_architecture](https://user-images.githubusercontent.com/74945210/150667625-3a4f516e-d1ea-48bd-9341-46a5eaa1c83e.png)

### VM
- Since VMs can focus on processing that is not related to View and View can focus on View event firing and updates (View processing), ViewController bloat can be prevented.
- The View and VM are data-bound to each other, and the View state is updated in sync with changes in the ViewModel state and reflected on the screen.
- With kickstarter's MVVM, the input and output of data binding to the VM are clearly defined by the interface, so it is easy to understand the process flow even if the process becomes complex when it becomes large-scale.
<br>

- VMでViewに関係のない処理・ViewはViewのイベント発火・更新(Viewの処理)に専念できるので、ViewControllerの肥大化を防げる。
- ViewとVMは互いにデータバインディングし、ViewModel の状態変更に同期して Viewの状態も更新され、画面に反映。FRPに強いRxSwiftを用いるとデータバインディングが簡単に実現
- kickstarterのMVVMだと、インターフェースにより、VMへのデータバインディングのinputとoutputが明確になるので、大規模になった際に処理が複雑になっても、処理の流れが理解しやすい。

### Flux
- Unidirectional data flow makes it easy to grasp the processing flow.
- It is strong when state consistency between screens is required. Since data is managed by a singleton class (store pattern), state inconsistency does not occur.
- Since ActionCreators and Dispatchers share the same logic for updating and retrieving data from the store, it is easy to use on any screen. If you manage the state using only store instead of Flux, and update and retrieve store data on multiple screens, you will have to write the same process on multiple screens when updating store data in View or VM, which will be difficult if you need to modify the logic.
<br>

- 単一方向のデータフローで処理の流れを把握しやすい。
- 画面間の状態整合性が必要な場合に強い。シングルトンなクラスでデータを管理する(storeパターン)ので、状態の不整合が起きない。
- ActionCreatorsやDispatcherでストアのデータ更新・取得ロジックの共通化することになるので、どの画面でも使いやすい。もし、Fluxでなく、storeだけで状態を管理し、複数の画面でstoreのデータを更新・取得する場合、ViewまたはVMでstoreのデータを更新する際に、複数の画面で同じ処理を書かなければいけないので、ロジックの修正が起こった場合など大変。

## library
- RxSwift
- RxCocoa
- Moya/RxSwift
- Kingfisher
- R.swift
- SwiftSpinner

## Reference
- iOSアプリ設計パターン
- RxSwift 研究読本シリーズ
