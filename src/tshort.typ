// 设置文档主要字体为 Source Han Serif，
// 以及文档语言为中文，默认字体大小为 12pt
#set text(
  font: "Source Han Serif",
  size: 12pt,
  lang: "zh",
)
// 设置页面大小为 a4
#set page(paper: "a4")
// 启用段落自动调整功能
#set par(justify: true)
// 设置引用格式为 gb-7714-2015-numeric
#set cite(style: "gb-7714-2015-numeric", form: "normal")
// 设置 figure 的编号方式
#set figure(numbering: it => [ #counter(heading).get().first().#it ])
// 设置 footnote 字体大小为 0.8em
#show footnote.entry: set text(size: 0.8em)
// 设置 figure 的上下外间距
#show figure: set block(above: 1.6em, below: 1.6em)
// 设置 figure 标题的上下边距
#show figure.caption: it => {
  // 标题字体应该要略小于正文字体
  set text(size: 0.96em)
  v(0.8em) + it + v(0.32em)
}
// 设置链接和引用的的文本颜色
#show link: set text(fill: rgb(87, 123, 193))
#show ref: set text(fill: rgb(52, 76, 183))
// 设置数学字体为 STIX Two Math，字体大小为 12pt
#show math.equation: set text(font: "STIX Two Math", size: 12pt)
// 设置等宽字体为 Sarasa Fixed Slab SC，字体大小为 11pt
#show raw: set text(font: "Sarasa Fixed Slab SC", size: 11pt)
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
      #block(above: 3.2em, below: 1.6em)[
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
} else {
  // 对于二级以下的标题，如三级标题
  // 设置标题字体大小为 1.2em
  text(size: 1.2em)[
    // 设置上外边距为 1.6em，下外边距为 1.2em
    #block(above: 1.6em, below: 1.2em)[
      //! 二级以下的标题一定有编号，所以按照有编号的格式显示
      #counter(heading).display(it.numbering)#h(1em)#it.body
    ]
  ]
}

// ---------
//  封面部分
// ---------

// 引入文档封面
#include "cover.typ"
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
      []
    } else {
      // 否则，显示页眉
      align(center + bottom)[
        // 页眉内容为粗体显示
        #text(weight: "bold")[
          #if calc.even(current_page) [
            // 如果当前页面是偶数，
            // 则按照 <页码 间隔 标题> 的格式显示页眉
            #counter(page).display()#h(1fr)前言
          ] else [
            // 如果是奇数，
            // 则按照 <标题 间隔 页码> 的格式显示页眉
            前言#h(1fr)#counter(page).display()
          ]
        ]
        // 收缩内容与分割线间隔，调整具体样式
        #v(-0.48em)
        // 自己绘制分割线
        #line(length: 100%, stroke: 0.64pt + black)
      ]
    }
  },
  footer: context {
    // 获取所有一级标题的位置
    let positions = query(heading.where(level: 1)).map(it => it.location().page())
    // 获取当前页面的实际位置
    let current_page = here().page()
    // 检查当前页面是否有一级标题
    if current_page in positions {
      // 如果是章节首页，则显示页码作为页脚
      align(center + top)[
        #text(weight: "semibold")[
          #counter(page).display()
        ]
      ]
    } else {
      // 否则不显示页脚
      []
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
  leading: 0.8em, // 默认是 0.65em，稍微增加行间距
  linebreaks: "optimized", // 优化分行
)
// 引入前言
#include "prelude.typ"
// 设置目录的页眉显示
#pagebreak()
#set page(
  header: context {
    // 获取所有一级标题的位置
    let positions = query(heading.where(level: 1)).map(it => it.location().page())
    // 获取当前页面的实际页码
    let current_page = here().page()
    // 检查当前页面是否是章节首页
    if current_page in positions {
      // 如果是则不显示页眉
      []
    } else {
      // 否则显示页眉
      align(center + bottom)[
        #text(weight: "bold")[
          #if calc.even(current_page) [
            // 格式为偶数 <页码 间隔 标题>
            #counter(page).display()#h(1fr)目录
          ] else [
            // 奇数页眉为 <标题 间隔 页码>
            目录#h(1fr)#counter(page).display()
          ]
        ]
        #v(-0.48em)
        #line(length: 100%, stroke: 0.64pt + black)
      ]
    }
  },
)

// ---------
//  目录部分
// ---------

