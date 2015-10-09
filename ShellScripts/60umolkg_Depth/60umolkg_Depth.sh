#!/bin/sh
rm ShellScripts/60umolkg_Depth/Depth.jnl

echo "set data \"EnvironmentalData/woce_monthly_linear_ann_ave.nc\", \"EnvironmentalData/salinity_annual_1deg.nc\", \"EnvironmentalData/temperature_annual_1deg.nc\"" > ShellScripts/60umolkg_Depth/Depth.jnl

echo "let dens = rho_un(s_an[d=2], t_an[d=3], z[d=3])" >> ShellScripts/60umolkg_Depth/Depth.jnl

echo "define grid/like=o2_ann_no_time[d=1] gcommon" >> ShellScripts/60umolkg_Depth/Depth.jnl

echo "let o2_an3 = (o2_ann_no_time[d=1]/dens[g=gcommon])*1000" >> ShellScripts/60umolkg_Depth/Depth.jnl

echo "let mask60 = o2_an3*0+60" >> ShellScripts/60umolkg_Depth/Depth.jnl

echo "let hypconc1 = o2_an3-mask60" >> ShellScripts/60umolkg_Depth/Depth.jnl

echo "let depth_60umolkg = hypconc1[z=@loc:0]" >> ShellScripts/60umolkg_Depth/Depth.jnl

echo "SAVE/CLOBBER/FILE=\"Results/60umolkg_Depth/Hypoxia_60umolkg_Depth.nc\" depth_60umolkg" >> ShellScripts/60umolkg_Depth/Depth.jnl

echo "quit" >> ShellScripts/60umolkg_Depth/Depth.jnl

ferret < ShellScripts/60umolkg_Depth/Depth.jnl > ShellScripts/60umolkg_Depth/ferret_out.txt

rm ferret.jnl*
