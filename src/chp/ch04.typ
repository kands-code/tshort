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


=== 数学模式<ch-3-数学模式>

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
  行内分式：$3\/8 quad 3/8$

  display 对比：$1 1/2$ 小时
  #h(1em) $display(1 1/2)$ 小时
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
其中，有些算符可以像 $integral$ 一样在符号顶部和底部附带内容，
这些算符被称为巨算符（big/large operator）。

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
    overbrace(1 + 2 + ... + 5, "numbers") \
    underbrace(1 + 2 + ... + 5, "numbers") \
    overbracket(1 + 2 + ... + 5, "numbers") \
    underbracket(1 + 2 + ... + 5, "numbers") \
    overparen(1 + 2 + ... + 5, "numbers") \
    underparen(1 + 2 + ... + 5, "numbers") \
    overshell(1 + 2 + ... + 5, "numbers") \
    undershell(1 + 2 + ... + 5, "numbers")
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

需要注意的是，```typm stretch``` 函数不是所有的符号都能拉伸，例如：

#code-and-show(code-func: code-card, columns: (5fr, 2fr))[```typ
  $
    a stretch(arrow.l.long)^(x + y + z) b \
  $
  ```]

=== 分类

在 Typst 中，符号被分成了许多类别，这些类别决定了这些符号该怎么被渲染。

#grid(columns: 2, inset: 0.8em)[
  / normal: 默认符号类别。
][
  / large: 巨算符，例如 ```typm sum```。
][
  / punctuation: 标点符号，例如逗号。
][
  / relation: 关系算符，例如 ```typm prec```。
][
  / opening: 开始分隔符，例如 ```typm (```。
][
  / unary: 一元算符，例如 ```typm not```。
][
  / closing: 结束分隔符，例如 ```typm )```。
][
  / binary: 二元算符，例如 ```typm div```。
][
  / fence: 中间分隔符，例如 ```typm |```。
][
  / vary: 一元或二元算符，例如 ```typm +```。
]

如果要明确标注某个符号的分类，可以使用 `math.class` 函数，例如：

#code-and-show(columns: (5fr, 3fr))[```typ
  #let loves = math.class(
    "relation",
    sym.suit.heart,
  )

  $x loves y and y loves 5$
  ```]

=== 分隔符

公式块的边界可以由分隔符表示，包括 `"opening"`、`"closing"` 以及 `"fence"`。

通常情况下，成对的分隔符会自动根据内容缩放，
但是我们也可以使用 ```typm lr``` 函数来匹配任意分隔符并精确控制其大小。

#code-and-show(code-func: code-card, columns: (5fr, 2fr))[```typ
  $
    (1 + 1 / (1 - x^2))^3 \
    lr((partial f) / (partial t) |)_(t = 0)
    quad quad lr(]sum_(x=1)^n], size: #50%) x \
  $
  ```]

其中，参数 `size` 的默认值是 `100%+0pt`，可以设置为任意相对长度。

对于 `"fence"`，作为中间分隔符时可能需要使用 `mid` 函数让分隔符大小匹配。

#code-and-show(code-func: code-card, columns: (5fr, 2fr))[```typ
  $
    { x | sum_(i=1)^n w_i|f_i (x)| < 1 } \
    { x mid(|) sum_(i=1)^n w_i|f_i (x)| < 1 }
  $
  ```]


当然，对于常见的括号和分隔符，可以使用对应的函数：

#code-and-show(columns: (5fr, 2fr))[```typ
  $
    abs(-1) = 1 \
    norm(vec(delim: \[, 1, 2)) = sqrt(5) \
    floor(3.7) = 3 \
    ceil(3.2) = 4 \
    round(3.5) = 4 \
  $
  ```]

== 多行公式

通常来讲应当避免写出超过一行而需要折行的长公式。
如果一定要折行的话，习惯上优先在等号之前折行，
其次在加号、减号之前。其它位置应当避免折行。

#code-and-show(code-func: code-card, columns: (5fr, 4fr))[```typ
  $
    a + b + c + d + e + f + g + h + i \
    = j + k + l + m + n \
    = o + p + q + r + s
  $
  ```]

=== 公式对齐

默认多行公式会使用中间对齐的方式显示：

#code-and-show(code-func: code-card, columns: (1fr, 1fr))[```typ
  $
    a + b + c = d + e + f \
    g + h + i = j + k \
    l + m = o + p + q
  $
  ```]

通常情况下，多行公式会对齐等号，那么可以使用 `&`：

#code-and-show(code-func: code-card, columns: (1fr, 1fr))[```typ
  $
    a + b + c & = d + e & + f \
    g + h + i & = j & + k \
    l + m & = o + p + q
  $
  ```]

如果有多个对齐点，公式会自动添加间距来实现对齐。
这里，由于第三行只有一个对齐点，那么第一行和第二行的加号会与第三行的末尾对齐。

=== 公式编号

Typst 目前还*不支持*对行间公式的任意一行公式编号。
如果要编号的公式间不需要对齐，可以将公式分别放置在不同的行间公式中。

#code-and-show(columns: (9fr, 5fr))[```typ
  #lorem(16)
  #set math.equation(numbering: it => {
    numbering("(A)", it)
  })
  $
    E = m upright(c)^2
  $<test-multi-eq-1>
  #math.equation(
    block: true,
    number-align: bottom,
  )[$
      F & = m a               \
        & = (dif p) / (dif t)
    $]<test-multi-eq-2>
  @test-multi-eq-1
  and @test-multi-eq-2
  ```]

如果需要编号的同时还需要对齐，
则可以尝试使用 #link("https://typst.app/universe/package/equate")[equate]。



== 向量和矩阵

Typst 中提供了排版向量和矩阵的函数，即 ```typm vec``` 和 ```typm mat```。

#code-and-show(code-func: code-card)[```typ
  $
    vec(x, y, z) quad
    mat(1, 2; 3, 4)
  $
  ```]

向量和矩阵默认使用圆括号作为分隔符，并且矩阵每一行的元素使用分号 `;` 隔开。
如果想要修改向量和矩阵的括号，可以设置参数 `delim`：

#code-and-show(code-func: code-card, columns: (5fr, 3fr))[```typ
  $
    vec(delim: #"[", x, y, z) quad
    mat(delim: #"|", 1, 2; 3, 4)
  $
  ```]

只需要提供一半的分隔符，Typst 会自动匹配对应的分隔符。

如果向量或者矩阵包含分式，此时需要对分式使用 ```typm display``` 函数让内容以行间公式形式显示。
并且可以使用参数 `gap` 来调整元素之间的距离；
对于矩阵的行列间距，可使用参数 `row-gap` 和 `column-gap` 调整。

#code-and-show(columns: (5fr, 2fr))[```typ
  $
    upright(bold(H)) = mat(
      gap: #0.64em, delim: #"[",
      display((partial^2 f) / (partial x^2)),
      display((partial^2 f) / (partial x y));
      display((partial^2 f) / (partial x y)),
      display((partial^2 f) / (partial y^2));
    )
  $
  ```]

另外，对于分段函数，Typst 也提供了 ```typm cases``` 函数方便展示：

#code-and-show(columns: (5fr, 3fr))[```typ
  $
    abs(x) stretch(=)^#[def] cases(
      -x quad & "if" x < 0,
      0 quad & "if" x = 0,
      x quad & "otherwise")
  $
  ```]

其中，```typm cases``` 函数也支持设置参数 `delim` 来修改分隔符，默认使用花括号。

== 数学符号的字体控制

=== 数学字母字体

Typst 允许一部分数学符号切换字体，主要是拉丁字母、数字、大写希腊字母以及重音符号等。
不同的数学字体往往带有不同的语义，
如矩阵、向量等常会使用粗体或粗斜体，而数集常会使用 ```typm bb``` 表示。

其中，如果想要使用 `scr` 字形，也就是手写体字形，
由于 `scr` 与 ```typm cal``` 字形共享相同的 Unicode 码位，
因此，只有当字体通过字体功能支持时，才能在两种样式之间切换。
可以使用如下方式设置：

#code-card[```typ
  #let scr(it) = text(features: ("ss01",), box($cal(it)$))
  ```]

理论上，这里是不需要使用 `box` 函数的。
但是目前 Typst 对于数学文本样式处理还有许多限制，所以这里的 `box` 函数是必要的。

#code-block[
  ```typst
  #let scr(it) = text(features: ("ss01",), box($cal(it)$))
  $
    cal(B) quad frak(B) quad
    bb(B) quad scr(B) \
    cal(L) = -1/4 F_(mu nu) F^(mu nu) \
    frak(s u)(2) #[and] frak(s o)(3)
    #[Lie algebra]
  $
  ```
]

#show-block(width: auto)[
  #let scr(it) = text(features: ("ss01",), box($cal(it)$))
  $
    cal(B) quad frak(B) quad
    bb(B) quad scr(B) \
    cal(L) = -1/4 F_(mu nu) F^(mu nu) \
    frak(s u)(2) #[and] frak(s o)(3)
    #[Lie algebra]
  $
]

#let scr(it) = text(features: ("ss01",), box($cal(it)$))

这里列出字形和对应函数的对比，大家可自行选取：

#table(
  stroke: none,
  columns: (3fr, 1fr, 3fr, 1fr),
  align: (center + horizon, left + horizon),
  rows: 1.8em,
  table.hline(stroke: 0.08em + black),
  table.vline(x: 2, stroke: 0.06em + black),
  table.header([*示例*], [*函数*], [*示例*], [*函数*]),
  [$italic(A B C D E a b c d e 1 2 3 4)$], [```typm italic```],
  [$mono(A B C D E a b c d e 1 2 3 4)$], [```typm mono```],
  [$upright(A B C D E a b c d e 1 2 3 4)$], [```typm upright```],
  [$cal(A B C D E a b c d e 1 2 3 4)$], [```typm cal```],
  [$bold(A B C D E a b c d e 1 2 3 4)$], [```typm bold```],
  [$bb(A B C D E a b c d e 1 2 3 4)$], [```typm bb```],
  [$sans(A B C D E a b c d e 1 2 3 4)$], [```typm sans```],
  [$scr(A B C D E a b c d e 1 2 3 4)$], [```typm scr```],
  [$serif(A B C D E a b c d e 1 2 3 4)$], [```typm serif```],
  [$frak(A B C D E a b c d e 1 2 3 4)$], [```typm frak```],
  table.hline(stroke: 0.08em + black),
)

Typst 数学环境默认使用的字形是 ```typm serif```。

=== 数学符号的尺寸

数学符号按照符号排版位置规定尺寸，
从大到小包括行间公式尺寸、行内公式尺寸、上下标尺寸、次级上下标尺寸。
除了字号有别之外，行间和行内公式尺寸下的巨算符也使用不一样的大小。
Typst 为每个数学尺寸指定了一个切换的函数。

#align(center)[
  #block(width: 64%)[
    #table(
      stroke: none,
      columns: (1fr, 2fr, 1fr),
      rows: 1.8em,
      align: left + horizon,
      table.hline(stroke: 0.08em + black),
      table.header([*函数*], [*尺寸*], [*示例*]),
      [```typm display```], [行间公式尺寸], [$display(sum a)$],
      [```typm inline```], [行内公式尺寸], [$inline(sum a)$],
      [```typm script```], [上下标尺寸], [$script(sum a)$],
      [```typm sscript```], [次级上下标尺寸], [$sscript(sum a)$],
      table.hline(stroke: 0.08em + black),
    )
  ]
]

默认情况下，分式的分子和分母使用的都是行内公式尺寸：

#code-and-show(columns: (5fr, 4fr))[```typ
  $
    r = (sum_(i = 1)^n
    (x_i - x)(y_i - y))
    / display(
      [sum_(i = 1)^n (x_i - x)^2
        sum_(i = 1)^n
        (y_i - y)^2]^(1\/2)
    )
  $
  ```]

== 排版定理

在排版数学和其他科技文档时，会接触到大量的定理、证明等内容。

Typst *并没有*提供排版定理以及证明的函数，
但是我们可以使用 @自定义子图片图表示例 的方法来自定义定理内容的排版：

#figure(kind: raw, caption: [在 Typst 中自定义定理排版源代码示例])[
  #code-block[```typ
    #show figure.where(kind: "theroem"): set figure(
      numbering: "1", supplement: [定理],
    )
    #let fangsong = text.with(
      font: "Zhuque Fangsong (technical preview)",
    )
    #show figure.where(kind: "theroem"): it => {
      // 定理中的所有行间公式默认编号
      show math.equation.where(block: true): set math.equation(
        numbering: it => numbering("(1)", it),
        number-align: bottom,
      )
      // 默认设置 2em 的首行缩进
      set par(first-line-indent: (amount: 2em, all: true))
      set align(left) // 文本内容左对齐
      (
        h(-2em) // 定理名称编号和名称顶格
          + text(weight: "bold")[
            #it.supplement~#counter(figure.where(
              kind: "theroem",
            )).display()#if it.caption != none {
              [~(#it.caption.body)]
            }:~] + fangsong(it.body)
      )
    }
    // 模拟中文排版环境，首行缩进 2em
    #set par(first-line-indent: (amount: 2em, all: true))
    #figure(kind: "theroem", caption: [勾股定理])[
      直角三角形斜边的平方和等于两个腰的平方和。

      可以用符号语言表述为：设直角三角形 $triangle A B C$，
      其中 $angle C = 90degree$，则有：
      $
        A B^2 = B C^2 + A C^2
      $<test-theroem-eq>
    ]<test-theroem-th>

    满足 @test-theroem-th 中 @test-theroem-eq
    的整数称为#fangsong[勾股数]。

    #figure(kind: "theroem")[无名定理。]
    ```]
]

#show-block(width: auto)[
  #show figure.where(kind: "theroem"): set figure(numbering: "1", supplement: [定理])
  #let fangsong = text.with(
    font: "Zhuque Fangsong (technical preview)",
  )
  #show figure.where(kind: "theroem"): it => {
    // 定理中的所有行间公式默认编号
    show math.equation.where(block: true): set math.equation(
      numbering: it => numbering("(1)", it),
      number-align: bottom,
    )
    // 默认设置 2em 的首行缩进
    set par(first-line-indent: (amount: 2em, all: true))
    set align(left) // 文本内容左对齐
    (
      h(-2em) // 定理名称编号和名称顶格
        + text(weight: "bold")[
          #it.supplement~#counter(figure.where(kind: "theroem")).display()#if it.caption != none {
            [~(#it.caption.body)]
          }:~]
        + fangsong(it.body)
    )
  }
  // 模拟中文排版环境，首行缩进 2em
  #set par(first-line-indent: (amount: 2em, all: true))
  #figure(kind: "theroem", caption: [勾股定理])[
    直角三角形斜边的平方和等于两个腰的平方和。

    可以用符号语言表述为：设直角三角形 $triangle A B C$，
    其中 $angle C = 90degree$，则有：
    $
      A B^2 = B C^2 + A C^2
    $<test-theroem-eq>
  ]<test-theroem-th>

  满足 @test-theroem-th 中 @test-theroem-eq
  的整数称为#fangsong[勾股数]。

  #figure(kind: "theroem")[无名定理。]
]

这里，假设在中文环境中排版，设置了行首缩进，可以根据自己实际需要调整。

同样的，我们也可以自定义证明内容的排版，方法是一样的：

#code-block[
  ```typ
  #show figure.where(kind: "proof"): set figure(
    numbering: "1",
    supplement: [证明],
  )
  #let fangsong = text.with(
    font: "Zhuque Fangsong (technical preview)",
  )
  #show figure.where(kind: "proof"): it => {
    // 默认设置 2em 的首行缩进
    set par(first-line-indent: (amount: 2em, all: true))
    set align(left) // 文本内容左对齐
    (
      h(-2em) // 证明开始时顶格
        + text(weight: "bold")[
          #it.supplement~#counter(figure.where(
            kind: "proof",
          )).display()#if it.caption != none {
            [~(#it.caption.body)]
          }:~]
        + fangsong(it.body)
        + h(1fr)
        + sym.qed
    )
  }

  #figure(kind: "proof", caption: [简单证明])[
    我们可以直接使用：

    $
      E = m upright(c)^2
    $

    计算结果与预期相符，证毕。
  ]
  ```
]

#show-block(width: auto)[
  #show figure.where(kind: "proof"): set figure(numbering: "1", supplement: [证明])
  #let fangsong = text.with(
    font: "Zhuque Fangsong (technical preview)",
  )
  #show figure.where(kind: "proof"): it => {
    // 默认设置 2em 的首行缩进
    set par(first-line-indent: (amount: 2em, all: true))
    set align(left) // 文本内容左对齐
    (
      h(-2em) // 证明开始时顶格
        + text(weight: "bold")[
          #it.supplement~#counter(figure.where(kind: "proof")).display()#if it.caption != none {
            [~(#it.caption.body)]
          }:~]
        + fangsong(it.body)
        + h(1fr)
        + sym.qed
    )
  }

  #figure(kind: "proof", caption: [简单证明])[
    我们可以直接使用：

    $
      E = m upright(c)^2
    $

    计算结果与预期相符，证毕。
  ]
]

这里结束的 #sym.qed 符号可以换成其他你需要的符号，例如 #sym.square。

== 符号简写

这里列举了一些可以在 Typst 中通过符号组合输入的符号。

=== 标记模式

#table(
  align: center + horizon,
  columns: (1fr, 2fr, 2fr, 1fr, 2fr, 2fr),
  rows: 1.6em,
  stroke: none,
  table.hline(stroke: 0.08em + black),
  table.vline(x: 3, stroke: 0.06em + black),
  table.header([*符号*], [*代码*], [*含义*], [*符号*], [*代码*], [*含义*]),
  table.hline(stroke: 0.04em + black),
  [```typ --```], [`--`], [短破折号],
  [```typ -?```], [`sub-?set`], [可在此断行],
  [```typ ---```], [`---`], [长破折号],
  [```typ -```], [`-`], [减号/负号],
  [```typ ...```], [`...`], [省略号],
  [```typ ~```], [`T.~Thu`], [不可断行空格],
  table.hline(stroke: 0.08em + black),
)

=== 数学模式

#table(
  align: center + horizon,
  columns: (1fr, 2fr, 1fr, 2fr, 1fr, 2fr, 1fr, 2fr),
  rows: 1.6em,
  stroke: none,
  table.hline(stroke: 0.08em + black),
  table.vline(x: 2, stroke: 0.06em + black),
  table.vline(x: 4, stroke: 0.06em + black),
  table.vline(x: 6, stroke: 0.06em + black),
  table.header([*符号*], [*代码*], [*符号*], [*代码*], [*符号*], [*代码*], [*符号*], [*代码*]),
  table.hline(stroke: 0.04em + black),
  [$->$], [```typm ->```],
  [$|->$], [```typm |->```],
  [$=>$], [```typm =>```],
  [$|=>$], [```typm |=>```],
  [$==>$], [```typm ==>```],
  [$-->$], [```typm -->```],
  [$~~>$], [```typm ~~>```],
  [$~>$], [```typm ~>```],
  [$>->$], [```typm >->```],
  [$->>$], [```typm ->>```],
  [$<-$], [```typm <-```],
  [$<==$], [```typm <==```],
  [$<--$], [```typm <--```],
  [$<~~$], [```typm <~~```],
  [$<~$], [```typm <~```],
  [$<-<$], [```typm <-<```],
  [$<<-$], [```typm <<-```],
  [$<->$], [```typm <->```],
  [$<=>$], [```typm <=>```],
  [$<==>$], [```typm <==>```],
  [$<-->$], [```typm <-->```],
  [$*$], [```typm *```],
  [$||$], [```typm ||```],
  [$[|$], [```typm [|```],
  [$|]$], [```typm |]```],
  [$:=$], [```typm :=```],
  [$::=$], [```typm ::=```],
  [$...$], [```typm ...```],
  [$=:$], [```typm =:```],
  [$!=$], [```typm !=```],
  [$>>$], [```typm >>```],
  [$>=$], [```typm >=```],
  [$>>>$], [```typm >>>```],
  [$<<$], [```typm <<```],
  [$<<<$], [```typm <<<```],
  [$<=$], [```typm <=```],
  [$-$], [```typm -```],
  [$~$], [```typm ~```],
  [], [],
  [], [],
  table.hline(stroke: 0.08em + black),
)

=== 部分希腊字母

#table(
  align: center + horizon,
  columns: (1fr, 2fr, 1fr, 2fr, 1fr, 2fr, 1fr, 2fr),
  rows: 1.6em,
  stroke: none,
  table.hline(stroke: 0.08em + black),
  table.vline(x: 2, stroke: 0.06em + black),
  table.vline(x: 4, stroke: 0.06em + black),
  table.vline(x: 6, stroke: 0.06em + black),
  table.header([*字母*], [*代码*], [*字母*], [*代码*], [*字母*], [*代码*], [*字母*], [*代码*]),
  table.hline(stroke: 0.04em + black),
  [$alpha$], [```typm alpha```],
  [$beta$], [```typm beta```],
  [$gamma$], [```typm gamma```],
  [$delta$], [```typm delta```],
  [$epsilon$], [```typm epsilon```],
  [$zeta$], [```typm zeta```],
  [$eta$], [```typm eta```],
  [$theta$], [```typm theta```],
  [$iota$], [```typm iota```],
  [$kappa$], [```typm kappa```],
  [$lambda$], [```typm lambda```],
  [$mu$], [```typm mu```],
  [$nu$], [```typm nu```],
  [$xi$], [```typm xi```],
  [$omicron$], [```typm omicron```],
  [$pi$], [```typm pi```],
  [$rho$], [```typm rho```],
  [$sigma$], [```typm sigma```],
  [$tau$], [```typm tau```],
  [$upsilon$], [```typm upsilon```],
  [$phi$], [```typm phi```],
  [$chi$], [```typm chi```],
  [$psi$], [```typm psi```],
  [$omega$], [```typm omega```],
  [$beta.alt$], [```typm beta.alt```],
  [$epsilon.alt$], [```typm epsilon.alt```],
  [$kappa.alt$], [```typm kappa.alt```],
  [$phi.alt$], [```typm phi.alt```],
  [$pi.alt$], [```typm pi.alt```],
  [$rho.alt$], [```typm rho.alt```],
  [$sigma.alt$], [```typm sigma.alt```],
  [$theta.alt$], [```typm theta.alt```],
  [$Gamma$], [```typm Gamma```],
  [$Delta$], [```typm Delta```],
  [$Lambda$], [```typm Lambda```],
  [$Xi$], [```typm Xi```],
  table.hline(stroke: 0.08em + black),
)
