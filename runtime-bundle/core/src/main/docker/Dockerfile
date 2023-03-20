FROM adoptopenjdk/openjdk11:jdk-11.0.2.9-slim
RUN  apt update
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
RUN apt -y install ttf-mscorefonts-installer fontconfig
RUN fc-cache -f -v
ENV PORT 8080
EXPOSE 8080
WORKDIR /opt

COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

COPY target/runtime-bundle-core-7.9.0-SNAPSHOT.jar app.jar

ENTRYPOINT ["./entrypoint.sh"]
CMD ["-jar", "app.jar"]
