FROM gitpod/workspace-base

USER root

# Install util tools.
# software-properties-common is needed to add ppa support for Apptainer installation
RUN apt-get update --quiet && \
    apt-get install --quiet --yes \
        apt-transport-https \
        apt-utils \
        sudo \
        git \
        less \
        wget \
        curl \
        tree \
        graphviz \
        software-properties-common

# Install CLIP dependencies
RUN apt-get update && apt-get -y install python3-venv python3-pip git imagemagick

# Taken from: https://github.com/nf-core/tools/blob/master/nf_core/gitpod/gitpod.Dockerfile
# Install Apptainer (Singularity)
RUN add-apt-repository -y ppa:apptainer/ppa && \
    apt-get update --quiet && \
    apt install -y apptainer

# Install Conda and fix user permissions
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniconda3-latest-Linux-x86_64.sh && \
    mkdir -p /workspace/data && \
    chown -R gitpod:gitpod /opt/conda /workspace/data

ENV PATH="/opt/conda/bin:$PATH"

# Add classify to path
ADD bin/classify /usr/local/bin/classify

# Change user to gitpod
USER gitpod

RUN pip install torch torchvision ftfy regex tqdm 
RUN pip install git+https://github.com/openai/CLIP.git
# RUN python3 -c 'import clip; clip.load("ViT-B/32", device="cpu")'

# Uncomment if we need to pin the Nextflow version
ENV NXF_EDGE=1
ENV NXF_VER=24.02.0-edge

# Install nextflow, nf-core, Mamba, and pytest-workflow
RUN sudo rm -r ~/.cache && \
    conda config --add channels defaults && \
    conda config --add channels bioconda && \
    conda config --add channels conda-forge && \
    conda config --set channel_priority strict && \
    conda update --quiet --yes --all && \
    conda install --quiet --yes --name base \
        mamba \
        nextflow \
        nf-core \
        nf-test \
        black \
        prettier \
        pre-commit \
        pytest-workflow && \
    conda clean --all --force-pkgs-dirs --yes

# Update Nextflow
RUN nextflow self-update && nextflow -version

RUN unset JAVA_TOOL_OPTIONS
