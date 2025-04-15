
== Loss Function

=== MAE and SSIM

L1 loss, also known as Mean Absolute Error (MAE), is a widely used objective function in image restoration tasks, including single image dehazing, due to its robustness against outliers and ability to preserve fine-grained structural details. The L1 loss function is defined as:

$ #math.cal("L")_(L 1)=1 / N sum_(i=1)^N|y_i - hat(y_i)| $

where $y_i$ represents the pixel value of the ground truth image. $hat(y_i)$ denotes the corresponding pixel value of the dehazed output and $N$ is the total number of pixels in the image.

// #desc()[
//   - $y_i$ is the pixel value of ground truth image.

//   - $hat(y_i)$ is the pixel value of outputs image.

//   - $N$ is the total pixel value of the image.
// ]

MAE quantifies pixel-wise discrepancies between the dehazed and ground truth images, while SSIM@1284395@nilsson2020understandingssim evaluates structural similarity, capturing perceptual quality and preserving spatial correlations. SSIM serves as a perceptual metric for evaluating the similarity between two images by considering three fundamental components: luminance, contrast, and structural information. It is mathematically formulated as:

$ S S I M(y, hat(y)) = [l(y, hat(y))]^beta dot [c(y, hat(y))]^gamma dot [s(y, hat(y))]^delta $

where $beta, gamma, delta$ are weighting parameters that regulate the relative contribution of each component. Specifically, $l(y, hat(y)), c(y, hat(y))$ and $s(y, hat(y))$ represent the luminance similarity, contrast similarity, and structural similarity, respectively. By integrating these factors, SSIM provides a more perceptually aligned assessment of image quality compared to traditional pixel-wise metrics, making it particularly suitable for evaluating image restoration tasks like dehazing.

// #desc()[
//   - $beta, gamma, delta$ constants that control the importance of each factor.
//   - $l(y, hat(y)), c(y, hat(y)), s(y, hat(y))$ are the individual similarity measures for luminance, contrast, and structure, respectively.
// ]

Typically, the formula simplifies to:

$
  S S I M(y, hat(y)) = frac((2mu_y mu_hat(y)+C_1)(2sigma_(y,hat(y))+C_2), (mu_y^2+mu_hat(y)^2+C_1)(sigma_y^2+sigma_hat(y)^2+C_2))
$

where $mu_y$ and $mu_hat(y)$ denote the mean intensity values of the ground truth image $y$ and the reconstructed image $hat(y)$, respectively. $sigma_y$ and $sigma_hat(y)$ represent the standard deviations of $y$ and $hat(y)$, which measure the contrast of the images. $sigma_(y,hat(y))$ denotes the covariance between $y$ and $hat(y)$, capturing the structural similarity between the images.
$C_1$ and $C_2$ are small constants introduced to prevent numerical instability, particularly when the denominators approach zero.

// #desc()[
//   - $mu_y, mu_hat(y)$ are the means of $y$ and $hat(y)$
//   - $sigma_y, sigma_hat(y)$ are the standard deviation of $y$ and $hat(y)$
//   - $sigma_(y,hat(y))$ is the covariance between $y$ and $hat(y)$
//   - $C_1$ and $C_2$ are constants to stabilize the division when the values are close to zero.
// ]

=== MS-SSIM Loss

Multi-Scale Structural Similarity (MS-SSIM) extends the concept of Structural Similarity (SSIM) by evaluating image similarity across multiple scales or resolutions@ABDELSALAMNASR2017399@mss. This method acknowledges that structural details are more perceptible at various spatial resolutions, enabling MS-SSIM to capture finer aspects of image structure.

MS-SSIM computes the similarity of luminance, contrast, and structure across several downsampled versions of the image, with each scale generated through iterative Gaussian downsampling. By preserving structural information at reduced image sizes, this multi-scale approach facilitates a more comprehensive assessment of perceptual quality.

The resulting MS-SSIM score is an aggregate measure, combining the similarities at each scale to provide a more accurate representation of the perceptual similarity between the ground truth and the predicted image. The standard formula is as follows:

$
  M S"-"S S I M(y, hat(y)) = product_(j=1)^M [l_j (y, hat(y))^(beta_j) dot c_j (y, hat(y))^(gamma_j) dot s_j (y, hat(y))^(delta_j)]
$

$
  M S"-"S S I M(y, hat(y)) =[l_m (y, hat(y))]^(beta_M) dot product_(j=1)^M [c_j (y, hat(y))^(gamma_j) dot s_j (y, hat(y))^(delta_j)] #cite(label("ABDELSALAMNASR2017399"))
$

The MS-SSIM index measures the similarity of structural features across these scales, with a value range of $(0,1]$, where a value closer to 1 indicates higher similarity between the images. For loss minimization, we take the complement of the MS-SSIM score:

$ #math.cal("L")_(M S"-"S S I M) = 1 - M S"-"S S I M(y, hat(y)) $

where $M$ represents the lowest resolution level, corresponding to the number of downsampling operations applied to reduce the image resolution@ABDELSALAMNASR2017399. The luminance, contrast, and structure components at the $j$-th scale are denoted as $l_j, c_j$ and $s_j$, respectively. The weighting coefficients $beta_j, gamma_j$ and $delta_j$ determine the relative contribution of each component at scale $j$.

// #desc()[
//   - $M$ corresponds to the lowest resolution (i.e. the times of down samplings performed to reduce the image resolution)@ABDELSALAMNASR2017399 #strike[is the number of scales(typically 5 to 6 scales are used)]
//   - $l_j, c_j, s_j$ are the luminance, contrast, and structure factors at the $j$-th scale
//   - $beta_j, gamma_j, delta_j$ constants that control the importance of each factor at the $j$-th scale
// ]

=== Combined Loss

The final loss function is a weighted combination of L1 loss and MS-SSIM loss:

$ #math.cal("L") = alpha dot #math.cal("L")_(M S"-"S S I M) + (1- alpha) dot #math.cal("L")_(L 1) $

where $#math.cal("L")_(M S"-"S S I M)$ represents the MS-SSIM loss, which measures the structural similarity between the predicted and target images, and $#math.cal("L")_("L1")$ represents the L1 loss, which measures pixel-wise accuracy. The weight factor $alpha$ allows for adjusting the trade-off between these two losses. The MS-SSIM loss is computed by subtracting the MS-SSIM similarity score from 1, as MS-SSIM provides a similarity measure (the higher the similarity, the lower the loss).

The final loss function integrates both pixel-wise accuracy and perceptual quality by combining L1 loss and MS-SSIM loss in a weighted manner. The coefficient $alpha$ controls the balance between structural similarity preservation and pixel-wise fidelity, ensuring that the model optimizes both global structural coherence and local detail restoration.

And the code is as follows:

```py
# 计算 L1 损失
L1_loss = calculate_L1_loss(predicted_output, ground_truth)
# 计算 MS-SSIM 损失
MS_SSIM_score = calculate_MS_SSIM(predicted_output, ground_truth)
# 计算 MS-SSIM 损失 (注意: MS-SSIM 返回的是相似性分数，损失是 1 - 分数)
MS_SSIM_loss = 1 - MS_SSIM_score
# 最终损失 = MS-SSIM 损失和 L1 损失的加权和
total_loss = weight_factor * MS_SSIM_loss + (1 - weight_factor) * L1_loss
```
#bibliography("papers.bib")
