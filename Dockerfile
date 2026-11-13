FROM tomcat:latest
MAINTAINER Venkat <venkat@axisbank.com>
EXPOSE 8080
COPY target/my-webapp.war /usr/local/tomcat/webapps/my-webapp.war
