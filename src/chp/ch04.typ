#import "../utils.typ": abstract, code-and-show, code-block, code-card, show-block

= 排版数学公式

#abstract[
  Typst 作为一个面向科学写作的排版系统，排版数学公式自然是不在话下。
  本章旨在介绍公式排版的基础知识，足以应对多数日常需求。
]

== 公式排版基础

=== 行内和行间公式

在 @ch-3-typst的模式 介绍 Typst 的模式时提到了公式排版可分为行内公式和行间公式。

公式默认是没有编号的。如果要为行间公式编号，可以使用 `math.equation`：

#code-and-show(columns: (5fr, 3fr))[```typ
  #let neq = math.equation.with(
    block: true, numbering: it => {
      numbering("(1.1)",
        counter(heading
            .where(level: 1))
          .get().at(0), it)})
  勾股定理：
  #neq($a^2 + b^2 = c^2$)<test-neq>
  @test-neq 又名“商高定理”。
  ```]

公式编号默认使用 `end+horizon` 对齐方式。
如果想要修改，例如多行公式编号要与最后一行公式对齐，
可以设置参数 `number-align`。例如：

#code-and-show(columns: (5fr, 3fr))[```typ
  计算可以得到：
  #math.equation(
    block: true,
    numbering: "(A)",
    number-align: end + bottom,
    $ E & = sqrt(m_0^2 + p^2) \
        & approx 125 "GeV" $)
  ```]

行内公式和行间公式在排版一些大的公式元素时也会有不同的表现。例如：

#code-card[
  ```typ
  行内公式：$lim_(n -> oo) sum_(k=1)^n 1 / k^2 = pi^2 / 6$ \
  行间公式：$ lim_(n -> oo) sum_(k=1)^n 1 / k^2 = pi^2 / 6 $
  ```
]

#show-block(width: auto)[
  行内公式：$lim_(n -> oo) sum_(k=1)^n 1 / k^2 = pi^2 / 6$ \
  行间公式：$ lim_(n -> oo) sum_(k=1)^n 1 / k^2 = pi^2 / 6 $
]


=== 数学模式

数学模式与标记模式相比，有以下特点：

/ 忽略空格: 数学模式中的间距由符号本身决定。
  如果要增加符号间距，可以使用 `h` 函数；还可以使用 `quad` 固定增加 `1em` 间距。

/ 字母是变量: 所有单个字符都会当作变量处理，连续的字符会尝试解析为符号。
  如果要使用单词，可以使用字符串；还可以使用 `text` 等文本函数。例如：

  #code-and-show(columns: (5fr, 3fr))[```typ
    $x^2 >= 0 quad
      "for" #strong[all] x in RR$
    ```]

/ 字体隔离: 数学模式使用的字体与标记模式是不统一的。
  即便标记模式中设置了要使用特定字体，数学模式仍会使用默认字体。
  可以使用如下方式设置数学模式字体：

  #code-card[```typ #show math.equation: set text(font: "Fira Math")```]

== 数学符号

在数学模式中可以很方便地使用各种数学符号，这些符号是数学公式排版的基础。

=== 一般符号

希腊字母符号可以通过对应英文名称使用，首字母大写对应大写希腊字母。
其他常用符号还有一些简写方式，例如无穷大符号 $oo$（```typm oo```）。

#code-and-show(code-func: code-card, columns: (5fr, 2fr))[```typ
  $ tau Upsilon pi Iota sigma Psi  \
    infinity != oo approx nu $
  ```]

省略号有非常多的变体，例如：
#code-and-show(code-func: code-card, columns: (5fr, 2fr))[```typ
  $
    a_1, a_2, dots, a_n \
    a_1 + a_2 + dots.c + a_n \
    dots.v quad dots.down space dots.up
  $
  ```]

其中，```typm dots.h``` 与 ```typm dots``` 是等价的。

=== 指数、上下标和导数

在 Typst 中，沿用 LaTeX 的习惯，使用 `^` 和 `_` 表示上标和下标。
如果上下标的内容超过了一个符号，那么需要使用*括号包裹*，例如：

#code-and-show(code-func: code-card, columns: (5fr, 3fr))[```typ
  $ p^3_(i, j) + m^kappa approx
    upright(e)^x^2 +
      (upright(e)^(x + y))^2_(x_z) $
  ```]

导数符号可以使用 `'` 表示，其他上标一般要在导数符号后使用：

