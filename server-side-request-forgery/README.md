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


## Prevent

## Tools

## References

- https://portswigger.net/web-security/ssrf
- https://portswigger.net/web-security/ssrf/blind