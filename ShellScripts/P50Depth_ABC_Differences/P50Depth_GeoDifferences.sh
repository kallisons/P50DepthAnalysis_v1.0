#!/bin/sh
rm P50DepthDiff.jnl

  echo "set data \"../../Results/P50Depth_ABC/P50Depth_P50_2.0_deltaH_-40.nc\", \"../../Results/P50Depth_ABC/P50Depth_P50_2.0_deltaH_20.nc\", \"../../Results/P50Depth_ABC/P50Depth_P50_8.0_deltaH_-40.nc\"" > P50DepthDiff.jnl

  echo "let diffboth = P50Depth[d=2]-P50Depth[d=3]" >> P50DepthDiff.jnl
  echo "SAVE/CLOBBER/FILE=\"../../Results/P50Depth_ABC_Differences/DifferenceBothVars.nc\" diffboth" >> P50DepthDiff.jnl

  echo "let diffDeltaH = P50Depth[d=1]-P50Depth[d=2]" >> P50DepthDiff.jnl
  echo "SAVE/CLOBBER/FILE=\"../../Results/P50Depth_ABC_Differences/DifferenceDeltaH.nc\" diffDeltaH" >> P50DepthDiff.jnl

  echo "let diffAffinity = P50Depth[d=1]-P50Depth[d=3]" >> P50DepthDiff.jnl
  echo "SAVE/CLOBBER/FILE=\"../../Results/P50Depth_ABC_Differences/DifferenceAffinity.nc\" diffAffinity" >> P50DepthDiff.jnl

  echo "let mask1 = P50Depth[d=2]*0+1" >> P50DepthDiff.jnl 
  echo "SAVE/CLOBBER/FILE=\"../../Results/P50Depth_ABC_Differences/mask1.nc\" mask1" >> P50DepthDiff.jnl

  echo "let mask4 = P50Depth[d=3]*0+1" >> P50DepthDiff.jnl
  echo "SAVE/CLOBBER/FILE=\"../../Results/P50Depth_ABC_Differences/mask4.nc\" mask4" >> P50DepthDiff.jnl

  echo "quit" >> P50DepthDiff.jnl

  ferret < P50DepthDiff.jnl > ferret_out.txt
	
  rm ferret.jnl*