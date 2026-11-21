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
## @deftypefn {@var{T}} s2t (@var{S}, @var{Z0})
## Generates T/ABCD parameters from 2x2xM S parameters.
##
## Z0 may be a list of impedances of length M.
##
## @seealso{s2pImport}
## @end deftypefn

function T = s2t(S, Z0)
	if (ndims(S) > 3)
		error("Too many dims.");
	endif

	Z0 = Z0(:);
	S11 = squeeze(S(1, 1, :));
	S22 = squeeze(S(2, 2, :));
	S12 = squeeze(S(1, 2, :));
	S21 = squeeze(S(2, 1, :));

	A = ((1 + S11).*(1 - S22) + S12.*S21)./(2*S21);
	B = Z0.*((1 + S11).*(1 + S22) - S12.*S21)./(2*S21);
	C = ((1 - S11).*(1 - S22) - S12.*S21)./(Z0*2.*S21);
	D = ((1 - S11).*(1 + S22) + S12.*S21)./(2*S21);
	
	T(1, 1, :) = A;
	T(1, 2, :) = B;
	T(2, 1, :) = C;
	T(2, 2, :) = D;

endfunction