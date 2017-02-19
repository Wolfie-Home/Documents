**1 Purpose**
=============

This document is a description of API and webpages.

**2 Overview**
==============


**3 Page list**
==============

For every webpages URLs, only HTTP GET method is allowed.
The list of URLs of webpages is the following:

| Webpage URL                | DESCRIPTION                                             |
|----------------------------|---------------------------------------------------------|
| `/home`                    | Overview of user                                        |
| `/location`                | Overview of locations                                   |
| `/location/<id>`           | Detailed view of a location. Devices can be controlled here as a group of a locaion. Some statistical data of the entire room are also shown here. |
| `/device`                  | Overview of devices                                     |
| `/device/<id>`             | Detailed view of a device, you can control device here. Some statistical data of the device are also shown here. |
| `/device/<id>/<parameter>` | See all history of one parameter of a device.           |

**4 Web API list**
==================

The APIs are HTTP reqeusts.
All HTTP request should be `Content-Type: application/json`.
As a response, all response is also  `Content-Type: application/json`.
Unless otherwise specified, all successful response is `HTTP 200 OK`, and all
failed response is `HTTP 400 BAD REQUEST`.
All response includes `msg` and `errmsg` field for messaging/debugging.

| URL                                  | Method | Short Description                                |
|--------------------------------------|:-------|--------------------------------------------------|
| `/api/login`                         | POST   | login                                            |
| `/api/login`                         | GET    | Get info of current user in session              |
| `/api/logout`                        | POST   | logout                                           |
| `/api/location`                      | GET    | list all locations (house and rooms) of a user   |
| `/api/location`                      | POST   | create a new location                            |
| `/api/location/<id>`                 | GET    | get detail of location #id                       |
| `/api/location/<id>`                 | PUT    | change detail of location (such as name)         |
| `/api/location/<id>`                 | DELETE | delete location                                  |
| `/api/location/<id>/device`          | GET    | Get list of devices placed in the location       |
| `/api/device`                        | GET    | get all list of devices of a user                |
| `/api/device`                        | POST   | create a new device                              |
| `/api/device/<id>`                   | GET    | show detail of device #id                        |
| `/api/device/<id>`                   | PUT    | Update detail of device (such as name)           |
| `/api/device/<id>`                   | DELETE | Delete a device                                  |
| `/api/device/<id>/property`         | GET    | Get list of propertys of a device, with the latest values            |
| `/api/device/<id>/property/<name>`  | GET    | Get all records of a property of device #id (e.g. `/api/device/1/temp` will show all records of temp)   |

**5 Device API list**
==================

Although we support both MQTT and HTTP, beware MQTT packet should be sent to
a MQTT broker, not a main backend. Note that All API for device does not use ids
for user, location, and device identification.

| URL                                  | Protocol          | Short Description                  |
|--------------------------------------|:------------------|------------------------------------|
| `/dev_api/<user>/<location>/<device>` | HTTP POST    | Store new data entries of device        |

| Topic                             | Protocol          | Short Description             |
|-----------------------------------|:------------------|-------------------------------|
| `record/<user>/<location>/<device>` | MQTT    | Store new data entries of device     |
| `control/<user>/<location>/<device>` | MQTT    | This will triggers data    |

**6 Web API Detail/Examples**
==============
Even though it won't be mentioned below all responses include 
`msg` and `errmsg` field for messaging/debugging.

**`POST /api/login`**
---------------------------
Login a user. 

- Reqeust:
``` JavaScript
{
    'username': 'name',
    'password': 'password'
} 
```

- Response:
In the HTTP header, a `session` cookie will be return as well as the following content:

``` JavaScript
{
    'username': 'name',
    'user_id': 1,   // any integer indicates id
    'email': 'email of user'
} 
```

**`GET /api/login`**
---------------------------
Get information of a current user.

- Response:
``` JavaScript
{
    'username': 'name',
    'email': 'email of user',
    'last_login': 'last login time'
} 
```

**`GET /api/location`**
---------------------------
- Response:
``` JavaScript
{
    'locations': [
        {
            'id': id of house/room,
            'name': 'name of house/room',
            'description': 'description of the house/room',
            'house_id': id of house where room located, can be null  
        },
        {
            'id': id of house/room,
            'name': 'name of house/room',
            'description': 'description of the house/room',
            'house_id': id of house where room located, can be null  
        },
        ...
    ]
} 
```

