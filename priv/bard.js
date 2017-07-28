import React from 'react'
import R from 'ramda'
import xs from 'xstream'
import {Socket} from 'phoenix'

import {
  compose,
  createEagerElement,
  getContext,
  withContext,
  withProps,
  componentFromStreamWithConfig,
  mapPropsStreamWithConfig,
} from 'recompose'

import xstreamConfig from 'recompose/xstreamObservableConfig'
const componentFromStream = componentFromStreamWithConfig(xstreamConfig)

const logger = console.log.bind(console, 'Bard')
const topic = 'bard:client'
const sameTopic = R.find(ch => ch.topic === topic)
const componentStatus = ['ok', 'timeout', 'error', 'render']

const Bard = ({app, conf, uri, socket: existingSocket, components}) => {
  const socket = existingSocket || new Socket(uri, {logger})
  socket.isConnected() || socket.connect()

  const channel = sameTopic(socket.channels) || socket.channel(topic, {app, conf})
  channel.joinedOnce ||  channel.join()

  const in$ = xs.create()
  socket.onMessage(message => in$.shamefullySendNext(message))

  const push = R.curry((event, payload) => xs.create({
    stop: R.identity,
    start: listener => R.reduce(
      (a, e) => a.receive(e, value => listener.next({[e]: value})),
      channel.push(event, payload), componentStatus)}))

  const getComponent = namespaced => {
    const parts = namespaced.split('.')
    const namespace = parts.slice(0, -1).join('.')
    const name = parts.slice(-1)[0]
    const ns = components[namespace]
    if (ns[name]) { return ns[name] }
    if (typeof ns === 'function') { return ns(name) }
    throw `unknown component ${namespaced}`
  }

  const bardRender = value => {
    if (Array.isArray(value)) return R.map(bardRender, value)
    if (typeof value === 'object' && value.component) {
      const propValues = R.mapObjIndexed(bardRender)(value.props)
      const enhance = compose(withProps(propValues))
      const render = R.pipe(getComponent, enhance, createEagerElement)
      return render(value.component)
    }
    return value
  }

  const bardComponent = module => component => componentFromStream(
    props$ => props$
      .map(props => ({module, component, props}))
      .map(push('bard:render'))
      .flatten()
      .compose(reply$ => {
        const _render = R.prop('render')
        return reply$.filter(_render).map(_render).map(bardRender)
      }))

  return bardComponent
}

export default Bard
