#set heading(numbering: "I. A. 1. a. i")
#show raw: set text(font: ((name: "UbuntuMono Nerd Font Mono", covers: "latin-in-cjk"), (name: "BiauKaiTC")))
#show ref: set text(fill: blue)
#set math.equation(numbering: "(1)")
#let desc(content, color: rgb(248, 233, 221)) = {
  return block(inset: 6pt, fill: color, width: 100%, radius: 4pt)[#content]
}
#let todo(content, color: rgb("#a6d189")) = {
  return block(inset: 6pt, fill: color, width: 100%, radius: 4pt)[#content]
}
#set page(columns: 2)

#set par(
  leading: 1em,
  first-line-indent: (amount: 2em, all: true),
  justify: true,
)

#outline()

#block(
  fill: rgb("#b5d1eb"),
  inset: 6pt,
  radius: 4pt,
  width: 100%,
)[This document is due to collect the documentation support for the `GMANMBANet`.]

#pagebreak()

#heading(numbering: none, outlined: true)[Abstract]

// #todo()[
//   - What is the research used for? (Introduce the Object, Normally a practical something: a medical neural)
//   - The disadvantage of existing methods. (Expensive, Cost, Low accuracy)
//   - In this paper, we introduce XXX: a …
//     - It include …
//     - Firstly(Initially), we proposed a method
//     - Meanwhile, we noticed the previous method can not achieve the expected performance.
//       - Thus we propose a … to tackle this.
//     - Besides, we integrating … to our model to improve something/to tackle this challenge
//     - Extensive experiments show that our … significantly outperforms the state-of-the-art methods on …datasets without increasing the cost.
//     - To mitigate the … caused by …
// ]

Single-image dehazing poses a significant challenge in computer vision, essential for improving scene understanding in adverse atmospheric conditions, with relevance to applications like autonomous navigation and surveillance. Traditional prior-based methods and modern deep learning techniques often face difficulties in generalization, computational efficiency, or maintaining fidelity across varied haze distributions. In this paper, we present GMANMBANet, a hybrid architecture that combines the Graph Multi-Attention Network (GMAN) with a Mamba-inspired structured state-space modeling framework. Our method utilizes GMAN’s graph-based attention to capture detailed local structural dependencies and Mamba’s selective state-space dynamics to efficiently model long-range contextual relationships across broad spatial regions. We introduce a GMamba block to enhance feature extraction by balancing local coherence and global context, addressing limitations of prior approaches in managing non-uniform haze. This framework is further refined with residual connections and multi-scale feature fusion to reduce information loss and improve detail recovery. Extensive experiments on benchmark datasets, including RESIDE and HazeRD, show that GMANMBANet delivers strong performance, achieving high peak signal-to-noise ratio (PSNR) and structural similarity index (SSIM) scores while keeping computational demands low compared to state-of-the-art methods. This approach offers a practical balance between perceptual quality and resource efficiency, making it suitable for robust, real-time image dehazing in challenging environments.

= Introduction

Haze, as a prevalent atmospheric phenomenon, not only disrupts daily human activities and impairs visual perception but also poses significant threats to traffic safety under severe conditions. In the field of computer vision, the presence of haze substantially degrades image quality, leading to diminished model performance in high-level visual tasks. This degradation further propagates through machine perception systems, potentially compromising the reliability of critical applications such as autonomous driving. Consequently, the development of robust and efficient image dehazing algorithms is imperative to mitigate these adverse effects and enhance visual scene interpretation in complex environments.

Single-image dehazing focuses on recovering a clear scene from a hazy observation, inherently posing a severely ill-posed inverse problem@liu2019genericmodelagnosticconvolutionalneural@he2011. Traditional methods are primarily grounded in physical models and leverage various sharp image priors to constrain the solution space. However, these approaches heavily rely on manually designed priors, which often fail to generalize well to real-world haze conditions due to their limited capacity to capture the intricate and diverse nature of atmospheric scattering effects@ju2017@ren2016@chen2018gatedcontextaggregationnetwork@tong2024hazeawareattentionnetworksingleimage. In recent developments, deep learning methodologies have demonstrated considerable efficacy, achieving promising results across a wide range of tasks, especially image dehazing methods based on Transformer’s architecture@Song_2023.

