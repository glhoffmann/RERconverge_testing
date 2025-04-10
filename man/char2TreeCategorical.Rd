% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RERfuncs.R
\name{char2TreeCategorical}
\alias{char2TreeCategorical}
\title{Creates a categorical trait tree from a set of tip species.}
\usage{
char2TreeCategorical(
  tipvals,
  treesObj,
  useSpecies = NULL,
  model = "ER",
  root_prior = "auto",
  plot = FALSE,
  anctrait = NULL
)
}
\arguments{
\item{tipvals}{the trait/phenotype/character value at the tip, \code{names(tip.vals)} should match some of the \code{mastertree$tip.label}, though a perfect match is not required}

\item{treesObj}{A treesObj created by \code{\link{readTrees}}}

\item{useSpecies}{Give only a subset of the species to use for ancestral state reconstruction
(e.g., only those species for which the trait can be reliably determined).}

\item{model}{Specifies what rate model to use}

\item{root_prior}{The prior probabilities of each trait at the root used to fit the transition matrix. Can be a vector of length equal to the number of states or one of the following: "flat", "empirical", "stationary", "likelihoods", "max_likelihood".}

\item{plot}{Plots a phenotype tree}

\item{anctrait}{The trait to use for all ancestral species instead of inferring ancestral states if not NULL. The default is NULL.}
}
\value{
A tree with edge.length representing phenotype states
}
\description{
Creates a categorical trait tree from a set of tip species.
}
