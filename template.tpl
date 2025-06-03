___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Math",
  "description": "It allows you to do simple mathematical operations between two variables.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "RADIO",
    "name": "type",
    "displayName": "Type",
    "radioItems": [
      {
        "value": "multiply",
        "displayValue": "Multiply"
      },
      {
        "value": "divide",
        "displayValue": "Divide"
      },
      {
        "value": "add",
        "displayValue": "Add"
      },
      {
        "value": "subtract",
        "displayValue": "Subtract"
      }
    ],
    "simpleValueType": true
  },
  {
    "type": "TEXT",
    "name": "number1",
    "displayName": "Value 1",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "help": "Values can be numbers or numbers as strings."
  },
  {
    "type": "TEXT",
    "name": "number2",
    "displayName": "Value 2",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "roundResult",
    "displayName": "Round result",
    "checkboxText": "Round",
    "simpleValueType": true
  },
  {
  "type": "TEXT",
  "name": "decimals",
  "displayName": "Decimal places",
  "simpleValueType": true,
  "help": "Number of decimal places to round to (e.g., 2)",
  "valueValidators": [
    {
      "type": "NON_NEGATIVE_NUMBER"
    }
  ],
  "visibilityConditions": [
    {
      "parameterName": "roundResult",
      "predicateType": "EQUALS",
      "value": true
    }
  ]
}
]


___SANDBOXED_JS_FOR_SERVER___

const makeNumber = require('makeNumber');
const getType = require('getType');
const type = data.type;

if (data.number1.length <= 0 || data.number2.length <= 0 ) return undefined;

const number1 = makeNumber(data.number1);
const number2 = makeNumber(data.number2);

if (getType(number1) !== 'number' || getType(number2) !== 'number' || number1 !== number1 || number2 !== number2) {
  return undefined;
}

switch (type) {
  case 'multiply':
    return number1 * number2;
  case 'divide':
    return number2 !== 0 ? number1 / number2 : undefined;
  case 'add':
    return number1 + number2;
  case 'subtract':
    return number1 - number2;
  default:
    return undefined;
}


___TESTS___

scenarios: []


___NOTES___

Created on 8/15/2024, 12:08:53 PM