Although these Transformer-based model approaches achieve state-of-the-art results on the single image dehazing task, their models typically have a large number of parameters and are computationally expensive. Recently, state space sequence models (SSMs)@albert2023phd@gu2021combiningrecurrentconvolutionalcontinuoustime, particularly the structured state space sequence models (S4)@gu2022efficientlymodelinglongsequences, have emerged as a highly efficient and effective architectural component for deep network design. These models have demonstrated state-of-the-art performance in the analysis of continuous long-sequence data, setting new benchmarks in sequence modeling tasks@goel2022itsrawaudiogeneration@gu2022efficientlymodelinglongsequences.

Recently, Mamba@gu2024mambalineartimesequencemodeling@dao2024transformersssmsgeneralizedmodels has demonstrated exceptional capabilities in image and video classification and medical image segmentation, making it well-suited for vision tasks such as single image dehazing, where capturing global context is crucial for restoring fine details and improving perceptual quality@nguyen2022s4ndmodelingimagesvideos@islam2023longmovieclipclassification@dosovitskiy2021imageworth16x16words@liu2021swintransformerhierarchicalvision.

Inspired by GMAN@zheng2019gmangraphmultiattentionnetwork, U-Mamba@ma2024umambaenhancinglongrangedependency, UVM-Net@zheng2024ushapedvisionmambasingle and Mamba-UNet@wang2024mambaunetunetlikepurevisual, we propose a novel model that integrates GMAN and U-Mamba, leveraging their complementary strengths in long-range dependency modeling and spatial relationship learning.Specifically, U-Mamba efficiently captures global contextual information through state-space modeling, enabling robust feature extraction across extended spatial scales. Meanwhile, GMAN focuses on local structural dependencies using graph attention mechanisms, facilitating precise region-wise feature enhancement. This synergy ensures that the dehazed images retain their overall structural integrity while effectively restoring fine-grained details, thereby improving both perceptual quality and structural consistency.

#figure(
  image("GMamba-Net-Structure.png"),
  caption: "GMamba-Net Structure",
)

= Background

== Haze Formation and Physical Models

In computer vision, the single image dehazing problem is usually described based on physical models. The Atmospheric Scattering Model (ASM) is the cornerstone for understanding haze formation in images@5567108. It mathematically describes the observed hazy image intensity $I(x)$ at pixel $x$ as:

$ I(x)=J(x)t(x)+A(1-t(x)) $

Here, $J(x)$ represents the clear image intensity,$A$ is the global atmospheric light (airlight), and $t(x)$ is the transmission map, indicating the portion of light that reaches the camera without scattering. The transmission map is further defined by:

$ t(x)=e^(-beta d(x)) $

where $beta$ is the scattering coefficient and $d(x)$ is the scene depth at pixel $x$. This model highlights the ill-posed nature of image dehazing, as estimating $J(x)$ requires determining both $t(x)$ and $A$, with multiple combinations possible for a given $I(x)$. Various methods leverage priors or assumptions to address this challenge, forming the basis for both traditional and modern dehazing approaches.

== Traditional Image Dehazing Methods

Traditional single-image dehazing techniques predominantly rely on physical models and image priors to constrain the solution space and mitigate the inherent ill-posed nature of the problem. Among these, the Dark Channel Prior (DCP)@5567108 is one of the most widely adopted methods, leveraging the statistical observation that at least one color channel in a local patch of haze-free images exhibits minimal intensity. This property allows for effective estimation of the transmission map, facilitating atmospheric scattering removal. However, DCP-based methods suffer from limitations in bright regions, such as the sky, where the dark channel assumption does not hold, often leading to color distortions and artifacts.

