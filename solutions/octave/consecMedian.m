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
## @deftypefn {@var{xavg} @var{yavg}} consecMedian (@var{x}, @var{y}, @var{mask})
## Takes the median of consecutive runs of (x, y) selected by mask.
##
## Example: 
## 
## [xavg yavg] = consecMedian([1 2 3 4 5 6 7], [1 2 5 0 7 9 8], [1 1 1 0 1 1 1]);
## 
## yields
## 
## xavg = [2 2]
## yavg = [6 8]
## 
## @end deftypefn

function [xavg yavg] = consecMedian(x, y, mask)
# This function previously used averages rather than medians, but at least in my experience the median y is typically the desired value. The average x may be desired in some circumstances.
	if (!size_equal(x, y, mask))
		error("Sizes not equal")
	endif
	run = [];
	xavg = [];
	yavg = [];
	for i = 1:length(mask)
		if (mask(i))
			if (all(mask(run)))
				run = [run i];
				continue
			endif
		elseif (all(mask(run)) && !isempty(run))
			xavg = [xavg median(x(run))];
			yavg = [yavg median(y(run))];
		endif
		run = [];
	endfor
	
	if (all(mask(run)) && !isempty(run))
		xavg = [xavg median(x(run))];
		yavg = [yavg median(y(run))];
	endif
endfunction