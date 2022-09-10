# SQL injection
Allows an attacker to interfere with, and alter, SQL queries being performed by the app.  Relies on string concatenation from unsanitized user input directly into the SQL query.

The attack can come in various forms:

1. Immediate bypass of `WHERE` clause.
2. Information disclosure using `UNION` queries.
3. Stored SQL injection.  This is where the attacker can inject SQL into the database, and have it executed later.

## Prevent
Simple to prevent in an app by using parameterized queries and never allowing dynamic query construction.
```python
with db_connection.cursor(prepared=True) as cursor:
    stmt = "INSERT INTO notes (note, owner_id) VALUES (%s, %s)"
    cursor.execute(stmt, (note, owner_id))
```


## Examples
### Bypass WHERE clause
```python
# Insecure query
query = f"SELECT username FROM users WHERE username = '{username}' AND password = '{password}'"

# If username is passed as either of the following, attack will succeed as the password check is
# bypassed by the SQL comment `--`.
username = "admin'--"
username = "admin' OR 1=1--"
```

### Information disclosure
```python
# Insecure query
query = f"SELECT product_name FROM products WHERE product_id = {product_id}"

# Retrieve all users and passwords
# The UNION query concatenates multiple columns togehter into a single column
# as only one column is being returned by the original query
product_id = "1 UNION SELECT CONCAT(`username`, ' ', `password`) FROM users--"

# View database schema
product_id = "1 UNION SELECT CONCAT(`table_name`, ' ', `column_name`) FROM information_schema.columns--"
```



## Test

1. Use [Burp Proxy](https://portswigger.net/burp/documentation/desktop/tools/proxy) to intercept requests and send them to the [Repeater](https://portswigger.net/burp/documentation/desktop/tools/repeater).
2. Alter the request payloads and observe the response.

### Tips

If requests are being blocked, try encoding the attack using a tool like Hackvertor.  Firewalls can sometimes be circumvented by hex and decimal encoding, which the application will decode and execute.

## Tools
* [Burp Proxy](https://portswigger.net/burp/documentation/desktop/tools/proxy)
* [Burp Repeater](https://portswigger.net/burp/documentation/desktop/tools/repeater)
* [BApp Store > Hackvertor](https://portswigger.net/bappstore/65033cbd2c344fbabe57ac060b5dd100)

## References
* https://portswigger.net/web-security/sql-injection
