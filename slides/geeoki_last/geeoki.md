title: 証明支援系言語Agda
author: atton
profile: へーれつしんらいけん@ie
lang: Japanese

# Agda って言語がありますよ
* 証明支援系言語です
    * Coq, Idris とか
* `` Brain fu*k `` の数値のコピーって本当にコピーなの
* 証明とかできます

# 証明は型で書く
* 実は式の型は論理式に対応してます
* 論理式に対応する証明は式の定義です
* 依存型を持つ Agda では値に型を持てる
* 「等式」という型が存在する

# 数値を型で定義する
* 自然数の定義(Peano Arithmetic)
* 0は自然数
* 自然数+1 は自然数

```
module nat where
data Nat : Set where
    O : Nat
    S : Nat -> Nat
```

# 「等しい」という型
* 左辺と右辺に式を持つ等式型

```
data _≡_ {a} {A : Set a} (x : A) : A → Set a where
  refl : x ≡ x
```

# これで加法の交換法則とか証明できます

```
add-sym : (x y : Nat)  -> x + y ≡ y + x
add-sym = proof

```


# 結論
* 型で証明とかもできる
    * Liner Type
* こういう言語もあります
* ギー沖ありがとー

<!-- vim: set filetype=markdown.slide: -->
