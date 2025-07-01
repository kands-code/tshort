#import "utils.typ": abstract, code-and-show, code-block, code-card, show-block

= 安装 Typst 与排除错误<appendix-a>

#abstract[
  Typst 安装是非常简单的！
  本章将简单介绍几种常用的 Typst 安装方法，以及一些常见问题的解决方案。
]

== 安装 Typst

如果想要安装 Typst 命令行工具到本地环境，以下是几种常见的安装途径。

=== GitHub Release

通过 GitHub Release 安装 Typst 有大致一下几个步骤：

/ 访问发布页面: 前往 Typst 在 GitHub 上的 #link("https://github.com/typst/typst/releases")[Releases 页面]。

/ 下载压缩包: 根据当前使用的操作系统，选择并下载最新版本的压缩包。

/ 解压文件: 下载完成后，可以解压到任何你要想要存放 Typst 可执行文件的目录。

/ 配置环境变量（可选）: 要在命令行中直接运行 `typst` 命令，
  需要将包含 Typst 可执行文件的目录添加到系统的环境变量 `PATH`。

  对于类 Unix 系统：

  #code-card[
    ```sh
    export PATH="/path/to/typst":"$PATH"
    ```
  ]

=== 包管理器

许多操作系统都提供了包管理器，可以简化软件的安装和更新过程：

/ Windows: 使用 `winget`，在命令行执行：```sh winget install Typst.Typst```。

/ macOS: 如果配置好了 #link("https://brew.sh/")[Homebrew]，可以在终端执行：```sh brew install typst```。

/ ArchLinux: 使用 `pacman`，在终端执行：```sh sudo pacman -S typst```。

/ openSUSE: 使用 `zypper`，在终端执行：```sh sudo zypper install typst```。

其他系统可使用对应包管理器安装，部分发行版可能需要使用社区源。

=== 手动编译安装

如果本地有 Rust 的开发工具链，可以通过 Cargo 来安装 Typst。

/ 发行版: 安装 `typst-cli`：

  #code-card[```sh cargo install --locked typst-cli```]

/ 测试版: 安装时使用 `--git` 参数指定 GitHub 仓库即可：

  #code-card[```sh cargo install --git https://github.com/typst/typst --locked typst-cli```]

== 常见问题及解决方法

=== 分隔符的下标位置太过偏下

这是因为下标选择了整个表达式，而不是分隔符作为“依附”对象，所以基线要比预期的要更低；这也跟字体的设计有关。
解决方法是使用一个简单的函数：

#code-block[
  ```typ
  #let lspt(body) = {
    let subs = eval("script(" + body + ")", mode: "math")
    context place(bottom, float: true,
      scope: "parent", clearance: 0em,
      dy: -measure(subs).height / 2, subs)
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

=== 目录间隔问题

在 @ch-3-目录 中提到，通过参数 `target` 能得到对应目录。
如果把目录变成浮动体或者使用 `figure` 函数包裹，
并且设置过图表上下间隔，就会影响目录的间隔：

#code-block[
  ```typ
  // 恢复 figure 的下外间距
  #show figure: set block(below: auto)
  // 设置测试图表
  #show figure.where(kind: "test"): set figure(supplement: [T])
  #figure(kind: "test")[]
  #figure(kind: "test")[]
  // 对比目录
  #figure[
    *正常目录*
    #outline(target: figure.where(kind: "test"), title: none)
  ]
  // 设置 figure 的下外间距
  #show figure: set block(below: 2em)
  #figure[
    *异常目录*
    #outline(target: figure.where(kind: "test"), title: none)
  ]
  ```
]

#show-block(width: auto)[
  // 恢复 figure 的下外间距
  #show figure: set block(below: auto)
  // 设置测试图表
  #show figure.where(kind: "test"): set figure(supplement: [T])
  #figure(kind: "test")[]
  #figure(kind: "test")[]
  // 对比目录
  #figure[
    *正常目录*
    #outline(target: figure.where(kind: "test"), title: none)
  ]
  // 设置 figure 的下外间距
  #show figure: set block(below: 2em)
  #figure[
    *异常目录*
    #outline(target: figure.where(kind: "test"), title: none)
  ]
]

造成这个现象的原因是，*目录的每一个条目都是一个“块”*。
所以设置图表中块的上下间隔也会影响包裹在图表中的目录条目的上下间隔。
解决方法是临时将图表的上下间距恢复为 `auto`，或者将对于图表间距的设置移动到目录之后。


=== 引用编号格式问题

在 @ch-3-章节标题 中提到过，Typst 中的编号分为计数符号、后缀以及前缀三个部分。
而在引用时，编号仅会保留计数符号部分。例如：

#code-and-show(columns: (9fr, 5fr))[```typ
  #set math.equation(numbering: "(a)")
  $ E = m upright(c)^2 $<test-ref-wrong>

  测试引用编号 @test-ref-wrong。
  ```]

要保证引用的编号格式与设置的编号格式一致，可以使用函数而不是字符串。

#code-and-show(columns: (9fr, 4fr))[```typ
  #set math.equation(
    numbering: it => numbering("(a)", it),
  )
  $ E = m upright(c)^2 $<test-ref-right>

  测试引用编号 @test-ref-right。
  ```]

