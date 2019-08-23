FROM ubuntu:16.04

# Install dependencies
RUN apt-get update
RUN apt-get -y install git
RUN apt-get -y install wget
RUN wget https://dl.google.com/go/go1.12.2.linux-amd64.tar.gz
RUN tar -xvf go1.12.2.linux-amd64.tar.gz
RUN chmod +x go
RUN mv go /usr/local
RUN export GOROOT=/usr/local/go
RUN export PATH=$GOROOT/bin:$PATH

# Set the webserver port below
RUN export PORT=8080
# Set the webserver port again so that its picked by script as well, this script will set the env variables at run time
RUN echo 'export PORT=8080' >> /root/configure_go.sh
# Below is to set PATH within the script
RUN echo 'export GOROOT=/usr/local/go' >> /root/configure_go.sh
RUN echo 'export PATH=$GOROOT/bin:$PATH' >> /root/configure_go.sh

# Creating project folder for downloading the source code of webserver
RUN echo 'mkdir -p /var/webservercode' >> /root/configure_go.sh
RUN echo 'mkdir -p /var/gowebserverlog' >> /root/configure_go.sh
RUN echo 'cd /var/webservercode' >> /root/configure_go.sh

RUN echo 'git clone https://github.com/Fullscript/go-web-server.git' >> /root/configure_go.sh


RUN echo 'cd /var/webservercode/go-web-server' >> /root/configure_go.sh
RUN echo 'go build main.go'  >> /root/configure_go.sh
RUN echo 'go run main.go'  >> /root/configure_go.sh
RUN chmod 755 /root/configure_go.sh
# Exposing the container port set above

EXPOSE $PORT
# This script will perform all the tasks and bring up the webserver on desired port
CMD /root/configure_go.sh
