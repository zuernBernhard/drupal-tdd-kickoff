FROM gitpod/workspace-full
# Make runc's proc mount work again https://github.com/gitpod-io/gitpod/issues/5124#issuecomment-897048987
RUN curl -o olderrunc -L https://github.com/opencontainers/runc/releases/download/v1.0.0-rc93/runc.amd64 && chmod 755 olderrunc
RUN sudo rm /usr/bin/runc && sudo cp olderrunc /usr/bin/runc
RUN sudo apt-get -qq update && sudo apt-get install -y zsh && sudo chsh -s $(which zsh)
USER gitpod

  # set the zsh theme

ENV ZSH_THEME gentoo

# Install Oh-My-Zsh

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

  # start zsh

  CMD [ "zsh" ]

USER root
RUN sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes && echo 'eval "$(starship init zsh)"' > .zshrc
RUN curl -OL https://github.com/lando/lando/releases/download/v3.4.2/lando-x64-v3.4.2.deb && sudo dpkg -i --ignore-depends docker-ce,iptables lando-x64-v3.4.2.deb && rm -rf lando-x64-v3.4.2.deb
RUN mkdir -p ~/.lando && sudo chmod -R ~/.lando && echo "proxy: 'ON'\nproxyHttpPort: '8080'\nproxyHttpsPort: '4443'\nbindAddress: '0.0.0.0'\nproxyBindAddress: '0.0.0.0'" > ~/.lando/config.yml
