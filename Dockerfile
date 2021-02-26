FROM codercom/code-server:3.9.0

ENV SHELL /bin/bash
ENV PATH $PATH:/home/coder/.local/bin

USER root

## python and dotnet dependencies
RUN apt-get update && \
    apt-get -y install curl wget gpg python3-venv python3-pip && \
    wget -O- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg && \
    mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ && \
    wget https://packages.microsoft.com/config/debian/10/prod.list && \
    mv prod.list /etc/apt/sources.list.d/microsoft-prod.list && \
    chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
    chown root:root /etc/apt/sources.list.d/microsoft-prod.list && \
    apt-get update && apt-get -y install apt-transport-https && \
    apt-get update && apt-get -y install dotnet-sdk-5.0

USER coder

## install pip packages and code extension
RUN pip3 install --user pre-commit black tox && \
    code-server \
    --install-extension ms-dotnettools.csharp \
    --install-extension ms-python.python \
    --install-extension redhat.vscode-yaml \
    --install-extension wholroyd.jinja \
    --install-extension shd101wyy.markdown-preview-enhanced \
    --install-extension njpwerner.autodocstring