In addition to model-driven approaches, color balance and contrast enhancement techniques have been explored for haze removal by adjusting the global and local color distributions to enhance image visibility. While these methods can improve perceptual clarity, they lack an explicit modeling of the haze formation process, leading to potential over-enhancement and failure to generalize across varying haze conditions@7271737.

Graph-based optimization methods, such as Markov Random Fields (MRF) and Conditional Random Fields (CRF), have also been employed to refine dehazing results by enforcing spatial consistency in estimated transmission maps. These techniques improve edge preservation and artifact reduction by incorporating structural constraints. However, their reliance on manually designed priors and fixed parameters limits adaptability to diverse real-world scenarios.

Despite the progress made by traditional dehazing methods, their dependence on handcrafted priors and assumptions often results in suboptimal performance in complex atmospheric conditions. These limitations have motivated the transition toward deep learning-based approaches.

Recent advances in deep learning have led to significant improvements in single-image dehazing, with methods categorized into CNN-based models and attention-driven architectures@Rahmawati2024126142.

Early convolutional neural network (CNN)-based approaches, such as DehazeNet@Cai_2016, leverage multi-scale feature extraction to estimate transmission maps and reconstruct haze-free images. Subsequent works, such as AOD-Net@8237773, integrate the physical haze formation model within an end-to-end trainable framework, directly predicting the dehazed output without requiring intermediate estimations. While CNN-based architectures have demonstrated strong performance, their limited receptive fields hinder their ability to capture long-range dependencies, particularly in images with non-uniform haze distributions.

To address these shortcomings, attention-based dehazing models, including DehazeFormer@Song_2023, have been proposed. These architectures employ Transformer-based mechanisms, such as Swin Transformer@liu2021swintransformerhierarchicalvision blocks, to capture long-range dependencies and enable adaptive feature learning across multiple scales. By leveraging global attention, these methods achieve state-of-the-art performance in haze removal. However, their high computational complexity poses challenges for real-time applications and deployment on resource-constrained devices.

The efficiency limitations of Transformer-based dehazing models have driven research toward more lightweight architectures. Emerging approaches based on State Space Models (SSMs)@albert2023phd offer a promising alternative by capturing long-range dependencies while maintaining computational efficiency. These advancements pave the way for the development of dehazing models that balance expressiveness and real-time feasibility, enabling robust performance across diverse atmospheric conditions.

= Preliminaries

== Related Work

State Space Models (SSMs)@albert2023phd are mathematical models used to describe system behavior over time through state variables and their transitions. In machine learning, SSMs have been adapted for sequence modeling, providing an efficient alternative to Transformers for handling long sequences.

=== Structured State Space Models (S4)

Structured State Space Models (S4)@gu2022efficientlymodelinglongsequences, introduced by Gu et al., leverage a structured state space formulation to efficiently model sequential data, achieving state-of-the-art performance in tasks such as language modeling and time-series forecasting. By integrating principles from continuous-time dynamics, recurrent architectures, and convolutional mechanisms, S4 enables effective long-range dependency modeling while maintaining computational efficiency. This hybrid approach allows for improved sequence representation and scalability, making it a powerful tool for various deep learning applications.

=== Mamba

Mamba, proposed by Gu and Dao, is a selective State Space Model (SSM)@gu2024mambalineartimesequencemodeling that dynamically adjusts its parameters based on input content, enabling adaptive information propagation and selective forgetting across sequences. This mechanism enhances its capacity to capture global dependencies while maintaining computational efficiency. Mamba has demonstrated superior performance in various vision tasks, including image and video classification, medical image segmentation, and dynamic scene understanding.

In the context of image processing, Mamba can be adapted by modeling images as sequences of patches or pixels, effectively capturing long-range dependencies crucial for tasks such as image dehazing. Its recent applications in image compression and deraining highlight its potential for dehazing, offering a promising direction for robust and efficient haze removal methods@QIN2024110.

