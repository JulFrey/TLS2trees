# Start from NVIDIA CUDA container (Ubuntu 20.04)
FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

COPY requirements.txt /tmp/requirements.txt
COPY . /opt/fsct

# Set as non-interactve
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y  \
	    apt-utils git curl vim unzip wget \
	    build-essential 
	
 # Install pip and CUDA compatabiilty layer
RUN apt-get install -y python3.10 python3-pip cuda-compat-12-1

# Create symlink for libcusolver, needed for tensorflow
RUN	cd /usr/local/cuda-12.1/lib64/ && \
		ln -s libcusolver.so.11 libcusolver.so.10 && \
		cd -

# Install requirements using Python 3.10 pip
RUN python3.10 -m pip install --upgrade pip && \
    python3.10 -m pip install -r /tmp/requirements.txt && rm /tmp/requirements.txt

# Set python and pip to python3.10 by default
ENV PYTHON=python3.10
ENV PIP=pip3.10
ENV PATH="/usr/bin:$PATH"
RUN ln -sf /usr/bin/python3.10 /usr/bin/python && \
    ln -sf /usr/bin/pip3.10 /usr/bin/pip

# Make sure scripts are excecutable
RUN chmod a+x /opt/fsct/tls2trees/semantic.py /opt/fsct/tls2trees/instance.py

# Set environmental variables
ENV  LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda-12.1/lib:/usr/local/cuda-12.1/lib64:/usr/local/cuda/compat
ENV PYTHONPATH=/opt/fsct
ENV PATH=/opt/fsct:$PATH

