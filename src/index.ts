import express from 'express'
import { NFTRouter } from './routes/NFTRouter'
import { json } from 'body-parser'
import { accountRouter } from './routes/accountRouter'
import XrpLedgerAdapter from './ledger/XrpLedgerAdapter'
const app = express()
const PORT = 3000


app.use(json())
app.use('/nft/', NFTRouter)
app.use('/account/', accountRouter)
app.listen(PORT, async () => {
  await XrpLedgerAdapter.getInstance().connectClient()
  console.log(`Server is running on port ${PORT}`)
})
