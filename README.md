# Linux-Server-Config

Set up your new Linux server on Debian with essential instructions and scripts.

## Install Essential Tools

> Update the package list and install essential tools


```bash
apt update && apt install -y vim curl git zsh sudo locales tzdata bat
```

## Add a New User

> Note: Replace $USERNAME with your desired username.

```bash
useradd -m $USERNAME
passwd $USERNAME
usermod -aG sudo $USERNAME
```

## Now Change to New User

> Switch to the newly created user

```bash
su $USERNAME
```

## Modify sshd Config

> Note: Run `ssh-copy-id` before making these changes to ensure passwordless login.

```bash
sudo sh -c 'echo -e "PermitRootLogin no\nPasswordAuthentication no\nClientAliveInterval 30" >> /etc/ssh/sshd_config.d/custom.conf' && sudo systemctl restart sshd
```

## Install Oh-My-Zsh and Plugins

> Install Oh-My-Zsh

```bash
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

> Clone and install Oh-My-Zsh plugins

```zsh
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/zsh-you-should-use
sed -i 's/(git)/(git gitfast z sudo zsh-syntax-highlighting zsh-autosuggestions zsh-you-should-use docker)/g' ~/.zshrc && source ~/.zshrc
```

> Create an alias for `cat` using `batcat` to enable syntax highlighting.

```zsh
echo "alias cat='batcat -p --paging=never'" >> ~/.zshrc && source ~/.zshrc
# Optional (try the theme I modified)
mkdir -p "$(batcat --config-dir)/themes" && curl -o "$(batcat --config-dir)/themes"/Vim.tmTheme https://raw.githubusercontent.com/moesnow/Linux-Server-Config/main/Vim.tmTheme && batcat cache --build && echo "alias cat='batcat -p --paging=never --theme Vim'" >> ~/.zshrc && source ~/.zshrc
```

## Change Locale and Localtime

> Note: Replace `zh_CN.UTF-8` with your desired locale, and replace `Asia/Shanghai` with your desired city/timezone if needed.

```bash
sudo locale-gen zh_CN.UTF-8 && sudo update-locale LANG="zh_CN.UTF-8" && sudo ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

## Set Zram

> Install zram-tools and configure zramswap

```bash
sudo apt install -y zram-tools && sudo sh -c 'echo -e "\nALGO=zstd\nPERCENT=60" >> /etc/default/zramswap' && sudo systemctl reload zramswap.service
```

## Install Speedtest

> Install speedtest-cli to measure internet speed

```bash
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt install -y speedtest
```
