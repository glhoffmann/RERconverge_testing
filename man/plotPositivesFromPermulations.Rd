% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PermulationFuncs.R
\name{plotPositivesFromPermulations}
\alias{plotPositivesFromPermulations}
\title{Plots changes in number of statistically significant rate acceleration or deceleration versus the number of permulations}
\usage{
plotPositivesFromPermulations(
  res,
  perm.out,
  interval,
  pvalthres,
  output.res = FALSE
)
}
\arguments{
\item{res}{correlation statistic output from \code{\link{correlateWithBinaryPhenotype}} or \code{\link{correlateWithContinuousPhenotype}}}

\item{perm.out}{output from \code{\link{getPermsBinary}} or \code{\link{getPermsContinuous}}}

\item{interval}{interval of number of permulations (e.g., interval = 10 means that number of positives with be calculated for number of permulations = 10, 20, 30, ...)}

\item{pvalthres}{p-value threshold for identifying statistically significant rate acceleration or deceleration}

\item{output.res}{Boolean defining whether to output a list object containing changes in the number of identified elements with changing number of permulations (default=FALSE)}
}
\value{
A list containing changes in the number of identified elements with changing number of permulations (default=NULL)
}
\description{
Plots changes in number of statistically significant rate acceleration or deceleration versus the number of permulations
}
