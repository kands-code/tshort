# 使用标准字体，防止系统字体干扰
typst compile "src/tshort.typ" \
    --font-path "fonts/" \
    --ignore-system-fonts \
    "tshort.pdf"
