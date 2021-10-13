FROM lzzy12/mega-sdk-python:latest

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

RUN apt-get -qq update && \
    apt-get install -y software-properties-common && \
    rm -rf /var/lib/apt/lists/* && \
    apt-add-repository non-free && \
    apt-get -qq update && \
    apt-get -qq install -y p7zip-full p7zip-rar aria2 curl pv jq ffmpeg locales python3-lxml && \
    apt-get purge -y software-properties-common

COPY requirements.txt .
COPY gdtot /usr/local/bin
RUN chmod +x /usr/local/bin/gdtot && \
echo '{"url":"https://new.gdtot.org/","cookie":"_ga=GA1.2.1795196776.1634145008; crypt=a2FrY29sTWVhc1hlNmZaNHY5ZTZRcGFpcmpaRC9HaGdvV0VDQzBNTTFFUT0%3D; _gid=GA1.2.847202292.1634145008; PHPSESSID=eej7uc09h4mirrpf5thuacq4qd; _gat_gtag_UA_130203604_4=1; prefetchAd_3621940=true"}' > cookies.txt
COPY extract /usr/local/bin
COPY pextract /usr/local/bin
RUN chmod +x /usr/local/bin/extract && chmod +x /usr/local/bin/pextract
RUN pip3 install --no-cache-dir -r requirements.txt
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \ 
locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
COPY . .
COPY .netrc /root/.netrc
RUN chmod +x aria.sh

CMD ["bash","start.sh"]
