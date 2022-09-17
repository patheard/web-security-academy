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

### Context-dependent access control

Allow access to resources/actions based on some state (a user cannot remove items from their shopping cart after the checkout process has started).

## Access control models

- `Programatic access control`: matrix of stored permissions that can be applied to users, groups or roles.  Permissions are applied before actions or access is performed to determine if it is allowed.
- `Discretional access control (DAC)`: users or groups are given access to resources and **can** grant access to other users/groups.
- `Mandatory access control (MAC)`: users or groups are given access to resources and **cannot** grant access to other users/groups.
- `Role-based access control (RBAC)`: users are assigned roles which are given access to resources.  A user can have multiple roles.

## Prevent

## Tools

## References

- https://portswigger.net/web-security/access-control
- https://portswigger.net/web-security/access-control/security-models
