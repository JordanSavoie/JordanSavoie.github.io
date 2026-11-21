## Copyright (C) 2026 Jordan Savoie
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{ret} =} par (@var{a}, @var{b}, @var{c}, @dots{})
## Returns the parallel combination of its arguments.
##
## That is, it performs 
##
## @var{ret} = (@var{a}^-1 + @var{b}^-1 + @dots{})^-1.
##
## Inputs may be vertical vectors of a common length mixed with scalars.
## In this case, it will take the element-wise inverse and return a
## vector of the common length.
## @end deftypefn

function ret = par(varargin)
	# todo: pre-calculate inverse of single-valued arguments to make more efficient.
	list = nthargout(1:(nargin + 1), @common_size, varargin{:});
	if (list{1})
		error("Mismatched input dimensions")
	endif
	ret = sum(cell2mat(list(2:end)).^-1, 2).^-1;
endfunction