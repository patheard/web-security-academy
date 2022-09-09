# Burp
Experiements with [Burp Suite](https://portswigger.net/burp) and [Kali](https://www.kali.org/).

## Setup
```sh
brew install --cask virtualbox
brew install --cask vagrant
vagrant up
```

## Config
Inside the VM configure Firefox to use Burp as a proxy:

1. Start Burp Suite.
2. Visit http://127.0.0.1:8080.
2. Download the CA cert.
3. Open Firefox and change the following:
   1. `Settings > Proxy > Manual Proxy Configuration`: "127.0.0.1:8080" for both HTTP and HTTPS
   2. `Settings > Certificates`: Import and trust the CA cert.

:warning: This is required as the Burp pre-configured Chromium browser does not start successfully in Kali.