SSMs like Mamba offer a balance between performance and computational efficiency, addressing the limitations of Transformer-based models in vision tasks.

=== Graph Multi-Attention Network (GMAN)

Initially introduced by Zheng et al. for traffic prediction, the Graph Multi-Attention Network (GMAN) integrates Graph Convolutional Networks (GCNs) with multi-head attention mechanisms to capture complex spatio-temporal dependencies@zheng2019gmangraphmultiattentionnetwork. While originally designed for sequential data modeling, its graph-based architecture can be effectively adapted for image dehazing.

In the context of dehazing, GMAN can represent an image as a graph, where pixels serve as nodes and edges encode similarity relationships. By leveraging attention mechanisms, the model dynamically prioritizes relevant regions, enhancing haze removal while preserving fine structural details. This approach offers a flexible and effective way to integrate spatial relationships and global context for improved dehazing performance@cmc-202202-3339.

== Problem Formulation

// #desc(color: rgb("#d5e5fc"))[What we wanna(gonna) to do.]

Single-image dehazing constitutes an inherently under-constrained inverse problem within the domain of computer vision, aiming to reconstruct a haze-free scene radiance $J(x)$ from a single hazy observation $I(x)$. This challenge is mathematically encapsulated by the Atmospheric Scattering Model (ASM), expressed as:

$ I(x)=J(x)t(x)+A(1-t(x)) $

where $I(x)$ denotes the observed hazy image intensity at pixel $x$, $J(x)$ represents the latent haze-free scene radiance, $A$ is the global atmospheric light, and $t(x)$ signifies the transmission map, which quantifies the fraction of light that reaches the sensor without scattering. The transmission map $t(x)$ is further parameterized by the exponential decay function: $t(x)=e^(-beta d(x))$, where $beta$ is the atmospheric scattering coefficient and $d(x)$ denotes the scene depth at pixel $x$. The objective of dehazing is to invert this model to estimate $J(x)$, given only $I(x)$, necessitating the simultaneous recovery of $t(x)$ and $A$. However, the multiplicity of feasible solutions for $t(x)$ and $A$ that satisfy the equation renders this task ill-posed, as the system lacks sufficient constraints to uniquely determine the unknowns from a single input.

=== Challenges in Single-Image Dehazing

Traditional dehazing methodologies, such as those predicated on the Dark Channel Prior (DCP), impose hand-crafted statistical priors to regularize the solution space. While effective in controlled scenarios, these approaches exhibit limited generalization to diverse real-world haze distributions due to their reliance on assumptions that may not hold across varying atmospheric conditions, illumination profiles, or scene complexities. In contrast, contemporary deep learning paradigms, particularly those leveraging Transformer architectures, have demonstrated superior capacity to model global contextual dependencies, albeit at the expense of substantial computational overhead and parameter complexity. This trade-off motivates the exploration of alternative frameworks that balance efficacy with efficiency, particularly for applications demanding real-time performance or deployment on resource-constrained platforms.


In this research, we formulate the single-image dehazing problem as an optimization task aimed at designing a hybrid deep learning architecture—termed GMANMBANet—that synergistically integrates the Graph Multi-Attention Network (GMAN) and a Mamba-inspired state-space modeling framework. Our goal is to devise a model capable of capturing both local structural coherence and long-range contextual dependencies within hazy images, thereby enhancing the restoration of fine-grained details and global scene integrity without incurring prohibitive computational costs. Specifically, we seek to address the following challenges:

- Robustness to Heterogeneous Haze Conditions: Existing methods often falter in scenarios with non-uniform haze densities or complex atmospheric scattering effects, necessitating a model that adaptively learns haze characteristics across diverse spatial extents.

- Preservation of Structural and Textural Fidelity: The dehazing process must mitigate artifacts, color distortions, and edge degradation, ensuring that the reconstructed $J(x)$ retains perceptual fidelity and structural consistency with the underlying scene.

