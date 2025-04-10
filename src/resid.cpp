#include <RcppArmadillo.h>
#include <math.h>

using namespace Rcpp;
//using namespace arma;

//[[Rcpp::depends(RcppArmadillo)]]
// This is a simple example of exporting a C++ function to R. You can
// source this function into an R session using the Rcpp::sourceCpp
// function (or via the Source button on the editor toolbar). Learn
// more about Rcpp at:
//
//   http://www.rcpp.org/
//   http://adv-r.had.co.nz/Rcpp.html
//   http://gallery.rcpp.org/
//

// [[Rcpp::export]]
NumericVector timesTwo(NumericVector x) {
  return x * 2;
}

// [[Rcpp::export]]
List missingSampler() {
  return(List::create(NumericVector::create(NA_REAL),
                      IntegerVector::create(NA_INTEGER),
                      LogicalVector::create(NA_LOGICAL),
                      CharacterVector::create(NA_STRING)));
}

// [[Rcpp::export]]
LogicalVector isNA(NumericVector x) {
  int n = x.size();
  LogicalVector out(n);

  for (int i = 0; i < n; ++i) {
    out[i] = NumericVector::is_na(x[i]);
  }
  return out;
}


// [[Rcpp::export]]
arma::uvec isNotNArowvec(const arma::rowvec x) {

  int n = x.size();
  arma::vec out(n);

  for (int i = 0; i < n; ++i) {
    out[i] = NumericVector::is_na(x[i]);
  }
  arma::uvec ids = find(out==0);
  //  return x.elem(ids);
  return(ids);
}



// [[Rcpp::export]]
arma::mat fastLmResid(const arma::mat& Y, const arma::mat& X){

  int n = X.n_rows, k = X.n_cols;
  arma::mat res;

  arma::mat coef = Y*X*inv(trans(X)*X);    // fit model y ~ X
  res  = Y - coef*trans(X);           // residuals

  return res;
}

// [[Rcpp::export]]
arma::mat fastLmPredicted(const arma::mat& Y, const arma::mat& X){

  int n = X.n_rows, k = X.n_cols;
  arma::mat res;

  arma::mat coef = Y*X*inv(trans(X)*X);    // fit model y ~ X
  return coef*trans(X);           // residuals


}


// [[Rcpp::export]]
arma::mat fastLmResidWeighted(const arma::mat& Y, const arma::mat& X,  const arma::rowvec& wa){

  int n = X.n_rows, k = X.n_cols;
  arma::mat res;

  arma::rowvec ws=arma::rowvec(wa.n_elem);
  for (int j=0; j<ws.n_elem; j++){
    ws[j]=std::sqrt(wa[j]);
  }
  arma::mat W=diagmat(wa);

  // coeff=dat%*%W%*%modtmp %*% solve(t(modtmp) %*% W %*% modtmp)
  arma::mat coef = Y*W*X*inv(trans(X)*W*X);    // fit model y ~ X
  res  = Y - coef*trans(X);           // residuals
  res.each_row()%=ws;

  return res;
}




// [[Rcpp::export]]
List fastLm(const arma::mat& Y, const arma::mat& X) {
  int n = X.n_rows, k = X.n_cols;

  //  coeff=data[i,]%*%mod %*% solve(t(mod) %*% mod)
  //    resid[i, ] = data[i,] -(coeff %*% t(mod))\


  arma::mat coef = Y*X*inv(trans(X)*X);    // fit model y ~ X
  arma::mat res  = Y - coef*trans(X);           // residuals

  // std.errors of coefficients
  double s2 = std::inner_product(res.begin(), res.end(), res.begin(), 0.0)/(n - k);

  // colvec std_err = sqrt(s2 * diagvec(pinv(trans(X)*X)));

  return List::create(Named("coefficients") = coef,
                      //                   Named("stderr")       = std_err,
                      Named("df.residual")  = n - k);
}

// [[Rcpp::export]]
arma::mat fastLmResidMat(const arma::mat& Y, const arma::mat& X) {
  arma::uvec ids;
  arma::mat rmat=arma::mat(Y.n_rows, Y.n_cols);
  rmat.fill(arma::datum::nan);
  arma::uvec vec_i=arma::uvec(1);
  for (int i=0; i<Y.n_rows; i++){
    vec_i[0]=i;
    ids=isNotNArowvec(Y.row(i));
    if(ids.n_elem>X.n_cols){
      rmat.submat(vec_i, ids)=fastLmResid(Y.submat(vec_i, ids), X.rows(ids));
    }
  }
  return(rmat);
}


// [[Rcpp::export]]
arma::mat fastLmPredictedMat(const arma::mat& Y, const arma::mat& X) {
  arma::uvec ids;
  arma::mat rmat=arma::mat(Y.n_rows, Y.n_cols);
  rmat.fill(arma::datum::nan);
  arma::uvec vec_i=arma::uvec(1);
  for (int i=0; i<Y.n_rows; i++){
    vec_i[0]=i;
    ids=isNotNArowvec(Y.row(i));
    if(ids.n_elem>X.n_cols){
      rmat.submat(vec_i, ids)=fastLmPredicted(Y.submat(vec_i, ids), X.rows(ids));
    }
  }
  return(rmat);
}


// [[Rcpp::export]]
arma::mat fastLmResidMatWeighted(const arma::mat& Y, const arma::mat& X, const arma::mat& W) {
  arma::uvec ids;
  arma::mat rmat=arma::mat(Y.n_rows, Y.n_cols);
  rmat.fill(arma::datum::nan);
  arma::uvec vec_i=arma::uvec(1);
  for (int i=0; i<Y.n_rows; i++){
    vec_i[0]=i;
    ids=isNotNArowvec(Y.row(i));
    if(ids.n_elem>X.n_cols){
      rmat.submat(vec_i, ids)=fastLmResidWeighted(Y.submat(vec_i, ids), X.rows(ids), W.submat(vec_i, ids));
    }
  }
  return(rmat);
}



// [[Rcpp::export]]
arma::mat fastLmResidMatWeightedNoNACheck(const arma::mat& Y, const arma::mat& X, const arma::mat& W) {
  arma::uvec ids;
  arma::mat rmat=arma::mat(Y.n_rows, Y.n_cols);

  arma::uvec vec_i=arma::uvec(1);
  int nc=rmat.n_cols-1;
  for (int i=0; i<Y.n_rows; i++){
    rmat.submat(arma::span(i,i),arma::span(0, nc))=fastLmResidWeighted(Y.submat(arma::span(i,i),arma::span(0, nc)), X, W.submat(arma::span(i,i),arma::span(0, nc)));
  }
  return(rmat);
}


