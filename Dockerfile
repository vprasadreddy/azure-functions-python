# To enable ssh & remote debugging on app service change the base image to the one below
# FROM mcr.microsoft.com/azure-functions/python:4-python3.10-appservice
#FROM mcr.microsoft.com/azure-functions/python:4-python3.10
#
#ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
#    AzureFunctionsJobHost__Logging__Console__IsEnabled=true
#
#COPY requirements.txt /
#RUN pip install -r /requirements.txt
#
#COPY . /home/site/wwwroot

# Multi stage Dockerfile to deploy Python code to Azure Function App.

# Stage1
# Use Python base image
FROM python:3.11 AS build

COPY requirements.txt /
RUN pip install --target /home/site/wwwroot -r /requirements.txt

# Stage2
# Use Microsoft Azure Functions Python base image and it is need for Function App to be up and running.
FROM mcr.microsoft.com/azure-functions/python:4-python3.10
ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true

# Copy the build files from Stage1
COPY --from=build /home/site/wwwroot /home/site/wwwroot

COPY . /home/site/wwwroot
