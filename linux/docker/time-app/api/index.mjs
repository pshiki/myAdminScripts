import express from 'express'
import bodyParser from 'body-parser'
import cors from 'cors'
import {
  readRecords,
  insertRecord,
  deleteRecord,
} from './src/utils/records.mjs'

const app = express()

const port = process.env.PORT || 5000;
const host = process.env.HOST || 'localhost'
const schema = process.env.SCHEMA || 'http'

app.use(bodyParser.json())
app.use(cors({
  orign: false,//`${schema}://${host}`,
  preflightContinue: true,
}))
app.options('*', cors())

app.get('/', (_, res) => {
  res.send('Hello from the time saving service!')
})

app.get('/times', async (_, res) => {
  res.send(await readRecords())
})

app.post('/times', async (req, res) => {
  res.send(await insertRecord(req.body.time))
})

app.delete('/time/:id', async (req, res) => {
  res.send(await deleteRecord(req.params.id))
})

app.listen(port, () => {
  console.log(`Express web server is running at ${schema}://${host}:${port}`);
  console.log(process.env)
})
