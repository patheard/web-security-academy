# Server-side request forgery (SSRF) :fountain_pen:

Cause a server to make requests to an unintented location.  This can be an internal or external server and can result in:

- information leakage;
- account compromise; or
- an attack that appears to come from the compromised server.

SSRF attacks rely on exploiting trust, generally between an app and backend systems.

## Common attacks

### SSRF against self

Attacker causes the server to request itself via `localhost` or `127.0.0.1`.  This may bypass access controls since the request is coming from the server.

```http
# Request for product stock
POST /product/stock HTTP/1.0
Content-Type: application/x-www-form-urlencoded
Content-Length: 118

stockApi=http://stock.weliketoshop.net:8080/product/stock/check%3FproductId%3D6%26storeId%3D1

# Change to request for the `/admin` page via localhost
POST /product/stock HTTP/1.0
Content-Type: application/x-www-form-urlencoded
Content-Length: 118

stockApi=http://localhost/admin
```

This works for various reasons:

- Access controls are not part of the API that is handling requests from the server itself.
- Admin interface may be on a different port that is not accessbile to the internet, but is available on localhost.

#### SSRF attacks against other systems

Attacks where the server makes a request against other backend systems that are part of the application's private network.  This can be effective since these backend systems will have a weaker security posture as they are thought to be secure because of the network topology.

```http
POST /product/stock HTTP/1.0
Content-Type: application/x-www-form-urlencoded
Content-Length: 118

stockApi=http://192.168.0.68/admin
```

### Circumvent SSRF protection

#### Deny-list input filters

If an application does not allow strings like `localhost` or `127.0.0.1` to be processed, use alternate representations:

1. `2130706433`, `017700000001`, or `127.1`.
1. Register a domain that resolves to `127.0.0.1`.
1. Use URL encoding or case variation to bypass string matching.

#### Allow-list input filters

If an application only allows requests to safelisted domains, they can sometimes be bypassed based on how URLs are parsed:

```sh
https://evil-host.com#good-host.com # URL fragment
https://good-host.com.evil-host.com # Subdomain parsing
https://good-host.com@evil-host.com # Userinfo parsing

```

The above can be combined with URL encoding to help bypass filters.

#### Bypass via open redirects

If application contains an open redirect vulnerability, you can use it to bypass allow list filters:

```http
POST /product/stock HTTP/1.0
Content-Type: application/x-www-form-urlencoded
Content-Length: 118

stockApi=https://feedingfromthegardenuntilhistickerisjammed.com/product?id=42&path=http://192.168.0.68/admin
```

### Blind SSRF

When an attack succeeds and sends a request to a backend server, but does not send a response back to the attacker.

Detect using an out-of-band technique (OAST) where you send a request a server you control and monitoring for the SSRF request.

:bulb: It is common when testing for SSRF vulnerabilities to use a DNS lookup as the out-of-band technique.  This is because DNS lookups are usually permitted from most networks.  You can then check if only the DNS lookup succeeds and there is no subsequent HTTP request.  This indicates there is network filtering blocking your SSRF attack.

To exploit blind SSRF vulnerabilities:

- Send requests to the internal IP address space with known vulnerability payloads.  You may get lucky and stumble upon an unpatched vulnerability.  
- It is also possible to have the HTTP request from an SSRF vulnerability return a malicious response in an attempt to gain control over the system.

## Prevent

- Deny all outbound requests by default and safelist only what is required.
- Safelist DNS lookups from your network to prevent OAST.
- Safelist incoming requests to ensure they are to legitimate source.  As much as possible, use constants for the IP or URL so that it cannot be altered by an attacker. 

## Tools

- [Burp Intruder](https://portswigger.net/burp/documentation/desktop/tools/intruder/using)
- [Burp Repeater](https://portswigger.net/burp/documentation/desktop/tools/repeater/using)

## References

- https://portswigger.net/web-security/ssrf
- https://portswigger.net/web-security/ssrf/blind