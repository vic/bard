import React from 'react'
import Semantic from 'semantic-ui-react'
import Bard from 'bard'

const components = {
  'Elixir.BardDemo.Semantic':   Semantic,
  'Elixir.BardDemo.Components': module.exports
}

const WS_URI = 'ws://localhost:4000/socket'

const demo = Bard({
  uri: WS_URI,
  module: 'Elixir.BardDemo.Components',
  components,
})

export const ClickMe = demo('ClickMe')

const App = _ => <h1>HELLO BARD</h1>

export default App
