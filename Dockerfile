#change the alphine imge build from nyl
FROM  lsameerdheen/dotnet8alphine:v.0.0.1 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY aspnetapp/*.csproj .
RUN dotnet restore --ucr

# copy and publish app and libraries
COPY aspnetapp/. .
RUN dotnet publish --ucr --no-restore  -o /app

# Enable globalization and time zones:
# https://github.com/dotnet/dotnet-docker/blob/main/samples/enable-globalization.md
# final stage/image
FROM lsameerdheen/dotnet8alphine:v.0.0.1
# copy and publish app and libraries
ENV ASPNETCORE_URLS=http://*:8080
EXPOSE 8080
WORKDIR /app
COPY --from=build /app .
# Uncomment to enable non-root user
# USER $APP_UID
ENTRYPOINT ["./aspnetapp"]

