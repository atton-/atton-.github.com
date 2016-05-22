title: Vim 勉強会 2014
author: atton
cover:
lang: Japanese

# あじぇんだ
* Vim とはaaaaaaaaaaaaa
* Vim の Tips
* Vim を強化する
* それから先

# Vim とは
* テキストエディタです
* 人によっては環境とかOSとか言います
* とりあえずテキストエディタとして説明していきます

# Vim と他のエディタ
* emacs
* sublime text
* などなど
* 使い方や特徴は様々で好みが分かれる
* 宗教戦争とも言われる

# Vim と成長曲線
![ editor skill graph ](http://mrozekma.com/editor-learning-curve.png)

# Vim の特徴
* mode があります
* operator + motion で組み合わせできる
* help でいろいろ引ける
* いろいろと拡張可能

# mode : normal mode
* 通常起動時は normal mode
    * 移動などのモード
    * hjkl で移動
    * DDR の上下左右です
    * 矢印使うのはやめてホームポジションのみで移動しましょう

# mode : insert mode
* 挿入モード
    * 書くモードです
    * ここでは文字を打つだけ
    * 打ち終わったら ctrl + [ で normal mode に戻りましょう
    * Esc でも良いですが ^[ でホームポジションのままでいきましょう

# mode : command line mode
* コマンドラインモード
    * コマンドを実行します
    * 置換、終了、ファイル保存、ファイルを開くなど
    * 基本的に元が行指向なので行に対するコマンドが多いです
    * 一回実行すると normal mode に戻ります

# mode : Visual mode
* ビジュアルモード
    * 選択モード
    * 選択、行選択、矩形選択などがあります
    * 影響範囲を可視化するモードです

# mode を踏まえた上で vimtutor
* Vim には mode があるエディタです
* チュートリアルコマンドがあります
    * $ vimtutor
* 基本的な機能はここで分かります

# 分からないことは
* help を使います
* :help
* :help でヘルプが出るので読んでいく
* :help の後にキーワードを入れると引くことができます

# help を引く
* help help
* モードごとの motion を引く場合は command_prefix _ motion とか
* help i _ ^o
* help c _ ^i
* ctrl は ^ です

# help を旅する
* タグジャンプがあります
* キーワードの上で ^]
* 戻るのは ^o とか

* help を活用しましょう

# Vim の紹介
* Vim の軽い紹介はここまで
* mode があります
* help を使おう
* vimtutor をしよう

# Vim の tips
* Vim には大量の tips があります
* 便利そうなのを紹介していきます

# tips : operator + motion
* Vim の command は組み合わせが効きます
* dj など
    * d delete
    * j down
* 先頭を operator, 後ろを motion と良います

# tips : operator + motion
* 例えば c : change を j と組み合わせることができます
* cj
    * c change
    * down
* j の変わりに fo でも然り。
* motion や operator を覚えると組み合わせが増える

# tips : count
* operator は物によっては繰り返せます
* count とか言います
    * 3dw
        * 3 : three times
        * d : delete
        * w : word

# tips : text-object
* operator の一種
    * i( : () の中身
    * a[ : [] の対応1つ
* などと痒いところに手が届く物体


# tips : persistent_undo
* Vim で開く前からずっと undo を記録し続ける機能
* ファイルを移動とかしなけれは作成時からずっと undo tree が残る

```
if has('persistent_undo')
    let &undodir = expand('~/.vim/undo_history')
    set undofile
endif
```

# tips : .vimrc
* 忘れてましたが設定は ~/.vimrc などに書きます
* set optionname
    * ex. set number
    * 行番号を表示する
    * ちなみに command line mode で実行しまくるのと変わりません
    * help を読みましょう

# tips : basic settings
* これはやっておかないとどうしようも無い設定
* vi 互換モードオフ + ファイルによって色を付ける

```
set nocompatible
filetype plugin indent on
syntax enable
```

# tips : shell command
* :! shell-command
* でシェルコマンドも実行できます
* 一部のコマンドと併用可能
    * :r ! ls
    * :read ! ls

# tips : summary
* motion と operator の組み合せで自分の思った作業を短かいキータイプで
* 自分好みの設定とかしましょう
    * ここでも help は重要です
* persistent_undo, text-object とか便利

# Vim を強化する
* Vim には機能拡張機能があります
* Vimscript によって記述される vim plugin
* それらの紹介など

# plugin : NeoBundle
* プラグインを管理するプラグイン
* .vimrc に一行書いてコマンド実行するとプラグインが導入される
* とても便利
* 遅延ロードもできる
    * 特定のコマンドが実行されるまでプラグインをロードしない

# plugin : Unite.vim
* 統一インターフェースを提供するプラグイン
    * 文字列の表示と絞り込みしてコマンド実行
    * まー何でもできる
    * file_rec, register, buffer, file_mru, grep
    * file_mru は neomru が必要

# plugin : neocomplete
* 補完プラグイン
* neosnippet と組み合せることでスニペットもできる

# plugin : quickrun
* プログラム実行プラグイン
* Vim にいながらプログラムを実行可能
* このスライドも quickrun で生成しながら書いてました

# plugin : ref.vim
* リファレンスを引くプラグイン
* refe や rfc や man でもござれ
* dictonary もできるよ
* spell と組み合せると英語とかにつよい

# plugin : surrond.vim
* text-object の拡張
* { を ( に変更することができたりする
* 消すとかもできる
* 痒いところに手が届く
* 無いと微妙に面倒

# plugin : clever-f
* f を clever にするプラグイン
    * ; を使わない f search
    * サーチ対象の色付け
    * 行を越えた検索
    * migemo search
* 痒いところをより良い感じにしてくれるプラグイン

# plugin : summary
* Vim を拡張する plugin はまだまだあります
* Tweet する、 yamada を表示する、 etc...
* ちなみにスパルタン派もいます
* あなただけの Vim を。


# reference
* 最後に参考文献とかお世話になったものを紹介
* まずは本から

# book :  Learning the vi Editor
* [入門vi](http://www.amazon.co.jp/%E5%85%A5%E9%96%80vi-%E7%AC%AC6%E7%89%88-%E3%83%AA%E3%83%B3%E3%83%80-%E3%83%A9%E3%83%A0/dp/4873110831)
* いわゆるベーシックなやつ。サーバ管理用に vi の知識が欲しいならこれかな
* Vim でも使える知識満載。 register の話とか macro とかね。

# book : vim technic bible
* [Vimテクニックバイブル　～作業効率をカイゼンする150の技](http://www.amazon.co.jp/Vim%E3%83%86%E3%82%AF%E3%83%8B%E3%83%83%E3%82%AF%E3%83%90%E3%82%A4%E3%83%96%E3%83%AB-%EF%BD%9E%E4%BD%9C%E6%A5%AD%E5%8A%B9%E7%8E%87%E3%82%92%E3%82%AB%E3%82%A4%E3%82%BC%E3%83%B3%E3%81%99%E3%82%8B150%E3%81%AE%E6%8A%80-Vim%E3%82%B5%E3%83%9D%E3%83%BC%E3%82%BF%E3%83%BC%E3%82%BA/dp/4774147958)
* tips 集。 Vim の小ネタ満載。
* plugin も扱ってます

# book : practical vim
* [実践Vim 思考のスピードで編集しよう! ](http://www.amazon.co.jp/%E5%AE%9F%E8%B7%B5Vim-%E6%80%9D%E8%80%83%E3%81%AE%E3%82%B9%E3%83%94%E3%83%BC%E3%83%89%E3%81%A7%E7%B7%A8%E9%9B%86%E3%81%97%E3%82%88%E3%81%86-Drew-Neil/dp/4048916599/ref=sr_1_1?s=books&ie=UTF8&qid=1408710479&sr=1-1&keywords=%E5%AE%9F%E8%B7%B5+vim)
* 入門的内容から拡張まで
* 割と足して2で割った感じ?
* ただわたしはそんなに読みうやすくなかった

# book : Vim Script technic bible
* [Vim script テクニックバイブル ~Vim使いの魔法の杖](http://www.amazon.co.jp/Vim-script-%E3%83%86%E3%82%AF%E3%83%8B%E3%83%83%E3%82%AF%E3%83%90%E3%82%A4%E3%83%96%E3%83%AB-%7EVim%E4%BD%BF%E3%81%84%E3%81%AE%E9%AD%94%E6%B3%95%E3%81%AE%E6%9D%96-script%E3%82%B5%E3%83%9D%E3%83%BC%E3%82%BF%E3%83%BC%E3%82%BA/dp/4774166340/ref=sr_1_1?s=books&ie=UTF8&qid=1408710542&sr=1-1&keywords=vim+script)
* 気になってる
* そのうち買って読む予定

# web : Vimの極め方
* [Vimの極め方](http://whileimautomaton.net/2008/08/vimworkshop3-kana-presentation)
* トゥルーVim使い kana さんによる Vim の極め方
* help の重要性と .vimrc の書き方講座
* 一度は見ておきたい

# web : vim-jp » vim-users.jp
* [vim-jp » vim-users.jp](http://vim-jp.org/vim-users-jp/)
* Vim-users のまとめ
* Vim の tips や Vimrc 読み会、 vim advent calender など情報満載

# web : 「立て！立つんだビムー！」 - sorry, uninuplemented:
* [「立て！立つんだビムー！」 - sorry, uninuplemented:](http://rhysd.hatenablog.com/entry/2012/12/19/001145)
* 犬ことりんだんさんによる Vim の高速化と速度計測
* Vim にプラグインを入れすぎてしまったら見ておきたい

# web : あるVimmerのブログ
* [あるVimmerのブログ](http://vinarian.blogspot.jp/)
* 知る人ぞ知る '暗黒美夢王'
* 以上。

# web : dot files by atton
* 私の[.vimrc]( https://github.com/atton-/dot_files )
* 公開してますので気になる方は
* 設定ファイルは公開しておくと便利
* 環境の移行も楽だし

# reference : summary
* Vim の極め方は是非見ておきたい
* 本のおすすめは入門vi

# today's summary
* Vim にはモードがあります
* motion と operator の組み合せ
* tips はたくさんあります
* 機能が足りなければ plugin として拡張できます
* 自分の使いたいように Vim を使おう

<!-- vim: set filetype=markdown.slide: -->
