// 设置文档主要字体为 Source Han Serif，
// 以及文档语言为中文，默认字体大小为 12pt
#set text(
  size: 12pt,
  lang: "zh",
  fill: black,
  // 由于生成文档时默认禁用系统字体，
  // Emoji 字体默认回退为 Noto Color Emoji
  font: (
    (name: "New Computer Modern", covers: "latin-in-cjk"),
    (name: "Noto Color Emoji", covers: regex("\p{Emoji}")),
    "Source Han Serif SC",
  ),
)
// 设置数学字体为 New Computer Modern Math，字体大小为 12pt
#show math.equation: set text(size: 12pt, font: "New Computer Modern Math")
// 设置等宽字体为 Sarasa Fixed Slab SC，字体大小为 11pt
#show raw: set text(size: 11pt, font: "Sarasa Fixed Slab SC")
// 对于普通行内等宽内容，字体颜色设置为 rgb(135, 35, 65)，与普通内容区分
#show raw.where(block: false, lang: none): set text(fill: rgb(135, 35, 65))
// 设置页面大小为 a4
#set page(paper: "a4")
// 启用段落自动调整功能
#set par(justify: true)
// 设置引用格式为 gb-7714-2015-numeric
#set cite(style: "gb-7714-2015-numeric", form: "normal")
// footnote 设置
#show footnote.entry: it => {
  // 设置 footnote 字体大小为 12pt * 0.8
  set text(size: 9.6pt, fill: black)
  // 并且调整对应等宽字体大小 11pt * 0.8
  show raw: set text(size: 8.8pt)
  it
}
// 设置有序列表编号
#set enum(full: true, numbering: (..nums) => {
  let level = nums.pos().len()
  let num = nums.at(level - 1)
  if level == 1 {
    numbering("一、", num)
  } else if level == 2 {
    numbering("（一）", num)
  } else if level == 3 {
    numbering("1.", num)
  } else if level == 4 {
    numbering("(1)", num)
  } else if level == 5 {
    numbering("1)", num)
  } else if level == 6 {
    numbering("A.", num)
  } else {
    numbering("a.", num)
  }
})
// 设置所有 figure 的上下外间距
#show figure: set block(
  above: 2em,
  below: 2em,
  // 让 figure 可以跨页面
  breakable: true,
)
// 设置表格图表的标题位置
#show figure.where(kind: table): set figure.caption(position: top)
// 设置链接和引用的的文本颜色
#show link: set text(fill: rgb(87, 123, 193))
#show ref: set text(fill: rgb(52, 76, 183))
// 设置标题格式
#show heading: it => if it.level == 1 {
  // 重置脚注计数器，从 0 开始
  counter(footnote).update(0)
  // 对于一级标题，居中
  align(center)[
    // 标题字体大小为 1.6em
    #text(size: 1.6em)[
      // 上外边距固定为 3.2em
      #v(3.2em)
      // 下边距为 2.4em
      #block(below: 2.4em)[
        #if it.numbering == none {
          // 对于没有编号的标题，只显示标题内容
          it.body
        } else {
          // 如果有编号，则在编号与内容间设置间距为 1em
          counter(heading).display(it.numbering) + h(1em) + it.body
        }
      ]
    ]
  ]
} else if it.level == 2 {
  // 对于二级标题，居中
  align(center)[
    // 设置标题字体大小为 1.28em
    #text(size: 1.28em)[
      // 设置上外边距为 3.2em，下外边距为 1.6em
      #block(above: 2em, below: 1.2em)[
        #if it.numbering == none [
          // 对于没有编号的标题，只显示标题内容
          #it.body
        ] else [
          // 如果有编号，则在编号与内容间设置间距为 1em
          #counter(heading).display(it.numbering)#h(1em)#it.body
        ]
      ]
    ]
  ]
} else if it.level == 3 {
  // 对于三级标题，设置标题字体大小为 1.2em
  text(size: 1.2em)[
    // 设置上外边距为 1.6em，下外边距为 1.2em
    #block(above: 2em, below: 1.2em)[
      //! 二级以下的标题一定有编号，所以按照有编号的格式显示
      #counter(heading).display(it.numbering)#h(1em)#it.body
    ]
  ]
} else {
  // 对于三级及以下标题，设置标题字体大小为 1.08em
  text(size: 1.08em)[
    #block(above: 1.6em, below: 1.2em)[
      // 不显示编号
      #it.body
    ]
  ]
}

// ----------
//   部分工具
// ----------

// 插入空白页
#let insert-page(to: "odd") = {
  // 强制断页
  pagebreak(weak: false)
  // 确保页面完全空白
  set page(header: [], footer: [])
  // 让后续内容在 `to` 页面上
  // 默认是 奇数页面
  pagebreak(to: to, weak: true)
}

