#import "@preview/tablex:0.0.9": tablex, rowspanx, colspanx, hlinex, vlinex
#let cellx(
  content,
  x: auto,
  y: auto,
  rowspan: 1,
  colspan: 1,
  fill: auto,
  align: auto,
  inset: 5pt,
  fit-spans: auto,
  fontfamily: "libertinus serif",
  size: 10pt,
) = (
  tablex-dict-type: "cell",
  content: text(font: fontfamily, size: size)[#content],
  rowspan: rowspan,
  colspan: colspan,
  align: align,
  fill: fill,
  inset: inset,
  fit-spans: fit-spans,
  x: x,
  y: y,
)
#let t = {
  figure(
    tablex(
      inset: 2pt,
      columns: (auto, auto, auto, auto, auto, auto),
      align: center + horizon,
      auto-vlines: false,
      auto-hlines: false,

      hlinex(stroke: 1pt),

      rowspanx(3)[*Methods*],


      cellx()[*ITS*],
      hlinex(stroke: 0.8pt),
      cellx()[*OTS*],
      cellx()[*REDIDE-6K*],
      cellx()[*RS-Haze*],
      rowspanx(2)[*Overhead*],
      (),
      cellx()[SOTS-indoor],
      cellx()[SOTS-outdoor],
      cellx()[SOTS-mix],
      cellx()[RS-Haze-mix],
      hlinex(stroke: 0.8pt),
      (),
      (),
      cellx()[PSNR#h(5pt)SSIM],
      cellx()[PSNR#h(5pt)SSIM],
      cellx()[PSNR#h(5pt)SSIM],
      cellx()[PSNR#h(5pt)SSIM],
      cellx()[\#Params MACs],

      hlinex(stroke: 1pt),

      cellx()[(TPAMI’10) DCP],
      cellx()[16.62#h(5pt) 0.818],
      cellx()[19.13#h(5pt) 0.815],
      cellx()[17.88#h(5pt) 0.816],
      cellx()[17.86#h(5pt) 0.734],
      cellx()[-#h(40pt)-],

      cellx()[(TIP’16) DehazeNet],
      cellx()[19.82#h(5pt) 0.821],
      cellx()[24.75#h(5pt) 0.927],
      cellx()[21.02#h(5pt) 0.870],
      cellx()[23.16#h(5pt) 0.816],
      cellx()[0.009M#h(5pt) 0.581G],

      cellx()[(ECCV’16) MSCNN],
      cellx()[19.84#h(5pt) 0.833],
      cellx()[22.06#h(5pt) 0.908],
      cellx()[20.31#h(5pt) 0.863],
      cellx()[22.80#h(5pt) 0.823],
      cellx()[0.008M#h(5pt) 0.525G],

      cellx()[(ICCV’17) AOD-Net],
      cellx()[20.51#h(5pt) 0.816],
      cellx()[24.14#h(5pt) 0.920],
      cellx()[20.27#h(5pt) 0.855],
      cellx()[24.90#h(5pt) 0.830],
      cellx()[0.002M#h(5pt) 0.115G],

      cellx()[(CVPR’18) GFN],
      cellx()[22.30#h(5pt) 0.880],
      cellx()[21.55#h(5pt) 0.844],
      cellx()[23.52#h(5pt) 0.905],
      cellx()[29.24#h(5pt) 0.910],
      cellx()[0.499M#h(5pt) 14.94G],

      cellx()[(WACV’19) GCANet],
      cellx()[30.23#h(5pt) 0.980],
      cellx()[-#h(30pt)-],
      cellx()[25.09#h(5pt) 0.923],
      cellx()[34.41#h(5pt) 0.949],
      cellx()[0.702M#h(5pt) 18.41G],

      cellx()[(ICCV’19) GridDehazeNet],
      cellx()[32.16#h(5pt) 0.984],
      cellx()[30.86#h(5pt) 0.982],
      cellx()[25.86#h(5pt) 0.944],
      cellx()[36.40#h(5pt) 0.960],
      cellx()[0.956M#h(5pt) 21.49G],

      cellx()[(CVPR’20) MSBDN],
      cellx()[33.67#h(5pt) 0.985],
      cellx()[33.48#h(5pt) 0.982],
      cellx()[28.56#h(5pt) 0.966],
      cellx()[38.57#h(5pt) 0.965],
      cellx()[31.35M#h(5pt) 41.54G],

      cellx()[(ECCV’20) PFDN],
      cellx()[32.68#h(5pt) 0.976],
      cellx()[-#h(30pt)-],
      cellx()[28.15#h(5pt) 0.962],
      cellx()[36.04#h(5pt) 0.955],
      cellx()[11.27M#h(5pt) 50.46G],

      cellx()[(AAAI’20) FFA-Net],
      cellx()[36.39#h(5pt) 0.989],
      cellx()[33.57#h(5pt) 0.984],
      cellx()[29.96#h(5pt) 0.973],
      cellx()[39.39#h(5pt) 0.969],
      cellx()[4.456M#h(5pt) 287.8G],

      cellx()[(CVPR’21) AECR-Net],
      cellx()[37.17#h(5pt) 0.990],
      cellx()[-#h(30pt)-],
      cellx()[28.52#h(5pt) 0.964],
      cellx()[35.69#h(5pt) 0.959],
      cellx()[2.611M#h(5pt) 52.20G],

      cellx()[DehazeFormer-T],
      cellx()[35.15#h(5pt) 0.989],
      cellx()[33.71#h(5pt) 0.982],
      cellx()[30.36#h(5pt) 0.973],
      cellx()[39.11#h(5pt) 0.968],
      cellx()[0.686M#h(5pt) 6.658G],

      cellx()[DehazeFormer-S],
      cellx()[36.82#h(5pt) 0.992],
      cellx()[34.36#h(5pt) 0.983],
      cellx()[30.62#h(5pt) 0.976],
      cellx()[39.57#h(5pt) 0.970],
      cellx()[1.283M#h(5pt) 13.13G],

      cellx()[DehazeFormer-B],
      cellx()[37.84#h(5pt) 0.994],
      cellx()[34.95#h(5pt) 0.984],
      cellx()[31.45#h(5pt) 0.980],
      cellx()[39.87#h(5pt) 0.971],
      cellx()[2.514M#h(5pt) 25.79G],

      cellx()[DehazeFormer-M],
      cellx()[38.46#h(5pt) 0.994],
      cellx()[34.29#h(5pt) 0.983],
      cellx()[30.89#h(5pt) 0.977],
      cellx()[39.71#h(5pt) 0.971],
      cellx()[4.634M#h(5pt) 48.64G],

      cellx()[DehazeFormer-L],
      cellx()[40.05#h(5pt) 0.996],
      cellx()[-#h(30pt)-],
      cellx()[-#h(30pt)-],
      cellx()[-#h(30pt)-],
      cellx()[25.44M#h(5pt) 279.7G],

      cellx()[Ours],
      cellx()[40.17#h(5pt) 0.996],
      cellx()[34.92#h(5pt) 0.984],
      cellx()[31.92#h(5pt) 0.982],
      cellx()[39.88#h(5pt) 0.972],
      cellx()[19.25M#h(5pt) 173.5G],
      hlinex(stroke: 1pt),
    ),
    caption: "Hello",
  )
}

#let ot = {
  set table.cell(inset: (x: 2pt, y: 3pt))
  show table.cell: it => {
    align(center + horizon)[
      #scale(y: 80%)[
        #it
      ]
    ]
  }


  figure(
    table(
      columns: 6,
      stroke: none,
      table.hline(),
      table.header()[
        #align(center + horizon)[
          Method
        ]
      ][
        #grid(
          columns: 1, rows: 1,
          row-gutter: 5pt,
          grid.cell()[ITS],
          grid.cell()[SOTS-indoor],
          grid.cell()[PSNR SSIM]
        )
      ][
        #grid(
          columns: 1, rows: 1,
          row-gutter: 5pt,
          grid.cell()[OTS],
          grid.cell()[SOTS-outdoor],
          grid.cell()[PSNR SSIM]
        )
      ][
        #grid(
          columns: 1, rows: 1,
          row-gutter: 5pt,
          grid.cell()[RESIDE-6K],
          grid.cell()[SOTS-mix],
          grid.cell()[PSNR SSIM]
        )
      ][
        #grid(
          columns: 1, rows: 1,
          row-gutter: 5pt,
          grid.cell()[RS-Haze],
          grid.cell()[RS-Haze-mix],
          grid.cell()[PSNR SSIM]
        )][
        #align(center + horizon)[
          Overhead
        ]
      ],

      table.hline(),

      [(TPAMI’10) DCP],
      [16.62#h(5pt) 0.818],
      [19.13#h(5pt) 0.815],
      [17.88#h(5pt) 0.816],
      [17.86#h(5pt) 0.734],
      [-#h(40pt)-],

      [(TIP’16) DehazeNet],
      [19.82#h(5pt) 0.821],
      [24.75#h(5pt) 0.927],
      [21.02#h(5pt) 0.870],
      [23.16#h(5pt) 0.816],
      [0.009M#h(5pt) 0.581G],

      [(ECCV’16) MSCNN],
      [19.84#h(5pt) 0.833],
      [22.06#h(5pt) 0.908],
      [20.31#h(5pt) 0.863],
      [22.80#h(5pt) 0.823],
      [0.008M#h(5pt) 0.525G],

      [(ICCV’17) AOD-Net],
      [20.51#h(5pt) 0.816],
      [24.14#h(5pt) 0.920],
      [20.27#h(5pt) 0.855],
      [24.90#h(5pt) 0.830],
      [0.002M#h(5pt) 0.115G],

      [(CVPR’18) GFN],
      [22.30#h(5pt) 0.880],
      [21.55#h(5pt) 0.844],
      [23.52#h(5pt) 0.905],
      [29.24#h(5pt) 0.910],
      [0.499M#h(5pt) 14.94G],

      [(WACV’19) GCANet],
      [30.23#h(5pt) 0.980],
      [-#h(30pt)-],
      [25.09#h(5pt) 0.923],
      [34.41#h(5pt) 0.949],
      [0.702M#h(5pt) 18.41G],

      [(ICCV’19) GridDehazeNet],
      [32.16#h(5pt) 0.984],
      [30.86#h(5pt) 0.982],
      [25.86#h(5pt) 0.944],
      [36.40#h(5pt) 0.960],
      [0.956M#h(5pt) 21.49G],

      [(CVPR’20) MSBDN],
      [33.67#h(5pt) 0.985],
      [33.48#h(5pt) 0.982],
      [28.56#h(5pt) 0.966],
      [38.57#h(5pt) 0.965],
      [31.35M#h(5pt) 41.54G],

      [(ECCV’20) PFDN],
      [32.68#h(5pt) 0.976],
      [-#h(30pt)-],
      [28.15#h(5pt) 0.962],
      [36.04#h(5pt) 0.955],
      [11.27M#h(5pt) 50.46G],

      [(AAAI’20) FFA-Net],
      [36.39#h(5pt) 0.989],
      [33.57#h(5pt) 0.984],
      [29.96#h(5pt) 0.973],
      [39.39#h(5pt) 0.969],
      [4.456M#h(5pt) 287.8G],

      [(CVPR’21) AECR-Net],
      [37.17#h(5pt) 0.990],
      [-#h(30pt)-],
      [28.52#h(5pt) 0.964],
      [35.69#h(5pt) 0.959],
      [2.611M#h(5pt) 52.20G],

      [DehazeFormer-T],
      [35.15#h(5pt) 0.989],
      [33.71#h(5pt) 0.982],
      [30.36#h(5pt) 0.973],
      [39.11#h(5pt) 0.968],
      [0.686M#h(5pt) 6.658G],

      [DehazeFormer-S],
      [36.82#h(5pt) 0.992],
      [34.36#h(5pt) 0.983],
      [30.62#h(5pt) 0.976],
      [39.57#h(5pt) 0.970],
      [1.283M#h(5pt) 13.13G],

      [DehazeFormer-B],
      [37.84#h(5pt) 0.994],
      [34.95#h(5pt) 0.984],
      [31.45#h(5pt) 0.980],
      [39.87#h(5pt) 0.971],
      [2.514M#h(5pt) 25.79G],

      [DehazeFormer-M],
      [38.46#h(5pt) 0.994],
      [34.29#h(5pt) 0.983],
      [30.89#h(5pt) 0.977],
      [39.71#h(5pt) 0.971],
      [4.634M#h(5pt) 48.64G],

      [DehazeFormer-L], [40.05#h(5pt) 0.996], [-#h(30pt)-], [-#h(30pt)-], [-#h(30pt)-], [25.44M#h(5pt) 279.7G],
      [UShaped Mamba],
      [*40.17*#h(5pt) 0.996],
      [34.92#h(5pt) 0.984],
      [31.92#h(5pt) 0.982],
      [39.88#h(5pt) 0.972],
      [19.25M#h(5pt) 173.5G],
      [Ours],
      [*40.17*#h(5pt) 0.996],
      [34.92#h(5pt) 0.984],
      [31.92#h(5pt) 0.982],
      [39.88#h(5pt) 0.972],
      [19.25M#h(5pt) 173.5G],
      table.hline(),
    ),
    caption: "Quantitative comparison of various dehazing methods trained on the RE-SIDE datasets.",
  )
}
