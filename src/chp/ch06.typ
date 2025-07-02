#import "../utils.typ": abstract, code-block

= 其他内容排版

#abstract[
  本章介绍其他常见内容如何使用 Typst 排版。
  包括使用 BibTeX 或 YAML 文件自动生成参考文献；
  以及在 Typst 可以轻松地使用各种颜色和超链接，生成美观且易用的文档。
]

== 参考文献

=== BibTeX 数据库


=== BibTeX 样式

完整的内置参考文献样式可以参考
#link("https://typst.app/docs/reference/model/bibliography/#parameters-style")[bibliography 函数的参数 style]。

=== 基本的参考文献和引用

=== Hayagriva

Hayagriva 支持的条目以及标准格式可以参考
#link("https://github.com/typst/hayagriva/blob/main/docs/file-format.md")[Hayagriva 文件格式]。

例如：

#code-block[
  ```bib
  @techreport{unicode-techreport-23,
    author    = {Ken Whistler and Asmus Freytag},
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

等价于：

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
