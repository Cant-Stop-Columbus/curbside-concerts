let Hooks = {}

const columns = document.querySelectorAll('.column')

columns.forEach(column => {
  column.addEventListener('dragover', e => {
    if (e.preventDefault) {
      e.preventDefault() // Necessary. Allows us to drop.
    }
    column.classList.add('over')
  })
  column.addEventListener('dragenter', e => {
  })
  column.addEventListener('dragleave', e => {
    column.classList.remove('over')
  })
  column.addEventListener('drop', e => {
    if (lastGrabbedRequestBookerCard) {
      const toSessionId = column.getAttribute("phx-value-session-id")
      const fromSessionId = e.dataTransfer.getData('from_session_id') || null
      lastGrabbedRequestBookerCard.pushEvent("move_request", {
        "request_id": lastGrabbedRequestBookerCard.el.getAttribute("phx-value-request-id"),
        "over_request_id": null,
        "from_session_id": fromSessionId,
        "to_session_id": toSessionId
      })
    }
  })
})

let lastGrabbedRequestBookerCard = null

Hooks.RequestBookerCard = {
  mounted() {
    const elem = this.el

    elem.addEventListener('dragstart', e => {
      lastGrabbedRequestBookerCard = this

      const targetColumn = elem.closest('.column')
      const sessionId = targetColumn.getAttribute("phx-value-session-id")
      e.dataTransfer.setData('request_id', elem.getAttribute("phx-value-request-id"))
      if (sessionId) {
        e.dataTransfer.setData('from_session_id', sessionId)
      }
      e.dataTransfer.effectAllowed = 'move'
      e.currentTarget.classList.add('dragging')
    })

    // elem.addEventListener('dragenter', handleDragEnter, false)
    elem.addEventListener('dragover', e => {
      if (e.preventDefault) {
        e.preventDefault() // Necessary. Allows us to drop.
      }

      elem.classList.add('over')

      e.dataTransfer.dropEffect = 'move'
    })

    elem.addEventListener('dragenter', e => {
    })

    elem.addEventListener('dragleave', e => {
      elem.classList.remove('over')
    })

    elem.addEventListener('drop', e => {
      if (e.stopPropagation) {
        e.stopPropagation()
      }
      console.log('e.currentTarget')
      console.log(e.currentTarget.outerHTML)
      console.log('elem')
      console.log(elem)

      console.log('drop card')
      const targetDraggable = e.currentTarget.closest('[draggable]')
      const targetColumn = e.currentTarget.closest('.column')
      const receivingRequestId = e.dataTransfer.getData('request_id')

      if (receivingRequestId === elem.getAttribute("phx-value-request-id")) {
        console.log('dropped on self - do nothing')
      } else if (targetDraggable) {
        console.log('dropped on friend - fire event!')
      }
      targetDraggable.classList.add('over')
      targetColumn.classList.add('over')

      const requestId = e.dataTransfer.getData('request_id')
      const fromSessionId = e.dataTransfer.getData('from_session_id') || null
      const overRequestId = e.currentTarget.getAttribute("phx-value-request-id")
      const toSessionId = targetColumn.getAttribute("phx-value-session-id")


      this.pushEvent("move_request", {
        "request_id": requestId,
        "over_request_id": overRequestId,
        "from_session_id": fromSessionId,
        "to_session_id": toSessionId
      })
    });

    elem.addEventListener('dragend', e => {
      e.currentTarget.classList.remove('dragging')
    });
  }
}

export default Hooks
