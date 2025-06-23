#import "../utils.typ": abstract, code-and-show, code-block, code-card, kbd, show-block

= 用 Typst 排版文字

#abstract[
  文字是排版的基础。本章主要介绍如何在 Typst 中输入各种文字符号，
  包括标点符号、连字符、重音等，以及控制文字断行和断页的方式。
]

== 语言文字

Typst 源代码为文本文件，而文本文件的一个至关重要的性质是它的编码。

=== UTF-8 编码

在计算机世界中，所有信息都是以二进制形式存储。
为了使这些数据能被人类理解，我们需依循特定规则将其转换为可读内容，
此过程被称为*编码*，反之则为*解码*。

需要注意的是，同一串二进制数据若采用不同的编码方式进行解码，其所呈现的内容可能截然不同。
因此，处理文本文件时，明确其编码方式至关重要。

早期曾出现多种字符编码方案，但它们彼此独立且不兼容，常导致*乱码*问题。
为解决此困境，Unicode 标准应运而生，旨在为全球所有字符提供一个统一的编号。

UTF-8 作为 Unicode 最为广泛采用的实现方式，
具有广泛的兼容性与灵活性，尤其在处理多语言文本方面表现卓越。
鉴于此，Typst 将源代码文件默认编码设定为 UTF-8，
以确保用户能够处理包含各种语言字符的文档，避免潜在的乱码问题。

=== 文档语言

在 Typst 中，即使采用 UTF-8 编码，在处理文本时仍需明确其主要语言。
这是因为不同语言在排版时，需要考虑断词规则、文字方向、标点禁则等诸多细节，
这些细节对于生成高质量的文档至关重要。

Typst 允许通过 `text` 函数的 `lang` 参数为特定文本片段指定语言。
Typst 采用符合 #link("https://en.wikipedia.org/wiki/ISO_639")[
  ISO 639-1/2/3 标准
]的二或三字符语言代码来标识不同的语言。
若需统一设置整个文档的语言，可以使用 `set` 来设置规则。

例如，将文档语言设定为西班牙语，可使用：

