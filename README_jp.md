![Logo](https://github.com/mawastk/hyperspace-preview/blob/main/image/build/logo_2.png?raw=true)

# Hyperspace-preview
Androidで動作するSmash Hit用のレベルエディターです

![Screenshot](https://github.com/mawastk/hyperspace-preview/blob/ed310c6ec904443012c45610c5596521b3bee871/Screenshot.png?raw=true)

# インストール方法
Hyperspace, HyperspaceExporter, HyperspaceTesterの３つをインストールしてください

３つのアプリすべてを利用するにはAndroid5.1以上である必要があります。
（Android11以降では問題が発生する可能性があります）

| アプリ名 | 対応バージョン |
|:-----------|:------------:|
| Hyperspace       | Android 4.4.4 ~          |
| HyperspaceExporter     | Android 5.1 ~       |
| HyperspaceTester       | Android 2.3 ~         |

インストールが完了したらテンプレートxmlファイルをここに追加してください
/storage/emulated/0/Android/data/com.mawario.hyerspaceexporter/files/template.xml
(Android11でも動作するように、フルバージョンでは自動的に行われる予定です)

セットアップが完了したら、Hyperspaceを起動できます

# エクスポート方法

現時点でエクスポートメニューからはメッシュを含まない非圧縮xmlのエクスポートのみをサポートしています

QuickTestを実行した後はこのパスに.xml.gzと.meshが生成されるので、それを利用することも可能です
/storage/emulated/0/Android/data/com.mawario.hyerspaceexporter/files/

# 上手くいかない時
上手くいかないときは以下の点をチェックしてみてください

テンプレートファイルの拡張子は.xml.mp3ではなく、.xmlに設定してください

HyperspaceTesterでPlayを押すとフリーズしてしまう場合は、エクスポート後すぐにPlayを押してみてください

HyperspaceExporterでメッシュベイクされない場合は、キーボードアプリをgboardに置き換えてください
（Exporterにデータを送信するためにクリップボードを経由しているためです）

# より専門的な情報

MeshbakerChanが表示されているのにセグメントがうまくエクスポートされない場合は、クリップボード内のデータを確認してみてください
もし最後の２文字が"∞f"でない場合、セグメントのサイズが大きすぎるか、セグメントが破損しています

セグメントを作成する際は、元のxmlが18000文字を越さないことを目安にしてください
（技術的には24000文字まで行けそうですが、状況によって変わりそうなのでおすすめしないです...）

# 仕組み

HyperspaceエディターはGodotを使用して作成されています、ですがknot126氏のメッシュベイカーはpythonで記述されており、Godot内で実行することができません、そのためHyperspaceExporterに分離し、こちらはUnityで作成しています

UnityではChaquopyを使えるのでメッシュベイカーとその他のコードを実行してセグメントを生成して、HTTPサーバーを立ち上げます

HyperspaceTesterはKnShimをパッチしたSmash Hitをベースに作成しています、ローカルホストからレベルをダウンロードして、ユーザーデータフォルダに保存してプレイしています
（これを使えばPC側からセグメントのダウンロードができるかも？？？）

urlは http://<AndroidのローカルIPアドレス>:5000/ です<br>
/segment/に圧縮済みセグメント<br>
/mesh/にメッシュがアップロードされています<br>

chromeで開くとダウンロードされてしまうので、接続テストをする際には<br>
/test/にアクセスしてください（テキストが表示されます）

※ urlをパスではなく文字列として扱っているため、/segmentではなく、/segment/のように、最後のスラッシュをつけてください

# 使用したツール

KnShim by [knot126](https://codeberg.org/knot126)<br>
BakeMesh by [knot126](https://codeberg.org/knot126)
