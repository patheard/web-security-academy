# Access control :name_badge:

The authentication and authorization of a user (or service) to an application.  Dictates who can acccess and what they can do.  Includes:

- `Authentication`: identifies the user or service (who is this?)
- `Session management`: identifies subsequent requests from the same user or service (persist the authentication)
- `Access control (authorization)`: determines what the user or service can access and actions they can perform (what can they do?)

Access control is business logic that is determined by humans and enforced by the code.  Potential for errors and serious breaches are high.

## Types

### Vertical access control

Allow access to resources based on the role of the user (an administrator can access the admin panel).

#### Vertical privelege escalation

When a user is able to gain access to a role or user they should not have access to.  A simple example is gaining access to the admin panel.  Types are:

- `Unprotected functionality`: insufficient access control on a resource and relies on that resource being hidden (e.g. admin panel does not check if the request is for an authenticated administrator).
- `Parameter based access control`: when a user is able to provide a parameter that escalates their privileges (e.g. `?admin=true` on a request).
-  `Platform misconfiguration`: allow access to protected resources via unexecpted HTTP methods (e.g. `PUT` or `DELETE` instead of an expected `POST` or `GET`).

### Horizontal access control

Allow access to a subset of the same type of resources to users (a user can only access their own account profile page, but not other user's account profiles).

#### Horizontal privilege escalation

When a user gains access to another user's data or resources.  

This can often be turned into a vertical privilege escalation by compromising a more priveleged user and then using that user to grant access to the attacker's account or create another privileged user account controlled by the attacker.

#### Insecure director object reference

When an attacker can directly access objects through input they supply.  This can include:

- Direct access to databaes objects through a user-supplied ID (e.g. `?id=1`).
- Direct access to filesystem objects by altering the URL (e.g. `?imageUrl=../../../ect/passwd`).

### Context-dependent access control

Allow access to resources/actions based on some state (a user cannot remove items from their shopping cart after the checkout process has started).

#### Access control vulnerabilities in multi-step processes

When a user is able to bypass sections of a multi-step process, which can occur whena access controls are not applied consistently to all steps.

#### Referer based access control

When an application relies on the `Referer` HTTP header to enforce access control.  Since this can be altered in the request, it allows for access control bypass.

An example could be if a page like `/admin/deleteUser` only checks for `Referer=admin` to perform access validation.

#### Location based access control

When ap application relies on geolocation IP lookup to enforce access control.  This can be circumvented with a VPN.


## Access control models

- `Programatic access control`: matrix of stored permissions that can be applied to users, groups or roles.  Permissions are applied before actions or access is performed to determine if it is allowed.
- `Discretional access control (DAC)`: users or groups are given access to resources and **can** grant access to other users/groups.
- `Mandatory access control (MAC)`: users or groups are given access to resources and **cannot** grant access to other users/groups.
- `Role-based access control (RBAC)`: users are assigned roles which are given access to resources.  A user can have multiple roles.

## Prevent

- Deny access by default to all resources.  Implement an allow-list for resources that are accessible.
- Use a single access control model for the entire application to prevent confusion.
- Have developers thoroughly declare all access requirements for each resource.
- Do not rely on obfustication or hiding of resources to prevent access.
- Rigorously test access control for all resources and actions, ideally using automation.

## Tools
- [Burp Intruder](https://portswigger.net/burp/documentation/desktop/tools/intruder/using)
- [Burp Proxy](https://portswigger.net/burp/documentation/desktop/tools/proxy/using)

## References

- https://portswigger.net/web-security/access-control
- https://portswigger.net/web-security/access-control/idor
- https://portswigger.net/web-security/access-control/security-models