// 主目录使用一级标题
= 目录
// 设置为双栏目录，不显示标题
#columns(2)[
  #outline(
    title: none,
    depth: 3, // 最多显示三层目录
    // 按照不同层级缩进，从 0 开始
    indent: it => if it == 0 {
      0em
    } else if it == 1 {
      1.6em
    } else {
      3.2em
    },
  )
]
// 源码目录列表使用二级标题来符合格式要求
// 设置 outlined: false 来隐藏标题
#heading(level: 2, outlined: false)[源代码示例列表]
// 设置源码列表目录
#outline(
  title: none,
  // 列出所有的种类为 raw 的 figure 来生成目录
  target: figure.where(kind: raw),
)

#pagebreak()

// ---------
//  正文部分
// ---------

// 设置正文格式
#pagebreak()
// 正文一级标题编号使用 <第x章> 的格式
#show heading.where(level: 1): set heading(numbering: "第一章")
// 最多三级标题，第二和第三级标题使用 <x.x.x> 的格式
#set heading(numbering: "1.1.1")
// 设置正文的页面格式
#set page(
  // 页码使用阿拉伯数字格式
  numbering: "1",
  // 设置页眉格式
  header: context {
    // 获取所有的一级标题
    let level1_headings = query(heading.where(level: 1))
    // 获取所有一级标题的位置
    let positions = level1_headings.map(it => it.location().page())
    // 获取当前页面的实际页码
    let current_page = here().page()
    // 测试当前页面是否是章节首页
    if current_page in positions {
      // 如果是则不显示页眉
      []
    } else {
      // 否则显示页眉
      align(center + bottom)[
        #text(weight: "bold")[
          #if calc.even(current_page) {
            // 获取当前页面所属一级标题编号和内容
            let level1_headings_title = level1_headings
              .filter(it => it.location().page() <= current_page)
              .map(it => (counter(heading).get().first(), it.body))
              .rev()
              .first()
            // 对于偶数页面，
            // 页眉格式为 <页码 间隔 一级标题>
            (
              counter(page).display()
                + h(1fr)
                + [
                  #numbering(
                    "第一章",
                    level1_headings_title.first(),
                  )#h(1em)#level1_headings_title.at(1)
                ]
            )
          } else {
            // 获取所有二级标题
            let level2_heading = query(heading.where(level: 2))
              .map(it => (
                str(it.location().page()),
                (it.location(), it), // 保留标题的 location 信息
              )) // 将页码由整数转为字符串
              .rev() // 反转列表
              .to-dict() // 去掉相同页面的二级标题，只保留第一个二级标题
              .pairs() // 将字典转为列表
              .map(((l2_page, l2_heading)) => (
                int(l2_page),
                l2_heading,
              )) // 将页码恢复为整数
              .filter(((l2_page, _)) => l2_page <= current_page)
              .first() // 获取最接近的二级标题
              .at(1) // 去除页码信息
            // 对于奇数页面，
            // 页眉格式为 <二级标题 间隔 页码>
            (
              // 通过 location 定位获取真实的 counter(heading)，
              // 然后格式化显示
              numbering("1.1", ..counter(heading).at(level2_heading.at(0)))
                + h(1em) // 编号与标题内容间隔 1em
                + level2_heading.at(1).body // 标题内容
                + h(1fr) // 间隔
                + counter(page).display() // 页码
            )
          }
        ]
        #v(-0.48em)
        #line(length: 100%, stroke: 0.64pt + black)
      ]
    }
  },
)
// 设置当前页面为逻辑第一页
#counter(page).update(1)
// 第一章内容
#include "chp/ch01.typ"

// ---------
//  附录部分
// ---------

// 设置附录
#pagebreak()
// 附录一级标题显示为 <附录x>
#show heading.where(level: 1): set heading(numbering: "附录A")
// 其他标题显示为 <x.x.x>
#set heading(numbering: "A.1.1")
// 重置标题计数，标题默认从 0 开始计数
#counter(heading).update(0)
// 引入附录内容
#include "appendix.typ"

// 正文结束后取消标题编号
#show heading: set heading(numbering: none)

// -------------
//  参考文献部分
// -------------

// 设置参考文献
#pagebreak()
// 参考文献使用 gb-7714-2015-numeric 格式
// 参考内容引用自 refs.bib 文件
#bibliography(style: "gb-7714-2015-numeric", "refs.bib")

// -----------
//  许可证部分
// -----------

#pagebreak()
// 引用许可证
#include "license.typ"
