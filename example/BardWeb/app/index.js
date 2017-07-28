import React from 'react'
import * as Semantic from 'semantic-ui-react'
import Bard from 'bard'

import {
  withProps
} from 'recompose'

const universal = {
  Text: 'span',
  View: 'div',
  Title: withProps({size: 'huge'})(Semantic.Header),
  Button: Semantic.Button,
}

const components = {
  'Elixir.BardDemo.SemanticComponents': Semantic,
  'Elixir.BardDemo.UniversalComponents': name => universal[name] || universe(name),
  'Elixir.BardDemo.WebComponents': name => web(name)
}

const bard = Bard({app: 'demo', components, uri: 'ws://localhost:4000/socket'})
const web = bard('Elixir.BardDemo.WebComponents')
const universe = bard('Elixir.BardDemo.UniversalComponents')

const Hello = universe('Hello')
const ClickHere = universe('ClickHere')


const clicked = ev => alert("Clicked")

const App = _ => (
  <div>
    <Hello />
    <ClickHere />
  </div>
)

export default App
