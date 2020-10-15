#### Carte

library(data.table)
library(readr)
library(lubridate)

setwd("C:/Users/Valentin/Documents/Cours/TD AudeAxel/Audrey")
source("data_clean.r")

## Première carte 

data_clean <- as.data.table(data_clean)

data_xy <- data_clean[country == "United States"] #selection des data us
data_xy <- unique(data_xy[, sighting := .N , by = list(latitude, longitude)]) # agregation du nombre de vue aux us




## Seconde carte

xy <- data_clean[,c(11,10)]
spdf <- SpatialPointsDataFrame(coords = xy, data = data_clean,
                               proj4string = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))


#Colors
joliepalette<-viridis(7)[1:nlevels(spdf$shape2)]
getColor <- function(breweries91) {joliepalette[spdf$shape2]}

icons <- awesomeIcons(
  icon = 'ios-close',
  iconColor = 'black',
  library = 'ion'
  , markerColor = getColor(spdf)
)

#Generate the javascript

jsscript3<-
  paste0(
    "function(cluster) {
const groups= [",paste("'",levels(spdf$shape2),"'",sep="",collapse=","),"];
const colors= {
groups: [",paste("'",joliepalette,"'",sep="",collapse=","),"],
center:'#ddd',
text:'black'
};
const markers= cluster.getAllChildMarkers();

const proportions= groups.map(group => markers.filter(marker => marker.options.group === group).length / markers.length);
function sum(arr, first= 0, last) {
return arr.slice(first, last).reduce((total, curr) => total+curr, 0);
}
const cumulativeProportions= proportions.map((val, i, arr) => sum(arr, 0, i+1));
cumulativeProportions.unshift(0);

const width = 2*Math.sqrt(markers.length);
const radius= 15+width/2;

const arcs= cumulativeProportions.map((prop, i) => { return {
x   :  radius*Math.sin(2*Math.PI*prop),
y   : -radius*Math.cos(2*Math.PI*prop),
long: proportions[i-1] >.5 ? 1 : 0
}});
const paths= proportions.map((prop, i) => {
if (prop === 0) return '';
else if (prop === 1) return `<circle cx='0' cy='0' r='${radius}' fill='none' stroke='${colors.groups[i]}' stroke-width='${width}' stroke-alignment='center' stroke-linecap='butt' />`;
else return `<path d='M ${arcs[i].x} ${arcs[i].y} A ${radius} ${radius} 0 ${arcs[i+1].long} 1 ${arcs[i+1].x} ${arcs[i+1].y}' fill='none' stroke='${colors.groups[i]}' stroke-width='${width}' stroke-alignment='center' stroke-linecap='butt' />`
});

return new L.DivIcon({
html: `
<svg width='60' height='60' viewBox='-30 -30 60 60' style='width: 60px; height: 60px; position: relative; top: -24px; left: -24px;' >
<circle cx='0' cy='0' r='15' stroke='none' fill='${colors.center}' />
<text x='0' y='0' dominant-baseline='central' text-anchor='middle' fill='${colors.text}' font-size='15'>${markers.length}</text>
${paths.join('')}
</svg>
`,
className: 'marker-cluster'
});
}")