**`GET /api/location/<id>`**
---------------------------
- Response:
``` JavaScript
{
    'id': id of house/room,
    'name': 'name of house/room',
    'description': 'description of the house/room',
    'house_id': id of house where room located, can be null
    'house_name': name of house.
    'rooms': [  // if it is a room, there won't be list.
        {
            'id': id of house/room,
            'name': 'name of house/room',
            'description': 'description of the house/room'  
        },
        {
            'id': id of house/room,
            'name': 'name of house/room',
            'description': 'description of the house/room'  
        },
        ...
    ]
} 
```


**`GET /api/location/<id>/device`**
---------------------------
> When you set `<id>` as 0, the server will return list of devices
> that are not placed in any location (meaning location_id = Null).

- Response:
``` JavaScript
{
    'devices': [
        {
            'id': id of device,             
            'name': 'friendly name user has defined (e.g. LED4)',
            'mother_id': id of motherboard device (like arduino), can be null,
            'location_id': 'name of location where device is, can be null',
        },
        {
            'id': id of device,             
            'name': 'friendly name user has defined (e.g. LED4)',
            'mother_id': id of motherboard device (like arduino), can be null,
            'location_id': 'name of location where device is, can be null',
        },
        ...
    ]
} 
```



**`GET /api/device`**
-------------------------
- Response:
``` JavaScript
{
    'devices': [
        {
            'id': id of device,             
            'name': 'friendly name user has defined (e.g. LED4)',
            'mother_id': id of motherboard device (like arduino), can be null,
            'location_id': 'name of location where device is, can be null',
        },
        {
            'id': id of device,             
            'name': 'friendly name user has defined (e.g. LED4)',
            'mother_id': id of motherboard device (like arduino), can be null,
            'location_id': 'name of location where device is, can be null',
        },
        ...
    ]
} 
```


**`GET /api/device/<id>`**
------------------------------
- Response:
``` JavaScript
{
    'id': unique identifer from devices in getUserInfo api,
    'name': 'friendly name user has defined (e.g. LED4)',
    'class': 'class (or type) of device (e.g. LED)',
    'description': 'description of device',
    'mother_id': id of motherboard (like arduino), can be null,
    'location': 'id of location where device is, can be null', 
    'location_id': 'name of location where device is, can be null'
    'children': [
        {
            'id': id of child device,
            'name': 'friendly name user has defined (e.g. LED4)',
            'location_id': 'name of location where device is, can be null',
        },
        {
            'id': id of child device,
            'name': 'friendly name user has defined (e.g. LED4)',
            'location_id': 'name of location where device is, can be null',
        },
    ]
}
```

**`GET /api/device/<id>/property`**
------------------------------
- Response:
``` JavaScript
{
    'properties': [
        {"name": "switch", "type": "boolean", "controllable": false, 
            "description": "Default switch", 
            "records":[  // array but only one result
                {"value": True, "time": '2016-09-20 09:28:47.648621'}
                ]
            },
        {"name": "Green", "type": "integer", "controllable": true, 
            "description": "Default greed color value",
            "records":[  // array but only one result
                {"value": Green, "time": '2016-09-21 07:28:47.648621'}
                ]
            },
        {"name": "temp", "type": "number", "controllable": false,
            "description": "Default temperature value",
            "records":[  // array but only one result
                {"value": 22.4, "time" = '2016-09-20 09:28:47.648621'}
                ]
            },
        {"name": "msg", "type": "string", "controllable": true,
            "description": "Default messages to device",
            "records":[  // array but only one result
                {"value": 'Hello world?', "time": '2016-09-22 09:28:47.648621'}
                ]
        }
    ]
}
```

**`GET /api/device/<id>/property/<property>`**
------------------------------------------
- Response:
``` JavaScript
{
    "name": "msg",
    "type": "string",
    "controllable": true,
    "description": "Default messages to device",
    'records': [
        {"value": 22.4, "time" = '2016-09-20 09:28:47.648621'},
        {"value": 23.6, "time" = '2016-09-20 09:27:47.648621'},
        {"value": 21.5, "time" = '2016-09-20 09:26:47.648621'}
        ...
    ]
}
```


**7 Device API Detail/Examples**
==============

**`POST /dev_api/<user>/<location>/<device>`**
--------------------------------
**`MQTT control/<user>/<location>/<device>`**
--------------------------------

Input a record of a device. The format follows `payload.json` in [the schema folder](schema/)

### Example
- Input:
``` JavaScript
{
    "type": "info",
    "content": {
        "switch": True,
        "Green": 125,
        "temp": 30.23,
        "msg": "Default"
        ....
    },
    "password": "passphrase" // I know it's insecure.
}   
```