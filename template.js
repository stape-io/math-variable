const makeNumber = require('makeNumber');
const getType = require('getType');

const type = data.type;
const roundResult = !!data.roundResult;

let decimals = makeNumber(data.decimals);
if (getType(decimals) !== 'number' || decimals !== decimals || decimals < 0) {
  decimals = 2;
}

if (data.number1.length <= 0 || data.number2.length <= 0) return undefined;

const number1 = makeNumber(data.number1);
const number2 = makeNumber(data.number2);

if (
  getType(number1) !== 'number' ||
  getType(number2) !== 'number' ||
  number1 !== number1 ||
  number2 !== number2
) {
  return undefined;
}

let result;

switch (type) {
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

if (typeof result === 'number' && roundResult) {
  let factor = 1;
  let i = 0;
  while (i < decimals) {
    factor = factor * 10;
    i = i + 1;
  }

  result = (result * factor + 0.5);
  result = result - (result % 1);
  result = result / factor;
}

return result;