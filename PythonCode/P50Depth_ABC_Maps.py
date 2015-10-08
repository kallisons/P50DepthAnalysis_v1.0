	#ipython --pylab
import scipy
import glob
from mpl_toolkits.basemap import Basemap
from netCDF4 import Dataset
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.mlab as mlab

Files = glob.glob('../Results/P50Depth_ABC/*.nc')
File2 = glob.glob('../Results/60umolkg_Depth/*.nc')



fig, axes = plt.subplots(nrows=2, ncols=2, figsize=(7.66,6))
plt.subplots_adjust(bottom=0.2)
file = Files[0]
nc = Dataset(file,'r')
lats = nc.variables['LATITUDE'][:]
lons = nc.variables['LONGITUDE'][:]
lons2 = lons+360
depth = nc.variables['P50DEPTH'][:]
depth = depth.squeeze()
fig1 = plt.subplot(2, 2, 1)
m = Basemap(llcrnrlon=0.,llcrnrlat=-80.,urcrnrlon=360.,urcrnrlat=80.,projection='cyl',lon_0=180)
x, y = m(*np.meshgrid(lons, lats))
a, b = m(*np.meshgrid(lons2, lats))
m.drawmapboundary() #fill_color='0.5'
m.drawcoastlines()
m.fillcontinents(color='black', lake_color='0.5')
m.drawparallels(np.arange(-90.,120.,30.),labels=[1,0,0,0])
m.drawmeridians(np.arange(0.,420.,60.),labels=[0,0,0,0])
im1 = m.pcolor(x,y,depth,shading='flat',cmap=plt.cm.jet_r, vmin=0, vmax=1100)
#im2 = m.pcolor(a,b,depth,shading='flat',cmap=plt.cm.jet_r, vmin=0, vmax=1100)
fig1.set_title(r'Low P50 and $-\Delta$H')

file = Files[1]
nc = Dataset(file,'r')
lats = nc.variables['LATITUDE'][:]
lons = nc.variables['LONGITUDE'][:]
lons2 = lons+360
depth = nc.variables['P50DEPTH'][:]
depth = depth.squeeze()
fig2 = plt.subplot(2, 2, 2)
m = Basemap(llcrnrlon=0.,llcrnrlat=-80.,urcrnrlon=360.,urcrnrlat=80.,projection='cyl',lon_0=180)
x, y = m(*np.meshgrid(lons, lats))
a, b = m(*np.meshgrid(lons2, lats))
m.drawmapboundary() #fill_color='0.5'
m.drawcoastlines()
m.fillcontinents(color='black', lake_color='0.5')
m.drawparallels(np.arange(-90.,120.,30.),labels=[0,0,0,0])
m.drawmeridians(np.arange(0.,420.,60.),labels=[0,0,0,0])
im1 = m.pcolor(x,y,depth,shading='flat',cmap=plt.cm.jet_r, vmin=0, vmax=1100)
#im2 = m.pcolor(a,b,depth,shading='flat',cmap=plt.cm.jet_r, vmin=0, vmax=1100)
fig2.set_title(r'Low P50 and $+\Delta$H')

file = Files[2]
nc = Dataset(file,'r')
lats = nc.variables['LATITUDE'][:]
lons = nc.variables['LONGITUDE'][:]
lons2 = lons+360
depth = nc.variables['P50DEPTH'][:]
depth = depth.squeeze()
fig3 = plt.subplot(2, 2, 3)
m = Basemap(llcrnrlon=0.,llcrnrlat=-80.,urcrnrlon=360.,urcrnrlat=80.,projection='cyl',lon_0=180)
x, y = m(*np.meshgrid(lons, lats))
a, b = m(*np.meshgrid(lons2, lats))
m.drawmapboundary() #fill_color='0.5'
m.drawcoastlines()
m.fillcontinents(color='black', lake_color='0.5')
m.drawparallels(np.arange(-90.,120.,30.),labels=[1,0,0,0])
m.drawmeridians(np.arange(0.,420.,60.),labels=[0,0,0,1])
im1 = m.pcolor(x,y,depth,shading='flat',cmap=plt.cm.jet_r, vmin=0, vmax=1100)
#im2 = m.pcolor(a,b,depth,shading='flat',cmap=plt.cm.jet_r, vmin=0, vmax=1100)
fig3.set_title(r'High P50 and $-\Delta$H')

file = File2[0]
nc = Dataset(file,'r')
lats = nc.variables['LATITUDE'][:]
lons = nc.variables['LONGITUDE'][:]
lons2 = lons+360
depth = nc.variables['DEPTH_60UMOLKG'][:]
depth = depth.squeeze()
fig4 = plt.subplot(2, 2, 4)
m = Basemap(llcrnrlon=0.,llcrnrlat=-80.,urcrnrlon=360.,urcrnrlat=80.,projection='cyl',lon_0=180)
x, y = m(*np.meshgrid(lons, lats))
a, b = m(*np.meshgrid(lons2, lats))
m.drawmapboundary() #fill_color='0.5'
m.drawcoastlines()
m.fillcontinents(color='black', lake_color='0.5')
m.drawparallels(np.arange(-90.,120.,30.),labels=[0,0,0,0])
m.drawmeridians(np.arange(0.,420.,60.),labels=[0,0,0,1])
im1 = m.pcolor(x,y,depth,shading='flat',cmap=plt.cm.jet_r, vmin=0, vmax=1100)
#im2 = m.pcolor(a,b,depth,shading='flat',cmap=plt.cm.jet_r, vmin=0, vmax=1100)
fig4.set_title(r'60 $\mu$mol kg$^{-1}$')
cbar_ax = fig.add_axes([0.2, 0.1, 0.6, 0.03])
fig.colorbar(im1, cax=cbar_ax, orientation="horizontal")
plt.show()


outfig = '../Graphs/P50Depth_ABC_Maps.ps'
#fig.set_size_inches(7.5,10)
plt.savefig(outfig, dpi=300, bbox_inches=0)
