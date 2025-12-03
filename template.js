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
  let roundDecimalPlaces = makeNumber(data.roundDecimalPlaces);
  
  if (getType(roundDecimalPlaces) !== 'number' || roundDecimalPlaces !== roundDecimalPlaces || roundDecimalPlaces < 0) {
    roundDecimalPlaces = 2;
  }

  const factor = Math.pow(10, roundDecimalPlaces);
  result = result * factor;
  result = result >= 0 ? result + 0.5 : result - 0.5;
  result = result - (result % 1);
  result = result / factor;

  return result;
}

return result;
