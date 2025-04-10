between <- function(x,a,b,includeab = T){
     if(includeab){
          x >= a & x <= b
     }else{
          x > a & x < b
     }
}

getancedgexlims <- function(edgid, res){
     nodeid <- res$edge[edgid,2]
     nodeanc <- res$edge[edgid,1]
     return(c(res$xx[nodeanc],res$xx[nodeid]))
     #print(nodeanc)
}
getancedgeylims <- function(edgid, res){
     nodeid <- res$edge[edgid,2]
     nodeanc <- res$edge[edgid,1]
     return(c(res$yy[nodeanc],res$yy[nodeid]))
     #print(nodeanc)
}

getcolorpal <- function(n) {
  if (n >= length(palette())) {
    colors = colorRampPalette(palette())(n)
  }
  else {
    colors = palette()[2:(n+1)] # SKIP BLACK
  }
  return(colors)
}

click_plot_base <- function(mastertre,fgdedgs = NULL){
     tre = mastertre
     tre$edge.length = rep(1,nrow(tre$edge))

     xx.ape <- node.depth.edgelength(tre)

     res = list(edge = tre$edge,
                xx = xx.ape,
                yy = node.height(tre))

     ancnodeind = which(res$xx == min(res$xx))
     #qnts = quantile(c(0:max(res$xx)*1.1), probs = seq(0,1,length.out = 7))
     qnts = quantile(c(0:max(res$xx)*1.1), probs = seq(0,1,length.out = 9))
     doneloc <- qnts[2]
     undoloc <- qnts[4]
     resetloc <- qnts[6]
     newcatloc <- qnts[8]
     par(mar = c(1,1,2,2))
     plot.phylo(tre, plot=F)

     donewt <- strwidth('Finish\nselection', cex = 1.5)
     doneht <- strheight('Finish\nselection', cex = 1.5)
     undowt <- strwidth(paste0('Undo\nlast branch'), cex = 1.5)
     undoht <- strheight(paste0('Undo\nlast branch'), cex = 1.5)
     resetwt <- strwidth(paste0('Reset\nall branches'), cex = 1.5)
     resetht <- strheight(paste0('Reset\nall branches'), cex = 1.5)
     newcatwt <- strwidth('New\ncategory', cex = 1.5)
     newcatht <- strheight('New\ncategory', cex = 1.5)

     textlocy <- -strheight('Finish\nselection', cex = 1.5)

     edgcols <- rep('black', nrow(tre$edge))
     #edgcols[fgdedgs] <- 'red'
     pal <- getcolorpal(length(fgdedgs))
     for(i in 1:length(fgdedgs)) {
       edgcols[fgdedgs[[i]]] <- pal[i]
     }

     par(mar = c(1,1,2,2))
     scale <- 1 / (length(tre$tip.label) / 60)
     plot.phylo(tre, x.lim = c(0,max(res$xx)*1.1), y.lim = c(textlocy,max(res$yy)), edge.width = 2,edge.color = edgcols,
                main = 'Select Foreground branches on the tree', cex = scale)
     points(res$xx[ancnodeind], res$yy[ancnodeind])
     text(doneloc,textlocy,'Finish\nselection')
     rect(doneloc-donewt/2,textlocy-doneht/2,doneloc+donewt/2,textlocy+doneht/2)
     rect(undoloc-undowt/2,textlocy-undoht/2,undoloc+undowt/2,textlocy+undoht/2)
     rect(resetloc-resetwt/2,textlocy-resetht/2,resetloc+resetwt/2,textlocy+resetht/2)
     rect(newcatloc-newcatwt/2,textlocy-newcatht/2,newcatloc+newcatwt/2,textlocy+newcatht/2)
     text(undoloc,textlocy,'Undo\nlast branch')
     text(resetloc,textlocy,'Reset\nall branches')
     text(newcatloc, textlocy, 'New\ncategory')
}

