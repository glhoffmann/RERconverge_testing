#For testing new functions to plot and save per-branch RERs by gene
#(new plotting functions in plottingFuncs.R and tree saving functions in RERfuncs.R)
if (!require("RERconverge", character.only=T, quietly=T)) {
  require(devtools)
  install_github("nclark-lab/RERconverge",
                 ref="AddressReviewerComments") #can be modified to specify a particular branch
}
library(RERconverge)
#Run from vignettes directory
data("toyTrees")
data("mamRERw")
phenvExample <- foreground2Paths(c("Vole","Squirrel"),toyTrees,clade="terminal")
relGene = "BEND3"
#Find a way to map RERs to tree edges in order to use treePlotNew
#Perhaps using nvmaster?
#These examples just color/label based on edge lengths
#Basic treePlot:
treePlot(toyTrees$trees[[relGene]],vals=toyTrees$trees[[relGene]]$edge.length)

#treePlotNew (probably too complicated):
savet = treePlotNew(toyTrees$trees[[relGene]],vals=toyTrees$trees[[relGene]]$edge.length,
            colpan1="black",colpan2="red",colpanmid="gray")

#treePlotGG:
sampt = toyTrees$trees[[relGene]]
sampt$edge.length = sample(c(-1,0,1),length(sampt$edge.length),replace=T)
treePlotGG(sampt,tiplabels=T)

#plot RERs as labels on phylogeny
testrers = returnRersAsTree(treesObj = toyTrees, rermat = mamRERw, index = relGene, phenv = phenvExample, tip.cex = 0.8)

#display as newick string
rersnwk <- returnRersAsNewickStrings(toyTrees, mamRERw)
write.tree(testrers)
