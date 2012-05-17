#Load the MS Access database
require(Hmisc)
setwd('~/Dropbox/Projects/NYSReportCards/')
src = mdb.get('SRC2011.mdb') #Downlaod from https://reportcards.nysed.gov/
names(src)

#Save the tables to individual rda files
for(i in seq_len(length(src))) {
	df = src[i]
	save(df, file=paste('data/', gsub('[ /]', '', names(src)[i], fixed=FALSE), '.rda', sep=''))
}
resaveRdaFiles('data/.')

#Save the tables to an RSQLite database
require(RSQLite)
m = dbDriver('SQLite')
conn = dbConnect(m, dbname='SRC2011.db')
for(i in seq_len(length(src))) {
	df = db[i]
	dbWriteTable(conn, 
				 paste('data/', gsub('[ /]', '', names(db)[i], fixed=FALSE), sep=''), 
				 df)
}
dbDisconnect(conn)
