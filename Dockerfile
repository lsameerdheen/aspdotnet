# Learn about building .NET container images:
# https://github.com/dotnet/dotnet-docker/blob/main/samples/README.md
FROM  mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY aspnetapp/*.csproj .
RUN dotnet restore --ucr

# copy and publish app and libraries
COPY aspnetapp/. .
RUN dotnet publish --ucr --no-restore  -o /opt/app


# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
EXPOSE 8080
WORKDIR /opt/app
COPY --from=build /opt/app .
USER $APP_UID
ENTRYPOINT ["./aspnetapp"]
