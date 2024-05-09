
# Dotfiles

Este repositório contém meus arquivos de configuração pessoais, conhecidos como dotfiles. Eles são usados para configurar e personalizar várias ferramentas e aplicativos que uso regularmente em meu ambiente de desenvolvimento.


- **.zshrc**: Configurações para o shell Bash, incluindo aliases e personalizações de prompt.
- **.vimrc**: Configurações para o editor Vim, incluindo plugins e atalhos personalizados.
- **.gitconfig**: Configurações globais para o Git, como aliases e informações de usuário.
- **.tmux.conf**: Configurações para o multiplexador de terminal Tmux, incluindo atalhos e personalizações de layout.

## Instalação das ferramentas

***Debian***
```sh
sudo apt update
sudo apt install vim tmux zsh
```

***Fedora***
```sh
sudo dnf install vim tmux zsh
```

***Arch Linux***
```sh
sudo pacman -S vim tmux zsh
```

## Instalação do Vimplug

```sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Em seguida, você pode instalar os plugins executando o seguinte comando no Vim:

```sh
:PlugInstall
```

Isso instalará todos os plugins listados no arquivo `.vimrc`.
