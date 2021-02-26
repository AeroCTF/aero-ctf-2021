FROM adoptopenjdk/openjdk15:alpine
WORKDIR /tmp/compile/
COPY ./ .
RUN ./gradlew --no-daemon build

FROM adoptopenjdk/openjdk15:alpine-jre
WORKDIR /app
COPY --from=0 /tmp/compile/build/libs/i18n-*.jar app.jar
RUN echo Aero{j4va_1s_better_th4n_engl1sh} > /try_find_me.txt
CMD ["java", "-jar", "app.jar"]