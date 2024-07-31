FROM deeplabcut/deeplabcut:2.3.5-base-cuda11.7.1-cudnn8-runtime-ubuntu20.04-latest

# Set the timezone to America/Los_Angeles
ENV TZ=America/Los_Angeles

# Install tzdata and configure timezone
RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

# Install additional necessary packages
RUN apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    curl \
    vim \
    nano \
    git \
    less \
    unzip \
    tar \
    bash-completion

# Ensure nvidia-smi is available by installing nvidia-utils-460 (adjust version as necessary)
RUN apt-get update && apt-get install -y --no-install-recommends \
    nvidia-utils-460 && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN python3 -m pip install --upgrade pip

# Install the latest DeepLabCut 3.0 with PyTorch backend
#RUN pip install 'deeplabcut[tf,gui]'==3.0

# Install Jupyter Notebook
RUN pip install notebook

# Download and extract a sample DeepLabCut project
RUN mkdir -p /workspace/sample_project && \
    wget -O /workspace/sample_project/example_data.zip https://github.com/DeepLabCut/DeepLabCut/archive/refs/heads/master.zip && \
    unzip /workspace/sample_project/example_data.zip -d /workspace/sample_project && \
    rm /workspace/sample_project/example_data.zip

# Enable bash completion
RUN echo "source /usr/share/bash-completion/bash_completion" >> ~/.bashrc


# Copy the start-notebook.sh script to execute on start
COPY start-notebook.sh /usr/local/bin/start-notebook.sh

# Ensure the script can be executed
RUN chmod +x /usr/local/bin/start-notebook.sh


# Set the user context
USER root

# Expose the Jupyter Port
EXPOSE 8888