- Computational Efficiency: While Transformer-based models excel in capturing global dependencies, their quadratic complexity with respect to input resolution renders them impractical for high-resolution dehazing tasks. We aim to devise an architecture that scales linearly, leveraging the efficiency of state-space models.

=== GManmbaNet

To address these challenges, we propose GMANMBANet, a hybrid deep learning architecture that integrates Graph Multi-Attention Network (GMAN) and Mamba-based structured state-space modeling. This framework is designed to capture both local structural coherence and global contextual dependencies, thereby enhancing fine-grained detail restoration without excessive computational costs. Specifically, GMAN’s graph-based attention mechanisms effectively model spatial relationships, while Mamba’s state-space dynamics facilitate long-range dependency modeling in a computationally efficient manner.

We formulate the dehazing objective as a feature reconstruction problem, where the model learns a mapping function $F:I(x)→J(x)$, parameterized by a set of trainable weights $theta$. The network is optimized to minimize a composite loss function that balances pixel-wise fidelity and perceptual quality, defined as:

$
  #math.cal("L") (theta) = alpha dot #math.cal("L")_(M S"-"S S I M) (J(x), hat(J) (x)) + (1- alpha) dot #math.cal("L")_(L 1)(J(x), hat(J) (x))
$

where $hat(J)(x)=F(I(x);θ)$ is the predicted haze-free image. The L1 loss $#math.cal("L")_(L 1)$ ensures pixel-wise accuracy by minimizing the absolute difference between predicted and ground-truth images:

$ #math.cal("L")_(L 1)=1 / N sum_(i=1)^N|y_i - hat(y_i)| $

where $y_i$ and $hat(y)_i$ the pixel values of the ground truth and predicted images, respectively, and $N$ is the total number of pixels.

To incorporate perceptual quality, we employ Multi-Scale Structural Similarity (MS-SSIM)@ABDELSALAMNASR2017399@mss, an extension of SSIM@1284395@nilsson2020understandingssim that evaluates luminance, contrast, and structure similarity across multiple resolutions:

$
  M S"-"S S I M(y, hat(y)) = product_(j=1)^M [l_j (y, hat(y))^(beta_j) dot c_j (y, hat(y))^(gamma_j) dot s_j (y, hat(y))^(delta_j)]
$

where $beta_j$, $gamma_j$, $delta_j$ regulate the relative contributions of luminance, contrast, and structure at each scale. The final MS-SSIM loss is computed as:

$ #math.cal("L")_(M S"-"S S I M) = 1 - M S"-"S S I M(y, hat(y)) $

The trade-off between pixel-wise accuracy and perceptual similarity is controlled by the weighting factor $alpha$, ensuring balanced optimization of local detail preservation and global structural coherence@ABDELSALAMNASR2017399.

// We propose to reformulate the dehazing objective as a composite feature extraction and reconstruction problem. Let $F:I(x)→J(x)$ represent the mapping function embodied by GMANMBANet, parameterized by a set of learnable weights $theta$. The model is tasked with minimizing a composite loss function that balances pixel-wise reconstruction accuracy and perceptual quality, defined as:


// where $hat(J)(x)=F(I(x);θ)$ is the predicted haze-free image, $#math.cal("L")_(L 1)$denotes the Mean Absolute Error (MAE) for pixel-level fidelity, and $#math.cal("L")_(M S -S S I M)$ represents the Multi-Scale Structural Similarity loss for perceptual coherence. The weighting factor $alpha$ modulates the trade-off between these objectives, ensuring that $F$ optimizes both local detail recovery and global structural preservation.

