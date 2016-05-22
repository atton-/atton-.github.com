title: Agda 入門
author: Yasutaka Higa
cover:
lang: Japanese


# このセミナーの目的
* 証明支援系の言語である Agda の入門を目的としています
* 具体的には
  * Agda による証明の方法を知る
  * 実際に自然数に対する演算の証明を追う
* ことをしていきます


# Agda とはどういう言語なのか
* 証明支援系と呼ばれる分野の言語です
  * 他には Coq などがあります
* Haskell で実装されています
* 型が非常に強力で表現力が高いです
  * 命題や仕様を表す論理式を型として定義することができます
  * 例えば 1 + 1 = 2 とか


# 型と証明との対応 : Curry-Howard Isomorphism
* Agda における証明は
  * 証明したい命題 == 関数の型
  * 命題の証明     == 関数の定義
* として定義します
* 関数と命題の対応を Curry-Howard Isomorphism と言います

# 命題と定義, 仕様と実装
* どうしてプログラムで証明できるかというと
* (命題 と 定義) は (仕様 と 実装) のように対応します
  * int chars_to_int(char * chars)
  * つまり char * から int は作れる、という命題に対応している
  * 実装は { itoa(chars) }
* char * から int は作れる、という仕様(型, 命題)は
* atoi という実装(定義)により証明された


# Agda をはじめよう
* emacs に agda-mode があります
* module filename where
* を先頭に書く必要があります
* 証明を定義していく
* C-c C-l で型チェック(証明チェック)ができます


# 自然数の定義 : Peano Arithmetic
* 自然数 0 が存在する
* 任意の自然数 x にはその後続数 S (x) が存在する
* 0 より前の自然数は存在しない
* 異なる自然数は異なる後続数を持つ
    * x != y のとき S(x) != S(y) となる
* 0 が性質を満たし、a も性質を満たせばその後続数も性質を満たすとき、すべての自然数はその性質を満たす


# Agda における自然数の定義
* data 型を使います

```
  data Int : Set where
    O : Int
    S : Int -> Int
```
* Int は O か、 Int に S がかかったもののみで構成される
* Set は組込みで存在する型で、"成り立つ"と考えてもらうと良いです。


# 自然数の例
* 0 = O
* 1 = S O
* 2 = S (S O)
* 5 = S (S (S (S (S O))))


# 自然数に対する演算の定義
* x と y の加算 : x にかかっている S の分だけ S を y に適用する
* x と y の乗算 : x にかかっている S の分だけ y を 0 に加算する

* Agda tips : 不明な項を ? と書くこともできます。 goal と呼びます
* その状態で C-c C-l するとその項の型が分かります


# Agda における自然数に対する演算の定義
```
  infixl 30 _+_
  _+_ : Int -> Int -> Int
  x + O     = x
  x + (S y) = S (x + y)
```

* Agda tips : C-c C-n すると式を評価することができます
* (S O) + (S (S O)) などしてみましょう


# Agda における関数定義のSyntax
* Agda において、関数は
  * _ + _ : Int -> Int -> Int
  * 関数名                      : 型
  * 関数名 引数はスペース区切り = 関数の定義や値
* のように定義します
* 中置関数は、引数があるべきところに _ を書くことでできます


# Agda で複数の引数がある関数の型
* _ + _ : Int -> Int -> Int
* func : A -> (A -> B) -> B

* 引数の型 -> 返り値の型
* -> の結合は右結合です。なので括弧を付けると以下のようになります
  * A -> ((A -> B) -> B)
* 右結合のため、A を受けとって ((A -> B) -> B) を返す、とも読めます


# パターンマッチ
* Agda においてはデータ型は引数で分解することができます
* ある型に続している値が、どのコンストラクタにおいて構成されたかをパターンで示せます
* Int は O か Int に S が付いたもの、でした
  * x + O     = x
  * x + (S y) = S (x + y)
* 関数名 (引数のパターン) = 定義


