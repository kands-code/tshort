= 前言

Typst @typst 是一个类似于 TeX@tex 的排版系统（Typesetting System），
非常适用于生成高印刷质量的科技类和数学类文档。
Typst 还能够生成其他种类的文档 #footnote[
  详情可以参考 `page` 函数的 #link("https://typst.app/docs/reference/layout/page/#parameters-paper")[
    paper 参数
  ]
]，小到简单的信件，大到完整的书籍。

这份文档描述了 Typst 的使用，对 Typst 的大多数应用来说应该是足够了。
#link("https://typst.app/docs/reference/")[Typst 文档] 对 Typst 系统提供了完整的描述。

本文档在中文版 lshort 的基础上进行了改编，共有八章和一篇附录：

/ 第一章: 讲述 Typst 的基本信息，包括 Typst 的优缺点、源代码的基本结构、
  基本语法以及如何编译源代码生成文档。

/ 第二章: 讲述在 Typst 中如何正确书写文字，包括中文。

/ 第三章: 讲述文档排版基本元素 ------ 标题、目录、列表、图片、表格等等。
  结合前一章的内容，你应当能够制作内容较为丰富的文档了。

/ 第四章: Typst 排版公式的能力不输 LaTeX。本章的内容涉及了一些排版公式经常用到的函数，
  章节末尾列出了 Typst 常见的数学符号。

/ 第五章: 介绍了如何修改文档的一些基本样式，包括字体、段落、页面尺寸、页眉页脚等。

/ 第六章: 介绍了 Typst 的一些其他功能：排版参考文献、排版索引、使用颜色和超链接。

/ 第七章: 介绍了如何在 Typst 中使用基础元素绘图，这一部分只是简单介绍。

/ 第八章: 如果你已经相当熟悉前面几章的内容，
  可能会有自己编写包（package）来扩展 Typst 的需求。
  本章介绍了构建包的基本流程满足你的需求。

/ 附录 A: 介绍了如何安装 Typst 以及总结了一些常见错误的解决思路。

这些章节是循序渐进的，建议刚熟悉 Typst 的读者按顺序阅读。
一定要认真阅读例子的源代码，它们贯穿全篇文档，包含了很多的信息。

如果你对 Typst 较为熟练，本文档的内容已不足以解决你的问题时，
请访问 #link("https://forum.typst.app/")[Typst Forum]。
如果想要查看或使用别人编写的包，
可以访问 #link("https://typst.app/universe/")[Typst Universe]。

要在自己的电脑上安装 Typst，请参考 @appendix-a 中的内容。

如果对文档内容想要做出调整，请通知作者。
作者对于 Typst 初学者的反馈特别感兴趣，尤其是关于这份文档哪些内容很容易理解，
哪些内容可能需要更好的解释，而哪些内容由于太过难以理解、非常不常用而不适宜放在本文档。

#align(right)[
  Kevin Stephen

  #link("https://github.com/kands-code")
]

#v(1fr)

#text(size: 0.96em)[
  tshort 的最新版本位于 #link("https://github.com/kands-code/tshort")。
]
