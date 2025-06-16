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
    "checkboxText": "Round result",
    "simpleValueType": true,
    "subParams": [
      {
        "type": "TEXT",
        "name": "roundDecimalPlaces",
        "displayName": "Decimal places",
        "simpleValueType": true,
        "help": "Number of decimal places to round to (e.g., 2)",
        "valueValidators": [
          {
            "type": "NON_NEGATIVE_NUMBER"
          }
        ],
        "enablingConditions": [
          {
            "paramName": "roundResult",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const makeNumber = require('makeNumber');
const getType = require('getType');
const Math = require('Math');

/*==============================================================================
==============================================================================*/

const isValidValue = (value) => {
  const valueType = getType(value);
  return valueType !== 'null' && valueType !== 'undefined' && value !== '';
};

/*==============================================================================
==============================================================================*/

if (!isValidValue(data.number1) || !isValidValue(data.number2)) return undefined;

const number1 = makeNumber(data.number1);
const number2 = makeNumber(data.number2);

if (getType(number1) !== 'number' || getType(number2) !== 'number' || number1 !== number1 || number2 !== number2) {
  return undefined;
}

let result;

switch (data.type) {
  case 'multiply':
    result = number1 * number2;
    break;
  case 'divide':
    result = number2 !== 0 ? number1 / number2 : undefined;
    break;
  case 'add':
    result = number1 + number2;
    break;
  case 'subtract':
    result = number1 - number2;
    break;
  default:
    return undefined;
}

if (!!data.roundResult && getType(result) === 'number') {

  let roundDecimalPlaces = data.roundDecimalPlaces;
  if (getType(roundDecimalPlaces) !== 'number' || roundDecimalPlaces !== roundDecimalPlaces || roundDecimalPlaces < 0) {
    roundDecimalPlaces = 2;
  } else {
    roundDecimalPlaces = makeNumber(roundDecimalPlaces);
  }

  const factor = Math.pow(10, roundDecimalPlaces);
  result = result * factor;
  result = result >= 0 ? result + 0.5 : result - 0.5;
  result = result - (result % 1);
  result = result / factor;

  return result;
}

return result;


___TESTS___

scenarios:
- name: Empty strings as inputs (should return undefined)
  code: |-
    mockData.type = 'multiply';
    mockData.number1 = '';
    mockData.number2 = '';

    const variableResult = runCode(mockData);

    assertThat(variableResult).isUndefined();
- name: Undefined inputs (should return undefined)
  code: |-
    mockData.type = 'multiply';
    mockData.number1 = undefined;
    mockData.number2 = undefined;

    const variableResult = runCode(mockData);

    assertThat(variableResult).isUndefined();
- name: Null inputs (should return undefined)
  code: |-
    mockData.type = 'multiply';
    mockData.number1 = null;
    mockData.number2 = null;

    const variableResult = runCode(mockData);

    assertThat(variableResult).isUndefined();
- name: Inputs as strings should be transformed into numbers
  code: |-
    mockData.type = 'multiply';
    mockData.number1 = '2.49';
    mockData.number2 = '0.18';

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(0.44820000000000004);
- name: '[Multiply] numeric inputs both floats - without rounding'
  code: "mockData.type = 'multiply';\nmockData.number1 = 2.49;\nmockData.number2 =\
    \ 0.18;\n\nconst variableResult = runCode(mockData);\n\nassertThat(variableResult).isEqualTo(0.44820000000000004);\
    \        "
- name: '[Add] numeric inputs both floats - without rounding'
  code: |-
    mockData.type = 'add';
    mockData.number1 = 2.49;
    mockData.number2 = 0.18;

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(2.6700000000000004);
- name: '[Divide] numeric inputs both floats - without rounding'
  code: |-
    mockData.type = 'divide';
    mockData.number1 = 2.49;
    mockData.number2 = 0.18;

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(13.833333333333336);
- name: '[Subtract] numeric inputs both floats - without rounding'
  code: |-
    mockData.type = 'subtract';
    mockData.number1 = 2.49;
    mockData.number2 = 0.18;

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(2.31);
- name: '[Multiply] numeric inputs integer and float - without rounding'
  code: |-
    mockData.type = 'multiply';
    mockData.number1 = 2.5;
    mockData.number2 = 4;

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(10);
- name: '[Divide] numeric inputs integer and float - without rounding'
  code: |-
    mockData.type = 'divide';
    mockData.number1 = 2.5;
    mockData.number2 = 4;

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(0.625);
- name: '[Add] numeric inputs integer and float - without rounding'
  code: |-
    mockData.type = 'add';
    mockData.number1 = 2.5;
    mockData.number2 = 4;

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(6.5);
- name: '[Subtract] numeric inputs integer and float - without rounding'
  code: |-
    mockData.type = 'subtract';
    mockData.number1 = 2.5;
    mockData.number2 = 4;

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(-1.5);
- name: '[Multiply] with rounding'
  code: |-
    mockData.type = 'multiply';
    mockData.number1 = 2.49;
    mockData.number2 = 0.18;
    mockData.roundResult = true;
    mockData.roundDecimalPlaces = 2;

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(0.45);
- name: '[Add] with rounding'
  code: |-
    mockData.type = 'add';
    mockData.number1 = 2.49;
    mockData.number2 = 0.18;
    mockData.roundResult = true;
    mockData.roundDecimalPlaces = 2;

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(2.67);
- name: '[Divide] with rounding'
  code: |-
    mockData.type = 'divide';
    mockData.number1 = 2.49;
    mockData.number2 = 0.18;
    mockData.roundResult = true;
    mockData.roundDecimalPlaces = 2;

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(13.83);
- name: '[Subtract] with rounding'
  code: |-
    mockData.type = 'subtract';
    mockData.number1 = 2.49;
    mockData.number2 = 0.18;
    mockData.roundResult = true;
    mockData.roundDecimalPlaces = 2;

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(2.31);
- name: '[Multiply] Float and integer with rounding to 2 decimals'
  code: |-
    mockData.type = 'multiply';
    mockData.number1 = 2.5;
    mockData.number2 = 4;
    mockData.roundResult = true;
    mockData.roundDecimalPlaces = 2;

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(10);
- name: '[Divide] Float and integer with rounding to 2 decimals'
  code: |-
    mockData.type = 'divide';
    mockData.number1 = 2.5;
    mockData.number2 = 4;
    mockData.roundResult = true;
    mockData.roundDecimalPlaces = 2;

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(0.63);
- name: '[Add] Float and integer with rounding to 2 decimals'
  code: |-
    mockData.type = 'add';
    mockData.number1 = 2.5;
    mockData.number2 = 4;
    mockData.roundResult = true;
    mockData.roundDecimalPlaces = 2;

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(6.5);
- name: '[Subtract] Float and integer with rounding to 2 decimals'
  code: |-
    mockData.type = 'subtract';
    mockData.number1 = 2.5;
    mockData.number2 = 4;
    mockData.roundResult = true;
    mockData.roundDecimalPlaces = 2;

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(-1.5);
- name: Float and integer with rounding to 2 decimals
  code: |-
    mockData.type = 'subtract';
    mockData.number1 = 2.5;
    mockData.number2 = 4;
    mockData.roundResult = true;
    mockData.roundDecimalPlaces = 10;

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(-1.5);
- name: Float and integer with rounding to 0 decimals
  code: |-
    mockData.type = 'add';
    mockData.number1 = 1.49;
    mockData.number2 = 1;
    mockData.roundResult = true;
    mockData.roundDecimalPlaces = 0;

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(2);
- name: Fallback to 2 decimals when roundDecimalPlaces is invalid
  code: |-
    mockData.type = 'divide';
    mockData.number1 = 2.5;
    mockData.number2 = 4;
    mockData.roundResult = true;
    mockData.roundDecimalPlaces = null;

    const variableResult = runCode(mockData);

    assertThat(variableResult).isEqualTo(0.63);
setup: |-
  const makeNumber = require('makeNumber');
  const mockData = {};


___NOTES___

Created on 8/15/2024, 12:08:53 PM


