const numberMaskFields = document.querySelectorAll('[data-mask]')
Array.prototype.forEach.call(numberMaskFields, numberMask)

function numberMask(element) {
  const DEFAULT_MASK = '(___) ___-____'
  const MASK = (element.dataset.mask || DEFAULT_MASK).split('')

  function onlyDigits(maskedData) {
    const digits = maskedData.split('').filter(function (char) {
      return /\d/.test(char)
    })

    if (digits[0] == '1') {
      digits.shift()
    }

    return digits
  }

  function applyMask(data) {
    return MASK.map(function (char) {
      if (char != '_') return char
      if (data.length == 0) return char
      return data.shift()
    }).join('')
  }

  function nextInputPosition(string) {
    const firstBlankIndex = string.indexOf('_')
    if (firstBlankIndex === -1) {
      return string.length
    } else {
      return firstBlankIndex
    }
  }

  function resetCursor(field) {
    const cursorIndex = nextInputPosition(field.value)
    field.selectionStart = cursorIndex
    field.selectionEnd = cursorIndex
  }

  function handleFocus(event) {
    const field = event.target
    resetCursor(field)
  }

  function allowChange(event) {
    const field = event.target

    if (event.keyCode === 8 || event.keyCode === 46) {
      // only prevent deletion when cursor has not selected a range
      if (field.selectionStart === field.selectionEnd) {
        event.preventDefault()
      }
    } else if (event.keyCode === 9) {
      // allow tab
    } else {
      event.preventDefault()
    }
  }

  function handleChange(event) {
    const field = event.target
    const digits = onlyDigits(field.value)

    if (event.keyCode === 8 || event.keyCode === 46) { // delete or backspace
      if (field.selectionStart === field.selectionEnd && digits.length >= 1) {
        digits.pop()
      }
    } else if (event.keyCode >= 48 && event.keyCode <= 57) {
      digits.push(event.key)
    }

    if (event.keyCode !== 9) {
      // not tab
      field.value = applyMask(digits)
      resetCursor(field)
    }
  }

  element.addEventListener('click', handleFocus)
  element.addEventListener('focus', handleFocus)
  element.addEventListener('keydown', allowChange)
  element.addEventListener('keyup', handleChange)

  element.value = applyMask(onlyDigits(element.value))
}

