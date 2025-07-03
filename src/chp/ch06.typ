#import "../utils.typ": abstract, code-and-show, code-block, code-card, show-block

= 其他内容排版

#abstract[
  本章介绍其他常见内容如何使用 Typst 排版。
  包括使用 BibTeX 或 YAML 文件自动生成参考文献；
  以及在 Typst 可以轻松地使用各种颜色和超链接，生成美观且易用的文档。
]

== 参考文献

=== BibTeX 数据库

BibTeX 是最为流行的参考文献数据组织格式之一。
它的出现让我们摆脱手写参考文献条目的麻烦。
我们还可以通过参考文献样式的支持，让同一份 BibTeX 数据库生成不同样式的参考文献列表。
下面是一个 BibTeX 文献条目示例：

#code-block[
  ```bib
  @techreport{unicode-techreport-23,
    author    = {Whistler, Ken and Freytag, Asmus},
    title     = {The Unicode Character Property Model},
    institution = {Unicode Consortium},
    number    = {23},
    series    = {Unicode Technical Report},
    type      = {Technical Report},
    edition   = {15},
    date      = {2022-11},
    url       = {https://www.unicode.org/reports/tr23/},
  }
  ```
]

其中 `@techreport` 说明是一个技术报告类文献条目，而 `unicode-techreport-23` 就是这个条目的引用名称。
在 BibTeX 中，`and` 是专门用于连接多个名称的，如果想要表示文本 `and`，可以使用 `{and}` 防止解析错误。

多数时候，我们无需自己手写 BibTeX 文献条目。
从谷歌学术或其他期刊/数据库的网站上都能够导出 BibTeX 文献条目，
经典的文献管理软件 EndNote 也支持生成 BibTeX 格式的数据库。
还有许多开源软件支持 BibTeX 文献条目的导入、导出和管理。

=== 参考文献样式

参考文献的渲染格式在不同的文献里千差万别，要显示条目的哪些信息，以及这些信息分别该如何渲染，
包括每一项的的顺序和字体样式、条目在列表中的排序等。

Typst 用样式来决定参考文献的渲染格式。
Typst 提供了一些预定义的常见样式，包括 `"ieee"`、`"gb-7714-2015-numeric"`、`"nature"` 等。
还可以使用自定义样式，样式文件以 `.csl` 为扩展名。
引用样式也可以按照类似的方法设置。例如：

#code-card[
  ```typ
  #set cite(style: "custom.csl", form: "normal")
  #set bibliography(style: "gb-7714-2015-numeric")
  ```
]

完整的内置参考文献样式可以参考
#link("https://typst.app/docs/reference/model/bibliography/#parameters-style")[bibliography 函数的参数 style]。

=== 基本的参考文献和引用

参考文献可以像正常的引用一样使用，并根据引用样式和参考文献样式渲染。
下面是一个正常使用参考文献的示例：

#code-block[
  ```typ
  #set cite(style: "gb-7714-2015-numeric", form: "normal")
  #set bibliography(style: "gb-7714-2015-numeric")

  #lorem(32)@cite01

  #bibliography("refs.bib")
  ```
]

其中 `cite01` 是条目的引用名称，
`bibliography` 函数与 `outline` 函数一样，默认会生成一个一级目录以及参考文献组成的列表。

=== Hayagriva

BibTeX 还是使用了许多 LaTeX 的语法，对于一般用户不太方便使用。
Typst 的内部，参考文件的渲染实际上是依靠 Hayagriva @hayagriva 的解析。
而 Hayagriva 支持使用 YAML 格式来书写引用条目，便于用户阅读和修改。
例如上述 BibTeX 的参考条目的等价 YAML 写法为：

#code-block[
  ```yaml
  unicode-techreport-23:
    type: report
    title: The Unicode Character Property Model
    genre: Technical Report
    author:
      - "Whistler, Ken"
      - "Freytag, Asmus"
    organization: Unicode Consortium
    edition: 15
    serial-number: 23
    date: 2022-11
    url: "https://www.unicode.org/reports/tr23/"
    parent:
      type: report
      title: Unicode Technical Report
  ```
]

不过，Hayagriva 的实现与 BibTeX 以及 BibLaTeX 有一些不同，部分条目的渲染还有一些问题#footnote[
  例如 #link("https://github.com/typst/hayagriva/issues/312")[hayagriva/issues/312]
  以及 #link("https://github.com/typst/hayagriva/issues/246")[hayagriva/issues/246]。
]。
Hayagriva 支持的选项以及标准格式可以参考
#link("https://github.com/typst/hayagriva/blob/main/docs/file-format.md")[Hayagriva 文件格式]。

在编写 YAML 格式的参考文献数据库时，还可以在文件的顶端加上这么*一行*注释，
可以让语言服务器帮忙检查文件格式是否有问题：

#code-card[
  ```yaml
  # yaml-language-server: $schema=https://raw.githubusercontent.com/mkdjr/hayagriva/refs/heads/main/hayagriva.schema.json
  ```
]

== 使用颜色

在前面的内容中，我们已经使用了许多颜色，包括直接使用颜色名称，例如 `black`；
使用 `rgb` 函数指定颜色；
以及使用 `gradient` 来构造颜色梯度。

=== 颜色的表达方式

总的来说，Typst 支持多种颜色的表达方式，包括：

#align(center)[
  #block(width: 96%)[
    #table(
      stroke: none,
      columns: (5fr, 6fr, 5fr, 6fr),
      align: left + horizon,
      table.hline(stroke: 0.08em + black),
      table.header([*颜色种类*], [*函数*], [*颜色种类*], [*函数*]),
      table.vline(x: 2, stroke: 0.04em + black),
      table.hline(stroke: 0.06em + black),
      [*sRGB*], [`rgb`], [*Oklch*], [`oklch`],
      [*CMYK*], [`cmyk`], [*线性 RGB*], [`color.linear-rgb`],
      [*D65 灰度*], [`luma`], [*HSL*], [`color.hsl`],
      [*Oklab*], [`oklab`], [*HSV*], [`color.hsv`],
      table.hline(stroke: 0.08em + black),
    )
  ]
]
