FROM mcr.microsoft.com/dotnet/runtime:5.0

RUN apt update \
    && apt install -y socat

RUN useradd -M -s /bin/false custom

RUN mkdir -p /var/custom/

WORKDIR /var/custom/

COPY Custom Custom.deps.json Custom.dll Custom.pdb Custom.runtimeconfig.json flag.txt ./

USER custom

ENTRYPOINT socat TCP-LISTEN:31337,reuseaddr,fork EXEC:"./Custom"
