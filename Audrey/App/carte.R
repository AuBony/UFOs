#### Carte

# Package ----
require(data.table)

# Import Dataset ----
library(readr)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) # Répertoire de travail = répertoire du fichier R (où on doit mettre les data, du coup)
data_tot <- read_csv("scrubbed.csv", col_types = cols(comments = col_skip(),`date posted` = col_skip(), datetime = col_skip(),
                                                                          `duration (hours/min)` = col_skip(),
                                                                          `duration (seconds)` = col_skip(), shape = col_character(),
                                                                          state = col_skip()), locale = locale())
# Modification du jeu de donnees ----
data_tot$latitude <- as.numeric(as.character(data_tot$latitude))
data_tot <- as.data.table(data_tot)

data_us <- data_tot[country == "us"] #selection des data us
data_xy <- unique(data_us[, sighting := .N , by = list(latitude, longitude)]) # agregation du nombre de vue aux us






library(countrycode)
library(lubridate)
library(dplyr)
library(ggplot2)

complete <- read.csv("~/Cours/TD AudeAxel/complete.csv", na.strings="")
complete$datetime=mdy_hm(complete$datetime)
complete$latitude=as.numeric(as.character(complete$latitude))
complete$longitude=as.numeric(as.character(complete$longitude))


# temp=gsub( "^.* ", "", complete$datetime)
# complete$heure=gsub(":.*$", "", temp)      

complete$heure= hour(complete$datetime) # création de la colonne heure, qui donne l'heure à laquelle a lieu l'évènement
complete$date= floor_date( complete$datetime, unit = "day")


complete$countrystate = paste(complete$country, complete$state)

complete$countrystate[which(complete$countrystate=="NA al")] ="us al"
complete$countrystate[which(complete$countrystate=="NA ar")] ="us ar"
complete$countrystate[which(complete$countrystate=="NA ak")] ="us ak"
complete$countrystate[which(complete$countrystate=="NA az")] ="us az"
complete$countrystate[which(complete$countrystate=="NA ca")] ="us ca"
complete$countrystate[which(complete$countrystate=="NA co")] ="us co"
complete$countrystate[which(complete$countrystate=="NA ct")] ="us ct"
complete$countrystate[which(complete$countrystate=="NA dc")] ="us dc"
complete$countrystate[which(complete$countrystate=="NA de")] ="us de"
complete$countrystate[which(complete$countrystate=="NA fl")] ="us fl"
complete$countrystate[which(complete$countrystate=="NA ga")] ="us ga"
complete$countrystate[which(complete$countrystate=="NA hi")] ="us hi"
complete$countrystate[which(complete$countrystate=="NA ia")] ="us ia"
complete$countrystate[which(complete$countrystate=="NA id")] ="us id"
complete$countrystate[which(complete$countrystate=="NA il")] ="us il"
complete$countrystate[which(complete$countrystate=="NA in")] ="us in"
complete$countrystate[which(complete$countrystate=="NA ks")] ="us ks"
complete$countrystate[which(complete$countrystate=="NA ky")] ="us ky"
complete$countrystate[which(complete$countrystate=="NA la")] ="us la"
complete$countrystate[which(complete$countrystate=="NA ma")] ="us ma"
complete$countrystate[which(complete$countrystate=="NA md")] ="us md"
complete$countrystate[which(complete$countrystate=="NA me")] ="us me"
complete$countrystate[which(complete$countrystate=="NA mi")] ="us mi"
complete$countrystate[which(complete$countrystate=="NA mn")] ="us mn"
complete$countrystate[which(complete$countrystate=="NA mo")] ="us mo"
complete$countrystate[which(complete$countrystate=="NA ms")] ="us ms"
complete$countrystate[which(complete$countrystate=="NA mt")] ="us mt"
complete$countrystate[which(complete$countrystate=="NA nd")] ="us nd"
complete$countrystate[which(complete$countrystate=="NA ne")] ="us ne"
complete$countrystate[which(complete$countrystate=="NA nc")] ="us nc"
complete$countrystate[which(complete$countrystate=="NA nd")] ="us nd"
complete$countrystate[which(complete$countrystate=="NA nh")] ="us nh"
complete$countrystate[which(complete$countrystate=="NA nj")] ="us nj"
complete$countrystate[which(complete$countrystate=="NA nm")] ="us nm"
complete$countrystate[which(complete$countrystate=="NA ns")] ="us ns"
complete$countrystate[which(complete$countrystate=="NA nv")] ="us nv"
complete$countrystate[which(complete$countrystate=="NA ny")] ="us ny"
complete$countrystate[which(complete$countrystate=="NA oh")] ="us oh"
complete$countrystate[which(complete$countrystate=="NA ok")] ="us ok"
complete$countrystate[which(complete$countrystate=="NA or")] ="us or"
complete$countrystate[which(complete$countrystate=="NA pa")] ="us pa"
complete$countrystate[which(complete$countrystate=="NA pr")] ="us pr"
complete$countrystate[which(complete$countrystate=="NA ri")] ="us ri"
complete$countrystate[which(complete$countrystate=="NA sc")] ="us sc"
complete$countrystate[which(complete$countrystate=="NA sd")] ="us sd"
complete$countrystate[which(complete$countrystate=="NA ut")] ="us ut"
complete$countrystate[which(complete$countrystate=="NA vi")] ="us vi"
complete$countrystate[which(complete$countrystate=="NA vt")] ="us vt"
complete$countrystate[which(complete$countrystate=="NA tn")] ="us tn"
complete$countrystate[which(complete$countrystate=="NA tx")] ="us tx"
complete$countrystate[which(complete$countrystate=="NA va")] ="us va"
complete$countrystate[which(complete$countrystate=="NA wa")] ="us wa"
complete$countrystate[which(complete$countrystate=="NA wi")] ="us wi"
complete$countrystate[which(complete$countrystate=="NA wv")] ="us wv"
complete$countrystate[which(complete$countrystate=="NA wy")] ="us wy"


