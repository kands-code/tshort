/// 生成摘要
#let abstract(body) = {
  align(center)[
    #block(width: 64%)[
      #text(
        font: "Sarasa Gothic SC",
        size: 0.96em,
        weight: "semibold",
      )[
        #body
      ]
    ]
  ]
  v(1.6em)
}
