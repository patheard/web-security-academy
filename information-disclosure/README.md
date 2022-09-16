# Information disclosure :eye:


When a website or service leaks information about:

- it's users (PII);
- sensitive commercial or business data; or
- technical details about the service infrastructure.

This can then allow the attacker to cause harm to the users, business or service itself (through exploiting known vulnerabilities with the infrastructure).

## Examples

- Revealing names and structure of hidden directories.
- Gaining access to backups and sensitive files.
- Error messages providing too much technical detail to the user.
- Exposing highly sensitive information, like credit cards, in the application logs or GUI.
- Hard-coded credentials in source code.
- 'Fingerprinting' the hosting platform by through server headers.
- Determining underlying existence/absense of resources by observing differences between responses.

## Techniques

Information disclosure can be triggered and detected by:

- Fuzzing: sending a large number of requests with varying inputs to see how the application behaves.
- Scanning: using a tool like [Burp Scanner](https://portswigger.net/burp/vulnerability-scanner) to test for and identify information leakage during browsing.
- Causing errors: attempting to cause error conditions in the application to see what information is revealed in the error messages.

## Sources of information disclosure

- Web crawler files like `robots.txt` and `sitemap.yml` which can reveal hidden directories.
- Web server automatic directory listings (poorly configured web servers can reveal hidden directories).
- Developer commesn in source code
- Error messages providing too much information
- Debug data in the response
- User account pages with poor authorization controls
- Backup files which can leak the application source code
- Insecure build pipeline or web server configuration
- Version control history

## Prevent

- Ensure all members of the service team know what information is and isn't considered sensitive so that it can be treated consistenly.
- Keep error messages generic and devoid of technical details.
- Disable stack trace and log output to the user in production.
- Audit code and build logs for sensitive information.
- Ensure production services have a secure configuration that strips as mush identifying information as possible from the responses (e.g. response header fingerprinting).

## Tools

- [Burp Intruder](https://portswigger.net/burp/documentation/desktop/tools/intruder/using)
- [Burp Scanner](https://portswigger.net/burp/vulnerability-scanner)

## References

- https://portswigger.net/web-security/information-disclosure
- https://portswigger.net/web-security/information-disclosure/exploiting