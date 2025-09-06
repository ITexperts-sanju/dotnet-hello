# Build stage with .NET Core 2.1 SDK (closest to 2.0)
FROM mcr.microsoft.com/dotnet/core/sdk:2.1 AS build
WORKDIR /src
COPY . .
RUN dotnet restore
RUN dotnet publish hello-world-api/hello-world-api.csproj -c Release -o /app/publish

# Runtime stage with ASP.NET Core 2.1
FROM mcr.microsoft.com/dotnet/core/aspnet:2.1 AS runtime
WORKDIR /app

# Set ASP.NET Core to listen on port 5000
ENV ASPNETCORE_URLS=http://+:5000
EXPOSE 5000

COPY --from=build /app/publish ./
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
