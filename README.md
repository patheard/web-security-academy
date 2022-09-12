# Web Security Academy :school:

Working through PortSwigger's [Web Security Academy](https://portswigger.net/web-security) and experimenting with [Burp Suite](https://portswigger.net/burp) and [Kali](https://www.kali.org/).

## Topics

- [Authentication](authentication/README.md)
- [Business logic vulnerabilities](business-logic-vulnerabilities/README.md)
- [Command injection](command-injection/README.md)
- [Directory traversal](directory-traversal/README.md)
- [Information disclosure](information-disclosure/README.md)
- [SQL injection](sql-injection/README.md)

## Setup
```sh
# Install Homebrew, VirtualBox, Vagrant and create a Kali VM
curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
brew bundle
vagrant up
```

Optionally, configure Chromium to trust the Burp CA certificate:

1. In the VM, open Burp's integrated Chromium browser.
2. Go to `http://burpsuite` and download the `cacert.der` certificate.
3. Go to `chrome://settings/certificates` and select `Authorities`.
4. Click `Import`, select `cacert.der`, and trust for web identies.
