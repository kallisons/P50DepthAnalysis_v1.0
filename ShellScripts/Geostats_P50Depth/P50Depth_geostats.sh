#!/bin/sh
rm P50Depth.jnl
rm ../../Results/Geostats_P50Depth/P50Depth_geostats.txt

for p50 in 0.2 0.4 0.6 0.8 1 1.2 1.4 1.6 1.8 2 2.2 2.4 2.6 2.8 3 3.2 3.4 3.6 3.8 4 4.2 4.4 4.6 4.8 5 5.2 5.4 5.6 5.8 6 6.2 6.4 6.6 6.8 7 7.2 7.4 7.6 7.8 8 8.2 8.4 8.6 8.8 9 9.2 9.4 9.6 9.8 10

do

  for deltaH in -140 -135 -130 -125 -120 -115 -110 -105 -100 -95 -90 -85 -80 -75 -70 -65 -60 -55 -50 -45 -40 -35 -30 -25 -20 -15 -10 -5 0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 105 110 115 120 125 130 135 140 
  
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

      echo "Let p50_diffequal0 = p50_diff[z=@loc:0]" >> P50Depth.jnl

      echo "Let ocean = t_an[d=2]*0+1" >> P50Depth.jnl

      echo "Let p50_area = p50_diffequal0*0+1" >> P50Depth.jnl

      echo "list/clobber/nohead/file=\"../../Results/Geostats_P50Depth/P50Depth_geostats.txt\"/format=tab/append p50_critter, deltaH_critter, ocean[x=@din, y=@din, k=1], p50_area[x=@din, y=@din], p50_diffequal0[x=@min, y=@min], p50_diffequal0[x=@max, y=@max]" >> P50Depth.jnl

      echo "quit" >> P50Depth.jnl

      ferret < P50Depth.jnl > ferret_out.txt
	
      rm ferret.jnl*
	
  done

done
