# Authentication :unlock:
Vulnerabilities around logging into an application (proving your identity to that app).  Generally fall into two types:

1. Login susceptible to brute force attacks.
1. Authentication can by bypassed entirely (broken authentication).

## Prevent

1. `Safeguard credentials`: strong encryption and password hashing.  Never pass or store credentials in plain text.
1. `Multi-factor authentication`: something you know (password), something you have (phone/token), and something you are (biometrics).
1. `Rate limiting, account locking and CAPTCHA`: prevent brute force attacks.
1. `Review authentication/authorization logic`: bugs can allow users to access resources they shouldn't be able to.
1. `Review secondary authentication logic`: new account and password reset flows can be vulnerable to account takeover.
1. `Prevent user enumeration`: do not use sequential user IDs, ensure error messages and request processing times are generic, and do not allow account enumeration via API endpoints.

## Password based vulnerabilities :key:

### Brute forcing

Use a tool like [Hydra](https://github.com/vanhauser-thc/thc-hydra) or [Burp Intruder](https://portswigger.net/burp/documentation/desktop/tools/intruder/using) to brute force a login form.  The tool will try a list of common usernames and passwords against the login form submission.

The following can all be used to perform user enumeration and hone the attack:

1. Error messages returned (Invalid username vs. Incorrect password)
1. Response times
1. Response status codes

This attack can be mitigated by IP based rate limiting, request throttling, account locking, MFA and CAPTCHAs.

```sh
# Brute force an https form POST submission
# You can get the $LOGIN_PATH and $FORM_SUBMIT_PAYLOAD using Burp Proxy or your browser's dev tools
hydra \
    -L "$FILE_WITH_USERNAMES" \
    -P "$FILE_WITH_PASSWORDS" \
    "$URL_OR_IP" \
    https-post-form "$LOGIN_PATH:$FORM_SUBMIT_PAYLOAD:$FAILURE_MESSAGE"

# Username and password list
hydra \
    -L usernames.list \
    -P passwords.list \
    web-security-academy.net \
    https-post-form "/login:username=^USER^&password=^PASS^:Invalid username"

# Known user and password list
hydra \
    -l the_big_cheese \
    -P passwords.list \
    web-security-academy.net \
    https-post-form "/login:username=^USER^&password=^PASS^:Invalid username"
```

#### Considerations
- `Account locking`: can lead to user enumeration by indicating the account exists.  When an account is locked, the error message should remain generic.
- `Credential stuffing`: relies on people using the same password across multiple sites.  Uses a dictionary of `username:password` combinations and only tries each `username` once, thereby bypassing account locking.  This must be caught with rate limiting or throttling.
- `IP based rate limiting flaws`: if a successful login resets the rate limit counter, an attacker can bypass the rate limit by logging in with a valid account every `n` attempts.  Rate limiting should be unconditional for a set period based on the IP address.  This can be bypassed by using multiple IP addresses to conduct the attack.

## Tools
* [Hydra](https://github.com/vanhauser-thc/thc-hydra)
* [Burp Intruder](https://portswigger.net/burp/documentation/desktop/tools/intruder/using)

## References
* https://portswigger.net/web-security/authentication
* https://portswigger.net/web-security/authentication/password-based
* https://portswigger.net/web-security/authentication/securing