// ---------
//  封面部分
// ---------

// 引入文档封面
#include "cover.typ"
#insert-page()

// 设置文档信息
#set document(
  title: [一份（不太）简短的 Typst 介绍], // 文档标题
  author: ("Kevin Stephen",), // 文档作者
  description: [Typst 入门介绍], // 文档简介
  keywords: ("Typst", "入门", "教程"), // 文档关键词
  date: datetime.today(), // 文档创建日期，默认为当天
)

// ---------
//  前言部分
// ---------

// 设置前言部分的页面页眉和页脚格式
// 前言部分标题固定显示 <前言>
#set page(
  header: context {
    // 获取所有一级标题的位置，每一个章节只有一个一级标题
    let positions = query(heading.where(level: 1)).map(it => it.location().page())
    // 获取当前页面的实际页数
    let current_page = here().page()
    // 检查当前页面是否包含一级标题，即是否是每一章第一页
    if current_page in positions {
      // 如果是，则不显示页眉
      none
    } else {
      // 否则，显示页眉
      align(
        center + bottom,
        // 页眉内容为粗体显示
        text(weight: "bold", if calc.even(current_page) [
          // 如果当前页面是偶数，
          // 则按照 <页码 间隔 标题> 的格式显示页眉
          #counter(page).display()#h(1fr)前言
        ] else [
          // 如果是奇数，
          // 则按照 <标题 间隔 页码> 的格式显示页眉
          前言#h(1fr)#counter(page).display()
        ])
          + v(-0.48em) // 收缩内容与分割线间隔，调整具体样式
          + line(length: 100%, stroke: 0.64pt + black), // 自己绘制分割线
      )
    }
  },
  footer: context {
    // 获取当前页码
    let current-page = here().page()
    // 检查当前页面是否有一级标题
    if (
      current-page
        == query(heading.where(level: 1))
          .filter(it => it.location().page() <= current-page)
          .last()
          .location()
          .page()
    ) {
      // 如果是章节首页，则显示页码作为页脚
      align(center + top)[
        #text(weight: "semibold")[
          #counter(page).display()
        ]
      ]
    } else {
      // 否则不显示页脚
      none
    }
  },
)
// 设置前言部分的页码编号格式为小写罗马字母
#set page(numbering: "i")
// 设置当前页面为逻辑上的第一页
#counter(page).update(1)
// 设置段落缩进为 2em，所有段落都缩进
#set par(
  first-line-indent: (amount: 2em, all: true),
  // 上一行底部边缘与下一行顶部边缘的间距
  // > Leading defines the spacing
  // > between the bottom edge of one line
  // > and the top edge of the following line.
  leading: 0.8em, // 默认是 0.65em
  linebreaks: "optimized", // 优化分行
)
// 引入前言
#include "prelude.typ"
#insert-page()

// ---------
//  目录部分
// ---------

// 设置目录的页眉显示
#set page(header: context {
  // 获取所有一级标题的位置
  let positions = query(heading.where(level: 1)).map(it => it.location().page())
  // 获取当前页面的实际页码
  let current_page = here().page()
  // 检查当前页面是否是章节首页
  if current_page in positions {
    // 如果是则不显示页眉
    none
  } else {
    // 否则显示页眉
    align(
      center + bottom,
      text(weight: "bold", if calc.even(current_page) [
        // 格式为偶数 <页码 间隔 标题>
        #counter(page).display()#h(1fr)目录
      ] else [
        // 奇数页眉为 <标题 间隔 页码>
        目录#h(1fr)#counter(page).display()
      ])
        + v(-0.48em)
        + line(length: 100%, stroke: 0.64pt + black),
    )
  }
})

// 目录手动使用一级标题
= 目录

// 一级标题与页码间使用空白填充
#show outline.entry.where(level: 1): set outline.entry(fill: [])
// 一级标题显示为粗体
#show outline.entry.where(level: 1): set text(weight: "bold")
// 设置为双栏目录，不显示目录标题
#columns(2)[
  // 字体大小设置为 11pt，方便显示标题
  #set text(size: 11pt)
  // 目录内容
  #outline(
    title: none,
    depth: 3, // 最多显示三层目录
    // 每一层级缩进 1.6em
    indent: 1.6em,
  )

  // 设置源码目录条目间距
  #show figure.where(kind: "outline"): set block(below: 1em)
  // 使用浮动体确保源码目录显示在目录同一页的底部
  #figure(
    caption: none,
    gap: 0em,
    kind: "outline",
    numbering: none,
    outlined: false,
    placement: bottom,
    scope: "parent",
    supplement: none,
  )[
    // 手动设置上外边距
    #v(3.2em)
    // 源码目录列表使用二级标题来符合格式要求
    // 设置 outlined: false 来隐藏标题
    #heading(level: 2, outlined: false)[源代码示例列表]
    // 设置源码列表目录
    #show outline.where(target: figure.where(kind: raw)): it => {
      // 恢复默认间隔填充
      show outline.entry: set outline.entry(fill: repeat(sym.dot, gap: 0.15em))
      // 使用常规字重
      show outline.entry: set text(weight: "regular", fill: rgb(37, 77, 112))
      it
    }
    #outline(
      title: none,
      // 列出所有的种类为 raw 的 figure 来生成目录
      target: figure.where(kind: raw),
    )
  ]
]

