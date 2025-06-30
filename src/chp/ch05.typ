#import "../utils.typ": abstract, code-and-show, code-block, code-card, show-block

= 排版样式设定

#abstract[
  至此你已经基本学会排版内容丰富的文档，标题、目录、章节、公式、列表、图片、表格等等应有尽有。
  但是你可能有点不甘心，因为排版出来的文档“千篇一律”
  ------ Typst 默认的字体、不太满意的页边距，等等。
  本章的内容将带你一览如何修改 Typst 的排版样式。
]

== 字体和字号

Typst 会根据内容的位置自动选择字体样式和字号。
但是目前 Typst 的字体设置还是比较局限，
只能设置默认字体，然后使用 `covers` 去匹配应用。


#figure(kind: table, caption: [标准字体命令与字号的对应@ctex-manual-2022], numbering: none)[
  #table(
    columns: (3fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
    stroke: none,
    column-gutter: 1em,
    align: center + horizon,
    table.hline(stroke: 0.08em + black),
    table.header(
      [LaTeX], table.cell(colspan: 2)[`zihao = 5`],
      table.cell(colspan: 2)[`zihao = -4`],
      [`10pt`], [`11pt`], [`12pt`],
      [ 字体命令], [字号], [bp], [字号], [bp], [pt], [pt], [pt],
    ),
    table.hline(y: 1, start: 1, end: 3, stroke: 0.04em + black),
    table.hline(y: 1, start: 3, end: 5, stroke: 0.04em + black),
    table.hline(y: 1, start: 5, end: 6, stroke: 0.04em + black),
    table.hline(y: 1, start: 6, end: 7, stroke: 0.04em + black),
    table.hline(y: 1, start: 7, end: 8, stroke: 0.04em + black),
    table.hline(y: 2, stroke: 0.06em + black),
    [`tiny`], [七号], [5.5], [小六], [6.5], [5], [6], [6],
    [`scriptsize`], [小六], [6.5], [六号], [7.5], [7], [8], [8],
    [`footnotesize`], [六号], [7.5], [小五], [9], [8], [9], [10],
    [`small`], [小五], [9], [五号], [10.5], [9], [10], [11],
    [`normalsize`], [五号], [10.5], [小四], [12], [10], [11], [12],
    [`large`], [小四], [12], [小三], [15], [12], [12], [14],
    [`Large`], [小三], [15], [小二], [18], [14], [14], [17],
    [`LARGE`], [小二], [18], [二号], [22], [17], [17], [20],
    [`huge`], [二号], [22], [小一], [24], [20], [20], [25],
    [`Huge`], [一号], [26], [一号], [26], [25], [25], [25],
    table.hline(stroke: 0.08em + black),
  )
]


#code-and-show(columns: (3fr, 2fr))[```typ
  #text(size: 11pt)[Small] and
  #text(size: 14pt)[Large].
  ```]

=== 字体样式

字体样式包括字体，字重和字形，分别对应 `text` 函数的参数 `font`、`weight` 和 `style`。
通过 `set` 规则设置的字体样式会在文档内全局生效，而单独使用 `text` 函数设置的样式仅对函数参数生效。

#code-and-show(columns: (9fr, 5fr))[```typ
  #set text(size: 16pt) // 全局
  Text, #text(size: 9pt)[
    Text, // 局部
  ] and Text.
  ```]

=== 更改对应元素字体

通过 `set` 规则设置的字体仅对标记模式的文本内容生效。
如果想要修改其他元素的字体，则需要使用 `show` 规则来设置：

#code-and-show(columns: (7fr, 3fr))[````typ
  #set text( // 普通文本
    font: "Sarasa Gothic SC",
  )
  #show raw: set text( // 等宽文本
    font: "DejaVu Sans Mono",
  )
  #show math.equation: set text(
    font: "New Computer Modern Sans Math",
  ) // 数学字体
  标记模式文本测试。\
  ```py
  // 等宽文本测试
  print("hello")
  ```
  $
    integral_0^1 ln(x) = -1
  $
  ````]

如果要分语言设置字体，可以参考 @ch-2-排版中文 中的示例。

如果需要使用其他字体，例如仿宋，建议使用 `with` 方法得到对应函数，然后在需要使用的地方使用。

#code-card[```typ
  #let fangsong = text.with(font: "Zhuque Fangsong (technical preview)")
  #fangsong[需要仿宋]，正常文本。
  ```]
