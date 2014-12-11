install.packages('ggplot2', dep = TRUE)
library(ggplot2)
setwd("~/Documents/Work/Manuscripts/submitted/gal_paper/topoplot/2nd/")

## Import the data by chromsome

ch01 <- read.delim("ch01.matrix");
ch02 <- read.delim("ch02.matrix");
ch03 <- read.delim("ch03.matrix");
ch04 <- read.delim("ch04.matrix");
ch05 <- read.delim("ch05.matrix");
ch06 <- read.delim("ch06.matrix");
ch07 <- read.delim("ch07.matrix");
ch08 <- read.delim("ch08.matrix");
ch09 <- read.delim("ch09.matrix");
ch10 <- read.delim("ch10.matrix");
ch11 <- read.delim("ch11.matrix");
ch12 <- read.delim("ch12.matrix");

## Import the function

source("topo4ggplot_rfunction.R");

## Create the data frames with the data using the function

ch01df = topo4ggplot(ch01, 15);
ch02df = topo4ggplot(ch02, 15);
ch03df = topo4ggplot(ch03, 15);
ch04df = topo4ggplot(ch04, 15);
ch05df = topo4ggplot(ch05, 15);
ch06df = topo4ggplot(ch06, 15);
ch07df = topo4ggplot(ch07, 15);
ch08df = topo4ggplot(ch08, 15);
ch09df = topo4ggplot(ch09, 15);
ch10df = topo4ggplot(ch10, 15);
ch11df = topo4ggplot(ch11, 15);
ch12df = topo4ggplot(ch12, 15);

## Finally create all the graphs
png(filename = "chr01.png", width = 700, height = 500, units = "px", pointsize = 15)
ggplot(ch01df, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, fill=Topologies, xlab="Position (bp)")) + scale_x_continuous(name="Position (bp)", breaks=c(0,1e+07,2e+07,3e+07,4e+07,5e+07,6e+07,7e+07,8e+07,9e+07), limits=c(0,9e+07)) + scale_y_continuous(name="Frequency") + geom_rect() + labs(title="Chromosome 1");
dev.off()
png(filename = "chr02.png", width = 700, height = 500, units = "px", pointsize = 15)
ggplot(ch02df, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, fill=Topologies, xlab="Position (bp)")) + scale_x_continuous(name="Position (bp)", breaks=c(0,1e+07,2e+07,3e+07,4e+07,5e+07,6e+07,7e+07,8e+07,9e+07), limits=c(0,9e+07)) + scale_y_continuous(name="Frequency") + geom_rect() + labs(title="Chromosome 2");
dev.off()
png(filename = "chr03.png", width = 700, height = 500, units = "px", pointsize = 15)
ggplot(ch03df, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, fill=Topologies, xlab="Position (bp)")) + scale_x_continuous(name="Position (bp)", breaks=c(0,1e+07,2e+07,3e+07,4e+07,5e+07,6e+07,7e+07,8e+07,9e+07), limits=c(0,9e+07)) + scale_y_continuous(name="Frequency") + geom_rect() + labs(title="Chromosome 3");
dev.off()
png(filename = "chr04.png", width = 700, height = 500, units = "px", pointsize = 15)
ggplot(ch04df, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, fill=Topologies, xlab="Position (bp)")) + scale_x_continuous(name="Position (bp)", breaks=c(0,1e+07,2e+07,3e+07,4e+07,5e+07,6e+07,7e+07,8e+07,9e+07), limits=c(0,9e+07)) + scale_y_continuous(name="Frequency") + geom_rect() + labs(title="Chromosome 4");
dev.off()
png(filename = "chr05.png", width = 700, height = 500, units = "px", pointsize = 15)
ggplot(ch05df, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, fill=Topologies, xlab="Position (bp)")) + scale_x_continuous(name="Position (bp)", breaks=c(0,1e+07,2e+07,3e+07,4e+07,5e+07,6e+07,7e+07,8e+07,9e+07), limits=c(0,9e+07)) + scale_y_continuous(name="Frequency") + geom_rect() + labs(title="Chromosome 5");
dev.off()
png(filename = "chr06.png", width = 700, height = 500, units = "px", pointsize = 15)
ggplot(ch06df, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, fill=Topologies, xlab="Position (bp)")) + scale_x_continuous(name="Position (bp)", breaks=c(0,1e+07,2e+07,3e+07,4e+07,5e+07,6e+07,7e+07,8e+07,9e+07), limits=c(0,9e+07)) + scale_y_continuous(name="Frequency") + geom_rect() + labs(title="Chromosome 6");
dev.off()
png(filename = "chr07.png", width = 700, height = 500, units = "px", pointsize = 15)
ggplot(ch07df, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, fill=Topologies, xlab="Position (bp)")) + scale_x_continuous(name="Position (bp)", breaks=c(0,1e+07,2e+07,3e+07,4e+07,5e+07,6e+07,7e+07,8e+07,9e+07), limits=c(0,9e+07)) + scale_y_continuous(name="Frequency") + geom_rect() + labs(title="Chromosome 7");
dev.off()
png(filename = "chr08.png", width = 700, height = 500, units = "px", pointsize = 15)
ggplot(ch08df, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, fill=Topologies, xlab="Position (bp)")) + scale_x_continuous(name="Position (bp)", breaks=c(0,1e+07,2e+07,3e+07,4e+07,5e+07,6e+07,7e+07,8e+07,9e+07), limits=c(0,9e+07)) + scale_y_continuous(name="Frequency") + geom_rect() + labs(title="Chromosome 8");
dev.off()
png(filename = "chr09.png", width = 700, height = 500, units = "px", pointsize = 15)
ggplot(ch09df, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, fill=Topologies, xlab="Position (bp)")) + scale_x_continuous(name="Position (bp)", breaks=c(0,1e+07,2e+07,3e+07,4e+07,5e+07,6e+07,7e+07,8e+07,9e+07), limits=c(0,9e+07)) + scale_y_continuous(name="Frequency") + geom_rect() + labs(title="Chromosome 9");
dev.off()
png(filename = "chr10.png", width = 700, height = 500, units = "px", pointsize = 15)
ggplot(ch10df, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, fill=Topologies, xlab="Position (bp)")) + scale_x_continuous(name="Position (bp)", breaks=c(0,1e+07,2e+07,3e+07,4e+07,5e+07,6e+07,7e+07,8e+07,9e+07), limits=c(0,9e+07)) + scale_y_continuous(name="Frequency") + geom_rect() + labs(title="Chromosome 10");
dev.off()
png(filename = "chr11.png", width = 700, height = 500, units = "px", pointsize = 15)
ggplot(ch11df, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, fill=Topologies, xlab="Position (bp)")) + scale_x_continuous(name="Position (bp)", breaks=c(0,1e+07,2e+07,3e+07,4e+07,5e+07,6e+07,7e+07,8e+07,9e+07), limits=c(0,9e+07)) + scale_y_continuous(name="Frequency") + geom_rect() + labs(title="Chromosome 11");
dev.off()
png(filename = "chr12.png", width = 700, height = 500, units = "px", pointsize = 15)
ggplot(ch12df, aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, fill=Topologies, xlab="Position (bp)")) + scale_x_continuous(name="Position (bp)", breaks=c(0,1e+07,2e+07,3e+07,4e+07,5e+07,6e+07,7e+07,8e+07,9e+07), limits=c(0,9e+07)) + scale_y_continuous(name="Frequency") + geom_rect() + labs(title="Chromosome 12");
dev.off()

