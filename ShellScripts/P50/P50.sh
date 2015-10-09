#!/bin/sh
rm ShellScripts/P50/p50.jnl

for p50 in 2.0 8.0

do

  for deltaH in -40 20 

  do

    echo "SET DATA \"EnvironmentalData/Bianchi_po2_annual_1deg.nc\", \"EnvironmentalData/temperature_annual_1deg.nc\"" > ShellScripts/P50/p50.jnl

    echo "Let p50_critter = ${p50}" >> ShellScripts/P50/p50.jnl #kPa

    echo "Let deltaH_critter = ${deltaH}" >> ShellScripts/P50/p50.jnl  #kJ mol^-1 

    echo "Let R =  0.008314" >> ShellScripts/P50/p50.jnl  #!kJ mol^-1 K^-1 universal gas constant

    echo "Let tempK = t_an[d=2] + 273.15" >> ShellScripts/P50/p50.jnl #Convert to Kelvin

    echo "Let tempK_ml = t_an[d=2, k=2]+ 273.15" >> ShellScripts/P50/p50.jnl #Convert to Kelvin

    echo "Let tempshift_p50 = (deltaH_critter*((1/tempK)-(1/tempK_ml))/(2.303*R))" >> ShellScripts/P50/p50.jnl #Van't Hoff Equation 

    echo "Let p50 = 10^(log(p50_critter) + tempshift_p50)" >> ShellScripts/P50/p50.jnl

    echo "SAVE/CLOBBER/FILE=\"Results/P50/P50_${p50}_deltaH_${deltaH}.nc\" p50" >> ShellScripts/P50/p50.jnl

    echo "quit" >> ShellScripts/P50/p50.jnl

    ferret < ShellScripts/P50/p50.jnl > ShellScripts/P50/ferret_out.txt
	
    rm ferret.jnl*

  done

done

rm Results/P50/P50_8.0_deltaH_20.nc
