function evaluator(code) { eval.bind(null)(code) }

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


function UUID() {
  // borrowed from http://stackoverflow.com/questions/105034/create-guid-uuid-in-javascript
  var d = new Date().getTime();
  var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
    var r = (d + Math.random() * 16) % 16 | 0;
    d = Math.floor(d / 16);
    return (c == 'x' ? r : r & 0x3 | 0x8).toString(16);
  });
  return uuid;
}

const logger = console.log.bind(console, 'Bard')
const topic = 'bard:client'
const sameTopic = R.find(ch => ch.topic === topic)
const sink = x$ => x$.addListener({next: R.identity, error: R.identity, complete: R.identity})
const filterMap = fn => x$ => x$.filter(fn).map(fn)

const Bard = ({app, conf, uri, socket: existingSocket, components}) => {
  const socket = existingSocket || new Socket(uri, {logger})
  socket.isConnected() || socket.connect()

  const channel = sameTopic(socket.channels) || socket.channel(topic, {app, conf})
  channel.joinedOnce ||  channel.join()

  const in$ = xs.create()
  socket.onMessage(message => in$.shamefullySendNext(message))

  const push = R.curry((event, payload) => {
    let pushed
    const stop = _ => pushed.reset()
    const start = listener => {
      pushed = channel.push(event, payload)
        .receive('timeout', e => listener.error(e))
        .receive('error', e => listener.error(e))
      const nextReply = ({status, response}) => {
        console.log("GOT EVENT REPLY ")
        status === 'reply' && listener.next(response)
      }
      channel.on(pushed.refEvent, nextReply)
    }
    return xs.create({start, stop})
  })

  const getComponent = namespaced => {
    const parts = namespaced.split('.')
    const namespace = parts.slice(0, -1).join('.')
    const name = parts.slice(-1)[0]
    const ns = components[namespace]
    if (ns[name]) { return ns[name] }
    if (typeof ns === 'function') { return ns(name) }
    throw `unknown component ${namespaced}`
  }

  const build = ({module, component, props}, props$) => {
    const funs = {}

    const defun = ({fun}) => funs[fun] = (...args) => {
      console.log("REMOVE INVOKE ", fun, args)
    }

    const mkFun = (fun, name) => {
      const id = `${name}:${UUID()}`
      funs[id] = fun
      return ({fun: id})
    }

    const encode = (value, name) => {
      if (Array.isArray(value)) return R.map(encode, value)
      if (typeof value === 'object') return R.mapObjIndexed(encode, value)
      if (typeof value === 'function') { return mkFun(value, name) }
      return value
    }

    const render = value => {
      if (Array.isArray(value)) return R.map(render, value)
      if (typeof value === 'object' && value.component) {
        const propValues = R.mapObjIndexed(render)(value.props)
        const enhance = compose(withProps(propValues))
        return R.pipe(getComponent, enhance, createEagerElement)(value.component)
      }
      return value
    }

    const param$ = props$.map(encode).map(props => ({module, component, props}))
    const reply$ = param$.map(push('bard:render')).flatten()
    const onReply = subject => reply$.compose(filterMap(R.prop(subject)))

    const render$ = onReply('render').debug('WILL RENDER').map(render).debug('RENDERED')

    onReply('eval').map(evaluator).compose(sink)
    onReply('log').map(console.log.bind(console)).compose(sink)
    onReply('def').map(defun).compose(sink)

    return render$
  }

  const bardComponent = module => component => componentFromStream(
    props$ => props$.take(1).map(props => build({module, component, props}, props$.startWith(props))).flatten())

  return bardComponent
}

export default Bard
