### Functional reorganization is related to motor recovery and structural disruption

This repository contains code to replicate analyses from the paper "Functional reorganization is related to motor recovery and structural disruption" by Olafson and colleagues.

![Thumbnail](thumbnail.png)

1. Extract precision matrices from timeseries data (set diagonals to 0 prior to graph matching)
	- `project/code/jupyter_code/extract_precision_matrices.ipynb`
2. Run graph matching algorithm on precision matrices
	- `project/code/jupyter_code/graph_matching_precision_stroke.ipynb`
3. Calculate remapping frequencies
	- `project/code/matlab_code/calculate_remapping_freq.m`
4. Perform analyses
	- `project/code/matlab_code/rev_Fig3CD_Contra_Ipsi_Yeo_remaps.m`
	- `project/code/matlab_code/rev_Fig4_nodestrength_ChaCo_remaps.m`
	- `project/code/matlab_code/rev_Fig5_remaps_and_recovery.m`
	- `project/code/matlab_code/SuppFig5_overlap_lesion_ROIs.m`
	- `project/code/matlab_code/SuppFig6_RemappingFD.m`

Estimate structural disconnection from lesion masks using the [NeMo tool v2.0](https://kuceyeski-wcm-web.s3.us-east-1.amazonaws.com/upload.html)