# もういちど : 自然数に対する演算の定義
```
  infixl 30 _+_
  _+_ : Int -> Int -> Int
  x + O     = x
  x + (S y) = S (x + y)
```
* 中置、関数、パターンマッチが使われています
* infixl は左結合を意味します。数値は結合強度です


# これから証明していきたいこと
* 加法の交換法則 : (x + y) = (y + x)
* 加法の結合法則 : (x + y) + z = x + (y + z) <- 目標ライン

* 乗法の交換法則 : (x * y) = (y * x)
* 乗法の結合法則 : (x * y) * z = x * (y * z)


# '等しい' ということ
* '等しい'という型 _ ≡ _ を data で定義します。

```
  data _≡_  {A : Set} : A -> A -> Set where
    refl  : {x : A} -> x == x
```

* defined : Relation.Binary.PropositionalEquality in Standard Library


# 等しさを保ったままできること
等しさを保ったまま変換する関数を作ると良い

* sym   : {A : Set} {x y : A} -> x ≡ y -> y ≡ x
* cong  : {A B : Set} {x y : A} -> (f : A -> B) -> x ≡ y -> f x ≡ f y
* trans : {A : Set} {x y z : A} -> x ≡ y -> y ≡ z -> x ≡ z

* Agda tips : 記号は \ の後に文字列を入れると出てきます。 '≡' は "\ =="


# '同じもの'とは
* 項なら同じ項
  * term : (A : Set) -> (a : Set) -> a ≡ a
  * term A a = refl
* 関数なら normal form が同じなら同じ
  * lambda-term : (A : Set)  -> (\ (x : A) -> x) ≡ (\ (y : A) -> y)
  * lambda-term A = refl
* 関数による式変形は等しいものとして扱います


# 単純な証明 : 1 + 1 = 2
* 型として (S O) + (S O) ≡ (S (S O)) を定義
* 証明を書く
* '同じもの' の refl でおしまい
* 自明に同じものになるのなら refl で証明ができます



# 交換法則を型として定義する
* ≡を用いて
  * (x : Int) -> (y : Int) -> x + y ≡ y + x
* 引数は (名前 : 型) として名前付けできます


# 交換法則を証明していく
```
  add-sym : (x y : Int)  -> x + y ≡ y + x
  add-sym    O     O  = refl
  add-sym    O  (S y) = cong S (add-sym O y)
  add-sym (S x)    O  = cong S (add-sym x O)
  add-sym (S x) (S y) = ?
```


# O, O の場合
* add-sym    O     O  = refl
* 両方ともO の時、証明したい命題は O + O ≡ O + O
* _ + _ の定義の x + O  = x より
* O ≡ O を構成したい
* refl によって構成する
* refl O と考えてもらえると良い


# 片方が O, 片方に S が付いている場合
* add-sym    O  (S y) = cong S (add-sym O y)
* 式的には O + (S y) ≡ (S y) + O
* _ + _ の定義 x + (S y) = S (x + y) より
* O + (S y) ≡ S (O + y)
* O と y を交換して O + (S y) ≡ S (y + O)
* つまり y と O を交換して S をかけると良い
* 交換して S をかける -> cong S (add-sym O y)


# trans による等式変形
* add-sym (S x) (S y) の時は1つの関数のみで等しさを証明できない
* 等しさを保ったまま式を変形していくことが必要になります