#code-and-show[```typ
  #set text(lang: "es")
  "La familia lo es todo."
  ```]

其中，`"es"` 代表西班牙语，中文一般使用 `"zh"`。

== 排版中文

Typst 在处理中文排版时，一方面是对中文字体的支持，
另一方面是对中文排版中的一些细节的处理，
包括在汉字之间控制断行、标点符号的禁则（如句号、逗号不允许出现在行首）、中英文之间插入间距等。

中文排版的细节处理，可通过明确文档语言来解决。
一旦指定了文档语言，Typst 便能自动应用相应的中文排版规则。

对于字体，Typst 默认会智能地选择并使用可用的中文字体。
也可以通过 `text` 函数的 `font` 参数指定。
`font` 的值可以是字体名称，还可以接受列表。
Typst 将按列表顺序尝试使用，可用于处理字体回退或显示特殊字符。

列表元素可以是字体名称，也可以是一个字典。
其中字典元素有 `name` 和 `covers` 键，
表示对应的字体名称和覆盖的范围。
`covers` 的值应该是 `"latin-in-cjk"`#footnote[
  匹配 CJK 内容中的拉丁内容，包括数字。
] 或者正则表达式，
正则表达式中可以使用 `\p` 匹配 Unicode 属性@unicode-techreport-23。

例如要让所有 Emoji 都使用 Noto Color Emoji 字体，
CJK 内容中的西文使用 New Computer Modern Sans 字体，
默认字体使用 Source Han Serif SC：

#code-block(linenumber: true, top-bottom-stroke: true, stroke-thickness: 0.04em)[
  ```typ
  #set text(
    lang: "zh",
    size: 12pt,
    font: (
      (name: "New Computer Modern Sans", covers: "latin-in-cjk"),
      (name: "Noto Color Emoji", covers: regex("\p{Emoji}")),
      "Source Han Serif SC",
    ),
  )
  Typst ♥️ 中文 2025。

  汉字和English单词混排，通常不需要在中英文之间添加额外的空格。
  当然，为了代码的可读性，加上汉字和 English 之间的空格也无妨。
  换行会引入一个西文空格，可能会影响排版。
  ```
]

#show-block[
  // 恢复默认排版
  #set align(left)
  #set par(first-line-indent: 0em, justify: false)
  #set text(lang: "zh", size: 12pt, font: (
    (name: "New Computer Modern Sans", covers: "latin-in-cjk"),
    (name: "Noto Color Emoji", covers: regex("\p{Emoji}")),
    "Source Han Serif SC",
  ))
  Typst ♥️ 中文 2025。

  汉字和English单词混排，通常不需要在中英文之间添加额外的空格。
  当然，为了代码的可读性，加上汉字和 English 之间的空格也无妨。
  换行会引入一个西文空格，可能会影响排版。
]



为了更加符合中文排版习惯，还可以设置 `par` 函数的参数来修改段落的排版，
例如调整首行缩进 `first-line-indent` 以及两端对齐 `justify`：

#code-card[
  ```typ
  #set par(
    first-line-indent: (amount: 2em, all: true),
    justify: true, // 使用两端对齐
    leading: 0.8em, // 段落内行间距，默认是 0.65em
  )
  ```
]

== Typst 中的字符

=== 空格和分段

Typst 源代码中，空格键和 #kbd[Tab] 键输入的空白字符视为“空格”。
连续的若干个空白字符视为一个空格。一行开头的空格忽略不计。

行末的换行符视为一个空格；但连续两个换行符，也就是空行，会将文字分段。
多个空行被视为一个空行。也可以在行末使用 ```typc parbreak``` 函数分段。


#code-block(linenumber: true, top-bottom-stroke: true, stroke-thickness: 0.04em)[
  ```typ
  Several spaces     equal one.
    Front spaces are ignored.

  An empty line starts a new paragraph.#parbreak()
  A `parbreak` command does the same.
  ```
]

#show-block[
  // 恢复默认排版
  #set align(left)
  #set par(first-line-indent: 0em, justify: false)

  Several spaces equal one.
  Front spaces are ignored.

  An empty line starts a new paragraph.#parbreak()
  A `parbreak` command does the same.
]

=== 特殊字符

有些字符在 Typst 里有特殊用途，例如 `#` 和 `$` 分别表示命令模式和数学模式。
输入这些字符得不到对应的符号，还往往会出错。

如果想要输入特殊字符，需要使用反斜线转义，例如：

#code-and-show[```typ \# \$ \_ \* \_ \\ \~```]

=== 连字

西文排版中经常会出现连字（ligatures），常见的有 ff/fi/fl/ffi/ffl。

#code-and-show(code-func: code-card, columns: (3fr, 2fr))[```typ
  #set text(
    lang: "en",
    font: "New Computer Modern",
  ) // 确保使用正确的西文字体
  It's difficult to find ... \
  #text(ligatures: false)[
    It's difficult to find ...
  ]
  ```]

=== 标点符号

中文的标点符号#footnote[
  绝大多数为非 ASCII 字符。
]使用中文输入法输入即可，一般不需要过多留意。
输入西文标点符号时，则有不少地方需要留意。

==== 引号

在 Typst 中，西文的双引号和单引号可直接通过 `'` 和 `"` 输入。
但是，西文引号和中文引号实际上是同一组符号，所以在非西文环境下，
引号可能会由不正确的字体渲染而导致宽度偏差，例如：

#code-block(linenumber: true, top-bottom-stroke: true, stroke-thickness: 0.04em)[
  ```typ
  // 默认是中文
  "It's MyGO!" \
  // 英文渲染
  #text(lang: "en", font: "New Computer Modern")[
    "It's MyGO!"
  ]
  ```
]

#show-block[
  // 默认是中文
  "It's MyGO!" \
  // 英文渲染
  #text(lang: "en", font: "New Computer Modern")[
    "It's MyGO!"
  ]
]

可以看到，引号的渲染结果差异显著。

==== 连字号和破折号

Typst 中有三种长度的“横线”可用：连字号（hyphen）、短破折号（en-dash）和长破折号（em-dash）。
它们分别有不同的用途：连字号 - 用来组成复合词；短破折号 -- 用来连接数字表示范围；
长破折号 --- 用来连接单词，语义上类似中文的破折号#footnote[
  中文的破折号一般使用 `------` 表示。
]。

