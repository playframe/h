
![PlayFrame](https://avatars3.githubusercontent.com/u/47147479)
# h

###### 0.3 kB Virtual Dom Producer

## Installation
```sh
npm install --save @playframe/h
```

## Usage
```js
import h from '@playframe/h'

// directly
h('a', {href: 'https://github.com/playframe/h'}, 'PlayFrame/h')

// JSX
const link = ()=>
  <a href="https://github.com/playframe/h"> PlayFrame/h </a>
```

## Annotated Source

Creating a unique Symbol for distinction between Virtual Nodes
and plain Arrays

    VNODE = Symbol 'VNODE'

Our Virtual Node is produced from a list of arguments passed
to `h` function. Children are passed as tail of arguments,
but any of them could be wrapped in Array

```js
h('div', {class: 's'}, child1, [ child2, child3 ], child4)`)
```
To achieve no runtime overhead we will avoid creating a new object
for Virtual Node and new Array for children. We will just mark array
of passed arguments as a `VNODE` and return it as is.
This is compensated by a more advenced child walker used in
[@playframe/dom](https://github.com/playframe/dom)

    module.exports = h = (a...)=>
      if typeof a[0] is 'function'
        invoke a...
      else
        a[VNODE] = true
        a

    h.VNODE = VNODE

If the first argument of `h` function is a not a `'div'` but
your Component function, we will flatten the children and attach
them to `props`

    invoke = (Component, props, children...)=>
      if children[0]
        flat = props.children = []
        for child in children
          if not child[VNODE] and Array.isArray child
            flat.push child...
          else
            flat.push child
      Component props
