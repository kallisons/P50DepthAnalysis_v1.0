#!/bin/sh
rm P50Depth.jnl

for p50 in 2.0 8.0

do

for deltaH in -40 20

do
	echo "SET DATA \"../../EnvironmentalData/Bianchi_po2_annual_1deg.nc\", \"../../EnvironmentalData/temperature_annual_1deg.nc\"" > P50Depth.jnl

	echo "Let p50_critter = ${p50}" >> P50Depth.jnl #kPa

	echo "Let deltaH_critter = ${deltaH}" >> P50Depth.jnl  #kJ mol^-1 

	echo "Let R =  0.008314" >> P50Depth.jnl  #!kJ mol^-1 K^-1 universal gas constant

	echo "Let tempK = t_an[d=2] + 273.15" >> P50Depth.jnl #Convert to Kelvin

	echo "Let tempK_ml = t_an[d=2, k=2]+ 273.15" >> P50Depth.jnl #Convert to Kelvin

	echo "Let tempshift_p50 = (deltaH_critter*((1/tempK)-(1/tempK_ml))/(2.303*R))" >> P50Depth.jnl #Van't Hoff Equation 

	echo "Let p50 = 10^(log(p50_critter) + tempshift_p50)" >> P50Depth.jnl

	echo "Define grid/like=po2[d=1] gcommon" >> P50Depth.jnl

	echo "Let p50_diff = po2[d=1]-p50[g=gcommon]" >> P50Depth.jnl

	echo "Let P50Depth = p50_diff[z=@loc:0]" >> P50Depth.jnl

	echo "define att P50Depth.p50 = \"kPa\"" >> P50Depth.jnl

	echo "define att P50Depth.units = \"m\"" >> P50Depth.jnl

  	echo "define att P50Depth.p50_10m_depth = \"${p50} kPa\"" >> P50Depth.jnl

  	echo "define att P50Depth.deltaH = \"${deltaH} kJ mol^-1\"" >> P50Depth.jnl

	echo "SAVE/CLOBBER/FILE=\"../../Results/P50Depth_ABC/P50Depth_P50_${p50}_deltaH_${deltaH}.nc\" P50Depth" >> P50Depth.jnl

	echo "quit" >> P50Depth.jnl

	ferret < P50Depth.jnl > ferret_out.txt
	
	rm ferret.jnl*

  done

done

rm ../../Results/P50Depth_ABC/P50Depth_P50_8.0_deltaH_20.nc