#code-and-show(code-func: code-card, columns: (3fr, 2fr))[```typ
  #set text(
    lang: "en",
    font: "New Computer Modern",
  ) // 确保使用正确的西文字体
  daughter-in-law, X-rated \
  pages 13--67 \
  yes---or no?
  ```]

==== 省略号

Typst 可以直接输入三个点表示省略号，等价于 ```typ #sym.dots```。

#code-block(linenumber: true, top-bottom-stroke: true, stroke-thickness: 0.04em)[
  ```typ
  // 确保使用正确的西文字体
  #set text(lang: "en", font: "New Computer Modern")
  one, two, three, ... one hundred. \
  one, two, three, #sym.dots one hundred.
  ```
]

#show-block[
  #set text(lang: "en", font: "New Computer Modern")
  one, two, three, ... one hundred. \
  one, two, three, #sym.dots one hundred.
]

=== 拉丁文扩展与重音

Typst *不支持*用符号输入西欧语言中各种拉丁文扩展字符，
详情请查看#link("https://github.com/typst/typst/issues/833")[issue]。

要输入这些字符，只能直接输入这些符号，
部分组合字符可以通过字符与修饰字符拼接的方式得到，例如：

#code-and-show(columns: (5fr, 3fr))[```typ
    è 等于 #{ [e] + "\u{300}" }， \
    á 等于 #{ [a] + "\u{301}" }， \
    ï 等于 #{ [i] + "\u{308}" }，\
    Ô 等于 #{ [O] + "\u{302}" }，\
    ø 这种 stroke 无法得到。
  ```]

=== 其他符号

Typst 预定义了其它一些文本模式的符号 ，部分符号可参考表 TODO(table 4.4)。

#code-and-show(columns: (5fr, 2fr))[```typ
  #sym.pilcrow    #sym.section
  #sym.dagger     #sym.dagger.double
  #sym.copyright  #sym.pound

  #sym.ast.op #sym.dot.c    #sym.bullet

  #sym.trademark.registered #sym.trademark
  ```]

Typst 支持的所有符号可以参考文档 sym@typst-symbols。

== 断行和断页

在绝大多数时候，我们无需自己操心断行和断页，但有时也会需要手工调整。

=== 单词间距

在西文排版实践中，断行的位置优先选取在两个单词之间，也就是在源代码中输入的“空格”。
“空格”本身通常生成一个间距，它会根据行宽和上下文自动调整。

文字在单词间的“空格”处断行时，“空格”生成的间距随之舍去。
我们可以使用字符 `~` 输入一个不会断行的空格，
通常用在英文人名、图表名称等上下文环境：

#code-and-show(code-func: code-card)[```typ
  Fig.~2a \
  Donald~E.~Knuth
  ```]

=== 手动断行和断页

如果我们确实需要手动断行，可使用 ```typ #linebreak()``` 或 ```typ \```。
其中 `linebreak` 函数可以通过参数 `justify` 来设置断行处是否使用两端对齐。

#code-and-show(code-func: code-card, columns: (1fr, 1fr))[```typ
  使用 `\` 断行的效果 \
  与使用 `justify: true` \
  断行的效果
  #linebreak(justify: true)
  进行对比
  ```]

手动断页可以使用 `pagebreak` 函数。

`pagebreak` 函数支持以下参数，以提供更精细的断页控制：

/ weak: 接受一个布尔值。

  设置为 `true` 时，如果当前页面为空白页，则不会发生断页。

/ to: 可选值为 ```typc none```、`"even"` 或 `"odd"`。

  - 设置为 `"even"`，可确保后续内容从*实际的*偶数页开始，必要时会插入空白页。
  - 设置为 `"odd"`，可确保后续内容从实际的奇数页开始。

在书籍排版中，通常要求每个章节从奇数页开始，此时可以使用如下函数分隔章节：

#code-block(linenumber: true, top-bottom-stroke: true, stroke-thickness: 0.04em)[
  ```typ
  #let insert-page(to: "odd") = {
    // 强制断页
    pagebreak(weak: false)
    // 确保页面完全空白
    set page(header: [], footer: [])
    // 让后续内容在 `to` 页面上
    // 默认是 奇数页面
    pagebreak(to: to, weak: true)
  }
  ```
]
