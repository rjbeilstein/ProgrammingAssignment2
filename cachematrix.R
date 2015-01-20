## Put comments here that give an overall description of what your
## functions do

#  Copyright (C) Robert J. Beilstein, 2015
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

## These two functions implement a caching scheme for an expensive operation
## (in this case, matrix inversion).  The general idea is that once you perform the
## calculation, subsequent calls for inverting the same matrix should not need to
## run the calculation again.

## This version returns a function object which caches a single matrix 
## and its inverse.  While it is certainly possible to return a general-purpose
## function that could cache multiple different matrices (and their inverses),
## this is actually fine, since the makeCacheMatrix function can produce
## an arbitrary number of these objects for an arbitrary number of matrices and
## their inverses


## makeCacheMatrix returns a 6-element list containing functions to set the value
## of the original matrix, get the value, set the value of the inverse, 
## fetch the value of the inverse, and set and get the previous list of optional
## parameters which were passed to solve() (since a change there makes the cached
## inverse value unreliable).
##
## if c1<-makeCacheMatrix(m1)
##
## Then:
##
## c1$set             Sets a new value for the saved matrix (overriding the value
##                  set via the initial invocation of makeCacheMatrix()
## c1$get           Returns the currently-set matrix value
##
## c1$setInverse    Sets a new value for the cached matrix inverse
##
## c1$getInverse    Returns the current cached matrix inverse
##
## c1$setDots        Saves the list of optional arguments last passed to solve()
##
## c1$getDots       Retrieves the saved list of optional parameters
##
##
## N.B.  This is a longer list than the example, but is required in order to
## ensure we continue to get the correct answer from cacheSolve in the presence
## of an arbitrary list of optional parameters to solve()
##

makeCacheMatrix <- function(x = matrix()) {
    inv<-NULL;                                          # No saved inverse yet
    dots<-NULL                                          # or optional parameters
    set <- function(y) {                                # save new matrix value
        x <<- y
        inv <<- NULL                                    # and clear saved inverse
        dots<<-NULL                                     # and optionals
    }
    get <- function() x                                 # get matrix value
    setInverse <- function(inverse) inv <<- inverse     # remember computed inverse
    getInverse <- function() inv                        # get saved inverse
    setDots <- function(optargs) dots <<- optargs       # remember optional args
    getDots <- function() dots                          # return same
    list(set = set, get = get,                          # return functions as a list
            setInverse = setInverse,
            getInverse = getInverse,
            setDots = setDots,
            getDots = getDots)
    
}


## cacheSolve takes as its an argument a list produced by cacheMatrix, which will
## contain a matrix whose inverse is to be returned.  The first time cacheSolve is
## called, it will actually calculate the inverse (using solve()), and store the 
## result in the cache before returning it.  Subsequent calls to cacheSolve will
## (in most cases) just return the cached value.  The one "fly in the ointment"
## is that cacheSolve and solve() both take an arbitrary list of optional
## parameters (denoted by "...") which may change the result of solve().  We will,
## therefore, keep track of the previous contents of this list of arbitrary
## parameters, and if cacheSolve is called with a different collection of optional
## parameters, we will recalculate the result and re-cache it, so as not to return
## a probably-incorrect cached value.
##

cacheSolve <- function(x, ...) {
    ## Return a matrix that is the inverse of 'x'
    inv<-x$getInverse()                                # get the cached inverse
    dots<-x$getDots()                                  # and remembered optional args
    if(!is.null(inv) & identical(dots,list(...))) {    # if we have inverse and
        message("getting cached data")                 # optional args haven't changed
        return(inv)                                    # return it
    }
    x$setDots(list(...))                               # save optional arguments
    data<-x$get()                                      # get original matrix
    inv<-solve(data,...)                               # compute the inverse
    x$setInverse(inv)                                  # remember result of solve()
    inv                                                # and return it
}
