


plot(dnorm(seq(-3,3,length.out = 100),0,1)~seq(-3,3,length.out = 100),type='l')

e <- 2.71828
logistic <- function(x){2*(1/(1+e^c(-x)))}
linear <- function(x){(1/5)*(x + 5)}
constant <- function(x){rep(1,times=length(x))}
i <- -5
j <- 5
total <- 1000

par(mfrow=c(1,2))
range <- seq(i,j,length.out=total)
logY<-logistic(range)
plot(logY~range,type="l",ylim=c())
linearY <- linear(range)
lines(linearY~range)
  constY <- constant(range)
lines(constY~range)

pdist <- seq(-5,5,length.out = 5)
lines(logistic(pdist)~pdist,col="red",lwd=2)
points(logistic(pdist)~pdist,col="red",cex=1.5)
lines(linear(pdist)~pdist,col="blue",lwd=2)
points(linear(pdist)~pdist,col="blue",cex=1.5)
lines(constant(pdist)~pdist,col="green",lwd=2)
points(constant(pdist)~pdist,col="green",cex=1.5)

g <- rnorm(10,0,0.05)
p <- rnorm(10,0,0.05)

plot(c(sum(p)* range +sum(g)) ~ range,type="l")

