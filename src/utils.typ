// 生成摘要
#let abstract(body) = {
  // 使用小一点的无衬线字体，半粗体
  text(size: 0.96em, weight: "semibold", font: "Sarasa Gothic SC")[
    // 内容居中
    #align(center)[
      // 内容宽度限定在 64%
      #block(width: 64%)[
        // 文本左对齐
        #align(left)[
          #body
        ]
      ]
    ]
  ]
}

// 表示键盘按键
#let kbd(
  body,
  background: rgb(235, 255, 216), // 背景颜色
  stroke-color: rgb(238, 238, 238), // 边框颜色
) = {
  show raw: set text(fill: black.mix(blue.lighten(16%)))
  text(
    // 使用标准等宽字体
    math.space.thin // 与周围文字添加一点间隔
      + box(
        // 使用 block 包裹
        fill: background,
        outset: 0.24em,
        stroke: 0.04em + stroke-color,
        radius: 0.16em,
        raw(body), // 显示内容
      )
      + math.space.thin, // 与周围文字添加一点间隔
  )
}

// 展示代码片段
#let code-card(body, background: rgb(238, 238, 238)) = {
  // 取消段落缩进和调整
  set par(first-line-indent: 0em, justify: false)
  // 手动缩进 2em
  (
    h(2em)
      + box(
        fill: background,
        // 圆角大小设置为 0.32em
        radius: 0.32em,
        // 上下边距为 0.64em，左右边距 1em
        inset: (y: 0.64em, x: 1em),
      )[
        #body
      ]
  )
}

// 展示代码块
#let code-block(
  body,
  background: rgb(255, 253, 246), // 代码块背景颜色
  linenumber: true, // 是否显示行号
  numbercolor: rgb(112, 119, 161), // 行号颜色
  top-bottom-stroke: true, // 是否显示代码块上下边框
  stroke-thickness: 0.04em, // 边框厚度
  stroke-color: black, // 边框颜色
) = {
  // 取消段落缩进和调整
  set par(first-line-indent: 0em, justify: false)
  // 设置代码块显示行号和背景
  show raw.where(block: true): it => {
    // 代码块默认居中显示
    align(center)[
      // 使用 block 包裹内容
      #block(
        fill: background, // 填充背景颜色
        width: 100% - 4em, // 左右各留出 2em 边距
        inset: 1em, // 设置内边距 1em
        stroke: if top-bottom-stroke {
          // 如果显示上下边框
          (y: stroke-thickness + stroke-color)
        } else {
          // 否则设置为 0em
          0em
        },
      )[
        #if linenumber {
          // 如果显示行号，则使用 grid 排版
          grid(
            // 行号右对齐，代码左对齐，水平居中
            align: (right + horizon, left + horizon),
            // 行号宽度自动，代码内容占据所有剩下的空间
            columns: (
              auto,
              1fr,
            ),
            // 行间距设置为 0.64em
            row-gutter: 0.64em,
            // 行号和代码内容间距设置为 1em
            column-gutter: 1em,
            ..it
              .lines
              .map(line => (
                // 使用 raw.line.number 获取行号
                text(fill: numbercolor)[#line.number],
                line.body,
              ))
              .flatten()
          )
        } else {
          // 如果不显示行号，则左对齐显示所有内容
          align(left, it.lines.map(line => line.body + linebreak()).join())
        }
      ]
    ]
  }
  // 显示内容
  body
}

// 显示渲染示例
#let show-block(
  body,
  width: 100%,
  background: rgb(255, 253, 246), // 背景颜色
  stroke: 0.04em + black.lighten(32%), // 边框厚度和颜色
  radius: 0.32em, // 圆角大小
) = {
  // 居中显示
  align(center, block(
    width: width,
    fill: background,
    stroke: stroke,
    // 设置合理内边距
    inset: 1em,
    radius: radius,
  )[
    // 恢复默认排版
    #set align(left)
    #set par(first-line-indent: 0em, justify: false)
    #body
  ])
}

// 同时显示代码和渲染示例
#let code-and-show(
  body,
  code-func: code-block,
  columns: (1fr, 1fr),
  width: auto,
  align: center + horizon,
) = {
  grid(
    columns: columns,
    align: align,
    code-func[#body],
    show-block(width: width)[
      #eval(body.text, mode: "markup")
    ]
  )
}