// By integrating GMAN’s graph-based attention mechanisms with Mamba’s selective state-space dynamics, GMANMBANet aims to exploit complementary strengths: the former excels at modeling localized spatial relationships and enhancing region-specific features, while the latter efficiently captures long-range dependencies across the image domain. This hybrid approach seeks to overcome the limitations of prior methods—such as the DCP’s sensitivity to bright regions and Transformer’s computational burden—while achieving state-of-the-art dehazing performance on benchmark datasets. Ultimately, our formulation endeavors to advance the field of single-image dehazing by delivering a robust, efficient, and perceptually superior solution tailored to real-world vision applications.

= Methodology

The GMamba block is based on the encoder-decoder network architecture, designed to efficiently capture both local features and long-range dependencies. In the following, we first introduce the Mamba block and then provide a detailed explanation of the GMamba framework.

// #desc(color: rgb("d5e5fc"))[
//   - Overview of our methods
//   - Stage of processing(Multiple stage)
//     - For example: Pre-training→Fine-tuning
// ]
== GMamba Block


Mamba has demonstrated remarkable performance across various discrete data types, but its application to image dehazing remains relatively unexplored. In this work, we leverage Mamba's efficient linear scaling capabilities to enhance the long-range dependency modeling inherent in traditional GMamba Block architectures.

#grid(
  columns: (1fr, 1fr),
  [
    #figure(
      image("UVM-Net.png", height: 30%),
      caption: [*UNet-Mamba Block*],
    )<figure1>
  ], // 添加Flatten
  [#figure(
      image("ResBlock.png", height: 30%),
      caption: [*Residual Block*],
    )<figure2>
  ],
)

As illustrated in @figure1, the convolutional block consists of a standard convolutional layer with a kernel size of 3 × 3, followed by a #strike()[Leaky ReLU] activation function.

The image features, initially of shape $(B, C, H, W)$, are subsequently #strike()[flattened] and transposed into a shape of $(B, L, C)$, where $L=H×W×D$. After passing through Layer Normalization, the features are processed by the Mamba block, which includes two parallel branches.

In the first branch, the feature representations are initially expanded to a shape of $(B, C, L)$ via an SSM layer. Subsequently, a roll operation is applied, transforming the features into a $(B, L, C)$ format before being processed by another SSM layer. In the second branch, the features are similarly expanded to $(B, L, C)$ through an SSM layer. These features are then subjected to a softmax operation, generating an attention map that captures the relative importance of different spatial locations. The outputs from both branches are fused using the Hadamard product to effectively integrate the complementary information. Finally, the merged features are projected back to their original shape $(B, L, C)$, followed by a reshaping and transposition operation to restore the feature map to $(B, C, H, W)$.

// #desc()[
//   Add a chart of B, C, H, W transposition.
// ]

The model architecture adheres to the standard U-Net framework for feature map processing, maintaining consistency in both down-sampling and up-sampling operations. Notably, bilinear interpolation is employed for up-sampling, ensuring smooth feature reconstruction while preserving spatial coherence.

== GMamba Net

@figure3 illustrates the proposed GMamba Net, a hybrid deep learning architecture designed to enhance feature extraction and long-range dependency modeling for image restoration tasks. The network incorporates both convolutional processing for local feature refinement and state-space modeling to capture global dependencies. The architecture follows an encoder-decoder framework with residual connections to preserve information flow. Here is the main components:

#figure(
  image("GMamba-Net.png"),
  caption: "GMamba Net",
)<figure3>

=== Convolutional Feature Extraction

The input image undergoes a series of convolutional layers to extract hierarchical feature representations. These layers refine local textures and edge details essential for fine-grained restoration.

=== Downsampling & Residual Blocks

Progressive downsampling layers reduce spatial resolution while increasing feature depth, allowing the network to focus on high-level abstractions. Residual blocks (ResBlocks) facilitate deeper feature transformation while mitigating gradient vanishing issues. The @figure2 illustrates the structure of Resudial Blocks.

=== Upsampling & Reconstruction

The network incorporates upsampling layers to restore the spatial resolution. Additional convolutional layers refine the upsampled features before merging with the original input.

=== GMamba Block for Long-Range Dependencies

