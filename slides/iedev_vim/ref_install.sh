#!/bin/sh
# iedevのVim勉強会(http://atnd.org/events/30822)用のスクリプト。
# vunldeとref.vimをインストール + webdict周りの設定をします。
# git と w3m は用意しておいてください

# git のチェック
which git > /dev/null
if [ $? -ne 0 ]; then
    echo git not found. please install git.
    exit
fi

# w3mのチェック
which w3m > /dev/null
if [ $? -ne 0 ]; then
    echo w3m not found. please install w3m.
    exit
fi

# ~/.vim 確認
if [ -d ~/.vim ]; then
    echo "~/.vim directory found."
else
    echo "~/.vim directory not found. create ~/.vim directory"
    mkdir ~/.vim
fi

# vundle の clone
# http://vim-users.jp/2011/04/hack215/ をなど参考に
git clone http://github.com/gmarik/vundle.git ~/.vim/vundle.git > /dev/null
echo clone vundle


# .vimrcの行頭に設定追加
touch ~/.vimrc
mv ~/.vimrc /tmp/ref_install_temp_vimrc
cat > /tmp/ref_install_temp_settings << EOF 
" ----- Vim勉強会による追加部分です。 -----
" vundle と ref.vim のインストール + webdictの設定などが含まれます。
set nocompatible                    " vi互換をオフにします
filetype off                        " vundle用に一時的にfiletypeをオフにします

set rtp+=~/.vim/vundle.git/         " vundleを読み込みます
call vundle#rc()                    " vundleを使います

Bundle 'thinca/vim-ref'

filetype plugin indent on           " filetype をオンにします

" ref.vim の webdict の設定
" FileTypeがtextならKでwebdictを使う
autocmd FileType text call ref#register_detection('_', 'webdict') 
" yahoo_dict と wikipedia を使う
let g:ref_source_webdict_sites = {
\ 'yahoo_dict' : {'url' : 'http://dic.search.yahoo.co.jp/search?p=%s', 'line' : '47'},
\ 'wikipedia'  : {'url' : 'http://ja.wikipedia.org/wiki/%s',},}
" webdict の辞書のデフォルトはyahoo_dict
let g:ref_source_webdict_sites.default = 'yahoo_dict'			
" テキストブラウザはw3mを使う
let g:ref_source_webdict_cmd = 'w3m -dump %s'

" ----- ここまでがVim勉強会での追加分です。 -----

EOF
cat /tmp/ref_install_temp_settings /tmp/ref_install_temp_vimrc > ~/.vimrc
echo add ref settings in ~/.vimrc

# ref.vimのインストール
vim -c "BundleInstall" -c "qa"
echo install ref.vim.

echo install finished.
