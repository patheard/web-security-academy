# Authentication
Vulnerabilities around an user or service proving its identity to an application.  Generally fall into two types:

1. Login susceptible to brute force attacks.
1. Authentication can by bypassed entirely (broken authentication).

## Prevent.
1. Safeguard credentials: strong encryption and password hashing.  Never pass or store credentials in plain text.
1. Use multi-factor authentication: something you know (password), something you have (phone/token), and something you are (biometrics).
1. Use rate limiting, account locking and CAPTCHA: prevent brute force attacks.
1. Review authentication/authorization logic: bugs can allow users to access resources they shouldn't be able to.
1. Review secondary authentication logic: new account and password reset flows can be vulnerable to account takeover.
1. Prevent user enumeration: do not use sequential user IDs, ensure error messages and request processing times are generic, and do not allow account enumeration via API endpoints.

## References
* https://portswigger.net/web-security/authentication
* https://portswigger.net/web-security/authentication/password-based
* https://portswigger.net/web-security/authentication/securing