* add-sym (S x) (S y) = trans (f : a ≡ b) (g : b ≡ c)
  * trans (refl) ?
  * trans (trans refl (cong S (add-sym (S x) y)) ?


# ≡-reasoning による等式変形
* trans が何段もネストしていくと分かりづらい
* ≡-reasoning という等式変形の構文が Standard Library にあります
* Agda では見掛け上構文のような関数をAgdaでは定義できます

```
  begin
    変換前の式
      ≡⟨ 変換する関数 ⟩
    変換後の式
  ∎
```


# ≡-reasoning による最初の定義

```
  add-sym (S x) (S y) = begin
      (S x) + (S y)
    ≡⟨ ? ⟩
      (S y) + (S x)
    ∎
```


# 交換法則の証明 : + の定義による変形
* _ + _ の定義である x + (S y) = S (x + y) により変形

```
  add-sym (S x) (S y) = begin
      (S x) + (S y)
    ≡⟨ refl ⟩
      S (S x + y)
    ≡⟨ ? ⟩
      (S y) + (S x)
    ∎
```


# cong と add-sym を使って交換
* S が1つ取れたのでadd-symで交換できる
* add-sym で交換した後に cong で S がかかる

```
    S ((S x) + y)
  ≡⟨ cong S (add-sym (S x) y) ⟩
    S ((y + (S x)))
```


# 加法の時に左側からSを移動させられない

* 加法の定義は
  * x + (S y) = S (x + y)
* left-operand にかかっている S を移動させる方法が無い
* たしかに ? のについて
  * S (y + S x) ≡ S y + S x
* にあてはまるものを入れてくれ、と出てきている


# left-operand からSを操作する証明を定義
```
  left-increment : (x y : Int) -> (S x) + y ≡ S (x + y)
  left-increment x y = ?
```

* Agda tips : goal の上で C-c C-c で引数のパターン分け
  * 例えば y にのみ適用してみる
* Agda tips : goal の上で C-c C-a で証明を探してくれる


# left-operand からSを移動させる
* left-increment は (S x) + y ≡ S (x + y) なので逆にして使う

```
    ...
    S ((S x) + y)
      ≡⟨ sym (left-increment x (S y)) ⟩
    (S y) + (S x)
  ∎
```


# 加法の交換法則 : (x + y) = (y + x)
```
  add-sym (S x) (S y) = begin
      (S x) + (S y)
    ≡⟨ refl ⟩
      S ((S x) + y)
    ≡⟨ cong S (add-sym (S x) y) ⟩
      S (y + (S x))
    ≡⟨ (sym (left-increment y (S x))) ⟩
      (S y) + (S x)
    ∎
```


# 加法の結合法則 : (x + y) + z = x + (y + z)
* 次に結合法則を証明します
* 手順は同じです
  * ≡ で証明したい式を定義
  * 定義に証明を書く
  * 必要ならば等式を変形していく
* ちなみに x + y + z は infixl なので ((x + y) + z) となります


# Agda による証明方法のまとめ
* 関数の型を命題、関数の定義を証明とする
* 等しさを証明するには等しいという型を定義する
* 等しさを保ったまま式を変形していくことにより等価性を証明できる
    * trans, reasoning
* C-c C-l により型のチェックが成功すれば証明終了


# 乗法の定義
```
  infixl 40 _*_
  _*_ : Int -> Int -> Int
  n *    O  = O
  n * (S O) = n
  n * (S m) = n + (n * m)
```

* _+_ よりも結合強度を上げるといわゆる自然数の演算


# 乗法の交換法則 : (x * y) = (y * x)
```
  mult-sym : (x y : Int) -> x * y ≡ y * x
```

途中で

```
  (x y : Int) -> (S x) * y ≡ y + (x * y)
```

が必要になることが分かる


# Agdaにおいて何ができるのか
* 証明の正しさを対話的に教えてくれる
  * それに必要な証明が結果的に分かることもある
* 今回は Int に対する演算だった
  * lambda-term に落とせれば Agda で証明していける
* 他にも命題論理の証明などがある
* プログラミング言語そのものに対するアプローチ
  * lambda-term の等価性によってリファクタリングなど


# 良くあるエラー
* parse error
  * スペースある無しで意味が変わります
  * A: Set <- NG
  * A : Set <- OK
  * A: という term がありえるから
* 型が合わない   -> 赤で警告されます
* 情報が足りない -> 黄色で警告されます


<!-- vim: set filetype=markdown.slide: -->