To integrate global contextual information, we introduce a GMamba block, leveraging the efficiency of Mamba’s state-space models (SSMs) for sequence modeling. The downsampling before GMamba ensures a computationally efficient representation, allowing the model to capture spatially long-range dependencies. After processing through GMamba, the extracted global features are incorporated back into the main reconstruction pipeline.

=== Residual Merging & Non-Linearity

Features from different branches are merged through element-wise summation$plus.circle$, preserving both local and global information. A ReLU activation function enhances non-linearity, improving feature expressiveness.


= Experiments

The experimental setup strictly follows the configuration of Dehazeformer@Song_2023, including the number of iterations, learning rate, and batch size. This choice is motivated by the fact that Dehazeformer represents the current state-of-the-art (SOTA) in single-image dehazing, and our model shares a similar architectural structure. For implementation, we utilized PyTorch 2.6 and conducted experiments on an NVIDIA RTX 4090 GPU with 24 GB of VRAM. To evaluate computational efficiency, we report the number of parameters (\#Param) and multiply-accumulate operations (MACs), with MACs computed on 256 × 256 input images.

== Experiment Setting

#block(height: 50%, width: 100%, below: 30pt)[
  #figure(
    grid(
      columns: (1fr, 1fr, 1fr),
      rows: (1fr, 1fr, 1fr),
      gutter: 4pt,
      image("hazy-0051_0.95_0.12.jpg", fit: "contain", height: 100%),
      image("dehazed-0051_0.95_0.12.png", fit: "contain", height: 100%),
      image("gt-0051_0.8_0.2.jpg", fit: "contain", height: 100%),

      image("hazy-0016_0.8_0.08.jpg", fit: "contain", height: 100%),
      image("dehazed-0016_0.8_0.08.png", fit: "contain", height: 100%),
      image("gt-0016_0.8_0.08.jpg", fit: "contain", height: 100%),

      image("hazy-0030_0.95_0.12.jpg", fit: "contain", height: 100%),
      image("dehazed-0030_0.95_0.12.png", fit: "contain", height: 100%),
      image("gt-0030_0.95_0.12.jpg", fit: "contain", height: 100%),
    ),
    caption: "Hazy, Ours, Ground Truth",
  )
]

== Quantitative Performance

#import "table.typ": t, ot

#ot


= Conclusion

In this work, we have introduced GMANMBANet, a hybrid architecture designed for single-image dehazing that tackles the challenges of robustness, perceptual quality, and computational efficiency in computer vision. By combining the Graph Multi-Attention Network (GMAN) with a Mamba-inspired structured state-space modeling framework, our approach leverages graph-based attention to capture local structural details and state-space dynamics to model long-range contextual relationships. This integration allows GMANMBANet to address limitations seen in traditional prior-based techniques and resource-heavy Transformer models. Comprehensive evaluations on benchmark datasets such as RESIDE and HazeRD demonstrate that GMANMBANet delivers competitive performance, achieving high PSNR and SSIM scores while maintaining a reduced computational burden compared to existing methods. Its linear scaling with input resolution further enhances its suitability for real-time applications on constrained devices, such as those in autonomous systems. These results highlight the potential of merging graph-based and state-space approaches for effective dehazing, offering a practical solution for improving visual clarity in hazy conditions with relevance to various vision tasks.


#bibliography("papers.bib")

#pagebreak()

= Tools

== Chart Color

#import "color.typ": CatppuccinFrappé, CatppuccinLatte, CatppuccinMacchiato, CatppuccinMocha, My

#My

#CatppuccinLatte
#CatppuccinFrappé
#CatppuccinMacchiato
#CatppuccinMocha


== GPT Prompt I used

#block(fill: rgb("#feccab"), inset: 6pt, radius: 4pt)[

  #raw("你是一個計算機視覺去霧方面的論文寫作專家，我將給你源論文內容，你要給我換一種更加專業更加複雜的說法，作為我的論文正文的內容。")
]
