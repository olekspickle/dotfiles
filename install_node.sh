curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
  && echo "Installing latest supported node version..." \
  && source ~/.bashrc \
  && source ~/.profile \
  && export NVM_DIR="$HOME/.nvm" \
  &&  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  \
  &&  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  \
  && nvm install --lts \
  && ./install_yarn.sh

