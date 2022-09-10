# Burp
Experiements with [Burp Suite](https://portswigger.net/burp) and [Kali](https://www.kali.org/).

## Setup
```sh
# Install brew https://brew.sh/
brew bundle
vagrant up
```

## Config
Configure Chromium to trust the Burp CA certificate:

1. Open Chromium from Burp.
2. Go to `http://burpsuite` and download the CA certificate.
3. Go to `chrome://settings/certificates` and select `Authorities`.
4. Click `Import`, select the CA certificate, and trust for web identies.