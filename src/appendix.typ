#import "utils.typ": abstract, code-block, show-block

= 安装 Typst 与排除错误<appendix-a>

#abstract[
  Typst 安装是非常简单的！
  本章将简单介绍几种常用的 Typst 安装方法，以及一些常见问题的解决方案。
]

== 安装 Typst

=== GitHub Release

=== 包管理器

=== 手动编译安装

== 常见问题及解决方法

=== 分隔符下标下沉过多

这是因为下标选择了整个表达式，而不是分隔符作为“依附”对象，
所以基线要比预期的要更低，但是可以使用简单的函数解决：

#code-block[
  ```typ
  #let lspt(body) = {
    let subs = eval("script(" + body + ")", mode: "math")
    context place(bottom, float: true,
      scope: "parent", clearance: 0em,
      dy: -measure(subs).height / 2,
      subs,
    )
  }

  $
    #[默认：]lr((partial f) / (partial t) |)^(y = 12)_(t = 0) quad
    #[现在：]lr((partial f) / (partial t) |)^(y = 12)_#lspt("t = 0")
  $
  ```
]

#show-block(width: auto)[
  #let lspt(body) = {
    let subs = eval("script(" + body + ")", mode: "math")
    context place(
      bottom,
      float: true,
      scope: "parent",
      clearance: 0em,
      dy: -measure(subs).height / 2,
      subs,
    )
  }

  $
    #[默认：]lr((partial f) / (partial t) |)^(y = 12)_(t = 0) quad
    #[现在：]lr((partial f) / (partial t) |)^(y = 12)_#lspt("t = 0")
  $
]
