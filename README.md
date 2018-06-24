# Codes of TEAD

*** TEAD (Taylor Expansion-based Adaptive Design) Experimental Design Tool ***

This documentation accompanies TEAD, an Taylor expansion-based adaptive design algorithm for efficient global surrogate model construction. The TEAD algorithm is proposed in the paper: Mo, S., Lu, D., Shi, X., Zhang, G., Ye, M., Wu, J., & Wu, J. (2017). A Taylor expansion‐based adaptive design strategy for global surrogate modeling with applications in groundwater modeling. Water Resources Research, 53, 10,802–10,823. https://doi.org/10.1002/2017WR021622. The surrogate methods containing in this documentation are Kriging developed by Dr. Lophaven (Lophaven, S.N., Nielsen, H.B., S?ndergaard, J., 2002. DACE-A MATLAB kriging toolbox, version 2.0.) and Radial Basis Function (RBF) implemented in MATSuMoTo toolbox developed by Dr. Müller (Müller J., (2014). MATSuMoTo Code Documentation.). It is noted that the RBF used in our manuscript mentioned above is the multi-quadric RBF implemented in the SUMO toolbox (Gorissen, D., Couckuyt, I., Demeester, P., Dhaene, T., & Crombecq, K. (2010). A surrogate modeling and adaptive sampling toolbox for computer based design. Journal of Machine Learning Research, 11(Jul), 2051-2055.), which is available at http://www.sumo.intec.ugent.be/SUMO.

Four examples are provided in the documentation, one can easily test a new example by refering the four examples. To run TEAD, run the m-file runTEAD.m.

Finally, should you have any questions or encounter any bugs, please feel free to contact me at the email address: smo@smail.nju.edu.cn

by Shaoxing Mo, Nanjing University
