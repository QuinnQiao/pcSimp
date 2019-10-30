The implementation of [**Feature Preserving and Uniformity-Controllable Point Cloud Simplification on Graph**](https://arxiv.org/abs/1812.11383), ICME19 (Oral)

### Abstract

This paper proposes a point cloud simplification algorithm, aiming to **strike a balance between preserving sharp features and keeping uniform density during resampling**. 
In particular, leveraging on graph spectral processing, we represent irregular point clouds naturally on graphs, and propose concise formulations of feature preservation and density uniformity based on graph filters. 
The problem of point cloud simplification is finally formulated as a trade-off between the two factors and efficiently solved by our
proposed algorithm. 


### Codes in Matlab:

code/main.m: main process, run main.m to simplify the point cloud according to the hyper-parameters in main.m.

code/divide.m: function, to split the point cloud into (overlapped) grids.

code/simplify.m: function, to simplify each grid individually on graph.

ply/anchor.ply: an example used by the codes, the simplified point cloud will be in this folder, too.



### Limitation:

1. **Time complexity** 

   Due to the iterative optimization process and multiple matrix multiplications, the proposed method is much slower than existed simplification algorithms.

2. **Grid effect**

   The proposed formulation is shift-invariant, rotation-invariant and scale-invariant [1]. But the properties will not be guaranteed due to the divide-into-cube trick (proposed to speed up the algorithm), in which the global information is partially ignored too.


### Citation:

If you find this code helpful for your research, please cite our paper.
```
@inproceedings{qi19fpuc,
  title = {Feature Preserving and Uniformity-Controllable Point Cloud Simplification on Graph},
  author = {Junkun Qi and Wei Hu and Zongming Guo.},
  booktitle = {International Conference on Multimedia and Expo (ICME)},
  year = {2019}
}
```



**References:**

[1] Siheng Chen, Dong Tian, Chen Feng, Anthony Vetro, and Jelena Kovaˇcevi´c, “Fast resampling of three-dimensional point clouds via graphs,” IEEE Transactions on Signal Processing, vol. 66, no. 3, pp.
666–681, 2018.
