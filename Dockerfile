FROM jupyter/scipy-notebook:2023-10-02

ENV CODE_VERSION=4.17.1

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

RUN apt-get update --yes && \
    apt-get install --yes --quiet --no-install-recommends \
        curl iputils-ping build-essential make cmake \
        g++ clang htop libopencv-dev && \
    apt-get --quiet clean && rm -rf /var/lib/apt/lists/*

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
	&& apt-get -y install --no-install-recommends texlive-latex-recommended \
                        texlive-latex-extra \
                        texlive-lang-german \
                        tex-common \
                        texlive-fonts-extra \
                        texlive-science \
                        texlive-xetex \
                        locales \
                        pandoc \
                        latexmk \
                        lmodern \
                        wget \
    && apt-get --quiet clean && rm -rf /var/lib/apt/lists/*

RUN curl -fOL https://github.com/coder/code-server/releases/download/v$CODE_VERSION/code-server_${CODE_VERSION}_amd64.deb \
    && dpkg -i code-server_${CODE_VERSION}_amd64.deb \
    && rm -f code-server_${CODE_VERSION}_amd64.deb
RUN /opt/conda/bin/conda install -c conda-forge jupyter-server-proxy
RUN /opt/conda/bin/conda install -c conda-forge jupyter-vscode-proxy
RUN /opt/conda/bin/conda install -c conda-forge jupyterlab_vim

RUN apt-get update --yes --quiet && \
    apt-get install --yes --quiet \
    dbus-x11 xfce4 xfce4-panel xfce4-session xfce4-settings xorg xubuntu-icon-theme firefox && \
    apt-get remove --yes --quiet light-locker && \
    apt-get clean --quiet && rm -rf /var/lib/apt/lists/*
RUN /opt/conda/bin/conda install -c manics websockify && \
    pip install git+https://github.com/yuvipanda/jupyter-desktop-server.git
 
# Switch back to jovyan to avoid accidental container runs as root
USER ${NB_UID}

RUN code-server --install-extension appulate.filewatcher
RUN code-server --install-extension auiworks.amvim
RUN code-server --install-extension DavidAnson.vscode-markdownlint
RUN code-server --install-extension James-Yu.latex-workshop
RUN code-server --install-extension mhutchie.git-graph
RUN code-server --install-extension ms-python.python
RUN code-server --install-extension ms-toolsai.jupyter
RUN code-server --install-extension oderwat.indent-rainbow
RUN code-server --install-extension redhat.ansible
RUN code-server --install-extension redhat.vscode-yaml
RUN code-server --install-extension yzhang.markdown-all-in-one

