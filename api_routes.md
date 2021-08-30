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

The bellow requests rely on the x-app-name-token header being passed to authenticate.

```yml
x-app-name-token: kiln-aid
```

Data is usually updated server side about once per minute, although updates are occasionally skipped.

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

## Full Kiln Info Request

returns all info about a controller from the controller id

`POST https://kiln.bartinst.com/kilns/view?token=${token}&user_email=${email}` with json content:

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
      "name": "CONTROLLER_NAME",
      "users": [],
      "is_premium": false,
      "status": {
        "_id": "HEXADECIMAL_ID",
        "fw": "LT4-4.1.0",
        "mode": "Complete",
        "alarm": "OFF",
        "t1": 126,
        "t2": 145,
        "t3": 157,
        "num_fire": 15,
        "firing": {
          "set_pt": 2236,
          "step": "Ramp 1 of 4",
          "fire_min": 19,
          "fire_hour": 8,
          "hold_min": 0,
          "hold_hour": 0,
          "start_min": 0,
          "start_hour": 0,
          "cost": 0,
          "etr": "0"
        },
        "diag": {
          "a1": 0,
          "a2": 0,
          "a3": 0,
          "nl": 252,
          "fl": 253,
          "v1": 1911,
          "v2": 1911,
          "v3": 1911,
          "vs": 1911,
          "board_t": 83,
          "last_err": 255,
          "date": "2021-08-27T22:01:15.845Z"
        },
        "error": {
          "err_text": "No Errors",
          "err_num": 35
        }
      },
      "config": {
        "_id": "612960ab441caf000a9b815f",
        "err_codes": "On",
        "t_scale": "F",
        "no_load": 252,
        "full_load": 253,
        "num_zones": 3
      },
      "program": {
        "_id": "612960ab441caf000a9b8160",
        "name": "Cone 6 Medium",
        "type": "Glaze",
        "num_steps": 4,
        "alarm_t": 9999,
        "speed": "Medium",
        "cone": "6",
        "steps": [
          {
            "_id": "612960ab441caf000a9b8164",
            "t": 180,
            "hr": 0,
            "mn": 0,
            "rt": 150,
            "num": 1
          },
          {
            "_id": "612960ab441caf000a9b8163",
            "t": 250,
            "hr": 0,
            "mn": 0,
            "rt": 150,
            "num": 2
          },
          {
            "_id": "612960ab441caf000a9b8162",
            "t": 1982,
            "hr": 0,
            "mn": 0,
            "rt": 400,
            "num": 3
          },
          {
            "_id": "612960ab441caf000a9b8161",
            "t": 2236,
            "hr": 0,
            "mn": 0,
            "rt": 120,
            "num": 4
          }
        ]
      },
      "log_request": false,
      "mac_address": "MAC_ADDRESS",
      "serial_number": "SERIAL_NUMBER",
      "firmware_version": "4.1.0",
      "product": "LT4K0",
      "external_id": "b1fpDT9W6",
      "createdAt": "2020-11-11T19:35:52.910Z",
      "updatedAt": "2021-08-27T22:01:15.843Z",
      "firings_count": 15,
      "is_premium_updated": "2020-12-01T20:59:23.201+00:00",
      "latest_firing_start_time": "1630023401906",
      "latest_firing": {
        "start_time": "1630023401906",
        "ended": false,
        "update_time": "1630101615811",
        "just_ended": false,
        "ended_time": null
      }
    }
  ]
}
```
