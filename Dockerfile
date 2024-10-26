FROM python:3.6-bullseye

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libsndfile1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install numpy==1.16.6
RUN pip install flask==1.1.1
RUN pip install torch==1.4.0+cpu torchvision==0.5.0+cpu -f https://download.pytorch.org/whl/torch_stable.html
RUN pip install librosa==0.7.2
RUN pip install python-speech-features==0.6
RUN pip install numba==0.48.0  # Pin numba to a compatible version
RUN pip install resampy==0.2.2  # Install a compatible version of resampy

# Copy application files into the container
COPY fbank_net/demo /fbank_net/demo
COPY fbank_net/model_training /fbank_net/model_training
COPY fbank_net/weights /fbank_net/weights
RUN touch /fbank_net/__init__.py

# Create data files directory
RUN mkdir /fbank_net/data_files

# Set environment variables
ENV PYTHONPATH="/fbank_net"
ENV FLASK_APP="demo/app.py"

# Set the working directory
WORKDIR /fbank_net

# Expose port 5000 for the Flask app
EXPOSE 5000

# Command to run the Flask app
CMD ["flask", "run", "--host", "0.0.0.0"]
