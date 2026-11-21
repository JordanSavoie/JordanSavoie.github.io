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
## @deftypefn {} {@var{x}, @var{feval}, @var{info}, @var{output}, @var{fjac} =} systemsolve (@var{f}, @var{init})
## This function solves a system nonlinear equations using Octave's
## fsolve function. The system, @var{f}, is a cell matrix of function
## handles. You may set your own list of initial conditions using the
## optional argument @var{init}.
## 
## It returns the returns of fsolve: @var{x}, @var{feval}, @var{info}, @var{output}, @var{fjac}
##
## For example:
## @example
## @code{
## model{1} = @@(x, y) f1(x,y);
## model{2} = @@(x, y) f2(x,y);
## ...
## systemsolver(model)
## }
## @end example
## @seealso{fsolve}
## @end deftypefn

function [x feval info output fjac] = systemsolver(f, init)
	if (!exist("init"))
		init = ones(length(f), 1);
	else
		init = init(:);
	endif

	function y = sys(f, x)
		x = num2cell(x);
		for i = 1:length(f)
			y(i) = f{i}(x{:});
		endfor
	endfunction

	[x feval info output fjac] = fsolve(@(x) sys(f, x), init);
endfunction
