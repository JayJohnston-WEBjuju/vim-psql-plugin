# vim-psql-plugin

A highly customizable pSQL VIM plugin, a brazen fork of [Zhenxu Ke's _excellent_ vim-mysql-plugin](https://github.com/kezhenxu94/vim-mysql-plugin). Get them both!

## Prerequisite

This plugin works on the basis of an installed psql client and configured .pgpass file:

```shell
$ psql --version
psql (PostgreSQL) 12.1
```

If the output is something like `-bash: psql: command not found`, then you must install a psql client first.

## Installation Options

1. [Install with Vundle](#install-with-vundle) (TODO)
2. [Install with Plug](#install-with-plug) (for neovim)
3. [Manually Install](#manually-install)

### Install with Vundle
(TODO...if these instructions work...great, let me know)

Add the following line to the ~/.vimrc file, after adding that, the file may look like this:

```vimrc
" ... some other configurations
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
" Add this plugin
Plugin 'git://github.com/JayJohnston-WEBjuju/vim-psql-plugin.git'
call vundle#end()
" ... some other configurations
```

And remember to execute `:PluginInstall` in VIM normal mode.

### Install with Plug
(for neovim)

Add the following to `~/.config/nvim/init.vim`:
```vimrc
" ... some other configurations
Plugin 'https://github.com/JayJohnston-WEBjuju/vim-psql-plugin.git'
" ... some other configurations
```

Then run `:PlugInstall`.

### Manually Install

Be sure you have `git` installed and configured to [authenticate to github.com via ssh](https://docs.github.com/en/authentication/connecting-to-github-with-ssh).
In your terminal...issue the following commands, one by one (this assumes you have `git` installed and configured):

```
cd ~;
git clone git@github.com:JayJohnston-WEBjuju/vim-psql-plugin.git;
ls -lah ~/vim-psql-plugin/plugin/vim-psql-plugin.vim;
echo "let mapleader = '\'" >> ~/.vimrc;
echo "source ~/vim-psql-plugin/plugin/vim-psql-plugin.vim" >> ~/.vimrc;
```

## Usage

There are two things to do after installation:

1. Put your database credentials in `~/.pgpass`

```
host:port:db_name:user_name:password
```

[Read more here about .pgpass here.](https://tableplus.com/blog/2019/09/how-to-use-pgpass-in-postgresql.html)

2. Use vim to issue psql commands!

- `vim anyfile.psql` (so that you can type your sql...file should end in .psql)
- at the top of the file you may put command line args (but one is mandatory)
 - the `-x` switch sets the output to vertical
 - each option **must** be on its own line

```
-- -h 127.0.0.1
-- -x
--

SELECT * FROM USER;
```
- Query `SELECT * FROM USER` with these keystrokes _(`<CR>` is carriage return/"enter")_:

```
/SELECT<CR>
V
\rs
```

The following is a description of the commands including an explanation of the `\SELECT<CR>V\rs` sequence:

- `/SELECT` then *<CR>* moves your cursor (via *search*) to the query
- `V` *shift+v* selects the entire query (line)
- `\rs` issues `<leader>`+rs
 - earlier we set `mapleader` to backslash _(change it in .vimrc)_

Query results appear in a split pane.

Remember to delimit your queries with semi-colons.

### Command Reference

- `<leader>rr` "Run Instruction"
- `<leader>ss` "Select Cursor Table"
- `<leader>ds` "Descript Cursor Table"
- `<leader>rs` "Run Selection"
- `<leader>re` "Run Explain"

"Run Instruction" executes query and can be run from anywhere within the query.

"Explain" can be run from anywhere within the query.

"Selection" means select _query_ before issuing command.

"Cursor" means place your cursor on _the table_ to issue command.

"Selection" means select _query_ before issuing command.

## Contribution

If you find it difficult to use this plugin, please open issues or help to improve it by creating pull requests.

## Change log

