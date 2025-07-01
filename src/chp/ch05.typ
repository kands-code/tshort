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

== 文字装饰与强调

要强调一段文字，除了改变文字的字体，就是为文字添加一些装饰物。

通常的强调方法包括加粗文本和使用斜体，对应 `strong` 和 `emph` 函数。
函数的效果可以使用 `show` 规则设置，例如让 `strong` 函数在加粗文本时让文本颜色变成红色：

#code-and-show(columns: (9fr, 5fr))[```typ
  #show strong: set text(fill: red)
  *Strong* test. \
  _Emphasis_ test.
  ```]


要为一段文字添加下划线装饰，可以使用 `underline` 函数：

#code-and-show(columns: (9fr, 5fr))[```typ
  An #underline[underlined] text.
  ```]

下划线可以通过参数 `stroke` 设置，例如加粗的渐变色下划线：

#code-and-show(columns: (9fr, 5fr))[```typ
  #set underline(
    stroke: 2pt + gradient
      .linear(..color.map.crest),
  )
  #underline(lorem(8))
  ```]

仔细看会发现，下划线有可能会被一些字母“截断”。
将参数 `evade` 设置 `false` 后，下划线就会穿过文字底部，不会被截断。
如果设置参数 `background` 为 `true`，下划线将不会遮挡文本，可用于模拟文本高亮的效果。

#code-and-show(columns: (9fr, 5fr))[```typ
  #set underline(
    stroke: 1em + yellow.lighten(64%),
    evade: false, background: true)
  #underline(lorem(8))
  ```]

不过 Typst 已经提供了 `highlight` 函数用于文本高亮，不需要重新实现：

#code-and-show(columns: (9fr, 5fr))[```typ
  #highlight(lorem(4))
  ```]

通过设置参数 `fill` 和 `stroke`，可以调整高亮使用的颜色，以及边框效果。

#code-and-show(columns: (9fr, 5fr))[```typ
  #highlight(
    stroke: 1pt + rgb(155, 23, 126),
    fill: rgb(255, 220, 220), lorem(8))
  ```]

== 段落格式和间距

=== 长度和长度变量

到目前为止，我们已经见到过许多长度的用法。
这一节作为汇总，将介绍 Typst 中所有支持的长度单位和用法。

#align(center)[
  #let normal = text.with(size: 12pt, lang: "zh", fill: black, font: (
    (name: "New Computer Modern", covers: "latin-in-cjk"),
    (name: "Noto Color Emoji", covers: regex("\p{Emoji}")),
    "Source Han Serif SC",
  ))
  #block(width: 72%)[
    #table(
      columns: (1fr, 4fr),
      stroke: none,
      align: (center + horizon, left + horizon),
      rows: 1.6em,
      table.hline(stroke: 0.08em + black),
      table.vline(x: 1, stroke: 0.06em + black),
      [`pt`],
      [磅，$approx 1\/72.27 #[in] #normal[（传统）] approx 1\/72 #[in] #normal[（现代）]$],
      [`mm`], [毫米],
      [`cm`], [厘米],
      [`in`], [英寸，$= 2.54 #[cm]$],
      table.hline(stroke: 0.04em + black),
      [`em`], [相对文本宽度，对应 `text` 函数的参数 `size`],
      [`%`], [相对某个长度的比例，例如 `64%`],
      [`fr`], [一份，将剩余空间等分后所占份数],
      table.hline(stroke: 0.08em + black),
    )
  ]

  通常使用 `百分比+绝对长度` 的形式表示相对长度，例如 `0%+5pt`。
]

=== 行距

当前 Typst 的页面模型中，*并没有*行距的概念#footnote[
  详情可以参考 #link("https://github.com/typst/typst/issues/4224")[typst/issues/4224]。
]。取而代之的是当前行的下边界与下一行的上边界的距离，以及段落之间的距离，
对应参数 `leading` 和 `spacing`。

参数 `leading` 的效果实际上会受到字体以及文本内容的影响，不过我们还是可以将其视为行间距。
参数 `leading` 和 `spacing` 的默认值分别为 `0.65em` 和 `1.2em`。

#code-and-show(columns: (9fr, 7fr))[```typ
  // 使用默认间距
  #set par(leading: 0.65em,
    spacing: 1.2em)
  #lorem(8)

  #lorem(8)

  #line(length: 100%)

  // 改变行间距和段间距
  #set par(leading: 1em,
    spacing: 2em)
  #lorem(8)

  #lorem(8)
  ```]

=== 段落格式

下面展示了如何设置段落的左缩进、右缩进和首行缩进：

#code-block[
  ```typ
  #lorem(16)
  #align(center, block(width: 100%, inset: (left: 5em, right: 4em))[
    #set align(left)
    #set par(
      first-line-indent: (amount: -1em, all: false),
      justify: true,
    )

    #lorem(16)

    #lorem(16)
  ])
  ```
]

#show-block(width: 100%)[
  #lorem(16)
  #align(center, block(width: 100%, inset: (left: 5em, right: 4em))[
    #set align(left)
    #set par(
      first-line-indent: (amount: -1em, all: false),
      justify: true,
    )

    #lorem(16)

    #lorem(16)
  ])
]

首行缩进可以通过 `par` 函数的参数 `first-line-indent` 设置。
如果 `all` 设置为 `false`，那么每一部分的第一段不缩进；
设置为 `true`，则所有的段落都缩进。
`amount` 表示缩进大小，小于零时表示悬挂缩进；
还可以通过参数 `hanging-indent` 设置悬挂缩进。

Typst 没有提供设置段落左右缩进的方法，但是可以使用 `align` 函数与 `block` 函数配合来实现。
设置 `block` 函数的宽度为 `100%` 以确保一行的长度与正常段落一致，
然后设置 `block` 函数的内边距来设置左右缩进。

=== 水平间距与竖直间距

如果要插入水平间距，可以使用 `h` 函数；插入竖直间距可以使用 `v` 函数。

#code-and-show[```typ
  #lorem(2)#h(2em)#lorem(2)\
  #v(2em)
  #lorem(2)
  ```]

如果要填充剩余空间，可以使用 `h(1fr)` 或这 `v(1fr)`。

== 页面和分栏

=== 设置页面参数

在不同场合中，对于页面的要求也是不一样的。
有时会选择使用 A4 尺寸，有时会选择使用美国信纸尺寸，这些选择往往不是我们自己决定的。

例如，使用 WPS 的默认页面设置，纸张大小为 A4 尺寸，上下边距 1 英寸，左右边距 1.25 英寸。
对应设置如下：

#code-card[```typ
  #set page(paper: "a4", margin: (x: 1.25in, y: 1in))
  ```]

如果上下左右边距一致，例如都是 1.25 英寸，那么可以使用：

#code-card[```typ
  #set page(paper: "a4", margin: 1.25in)
  ```]

考虑书籍打印装订，在装订侧往往会留出更多空白。
设置好参数 `binding` 后，可以使用 `inside` 和 `outside` 设置对应边距：

#code-card[```typ
  #set page(
    paper: "a4", binding: left,
    margin: (inside: 1in, outside: 1.25in))
  ```]

其中 `inside` 对应 `binding`，即装订的那一侧；`outside` 对应与另外一侧。
如果文字排版是从左往右，装订一般是在左侧；如果文字排版是从右往左，装订一般是在右侧。
并且，在边距设置中，`left` 和 `right` 与 `inside` 和 `outside` 是互斥的。
也就是说，如果使用了 `left` 或者 `right`，就不能使用 `inside` 和 `outside` 设置边距；反之亦然。

页面还有许多参数可以设置，例如参数 `footer-descent` 可以设置页脚相对底边距的高度差，
参数 `background` 可以设置页面背景，
参数 `numbering` 可以设置页面的编号。
如有需要，可以查看文档 #link("https://typst.app/docs/reference/layout/page")[page 函数]。

=== 分栏

Typst 支持文档的多栏排版。可以使用 `page` 函数的参数 `columns` 设置，
或者可以使用 `columns` 函数插入多栏内容。
只有上一栏被内容占满，剩余内容才会排版到下一栏。
如果需要强制切换到下一栏，可以使用 `colbreak` 函数。

#code-and-show(columns: (3fr, 5fr))[```typ
  #columns(3)[
    #lorem(2)
    #colbreak()
    #lorem(12)
  ]
  ```]

如果要让内容跨多栏显示，可以使用浮动体，并且设置参数 `scope` 为 `parent`：

#code-block[
  ```typ
  #block(height: 8em)[
    #columns(3)[
      #lorem(36)
      #figure(
        kind: "test", numbering: none,
        supplement: none, caption: none,
      )[
        测试跨行内容。
      ]
    ]
  ]
  #block(height: 8em)[
    #columns(3)[
      #lorem(40) // 测试溢出
      #figure(
        placement: bottom, scope: "parent",
        kind: "test", numbering: none,
        supplement: none, caption: none,
      )[
        测试跨行内容。#lorem(4) // 测试内容重叠
      ]
    ]
  ]
  ```
]

#show-block(width: auto)[
  #block(height: 8em)[
    #columns(3)[
      #lorem(36)
      #figure(
        kind: "test",
        numbering: none,
        supplement: none,
        caption: none,
      )[
        测试跨行内容。
      ]
    ]
  ]
  #block(height: 8em)[
    #columns(3)[
      #lorem(40)
      #figure(
        placement: bottom,
        scope: "parent",
        kind: "test",
        numbering: none,
        supplement: none,
        caption: none,
      )[
        测试跨行内容。#lorem(4)
      ]
    ]
  ]
]

使用 `block` 函数配合 `columns` 函数，如果总的空间不够，多出的内容会在最后一栏溢出，可能会导致内容的重叠显示。

== 页眉页脚

=== 常见的页眉页脚样式

通过设置 `page` 函数的参数 `header` 和 `footer`，可以自定义页面的页眉和页脚。

/ empty: 页眉页脚为空。

  #code-card[```typ #set page(header: none, footer: none)```]

