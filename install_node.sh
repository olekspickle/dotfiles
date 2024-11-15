curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
  && echo "Installing latest supported node version..." \
  && source ~/.bashrc \
  && source ~/.profile \
  && nvm install --lts

