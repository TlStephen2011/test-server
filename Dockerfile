# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# Copy the project file and restore dependencies
COPY *.csproj .
RUN dotnet restore

# Copy the remaining files and build the app
COPY . .
RUN dotnet publish -c Release -o /app/out

# Use the official .NET runtime image to run the app
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/out .

ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:5000

EXPOSE 5000

ENTRYPOINT ["dotnet", "server.dll"]