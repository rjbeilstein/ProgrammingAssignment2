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
## (in this case, matric inversion).  The general idea is that once you perform the
## calculation, subsequent calls for inverting the same matrix should not need to
## run the calculation again.

## This version returns a function object which caches a single matrix 
## and its inverse.  While it is certainly possible to return a general-purpose
## function that could cache multiple different 


## Write a short comment describing this function

makeCacheMatrix <- function(x = matrix()) {

}


## Write a short comment describing this function

cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
}
