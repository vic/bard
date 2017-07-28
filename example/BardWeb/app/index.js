import {Socket} from 'phoenix'
import React from 'react'
import Semantic from 'semantic-ui-react'
import Bard from 'bard'

const Text = 'span'

const adapted = {
  Text
}

const components = {
  'Elixir.BradDemo.PortableComponents': name => adapted[name] || portable(name),
  'Elixir.BradDemo.WebComponents': name => web(name)
}

const WS_URI = 'ws://localhost:4000/socket'
const socket = new Socket(WS_URI)

const web = Bard({socket, module: 'Elixir.BradDemo.WebComponents', components})
const portable = Bard({socket, module: 'Elixir.BradDemo.PortableComponents', components})

export const Hello = portable('Hello')

const App = _ => <Hello />

export default App
