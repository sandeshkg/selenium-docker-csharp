ARG dotnet_tag=7.0
FROM mcr.microsoft.com/dotnet/runtime:${dotnet_tag} AS base
WORKDIR /app

#Install dependencies for chrome - 
# https://github.com/puppeteer/puppeteer/blob/main/docs/troubleshooting.md#chrome-doesnt-launch-on-linux
RUN apt-get update \
&& apt-get install --no-install-recommends -y ca-certificates fonts-liberation libasound2 \
libatk-bridge2.0-0 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 \
libgbm1 libgcc1 libglib2.0-0 libgtk-3-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 \
libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 \
libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 lsb-release wget xdg-utils curl \
&& apt-get clean

#Install latest stable version of google chrome
RUN curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
&& apt-get install --no-install-recommends -y ./google-chrome-stable_current_amd64.deb \
&& rm google-chrome-stable_current_amd64.deb \
&& apt-get clean


 # Add your dotnet core project build stuff here
FROM mcr.microsoft.com/dotnet/sdk:${dotnet_tag} AS build
WORKDIR /src
COPY ["SeleniumChromeDocker.csproj", "./"]
RUN dotnet restore "SeleniumChromeDocker.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "SeleniumChromeDocker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "SeleniumChromeDocker.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SeleniumChromeDocker.dll"]