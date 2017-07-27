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

export const bardPrefix = (prefix) => R.pipe(
  R.mapObjIndexed((value, name) => ({[`${prefix}${name}`]: value})),
  R.values,
  R.mergeAll,
)

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

const sender = (channel, uuid) => payload => {
  const msgId = (uuid === null ? UUID() : uuid) || payload.msgId || UUID()

  const start    = 'bard:start:'+msgId
  const stop     = 'bard:stop:'+msgId
  const next     = 'bard:next:'+msgId
  const complete = 'bard:complete:'+msgId
  const error    = 'bard:error:'+msgId

  const startProducer = listener => {
    const onNext = data => (listener.next(data))
    const onError = err => (listener.error(err))
    const onComplete = _ => (listener.complete())

    channel.on(next, onNext)
    channel.on(complete, onComplete)
    channel.on(error, onError)
    channel.push(start, payload)
      .receive('ok', onNext)
      .receive('error', onError)
  }
  const stopProducer = _ => (channel.off(next),
                             channel.off(complete),
                             channel.off(error),
                             channel.push(stop, {}))
  return xs.create({start: startProducer, stop: stopProducer})
}

const Bard = ({module, components, uri, socket: existingSocket}) => {
  const logger = console.log.bind(console, 'Bard')
  const socket = existingSocket || new Socket(uri, {logger})
  socket.isConnected() || socket.connect()

  const channel = socket.channel('bard:app', {module})
  channel.join()

  const bardEncodeParams = (value, name) => {
    console.log('encoded', name, value)
    return value
  }

  const getComponent = namespaced => {
    const parts = namespaced.split('.')
    const namespace = parts.slice(0, -1).join('.')
    const name = parts.slice(-1)[0]
    const ns = components[namespace]
    if (ns[name]) { return ns[name] }
    if (typeof ns === 'function') { return ns(name) }
    if (namespace === module) { return bardComponent(name) }
    return namespaced
  }

  const bardRender = (value) => {

    if (Array.isArray(value)) {
      return R.map(bardRender, value)
    }

    if (typeof value === 'object' && value.component) {
      const props = R.pipe(
        R.mapObjIndexed((v, k) => withProps({[k]: bardRender(v)})),
        R.values,
      )(value.props)
      return R.pipe(
        getComponent,
        compose(
          ...props
        ),
        createEagerElement
      )(value.component)
    }

    return value
  }

  const bardComponent = name => componentFromStream(
    props$ => props$
      .map(R.mapObjIndexed(bardEncodeParams))
      .map(props => ({component: `${module}.${name}`, props}))
      .map(sender(channel, `render:` + UUID()))
      .flatten()
      .map(bardRender))

  return bardComponent
}

export default Bard
