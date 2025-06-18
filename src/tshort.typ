#set text(
  font: "Source Han Serif",
  size: 12pt,
  lang: "zh",
)
#set page(paper: "a4")
#set par(justify: true)
#set cite(style: "gb-7714-2015-numeric", form: "normal")

#set figure(numbering: it => [ #counter(heading).get().first().#it ])
#show figure: set block(above: 3.2em, below: 1.6em)

#show link: set text(fill: rgb(37, 95, 56))
#show ref: set text(fill: rgb(31, 125, 83))
#show math.equation: set text(font: "STIX Two Math", size: 12pt)
#show raw: set text(font: "Sarasa Fixed Slab SC", size: 10pt)
#show heading: it => if it.level == 1 {
  align(center)[
    #v(6.4em)
    #block(below: 3.2em)[
      #text(size: 1.6em)[
        #if it.numbering == none {
          it.body
        } else {
          counter(heading).display(it.numbering) + h(1em) + it.body
        }
      ]
    ]
  ]
} else if it.level == 2 {
  align(center)[
    #block(above: 3.2em, below: 1.6em)[
      #text(size: 1.28em)[
        #if it.numbering == none [
          #it.body
        ] else [
          #counter(heading).display(it.numbering)#h(1em)#it.body
        ]
      ]
    ]
  ]
} else {
  block(above: 1.6em, below: 1em)[
    #text(size: 1.2em)[
      #counter(heading).display(it.numbering)#h(1em)#it.body
    ]
  ]
}

#include "cover.typ"

#set page(
  header: context {
    let positions = query(heading.where(level: 1)).map(it => it.location().page())
    let current_page = here().page()
    let logic_page = counter(page).get().first()
    if current_page in positions {
      []
    } else {
      align(center + bottom)[
        #text(weight: "bold")[
          #if calc.even(logic_page) [
            #counter(page).display() #h(1fr)前言
          ] else [
            前言#h(1fr) #counter(page).display()
          ]
        ]
        #v(-0.48em)
        #line(length: 100%, stroke: 0.64pt + black)
      ]
    }
  },
  footer: context {
    let positions = query(heading.where(level: 1)).map(it => it.location().page())
    let current_page = here().page()
    if current_page in positions {
      align(center + top)[
        #text(weight: "semibold")[
          #counter(page).display()
        ]
      ]
    } else {
      []
    }
  },
)

#set page(numbering: "i")
#counter(page).update(1)

#set par(first-line-indent: (amount: 2em, all: true))
#include "prelude.typ"

#pagebreak()

#set page(
  header: context {
    let positions = query(heading.where(level: 1)).map(it => it.location().page())
    let current_page = here().page()
    let logic_page = counter(page).get().first()
    if current_page in positions {
      []
    } else {
      align(center + bottom)[
        #text(weight: "bold")[
          #if calc.even(logic_page) [
            #counter(page).display() #h(1fr)目录
          ] else [
            目录#h(1fr) #counter(page).display()
          ]
        ]
        #v(-0.48em)
        #line(length: 100%, stroke: 0.64pt + black)
      ]
    }
  },
  footer: context {
    let positions = query(heading.where(level: 1)).map(it => it.location().page())
    let current_page = here().page()
    if current_page in positions {
      align(center + top)[
        #text(weight: "semibold")[
          #counter(page).display()
        ]
      ]
    } else {
      []
    }
  },
)

= 目录
#columns(2)[
  #outline(
    title: none,
    depth: 3,
    indent: it => if it == 0 {
      0em
    } else if it == 1 {
      1.7em
    } else {
      3.5em
    },
  )
]

#heading(level: 2, outlined: false)[源代码示例列表]
#outline(title: none, target: figure.where(kind: raw))


#pagebreak()

#show heading.where(level: 1): set heading(numbering: "第一章")
#set heading(numbering: "1.1.1")

#set page(
  numbering: "1",
  header: context {
    let level1_headings = query(heading.where(level: 1))
    let positions = level1_headings.map(it => it.location().page())
    let current_page = here().page()
    let logic_page = counter(page).get().first()
    let level1_headings_titles = level1_headings
      .filter(it => it.location().page() <= current_page)
      .map(it => (counter(heading).get().at(0), it.body))
      .rev()
      .first()
    let level2_headings_titles = query(heading.where(level: 2))
      .map(it => (counter(heading).get(), it.body))
      .rev()
      .first()
    if current_page in positions {
      []
    } else {
      align(center + bottom)[
        #if calc.even(logic_page) [
          #text(weight: "bold")[
            #counter(page).display() #h(1fr) #if level1_headings_titles.at(0) == 0 [
              #level1_headings_titles.at(1)
            ] else [
              #numbering(
                "第一章",
                level1_headings_titles.at(0),
              )#h(1em)#level1_headings_titles.at(1)
            ]
          ]
        ] else [
          #text(weight: "bold")[
            #math.section#numbering(
              "1.1",
              level2_headings_titles.at(0).at(0),
              level2_headings_titles.at(0).at(1),
            )#h(1em)#level2_headings_titles.at(1)
            #h(1fr) #counter(page).display()
          ]
        ]
        #v(-0.48em)
        #line(length: 100%, stroke: 0.64pt + black)
      ]
    }
  },
)

#counter(page).update(1)

// content
= tes1

#lorem(108)

== tes11

#lorem(108)

#pagebreak()

== tes12

#lorem(108)

#figure(caption: "最简单示例", kind: raw)[
  ```typst
  nihc
  ```
]

#lorem(108)

#pagebreak()

#show heading.where(level: 1): set heading(numbering: "附录 A")
#counter(heading).update(0)

#include "appendix.typ"

#pagebreak()

#show heading.where(level: 1): set heading(numbering: none)

#bibliography(style: "gb-7714-2015-numeric", "refs.bib")

#include "license.typ"
