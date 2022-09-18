# File upload vulnerabilities :page_with_curl:
Vulnerabilities caused by accepting file uploads without sufficiently validating the file's content, size, or type.  In some cases the upload itself is the attack, other times the attacker will request the file they've upload to trigger the attack.

There are several types of attackes:

- `Content not validated`: allow an attacker to execute arbitrary script or code on the server.
- `File name/location not validated`: allow an attacker to overwrite existing files or upload files to a location they should not have access to.
- `Size not validated`: use file upload to consume memory and disk space (DoS).

## Prevent

- Validate the file type, size, and content.
- Ensure that file type/content validation cannot be bypassed by an attacker.
- Determine the safe max file size that can be uploaded.
- IP rate limit on file uploads to prevent DoS.

## Tools

- [Burp Proxy](https://portswigger.net/burp/documentation/desktop/tools/proxy/using)
- [Burp Repeater](https://portswigger.net/burp/documentation/desktop/tools/repeater/using)

## References
- https://portswigger.net/web-security/file-upload