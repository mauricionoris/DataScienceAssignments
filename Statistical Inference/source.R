params.seed   <- 555555
params.n_sim  <- 1000
params.n_dist <- 40
params.lambda <- 0.2
params.precision <- 2

set.seed(params.seed)

simulate <- function(f) {
  r <- NULL
  for (s in 1 : params.n_sim) { 
    r = c(r, f(rexp(params.n_dist, params.lambda)))   
  }
  r
}


output.means <- simulate(mean)
output.means.sample <- round(mean(output.means), params.precision)
output.means.theorical <- 1/params.lambda

hist(output.means, main="Dist 1000 averages of 40 exp"
                 , xlab= "Mean"
                 , ylab="Density"
                 , breaks= 30
                 , col="gray")
abline(v= output.means.sample, col="red",lwd= 2)
matrix(data=c(output.means.theorical, output.means.sample), nrow=1, ncol=2, byrow=TRUE, dimnames=list(c("Mean"), c("Theoretical", "Sample")))



output.vars  <- simulate(var)
output.vars.sample <- round(mean(output.vars), params.precision)
output.vars.theorical <- (1/params.lambda)^2
hist(output.vars, main="Dist 1000 vars of 40 exp"
     , xlab= "Var"
     , ylab="Density"
     , breaks= 30
     , col="gray")
abline(v= output.vars.sample, col="red",lwd= 2)
matrix(data=c(output.vars.theorical, output.vars.sample), nrow=1, ncol=2, byrow=TRUE, dimnames=list(c("Var"), c("Theoretical", "Sample")))

output.exponentials <- rexp(params.n_sim, params.lambda)
output.exponentials.mean <- (mean(output.exponentials))

par(mfrow=c(1,2))

hist(output.exponentials, main="Dist of 1000 exp"
     , xlab= "Random"
     , ylab="Density"
     , breaks= 50
     , col="gray")
abline(v= output.exponentials.mean, col="red",lwd= 2)

h1<- hist(output.means  , breaks= 50
          ,col="grey"
          , main=""
          , xlab= "Dist of 1000 grouped for 40 exp"
          , ylab="Density")

abline(v=mean(output.means),col="red",lwd=2)


x_norm <-seq( min(output.means)
              , max(output.means) , length= 100)

y_norm<-dnorm( x_norm
               , mean=mean(output.means)
               , sd=sd(output.means))

y_norm<-y_norm*diff(h1$mids[1:2])*length(output.means)

lines(x_norm, y_norm,col="red",lwd=2)

