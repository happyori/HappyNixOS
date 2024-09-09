local fmt = require('luasnip.extras.fmt').fmt
return {
  s(
    'lspec',
    fmt(
      [[
    ---@module 'lazy'
    ---@type LazySpec
    return {{
      {}
    }}
    ]],
      i(0)
    )
  ),
}
