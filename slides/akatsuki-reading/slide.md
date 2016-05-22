title: akatsuki 読み
author: atton
profile:
lang: Japanese

# akatsuki 読みについて
* 学科のWebコンパネ akatsuki を読みます
* ソースは gitlab にあります
    * https://gitlab.ie.u-ryukyu.ac.jp/gitlab/e115763/Akatsuki.git
    * 学科アカウントがあれば誰でも読むことができます

# この資料の目的
* シス管後輩への引き継ぎ用の資料です
* Rails の使い方の解説よりも、あとから見た時の価値を優先します
    * どこが何の処理をしているかを書いています
    * もし機能改善をすることになったらどの辺を見たら良いのか把握できることがゴール
* この資料は[ここ](http://ie.u-ryukyu.ac.jp/~e115763/slides/events/akatsuki-reading/slide.html)とかに置いてあります

# この読み会でやること
* akatsuki でやっていることの把握とその実装を見ていきます
* 以下のことは直接説明はしません
    * Rubyの書き方や Rails について
    * named, freeradius, libvirt の設定
* 対象とするバージョン
    * 2016/04/23 あたりのコード
    * 898a11a946039b8120bc8e1f8cdcd0cedeccaa6f

# akatsuki の機能について
* mac address とドメインの申請を受けつけてプライベートIPを割り当てる
* 割り当てられたドメインを引けるようにDNS用のレコードを用意
* 割り当てられたIPを DHCP で配布
* LDAP の情報変更(含む edy)
* VM の作成と起動/停止
* その他シス管用の細かい機能
    * VLAN51用 DHCP, LDAP新規アカウント追加, 卒業生アカウントの無効化

# akatsuki の方針
* なるべくシンプルに
    * Ajax で非同期表示とかしない
    * Reacive とかしない
    * むしろ JS 書かないくらいの気合
* テストを書く
    * なるべくテストを書く
    * 一般ユーザ向け部分はテスト必須

# akatsuki 起動方法
* akatsuki は LDAP を使ってログインするので slapd が必須です
* あと bind-sdb の backend が postgresql なのでDBは postgresql です
* 2つとも Dockerfile があるので起動しましょう
* See it (docker/bind-sdb/README.md, docker/slapd/README.md)

# ActiveRecord model overview
* User
    * LDAP でサインインしたユーザのデータ。 VM の作成権限の保持くらい
* IpAddress
    * IP 用。 mac address と domain の data を持ってる
    * User has_many IpAddress
* VirtualMachine
    * VM 用。 kvm ホストとか起動用のVM名とか持ってる
    * IpAddress has_one VirtualMachine
* LocalRecord
    * bind-sdb 用。 IpAddress が更新されると自動で更新
* RadiusCheckInformation, RadiusReplyInformation
    * freeradius 用。 IpAddress が更新されると自動で更新

# ActiveRecord model: User
* uid と vm_limit だけ
* uid は e115763 とかの uid
* vm_limit は VM の作成可能な数

# ActiveRecord model: IpAddress
* domain (ex: nw1163, firefly)
* affiliation (ex: st, cr)
* mac_address (ex: 11:22:33:44:55:66)
* assgined_address (ex: 10.0.2.238)
    * IPv4 用。 v6 はこれをもと domain の prefix を使った eui64 を生成
    * こいつは自動で設定される (see it: IpAddress#address_auto_assign)
        * index unique: true が付いてるので重複不可
        * ActiveRecord::RecordNotUnique を rescue して自動で取れるまでくりかえす
* save されると maintain_local_records と maintain_radius_informations が動く

# ActiveRecord model: LocalRecord
* bind-sdb 用。自分でいじることがあるのはシス管だけ。
* rdtype, rdata, name, ttl が bind-sdb が要求してくる column
* 基本的には IpAddress が save されると自動で maintain_local_records で調整される
* A, PTR, AAAA を更新すると SOA も自動で上げたいので LocalRecord#soa_record とか持ってる
    * see: LocalRecord#update_serial
* こいつ自身に after_save はかかってない

# ActiveRecord model: RadiusCheckInformation, RadiusReplyInformation
* freeradius 用。 DHCP 用に使ってます。
* デフォルトだと attribute, op, value とかのカラムを要求する
* カラム名に attribute ってのはまずいので radius_attribute に変更してある
    * see it (docker/radius-dhcp/files/mods-config/sql/main/postgresql/queries.conf)
    * see it [ guide/dhcp for static ip allocation ]( http://wiki.freeradius.org/guide/dhcp-for-static-ip-allocation )

# ActiveRecord model: VirtualMachine
* KVM 用。 fog-libvirt 経由で libvirt にアクセスしてます
* kvm_host と name を持ってる
    * kvm_host は対象のVMが存在する kvm ホスト名
    * name は libvirt が認識してる VM 名
    * template_name は一応持ってるけれど程度の情報
* vm_control とかやると fog-libvirt の instance が取れる

# fog-libvirt
* AWS とかの Iaas とか Paas とかのをいじる用gem fog の libvirt driver
* 地味に ie 用に[改変してます](https://github.com/atton-/fog-libvirt/tree/ie)
    * template pool から rental pool への clone の対応
* 気が向いたら本家に Pull Request を投げるかもしれません
* もし気が向かなかったら fork してメンテしてください

# ActiveLdap model: LDAP::User, LDAP::Group
* LDAP は ActiveLdap を使って操作してます
* User の uid から引けるように User#ldap_user とかで取れます
* User は /etc/slapd/slapd.conf あたりで定義されてる ObjectClass の attribute をいじれます
* Group は syskan とか iesudoer とか。 ActiveRecord みたいに belongs_to みたいなことができます
* ldapedyid という edy 用の attribute が ldap にあるので edy への登録もここでやります。

# Routes overview
* / 直下 は home_controller
* あとは対応したモデル用に resouces とかしてるだけ
* syskan, admin 用 namespace がある
* see it (config/routes.rb)
* tips (rake routes)

# Controllers overview
* application_controller
    * sign_in を必須にするようにしてたりします
        * see it (ApplicationController#authenticate_user! and before_action)
    * akatsuki の任意のページはログイン無しで見られてはいけないので
* home_controller
    * sign_in とか sign_out とかするだけのモデルに紐付いてないものです
* ip_address_controller, virtual_machine_controller, ldap/user_controller
    * モデルに対応するコントローラ
* syskan/users_controller, syskan/vlan51_controller, admin/local_records
    * シス管用の特別なやつ

# Views overview
* 全部 haml で書いてます
* view/home/\*.html.haml, view/ip_address/\*.html.haml, ...
    * モデルごとに作ってるくらいで特に変なことはしていないはず。
* layouts/application.html.haml
    * layout として全ページ navbar を持ってます
    * ユーザの持ってる権限に応じてnavbarが見えるようになります

# Tests: RSpec
* 一般ユーザ向けの部分はテスト必須
* model のメソッドのテストと Capybara での E2E のテスト
* このスライドを書いてる時のカバレッジは約90%

# Rake Tasks
* rake task は lib/tasks/ip_address.rake とか。
* 年度に一回だけやるタスクとかがここにあります
* tips: rake -vT

# Configs
* ドメイン情報とかIPの設定とかは軒並 constant で定義してあります
* see it (config/initializers/ie_config.rb)

<!-- vim: set filetype=markdown.slide: -->
