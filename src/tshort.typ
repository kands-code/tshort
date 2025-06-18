#set text(
  font: "Source Han Serif",
  size: 12pt,
  lang: "zh",
)
#set page(paper: "a4")
#set cite(style: "gb-7714-2015-numeric", form: "normal")
#show link: set text(fill: rgb(37, 95, 56))
#show ref: set text(fill: rgb(31, 125, 83))
#show raw: set text(font: "Sarasa Fixed Slab SC", size: 10pt)
#show math.equation: set text(font: "STIX Two Math", size: 12pt)
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
    #block(above: 1.6em, below: 1em)[
      #text(size: 1.28em)[
        #counter(heading).display(it.numbering)#h(1em)#it.body
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
    let level1_headings = query(heading.where(level: 1))
    let positions = level1_headings.map(it => it.location().page())
    let current_page = here().page()
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
        #if calc.even(current_page) [
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
        #v(-0.64em)
        #line(length: 100%)
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
#heading(level: 1, outlined: true)[目录]

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

#pagebreak()

#show heading.where(level: 1): set heading(numbering: "第一章")
#set heading(numbering: "1.1.1")

#set page(numbering: "1")
#counter(page).update(1)

// content
= tes

== tes

#pagebreak()

#show heading.where(level: 1): set heading(numbering: "附录 A")
#counter(heading).update(0)

#include "appendix.typ"

#pagebreak()

#show heading.where(level: 1): set heading(numbering: none)

#bibliography(style: "gb-7714-2015-numeric", "refs.bib")
