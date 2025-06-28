#import "../utils.typ": abstract, code-and-show, code-block, show-block

= 排版数学公式

#abstract[
  Typst 作为一个面向科学写作的排版系统，排版数学公式自然是不在话下。
  本章旨在介绍公式排版的基础知识，足以应对多数日常需求。
]

== 公式排版基础

=== 行内和行间公式

在 @ch-3-typst的模式 介绍 Typst 的模式时提到了公式排版可分为行内公式和行间公式。

如果要为行间公式编号，可以使用 `math.equation` 来排版公式：

#code-and-show(columns: (5fr, 3fr))[```typ
  #let neq = math.equation.with(
    block: true, numbering: it => {
      numbering("(1.1)",
      counter(heading
          .where(level: 1))
        .get().at(0), it)
  })
  勾股定理：#neq($a^2 + b^2 = c^2$)
  ```]

