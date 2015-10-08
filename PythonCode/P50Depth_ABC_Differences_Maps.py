#ipython --pylab
import scipy
import glob
from mpl_toolkits.basemap import Basemap
from netCDF4 import Dataset
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
from matplotlib.colors import LogNorm

Files = glob.glob('../Results/P50Depth_ABC_Differences/*.nc')
#neworder=[1,0,2,3]
#Files = [Files[k] for k in neworder]


file0 = Files[0]
nc0 = Dataset(file0,'r')
lats0 = nc0.variables['LATITUDE'][:]
lons0 = nc0.variables['LONGITUDE'][:]
lons02 = lons0+360
depth0 = nc0.variables['DIFFAFFINITY'][:]
depth0 = depth0.squeeze()

file1 = Files[1]
nc1 = Dataset(file1,'r')
lats1 = nc1.variables['LATITUDE'][:]
lons1 = nc1.variables['LONGITUDE'][:]
lons12 = lons1+360
depth1 = nc1.variables['DIFFBOTH'][:]
depth1 = depth1.squeeze()

file2 = Files[2]
nc2 = Dataset(file2,'r')
lats2 = nc2.variables['LATITUDE'][:]
lons2 = nc2.variables['LONGITUDE'][:]
lons22 = lons2+360
depth2 = nc2.variables['DIFFDELTAH'][:]
depth2 = depth2.squeeze()

file4 = Files[3]
nc4 = Dataset(file4,'r')
lats4 = nc4.variables['LATITUDE'][:]
lons4 = nc4.variables['LONGITUDE'][:]
lons42 = lons4+360
depth4 = nc4.variables['MASK1'][:]
depth4 = depth4.squeeze()

file3 = Files[4]
nc3 = Dataset(file3,'r')
lats3 = nc3.variables['LATITUDE'][:]
lons3 = nc3.variables['LONGITUDE'][:]
lons32 = lons3+360
depth3 = nc3.variables['MASK4'][:]
depth3 = depth3.squeeze()


fig, axes = plt.subplots(nrows=3, ncols=1, figsize=(4,6))
plt.subplots_adjust(right=0.8)
fig1 = plt.subplot(3, 1, 1)
m = Basemap(llcrnrlon=0.,llcrnrlat=-80.,urcrnrlon=360.,urcrnrlat=80.,projection='cyl',lon_0=180)
x, y = m(*np.meshgrid(lons0, lats0))
a, b = m(*np.meshgrid(lons02, lats0))
m.drawmapboundary() #fill_color='0.5'
m.drawcoastlines()
m.fillcontinents(color='black')
m.drawparallels(np.arange(-90.,120.,30.),labels=[1,0,0,0])
m.drawmeridians(np.arange(0.,420.,60.),labels=[0,0,0,0])
im1 = m.contourf(x,y,depth4, shading='flat', colors='grey')
im2 = m.contourf(a,b,depth4, shading='flat', colors='grey')
im3 = m.pcolor(x,y,depth0,shading='flat', cmap=plt.cm.jet_r, vmin=0, vmax=500)
#im4 = m.pcolor(a,b,depth0,shading='flat', cmap=plt.cm.jet_r, vmin=0, vmax=500)
fig1.set_title(r'O$_2$ affinity (A - C)')
cbar_ax = fig.add_axes([0.82, 0.685, 0.03, 0.2])
fig.colorbar(im3, cax=cbar_ax)
plt.show()

fig2 = plt.subplot(3, 1, 2)
m = Basemap(llcrnrlon=0.,llcrnrlat=-80.,urcrnrlon=360.,urcrnrlat=80.,projection='cyl',lon_0=180)
x, y = m(*np.meshgrid(lons2, lats2))
a, b = m(*np.meshgrid(lons22, lats2))
m.drawmapboundary() #fill_color='0.5'
m.drawcoastlines()
m.fillcontinents(color='black')
m.drawparallels(np.arange(-90.,120.,30.),labels=[1,0,0,0])
m.drawmeridians(np.arange(0.,420.,60.),labels=[0,0,0,0])
im1 = m.contourf(x,y,depth3, shading='flat', colors='grey')
im2 = m.contourf(a,b,depth3, shading='flat', colors='grey')
im3 = m.pcolor(x,y,depth2,shading='flat',cmap=plt.cm.jet_r, vmin=0, vmax=500)
#im4 = m.pcolor(a,b,depth2,shading='flat',cmap=plt.cm.jet_r, vmin=0, vmax=500)
fig2.set_title(r'$\Delta$H (A - B)')
cbar_ax = fig.add_axes([0.82, 0.402, 0.03, 0.2])
fig.colorbar(im3, cax=cbar_ax)
plt.show()

fig3 = plt.subplot(3, 1, 3)
m = Basemap(llcrnrlon=0.,llcrnrlat=-80.,urcrnrlon=360.,urcrnrlat=80.,projection='cyl',lon_0=180)
x, y = m(*np.meshgrid(lons1, lats1))
a, b = m(*np.meshgrid(lons12, lats1))
m.drawmapboundary() #fill_color='0.5'
m.drawcoastlines()
m.fillcontinents(color='black')
m.drawparallels(np.arange(-90.,120.,30.),labels=[1,0,0,0])
m.drawmeridians(np.arange(0.,420.,60.),labels=[0,0,0,1])
im1 = m.contourf(x,y,depth4, shading='flat', colors='grey')
im2 = m.contourf(a,b,depth4, shading='flat', colors='grey')
im3 = m.pcolor(x,y,depth1,shading='flat',cmap=plt.cm.jet_r, vmin=-100, vmax=100)
#im4 = m.pcolor(a,b,depth1,shading='flat',cmap=plt.cm.jet_r, vmin=-100, vmax=100)
cbar_ax = fig.add_axes([0.82, 0.12, 0.03, 0.2])
fig.colorbar(im3, cax=cbar_ax, ticks=(-100, -75,-50,-25,0,25,50,75,100))
fig3.set_title(r'$\Delta$H and O$_2$ affinity (B - C)')
plt.show()


outfig = '../Graphs/P50Depth_ABC_Differences_Map.ps'
plt.savefig(outfig, dpi=300, bbox_inches=0)