/ plain: 页眉为空，页脚居中显示页码。

  #code-card[```typ
    #set page(header: none, footer: context {
      align(center, counter(page).display("1 / 1", both: true))
    })
    ```]

  其中，参数 `both` 用于获取最终页码，所以 `"1 / 1"` 会分别显示当前页码与最后页码，
  当前页面会显示为 #context counter(page).display("1 / 1", both: true)。

/ headings: 页眉为章节标题和页码，页脚在章节首页显示页码。

#figure(kind: raw, caption: [在 Typst 中自定义标题格式页眉源代码示例。])[
  #code-block[
    ```typ
    #set page(footer: context {
        // 获取当前页码
        let current-page = here().page()
        // 检查当前页面是否有一级标题
        if (
          current-page
            == query(heading.where(level: 1))
              .filter(it => it.location().page()
                <= current-page)
              .last()
              .location().page()
        ) {
          // 如果是章节首页，则显示页码作为页脚
          align(center + top)[
            #text(weight: "semibold")[
              #counter(page).display()
            ]
          ]
        } else { none }
      },
      // 设置页眉格式
      header: align(center + bottom, context {
        let current-page = here().page()
        let title = query(heading.where(level: 1))
          .filter(it => it.location().page()
            <= current-page).last()
        if title.location().page() == current-page { none } else {
          if calc.even(current-page) {
            let section-index = counter(heading.where(level: 1))
              .get().at(0)
            // 对于偶数页，显示格式为 <页码 间隔 章节标题>
            text(weight: "bold",
              counter(page).display() + h(1fr)
                + numbering("第一章", section-index) + h(1em)
                + title.body,
            )
          } else {
            // 对于奇数页，格式为 <二级标题 间隔 页码>
            let level2-titles = query(heading.where(level: 2))
              .filter(it => (
                it.location().page() <= current-page
                  and it.location().page() >= title.location().page()
              ))
            let current-page-title = level2-titles.filter(it => (
              it.location().page() == current-page
            ))
            let (first, second, ..) = counter(heading).get()
            let level2-title = if current-page-title == () {
              level2-titles.last()
            } else {
              second += 1
              current-page-title.first()
            }
            text(weight: "bold",
              sym.section + numbering("1.1", first, second) + h(1em)
                + level2-title.body + h(1fr)
                + counter(page).display(),
            )
          }
          v(-0.48em)
          line(length: 100%, stroke: 0.64pt + black)
        }
      }),
    )
    ```
  ]
]

其中用到了 `query` 函数，可以用于查询满足条件的所有元素。

将上述 `headings` 的页眉样式稍作调整，即可改成任意所需格式。
如果要修改页码的格式，可以设置 `page` 函数的参数 `numbering`。

=== 单面文档与双面文档

通常情况下，如果是单面文档，页眉的格式一般为：

#align(center, block(width: 48%, table(
  columns: (3fr, 4fr, 2fr),
  rows: (1.6em, 3.2em),
  stroke: none,
  align: (left + horizon, center + horizon, right + horizon),
  table.hline(stroke: 0.08em + black),
  [章（节）标题], [], [页码],
  table.hline(stroke: 0.04em + black),
  table.cell(colspan: 3, align: center + horizon)[单面版心],
  table.vline(x: 0, stroke: 0.08em + black),
  table.vline(x: 3, stroke: 0.08em + black),
  table.hline(stroke: 0.08em + black),
)))

如果是双面文档，页眉格式一般为：

#align(center, block(width: 100%, grid(
  columns: (1fr, 1fr),
  column-gutter: 2em,
  table(
    columns: (2fr, 4fr, 3fr),
    rows: (1.6em, 4.8em),
    stroke: none,
    align: (left + horizon, center + horizon, right + horizon),
    table.hline(stroke: 0.08em + black),
    [页码], [], [章标题],
    table.hline(stroke: 0.04em + black),
    table.cell(colspan: 3, align: center + horizon)[
      双面偶数页

      （左页）版心
    ],
    table.vline(x: 0, stroke: 0.08em + black),
    table.vline(x: 3, stroke: 0.08em + black),
    table.hline(stroke: 0.08em + black),
  ),
  table(
    columns: (3fr, 4fr, 2fr),
    rows: (1.6em, 4.8em),
    stroke: none,
    align: (left + horizon, center + horizon, right + horizon),
    table.hline(stroke: 0.08em + black),
    [节标题], [], [页码],
    table.hline(stroke: 0.04em + black),
    table.cell(colspan: 3, align: center + horizon)[
      双面奇数页

      （右页）版心
    ],
    table.vline(x: 0, stroke: 0.08em + black),
    table.vline(x: 3, stroke: 0.08em + black),
    table.hline(stroke: 0.08em + black),
  ),
)))

要判断当前页面是左页还是右页，可以使用 `here` 函数获取当前的位置信息，
然后使用 `calc.even` 或者 `calc.odd` 函数判断当前页码是奇数还是偶数。

#code-and-show(columns: (9fr, 5fr))[```typ
  #context {
    let current-page = here().page()
    if calc.even(current-page) [
      #current-page | 是偶数页
    ] else [ #current-page | 是奇数页 ]
  }
  ```]

要注意，`here` 获取的是实际位置信息，
也就是说 `here().page()` 得到的是当前页面是当前文档的第几页，
与计数器得到的页码可能是不一样的。
