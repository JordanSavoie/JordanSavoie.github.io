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
## @deftypefn {@var{snew}} Srenorm (@var{S}, @var{Zold}, @var{Znew})
## Renormalize 2x2xM S matrix.
##
## Zold and Znew may be lists of impedances M long or single numbers.
## If one is single and ones is M long, then the single will be
## assumed to apply to all sets. All ports have same impedance.
##
## @seealso{s2t}
## @end deftypefn

function Snew = Srenorm(S, Zold, Znew)
# For equation for general system, see
# https://qucs.sourceforge.net/tech/node98.html#SECTION001611000000000000000
	Snew = zeros(size(S));
	dim = ndims(S);
	[err Zold Znew] = common_size(Zold, Znew);
	if (err)
		error("Zold and Znew cannot be brought to same size")
	endif
	
	if (dim == 3)
		M = size(S)(3);
		if (length(Zold) == M)
			for i = 1:M
				temp = squeeze(S(:, :, i));
				I = eye(2);
				R = (Znew(i) - Zold(i))/(Znew(i) + Zold(i))*I;
				Snew(:, :, i) = (temp - R)*inv(I - R*temp);
			endfor
		else
			for i = 1:M
				temp = squeeze(S(:, :, i));
				I = eye(2);
				R = (Znew - Zold)/(Znew + Zold)*I;
				Snew(:, :, i) = (temp - R)*inv(I - R*temp);
			endfor
		endif
	elseif (dim == 2)
		I = eye(2);
		R = (Znew - Zold)/(Znew + Zold)*I;
		Snew = (S - R)*inv(I - R*S);
	else
		error("Too many dimensions");
	endif
endfunction