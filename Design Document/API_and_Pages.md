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

**4 API list**
==============

The APIs are HTTP reqeusts.
All HTTP request should be `Content-Type: application/json`.
As a response, all response is also  `Content-Type: application/json`.
Unless otherwise specified, all successful response is `HTTP 200 OK`, and all
failed response is `HTTP 400 BAD REQUEST`.
All response includes `msg` and `errmsg` field for messaging/debugging.

| URL                             | Method | Short Description                                |
|---------------------------------|--------|--------------------------------------------------|
| `/api/login`                    | POST   | login                                            |
| `/api/logout`                   | POST   | logout                                           |
| `/api/current_user`             | GET    | Get info of current user                         |
| `/api/location`                 | GET    | list all locations (house and rooms) of a user   |
| `/api/location`                 | POST   | create a new location                            |
| `/api/location/<id>`            | GET    | get detail of location #id                       |
| `/api/location/<id>`            | PUT    | change detail of location (such as name)         |
| `/api/location/<id>`            | DELETE | delete location                                  |
| `/api/device`                   | GET    | get all list of devices of a user                |
| `/api/device`                   | POST   | create a new device                              |
| `/api/device/<id>`              | GET    | show detail of device #id                        |
| `/api/device/<id>`              | PUT    | Update detail of device (such as name)           |
| `/api/device/<id>`              | DELETE | Delete a device                                  |
| `/api/device/<id>/<parameter>`  | GET    | Get all records of a parameter of device #id (e.g. `/api/device/1/temp` will show all records of temp)   |


**5 API Detail**
==============
Even though it won't be mentioned below all responses include 
`msg` and `errmsg` field for messaging/debugging.


**5.1 `GET /api/current_user`**
---------------------------
- Response:
``` JavaScript
{
    'username': 'name',
    'email': 'email of user',
    'last_login': 'last login time'
} 
```

**5.2 `GET /api/location`**
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


**5.3 `GET /api/device`**
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


**5.4 `GET /api/device/<id>`**
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
    'location_id': 'name of location where device is, can be null',
    'time': 'time when value was recorded',
    'values': {
        'param1': 'string value', integer, or float,
        'param2': 'string value', integer, or float,
        ...
        'paramN': 'string value', integer, or float,
    }
}
```

**5.5 `GET /api/device/<id>/<parameter>`**
------------------------------------------
- Response:
``` JavaScript
{
    'name': 'name of parameter',
    'device_id': 'Id of device',
    'device_name': 'name of device'
    'values': [list of values can be 'string value', integer, or float],
    'time': [list of time recorded, index is shard with 'value' list]
}   
```