complete$countrystate[which(complete$countrystate=="NA ab")] ="ca ab"
complete$countrystate[which(complete$countrystate=="NA bc")] ="ca bc"
complete$countrystate[which(complete$countrystate=="NA mb")] ="ca mb"
complete$countrystate[which(complete$countrystate=="NA nb")] ="ca nb"
complete$countrystate[which(complete$countrystate=="NA nf")] ="ca nl" # pareil, nf et nl, m^endroit.
complete$countrystate[which(complete$countrystate=="NA nt")] ="ca nt"
complete$countrystate[which(complete$countrystate=="NA on")] ="ca on"
complete$countrystate[which(complete$countrystate=="NA pe")] ="ca pe"
complete$countrystate[which(complete$countrystate=="NA pq")] ="ca pq" #pq et qc sont les deux pour Québec (je crois)
complete$countrystate[which(complete$countrystate=="NA qc")] ="ca qc"
complete$countrystate[which(complete$countrystate=="NA sk")] ="ca sk"
complete$countrystate[which(complete$countrystate=="NA yk")] ="ca yk"
complete$countrystate[which(complete$countrystate=="NA yt")] ="ca yt"

complete$countrystate[which(complete$countrystate=="NA sa")] ="au sa"

unique(complete$countrystate)


complete=complete[-which(is.na(complete$city)),]

complete=complete[-which(is.na(complete$latitude)),]
complete$shape=as.factor(complete$shape)


xy <- complete[,c(11,10)]
spdf <- SpatialPointsDataFrame(coords = xy, data = complete,
                               proj4string = CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0"))


#Colors
viridis(29)
joliepalette<-viridis(29)[1:nlevels(spdf$shape)]
getColor <- function(breweries91) {joliepalette[spdf$shape]}

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
const groups= [",paste("'",levels(spdf$shape),"'",sep="",collapse=","),"];
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

