% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/asr_diagnostics.R
\name{getStatesAtNodes}
\alias{getStatesAtNodes}
\title{returns the states at each node corresponding to the state with the max likelihood}
\usage{
getStatesAtNodes(ancliks, confidence_threshold = NULL)
}
\arguments{
\item{ancliks}{a table of ancestral likelihoods with rows in node order and columns corresponding to phenotype states}

\item{confidence_threshold}{the default is NULL, but if provided it will only obtain states from nodes whose max likelihood is greater than or equal to the confidence threshold}
}
\value{
a vector of states for the internal nodes in order of the internal nodes
}
\description{
returns the states at each node corresponding to the state with the max likelihood
}
