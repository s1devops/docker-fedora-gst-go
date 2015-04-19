FROM fedora:21

RUN \
    yum localinstall -y --nogpgcheck http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    yum install -y gstreamer1 gstreamer1-plugins-good gstreamer1-libav tar git mercurial

RUN mkdir /goroot && curl https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz | tar xvzf - -C /goroot --strip-components=1
    
RUN mkdir /gopath
ENV GOROOT /goroot
ENV GOPATH /gopath
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

ADD go-build /bin/go-build
ADD go-run /bin/go-run

ONBUILD ADD . /gopath/src/app/
ONBUILD RUN /bin/go-build

EXPOSE 8080

CMD []

ENTRYPOINT ["/bin/go-run"]
