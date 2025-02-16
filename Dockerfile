FROM kalilinux/kali-rolling:latest
COPY ./includes.rc /root
RUN echo "source /root/includes.rc" >> /root/.bashrc
RUN apt update && apt install -y git python3 python3-pip curl wget gcc libpcap-dev nmap masscan tmux libxml2-utils whois dnsutils net-tools iputils-ping netcat-traditional iproute2 iputils-tracepath traceroute tcpdump jq vim nano lolcat ffuf dirsearch massdns
RUN apt-get clean

# Get architecture
ARG TARGETPLATFORM
ENV ARCHITECTURE=${TARGETPLATFORM#linux/}

# Combined Go installation process
RUN GO_VERSION=$(curl -s "https://go.dev/VERSION?m=text" | head -n 1) && \
    echo "GO_VERSION=${GO_VERSION}" >> /etc/environment && \
    case "${ARCHITECTURE}" in \
        "amd64") GO_ARCH="amd64" ;; \
        "arm64") GO_ARCH="arm64" ;; \
        "arm/v7") GO_ARCH="armv6l" ;; \
        *) echo "Unsupported architecture: ${ARCHITECTURE}" && exit 1 ;; \
    esac && \
    wget -q "https://go.dev/dl/${GO_VERSION}.linux-${GO_ARCH}.tar.gz" && \
    tar -C /usr/local -xzf "${GO_VERSION}.linux-${GO_ARCH}.tar.gz" && \
    rm "${GO_VERSION}.linux-${GO_ARCH}.tar.gz"

# Install pdtm
RUN /usr/local/go/bin/go install -v github.com/projectdiscovery/pdtm/cmd/pdtm@latest && \
    /root/go/bin/pdtm -install-all

RUN /root/.pdtm/go/bin/nuclei -ut
ENV PATH=$PATH:/usr/local/go/bin:/root/go/bin:/root/.local/bin:/root/.pdtm/go/bin

# Install karma_v2
RUN pip install --break-system-packages shodan mmh3
RUN go install -v github.com/tomnomnom/httprobe@master
RUN cd /opt && git clone https://github.com/codingo/Interlace.git && cd Interlace && python3 setup.py install
RUN go install -v github.com/tomnomnom/anew@master

# Install shosubgo
RUN go install github.com/incogbyte/shosubgo@latest

# Install CloudRecon
RUN go install github.com/g0ldencybersec/CloudRecon@latest

# Install GoSpider
RUN GO111MODULE=on go install github.com/jaeles-project/gospider@latest

# Install hakrawler
RUN go install github.com/hakluke/hakrawler@latest

# Install Amass
RUN snap install amass

# Install puredns (requires massdns)
RUN go install github.com/d3mondev/puredns/v2@latest

# Install jsluice
RUN go install github.com/BishopFox/jsluice/cmd/jsluice@latest
