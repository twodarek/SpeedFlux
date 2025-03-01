FROM python:3.13-slim-bullseye
LABEL maintainer="twodarek" \
    description="Original by Aiden Gilmartin. Maintained by Twodarek"

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update 
RUN apt-get -q -y install --no-install-recommends apt-utils gnupg1 apt-transport-https dirmngr curl

# Install Speedtest
RUN curl -s https://install.speedtest.net/app/cli/install.deb.sh --output /opt/install.deb.sh
RUN bash /opt/install.deb.sh
RUN apt-get update --allow-insecure-repositories && apt-get -q -y install speedtest --allow-unauthenticated
RUN rm /opt/install.deb.sh

# Clean up
RUN apt-get -q -y autoremove && apt-get -q -y clean 
RUN rm -rf /var/lib/apt/lists/*

# Copy and final setup
ADD . /app
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt 
COPY . .

# Excetution
CMD ["python", "main.py"]