#code-and-show(code-func: code-card, columns: (5fr, 3fr))[```typ
  $
    f(x) = x^2 quad f'(x) = 2 x \
      f''^2(x) = 4 != f^2''(x)
  $
  ```]

=== 分式和根式

分式可以直接使用 `/` 表示，例如 ```typm 4/3``` 表示为 $4/3$。
如果想要保持横式，需要转义分式符号，即 ```typm 4\/3``` 表示为 $4\/3$。

如果想要在行内保持行间公式显示，可以使用 ```typm display``` 函数：

#code-and-show(columns: (5fr, 4fr))[```typ
  行间分式：$ 3\/8 quad
    3/8 quad inline(3/8) $
  行内分式：$1 1/2$ 小时 #h(1em)
  $display(1 1/2)$ 小时
  ```]

一般根式使用 ```typm sqrt``` 函数，表示 x 的 n 次根式时写成 ```typm root(n, x)```：

#code-and-show(code-func: code-card, columns: (7fr, 4fr))[```typ
  $sqrt(x) <=> x^(1\/2) quad
    sqrt(x^2 + root(3, y))$
  ```]

特殊的分式形式，如二项式结构，可以使用 ```typm binom``` 函数：

#code-and-show(columns: (7fr, 4fr))[```typ
  帕斯卡定律：$
  binom(n, k) = binom(n - 1, k)
    + binom(n - 1, k - 1)
  $
  ```]

=== 关系符号

Typst 常见的关系符号大部分可以直接输入，例如 $>$、$<$ 以及 $=$，
其他符号需要使用符号名称输入，例如正比 $prop$（```typm prop```）。
使用 `attach` 将两个符号组合：
#code-and-show(columns: (7fr, 4fr))[```typ
  $
    f_n (x) attach(prop, t: star) 1 \
    attach("Al", tl: 26, bl: 13,
      tr: 3+, t: arrow.r.l,
      br: #[离子], b: maltese)
  $
  ```]

=== 算符

常见的算符大多书是二元算符，例如：加（```typm +```）、减（```typm +```）、
乘（```typm times```）和除（```typm div```）。
此外还有一些一元算符，例如 $nabla$（```typm nabla```）和 $partial$（```typm partial```）。

其实，一些常见的函数也是算符，例如 $lim$（```typm lim```）和 $cos$（```typm cos```）。
所有预先定义的文本算符可以参考
#link("https://typst.app/docs/reference/math/op/#predefined")[预定义算符]。
其中，有些算符可以像 $integral$ 一样在符号顶部和底部附带内容，这些算符被称为巨算符（big operator）。

如果需要自定义文本算符，可以使用 ```tyom op``` 函数：

#code-block[
  ```typ
  $
    lim_(x -> 0) sin(x) / x = 1 quad x equiv a space (mod b) \
    op(#[user]) x = op(#[Product], limits: #true)_("error" -> 0) x
  $
  ```
]

#show-block(width: auto)[
  $
    lim_(x -> 0) sin(x) / x = 1 quad x equiv a space (mod b) \
    op(#[user]) x = op(#[Product], limits: #true)_("error" -> 0) x
  $
]

设置参数 `limits` 为 `true` 时，可以让自定义文本算符变成一个巨算符。
在行内使用巨算符时，巨算符的上下标会移动至右上和右下，例如
$op(#[Product], limits: #true)_("error" -> 0) x$。

=== 数学重音和上下括号

数学符号也可以加重音，通常用于表示求导或者向量。
要注意，重音应该加在对应符号上，不包括上下标，例如：

#code-and-show(columns: (3fr, 1fr))[```typ
  $
    dot(x) equiv x' quad
    dot.double(x) equiv x'' \
    arrow(x)_0 space checkmark
    quad arrow(x_0) space crossmark \
    hat(e)_x space checkmark
    quad hat(e_x) space crossmark
  $
  ```]

Typst 还能为多个字符加重音，重音符号会自动扩展：

#code-and-show(code-func: code-card, columns: (5fr, 2fr))[```typ
  $
    0.overline(3)
      = underline(underline(1 \/ 3)) \
    hat(X) => hat(X Y) quad
      arrow(A) => arrow(A B)
  $
  ```]

还有很多上下括号函数可以用来标注：

#code-and-show(code-func: code-card, columns: (5fr, 2fr))[```typ
  $
    underbrace(1 + 2 + ... + 5, "numbers") \
    overbrace(1 + 2 + ... + 5, "numbers") \
    underbracket(1 + 2 + ... + 5, "numbers") \
    overbracket(1 + 2 + ... + 5, "numbers") \
    underparen(1 + 2 + ... + 5, "numbers") \
    overparen(1 + 2 + ... + 5, "numbers") \
    undershell(1 + 2 + ... + 5, "numbers") \
    overshell(1 + 2 + ... + 5, "numbers")
  $
  ```]

=== 箭头

常用箭头有右箭头（```typm ->``` 或 ```typm arrow```）、左箭头（```typm <-``` 或 ```typm arrow.l```）等。
使用 ```typm stretch``` 函数可以让箭头等符号自动拉伸，并且可以加上下标，默认拉伸为 `100%+0pt`。

#code-and-show(code-func: code-card, columns: (5fr, 2fr))[```typ
  $
    a stretch(<-, size: #150%)^(x + y + z) b \
    c stretch(->)_(x < y)^(a times b times c) d \
    f : X stretch(->>, size: #150%)_"surjective" Y
  $
  ```]

使用 ```typm stretch``` 函数时，不是所有的符号都能拉伸，例如：

#code-and-show(code-func: code-card, columns: (5fr, 2fr))[```typ
  $
    a stretch(arrow.l.long)^(x + y + z) b \
  $
  ```]

=== 括号和界定符

TODO
