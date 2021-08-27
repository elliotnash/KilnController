# Kiln Aid Api Routes

## Login Flow

## Login Request

Fetches authentication token and controllers from a username and password.
Returned tokens are only valid on the ip they are requested with.

`POST https://www.bartinst.com/users/login.json` with json content:

```json
{
  "user": {
    "email": "EMAIL",
    "password": "PASSWORD"
  }
}
```

successfull login returns 200 with json content:

```json
{
    "authentication_token": "TOKEN",
    "controller_ids": [
        "SERIAL_NUMBER"
    ],
    "controller_names": {
        "SERIAL_NUMBER": "CONTROLLER_NAME"
    },
    "email": "EMAIL",
    "needs_to_accept_new_terms_and_conditions": false,
    "new_terms_and_conditions": "",
    "redirect_url": "/users/account",
    "role": null,
    "status": "ok"
}
```

invalid email or password returns 401 with json content:

```json
[
    {
        "message": "Invalid email or password."
    }
]
```

## Kiln Requests

The bellow requests all rely on very specific headers being passed.
requests should be made via http2, and these headers seem to work:

```yml
x-app-name-token: kiln-aid
accept: application/json
user-agent: Mozilla/5.0 (Linux; Android 11; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/92.0.4515.159 Mobile Safari/537.36
content-type: application/json
origin: http://localhost
x-requested-with: com.bartinst.kilnaid
sec-fetch-site: cross-site
sec-fetch-mode: cors
sec-fetch-dest: empty
referer: http://localhost/
accept-encoding: gzip, deflate
accept-language: en-US,en;q=0.9
```

## Slim Kiln Info Request

returns basic info about a controller from the controller id

`POST https://kiln.bartinst.com/kilns/slim?token=${token}&user_email=${email}` with json content:

```json
{
    "ids": [
        "SERIAL_NUMBER"
    ]
}
```

successful request returns 200 with json content:

```json
{
    "kilns": [
        {
            "_id": "HEXADECIMAL_ID",
            "mac_address": "MAC_ADDRESS",
            "mode": "Complete",
            "name": "CONTROLLER_NAME",
            "num_zones": 3,
            "serial_number": "SERIAL_NUMBER",
            "status": {
                "firing": {
                    "hold_hour": 0,
                    "hold_min": 0
                }
            },
            "t1": 344,
            "t2": 356,
            "t3": 351,
            "t_scale": "F",
            "updatedAt": "2021-08-27T19:13:12.049Z"
        }
    ]
}
```

invalid token returns 401 with json content:

```json
{
  "success": false,
  "message": "Failed to authenticate token."
}
```
