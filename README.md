# Web Security Academy :school:

Working through PortSwigger's [Web Security Academy](https://portswigger.net/web-security) and experimenting with [Burp Suite](https://portswigger.net/burp) and [Kali](https://www.kali.org/).

## Topics

### Server-side
- [Access control](access-control/README.md)
- [Authentication](authentication/README.md)
- [Business logic vulnerabilities](business-logic-vulnerabilities/README.md)
- [Command injection](command-injection/README.md)
- [Directory traversal](directory-traversal/README.md)
- [File upload vulnerabilities](file-upload-vulnerabilities/README.md)
- [Information disclosure](information-disclosure/README.md)
- [Server-side request forgery (SSRF)](server-side-request-forgery/README.md)
- [SQL injection](sql-injection/README.md)
- [XML external entity (XXE) injection](xml-external-entity-injection/README.md)

## License

The content of this repo are study notes based on PortSwigger's [Web Security Academy](https://portswigger.net/web-security).  They hold all rights to any content that is not my own.

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
