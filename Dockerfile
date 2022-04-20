FROM mcr.microsoft.com/dotnet/runtime:6.0-alpine AS runtime
ENV configpath /app/appsettings.json

RUN apk update && apk add jq bash 
#RUN apk add ca-certificates && rm -rf /var/cache/apk/*

#COPY ./deploy/sh/startup.sh /startup.sh
#COPY ./deploy/sh/transform.sh /usr/bin/transform.sh
#RUN chmod a+x /startup.sh; chmod a+x /usr/bin/transform.sh

#COPY ./certs/* /usr/local/share/ca-certificates/
#WORKDIR /usr/local/share/ca-certificates/
#RUN update-ca-certificates

COPY startup.sh /
RUN dos2unix /startup.sh
RUN chmod a+x /startup.sh

WORKDIR /app
COPY publish/ /app
RUN rm /app/appsettings.local.json
#COPY --from=publish /app/src/${projectname}.WebApi/build.json ./
ENV ASPNETCORE_URLS=http://+:5000
ENV ASPNETCORE_ENVIRONMENT=Deployment

EXPOSE 5000/tcp
CMD ["/startup.sh"]