#' Interactive click-based function to select foreground branches showing convergent binary trait
#'
#' @param mastertre. A phylo tree object defining the topology of all species
#' @return A binary trait tree with branch lengths of 1 for selected foreground species and lengths of 0 for the rest
#' @export
click_select_foreground_branches <- function(mastertre){
     tre = mastertre
     tre$edge.length = rep(1,nrow(tre$edge))

     xx.ape <- node.depth.edgelength(tre)
     res = list(edge = tre$edge,
                xx = xx.ape,
                yy = node.height(tre))

     ancnodeind = which(res$xx == min(res$xx))
     qnts = quantile(c(0:max(res$xx)*1.1), probs = seq(0,1,length.out = 9))
     doneloc <- qnts[2]
     undoloc <- qnts[4]
     resetloc <- qnts[6]
     newcatloc <- qnts[8]
     par(mfrow = c(1,1))
     par(mar = c(1,1,2,2))
     plot.phylo(tre, plot=F)

     donewt <- strwidth('Finish\nselection', cex = 1.5)
     doneht <- strheight('Finish\nselection', cex = 1.5)
     undowt <- strwidth(paste0('Undo\nlast branch'), cex = 1.5)
     undoht <- strheight(paste0('Undo\nlast branch'), cex = 1.5)
     resetwt <- strwidth(paste0('Reset\nall branches'), cex = 1.5)
     resetht <- strheight(paste0('Reset\nall branches'), cex = 1.5)
     newcatwt <- strwidth('New\ncategory', cex = 1.5)
     newcatht <- strheight('New\ncategory', cex = 1.5)

     textlocy <- -strheight('Finish\nselection', cex = 1.5)
     par(mar = c(1,1,2,2))
     scale <- 1 / (length(tre$tip.label) / 60)
     plot.phylo(tre, x.lim = c(0,max(res$xx)*1.1), y.lim = c(textlocy,max(res$yy)), edge.width = 2,
                main = 'Select Foreground branches on the tree',cex = scale)
     points(res$xx[ancnodeind], res$yy[ancnodeind])

     text(doneloc,textlocy,'Finish\nselection')
     rect(doneloc-donewt/2,textlocy-doneht/2,doneloc+donewt/2,textlocy+doneht/2)
     rect(undoloc-undowt/2,textlocy-undoht/2,undoloc+undowt/2,textlocy+undoht/2)
     rect(resetloc-resetwt/2,textlocy-resetht/2,resetloc+resetwt/2,textlocy+resetht/2)
     rect(newcatloc-newcatwt/2,textlocy-newcatht/2,newcatloc+newcatwt/2,textlocy+newcatht/2)
     text(undoloc,textlocy,'Undo\nlast branch')
     text(resetloc,textlocy,'Reset\nall branches')
     text(newcatloc, textlocy, 'New\ncategory')

     ctr = 1
     xy = locator(n = 1)
     # valids = res$xx != 0
     yids = c()
     # edgs = c()
     edgs = list(c())
     alledgexlims <- sapply(1:nrow(res$edge),getancedgexlims,res)
     matedgexlims <- matrix(unlist(alledgexlims), nrow = nrow(res$edge), byrow = T)
     # alledgeylims <- sapply(1:nrow(res$edge),getancedgeylims,res)
     # matedgeylims <- matrix(unlist(alledgeylims), nrow = nrow(res$edge), byrow = T)
     while(!(between(xy$x, doneloc-donewt/2,doneloc+donewt/2) & between(xy$y,textlocy-doneht/2,textlocy+doneht/2))){
          if(ctr){
               if((between(xy$x, undoloc-undowt/2,undoloc+undowt/2) & between(xy$y,textlocy-undoht/2,textlocy+undoht/2)) | (between(xy$x, resetloc-resetwt/2,resetloc+resetwt/2) & between(xy$y,textlocy-resetht/2,textlocy+resetht/2))){
                    xy = locator(n = 1)
               }else{
                    xhits <- sapply(1:nrow(res$edge), function(x){
                         between(xy$x, matedgexlims[x,1],matedgexlims[x,2])
                    })
                    yhits <- abs(res$yy-rep(xy$y,length(res$yy)))
                    yhits_edge <- yhits[res$edge[,2]]
                    # edgs <- which(match(yhits_edge, min(yhits_edge[xhits]))==1)[1]
                    for(i in 1:length(yhits_edge)) {
                      if(!xhits[i]){
                        yhits_edge[i] <- NA
                      }
                    }
                    edgtoadd <- which.min(yhits_edge)
                    edgs[[length(edgs)]] <- edgtoadd
                    dev.off()
                    click_plot_base(tre,edgs)
                    #print(edgs)
                    ctr = 0
                    xy = locator(n = 1)
               }
          }else{
               undo <- function(edgs) {
              catcnt <- length(edgs)
              if(length(edgs[[catcnt]]) > 1) {
                edgs[[catcnt]] <- edgs[[catcnt]][1:(length(edgs[[catcnt]])-1)]
                return(edgs)
              }
              else if(length(edgs[[catcnt]]) == 1){
                if(catcnt > 1) {
                  edgs <- edgs[1:(length(edgs)-1)]
                  return(edgs)
                }
                else{
                  return(list(c()))
                }
              }
              else if(is.null(edgs[[catcnt]])) {
                if(catcnt > 1) {
                  edgs[[catcnt]] <- edgs[[catcnt]][1:(length(edgs[[catcnt]])-1)]
                  undo(edgs)
                }
                else {
                  return(list(c()))
                }
              }
            }
               if(between(xy$x, undoloc-undowt/2,undoloc+undowt/2) & between(xy$y,textlocy-undoht/2,textlocy+undoht/2)){
                    #print(edgs)
                    # if(length(edgs) <= 1){
                    #      edgs = c()
                    #      dev.off()
                    #      click_plot_base(tre)
                    # }else{
                    #      edgs = edgs[1:(length(edgs)-1)]
                    #      dev.off()
                    #      click_plot_base(tre,edgs)
                    # }
                    # xy = locator(n = 1)
                   edgs <- undo(edgs)
                   dev.off()
                   click_plot_base(tre, edgs)
                   # print(edgs)
                   xy = locator(n = 1)
               } else if(between(xy$x, resetloc-resetwt/2,resetloc+resetwt/2) & between(xy$y,textlocy-resetht/2,textlocy+resetht/2)){
                    dev.off()
                    click_plot_base(tre)
                    # edgs = c()
                    edgs = list(c())
                    xy = locator(n = 1)
               }
               else if(between(xy$x, newcatloc-newcatwt/2,newcatloc+newcatwt/2) & between(xy$y,textlocy-newcatht/2,textlocy+newcatht/2)) {
                 edgs <- append(edgs, list(NULL))
                 # print(edgs)
                 xy = locator(n = 1)
               } else{
                    xhits <- sapply(1:nrow(res$edge), function(x){
                         between(xy$x, matedgexlims[x,1],matedgexlims[x,2])
                    })
                    yhits <- abs(res$yy-rep(xy$y,length(res$yy)))
                    yhits_edge <- yhits[res$edge[,2]]
                    # edgtoadd <- which(match(yhits_edge, min(yhits_edge[xhits]))==1)[1]
                    # if(!(edgtoadd %in% edgs)){
                    #      edgs = c(edgs,edgtoadd)
                    #      dev.off()
                    #      click_plot_base(tre,edgs)
                    #      #print(edgs)
                    # }

                    for(i in 1:length(yhits_edge)) {
                      if(!xhits[i]){
                        yhits_edge[i] <- NA
                      }
                    }
                    edgtoadd <- which.min(yhits_edge)

                    # CHECK IF THE EDGE HAS BEEN SELECTED ALREADY
                    edge_already_selected <- function(edgtoadd, edgs) {
                      for(i in 1:length(edgs)){
                        if(edgtoadd %in% edgs[[i]]) {return(T)}
                      }
                      return(F)
                    }

                    if(!(edge_already_selected(edgtoadd, edgs))){
                      n <- length(edgs)
                      edgs[[n]] = c(edgs[[n]],edgtoadd)
                      dev.off()
                      click_plot_base(tre,edgs)
                      # print(edgs)
                    }

                    xy = locator(n = 1)
               }
          }
     }
     if(length(edgs) > 1) {
       cattre <- tre
       cattre$edge.length = rep(1,nrow(tre$edge))
       for(i in 1:length(edgs)) {
         cattre$edge.length[edgs[[i]]] <- i + 1
       }
       plotTreeCategorical(cattre)
       print("This is a non-binary categorical trait. Use correlateWithCategoricalPhenotype to calculate association statistics.")
       return(cattre)
     }
     # OTHERWISE, GENERATE A BINARY PHENOTYPE TREE
     else {
       bintre <- tre
       bintre$edge.length = rep(0, nrow(tre$edge))
       bintre$edge.length[edgs[[1]]] <- 1
       plot.phylo(bintre, main = "Binary trait tree")
       print("This is a binary trait. Use correlateWithBinaryPhenotype to calculate association statistics.")
       return(bintre)
     }
     # bintre <- tre
     # bintre$edge.length = rep(0,nrow(tre$edge))
     # bintre$edge.length[edgs] <- 1
     # plot.phylo(bintre, main = 'Binary trait tree')
}