#insert-page()

// ---------
//  正文部分
// ---------


// 设置正文格式
// 正文一级标题编号使用 <第x章> 的格式
#show heading.where(level: 1): set heading(numbering: "第一章", supplement: [章节])
// 最多三级标题，第二和第三级标题使用 <x.x.x> 的格式
#set heading(numbering: "1.1.1", supplement: [小节])
// 设置正文的页面格式
#set page(
  // 页码使用阿拉伯数字格式
  numbering: "1",
  // 设置页眉格式
  header: align(center + bottom, context {
    let current-page = here().page()
    let title = query(heading.where(level: 1))
      .filter(it => it.location().page() <= current-page)
      .last()
    if title.location().page() == current-page {
      none // 如果当前页面有一级标题，不显示页眉
    } else {
      if calc.even(current-page) {
        let section-index = counter(heading.where(level: 1)).get().at(0)
        // 对于偶数页，显示格式为 <页码 间隔 章节标题>
        text(
          weight: "bold",
          counter(page).display()
            + h(1fr)
            + numbering("第一章", section-index)
            + h(1em)
            + title.body,
        )
      } else {
        // 对于奇数页，格式为 <二级标题 间隔 页码>
        let level2-titles = query(heading.where(level: 2)).filter(it => (
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
        text(
          weight: "bold",
          sym.section
            + numbering("1.1", first, second)
            + h(1em)
            + level2-title.body
            + h(1fr)
            + counter(page).display(),
        )
      }
      v(-0.48em) + line(length: 100%, stroke: 0.64pt + black)
    }
  }),
)
// 设置当前页面为逻辑第一页
#counter(page).update(1)
// 第一章内容
#include "chp/ch01.typ"
#insert-page()
// 第二章内容
#include "chp/ch02.typ"
#insert-page()
// 第三章内容
#include "chp/ch03.typ"
#insert-page()
// 第四章内容
#include "chp/ch04.typ"
#insert-page()
// 第五章内容
#include "chp/ch05.typ"
#insert-page()
// 第六章内容
#include "chp/ch06.typ"
#insert-page()

// ---------
//  附录部分
// ---------

// 设置附录
// 附录一级标题显示为 <附录x>
#show heading.where(level: 1): set heading(numbering: "附录A", supplement: [附录])
// 其他标题显示为 <x.x.x>
#set heading(numbering: "A.1.1")
// 重置标题计数，标题默认从 0 开始计数
#counter(heading).update(0)
// 引入附录内容
#include "appendix.typ"
#insert-page()

// 正文结束后取消标题编号
#show heading: set heading(numbering: none)

// -------------
//  参考文献部分
// -------------

// 设置参考文献页眉
#set page(header: context {
  // 获取所有一级标题的位置
  let positions = query(heading.where(level: 1)).map(it => it.location().page())
  // 获取当前页面的实际页码
  let current_page = here().page()
  // 检查当前页面是否是章节首页
  if current_page in positions {
    // 如果是则不显示页眉
    none
  } else {
    // 否则显示页眉
    align(
      center + bottom,
      text(weight: "bold", if calc.even(current_page) [
        // 格式为偶数 <页码 间隔 标题>
        #counter(page).display()#h(1fr)参考文献
      ] else [
        // 奇数页眉为 <间隔 页码>
        #h(1fr)#counter(page).display()
      ])
        + v(-0.48em)
        + line(length: 100%, stroke: 0.64pt + black),
    )
  }
})

// 参考文献使用 gb-7714-2015-numeric 格式
// 参考内容引用自 refs.bib 文件
#bibliography(style: "gb-7714-2015-numeric", "refs.bib")<ch-1-reference>
#insert-page()

// -----------
//  许可证部分
// -----------

// 引用许可证
#include "license.typ"
// 结束页面设置为偶数页，即便会产生空白纸张
#insert-page(to: "even")
