import moment from 'moment'

let baseUrl = `${import.meta.env.VITE_SCHEMA}://${import.meta.env.VITE_HOST}`

const port = import.meta.env.VITE_PORT || 5555;
if (port) {
  baseUrl += `:${port}`
}

function startInterval() {
  setInterval(() => {
    this.currentTime = moment().format('HH:mm:ss')
  }, 1000)
}

async function saveTime() {
  const time = this.currentTime
  const res = await fetch(`${baseUrl}/times`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ time }),
  })
  const json = await res.json()
  if (json.insertId) {
    this.savedTimes.unshift({ id: json.insertId, time })
    this.$toast.success(`Время ${time} сохранено`, { position: 'top-right' })
  }
}

async function deleteTime(id) {
  const res = await fetch(`${baseUrl}/time/${id}`, {
    method: 'DELETE',
  })
  const json = await res.json()
  if (json.affectedRows) {
    this.savedTimes = this.savedTimes.filter((savedTime) => savedTime.id !== id)
    this.$toast.error(`Время с ID ${id} удалено`, {
      position: 'top-right',
    })
  }
}

export { startInterval, saveTime, deleteTime }
