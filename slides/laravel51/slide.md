title: Laravel 5.4 の QuickStart
author: Yasutaka Higa
profile: <yasutaka_higa@dwango.co.jp>
lang: Japanese

# 今回の発表の目的
* Laravel の紹介
* MVC Web Framework 触ったことありますアピール
* インフラもそこそこ触れますアピール

# Laravel とは
* PHP の Web フレームワーク
* MVC のフルスタック
    * Model: Eloquent ORM
    * View: *.blade.php
    * Controller: ? (DI とか可能らしい)

# QuickStart 5.1
* Laravel 公式の QuickStart
    * [Basic Task List](https://laravel.com/docs/5.1/quickstart)
* いわゆる TODO List
    * タスクに名前がある
    * タスクを追加できる
    * タスクが終わったら消せる
* CRUD の CRD だけできるやつを[作りました](https://github.com/atton-/laravel-quickstart)
    * デモンストレーション

# Routing
* URL PATH + callback anonymous function
    * `routes/web.php` とか
        * `Route::get('/', function() { return view('tasks')})
    * `routes/api.php` とか
    * `routes/console.php` とか
* 割とモダン。 webと api とで routes が分かれている

# Model
* Eloquent OR-Mapper
* 割と普通。特定の class を extends すると attributes が生える

```
class Task extends Model
{
    //
}
```

# View
* blade.php
* 基本的には html
* `@if` とか `@foreach` とか書く部分だけが特殊(blade)

# Migration
* 日付付きで名前管理
* up/down を定義
* 全体の schema file は無い(rails でいう schema.rb)
* php artisan migration で migration が走る

```
class CreateTasksTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('tasks', function (Blueprint $table) {
            $table->increments('id');
            $table->string('name');
            $table->timestamps();
        });
    }
```

# .env
* 環境変数の管理機構も用意されている
* default で redis 対応っぽい?
* .gitignore とかももちろん生成される
    * 便利

# package manager
* php の package manager は composer 推奨
* module とかもこいつで入れるみたい
* 特に感想は無し。 install で package 入りますね、というくらい
    * Gemfile.lock みたいなのも生成するので composer 一本で package 管理はOKそう

# 5.1 と 5.4 の違いは?
* Routing の部分のみ
    * 5.1 では web/api/channel.php に分かれていない
    * resouces/Http/routes.php に書く必要があった
    * その部分をまるまる web.php に持ってくると動きました
* とりあえずリポジトリは[ここ](https://github.com/atton-/laravel-quickstart)。


# PHP 書いててどう思う?
* パーフェクトPHPは罠っぽいのが大量にあってつらそうだった
    * 配列は全て連想配列である
    * 名前空間が \ 区切り
* Laravel は割とモダンというか踏み抜いたことは無い
    * 一番時間かけたのは Apache の config かも?
* あとは[ブログ](https://attonblog.blogspot.jp/2017/07/laravel-51-quickstart-using-laravel-54.html)にまとめてあります。

<!-- vim: set filetype=markdown.slide: -->
