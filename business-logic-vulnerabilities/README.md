# Business logic vulnerabilities :bug:
Flaws and bugs in how an application processes user requests.  These are typically caused by an attacker interacting with the application in a way the developers did not anticipate.

## Examples
### Excessive trust in client-side controls
Assuming that requests will only come through the user interface and be subjected to client-side validation.  Easily bypassed by tools like Burp Suite.

### Failing to handle unconventional input
Bugs triggered by receiving user input that is not of the expected type or within the expected range (e.g. a negative number when only positive values are expected).  This must be caught with input and business logic validation.

### Making flawed assumptions about user behavior
Assuming that users will interact predictably.  This can include:
- Not following an expected workflow sequence; 
- Not providing all required input; and
- Not remaining trustworthy after initial authentication.

### Providing an encryption oracle
Occurs when user provided input is then returned as cipher text to the user.  This can allow the attacker to determine the encryption algorithm and key used by the application.

## Tips
- Look for all requests that submit input to the server and check if there is adequate server-side validation.
- Submit input that satisfies validation, but is outside of expected ranges (e.g. negative numbers in a scenario where they do not make sense).
- Attempt to bypass sections of workflows (skip ahead to the end).

## Prevent
1. Make sure all developers and testers understand the application logic.
1. Validate all user inputs.
1. Write clear, simple code that is easy to understand and test.
1. Break complex logic into smaller, simpler functions and ensure each function is thoroughly tested.

## Tools
- [Burp Proxy](https://portswigger.net/burp/documentation/desktop/tools/proxy)
- [Burp Repeater](https://portswigger.net/burp/documentation/desktop/tools/repeater)
- [BApp Store > Hackvertor](https://portswigger.net/bappstore/65033cbd2c344fbabe57ac060b5dd100)

## References
- https://portswigger.net/web-security/logic-flaws
- https://portswigger.net/web-security/logic-flaws/examples