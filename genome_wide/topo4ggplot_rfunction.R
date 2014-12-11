topo4ggplot <- function(x, y) { 
  topocount  = y; 
  topostart  = x[,2]; 
  topoend    = x[,3]; 
  topomatrix = x[,4:(topocount+3)];
  elements   = length(topostart);
  
  ggplot_names = paste("topology", formatC(1:topocount, digits=0, width=2, flag="0"));
  #print(ggplot_names);
  
  xmin = rep(topostart, topocount); 
  xmax = rep(topoend, topocount); 
  
  ymin_matrix=as.matrix((cbind(rep(0, elements), topomatrix[,1:topocount-1])));
  ymin_row = elements; 
  ymin_col = length(ymin_matrix[1,]);
  
  ## At the same time it will fill the fill argument
  
  fill_matrix = as.matrix(topomatrix);
  
  for (c in 1:length(ggplot_names)) {
    for (r in 1:ymin_row) {
      
        fill_matrix[r,c] = ggplot_names[c];
    }
  }
  
  Topologies = as.vector(fill_matrix);
  
  ##Now it will replace them by the sum
  for (c in 2:ymin_col) {
    for (r in 1:ymin_row) {
      
      curr = ymin_matrix[r,c];
      past = ymin_matrix[r,c-1];
      mod = curr + past;
      ymin_matrix[r,c] = mod;
    }
  }
  
  ## Linearize ymin
  ymin=as.vector(ymin_matrix); 
  
  ## Sum with ymax
  ymax_matrix = ymin_matrix + as.matrix(topomatrix)
  
  ymax=as.vector(as.matrix(ymax_matrix)); 
  
  ggplot_matrix=data.frame(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, Topologies=Topologies); 
  
  return(ggplot_matrix);
  }
