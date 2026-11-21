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
## @deftypefn {} {@var{retval} =} savedat (@var{file}, @var{h1}, @var{h2},..., @var{c1}, @var{c2},...)
## Saves data to a tab-separated variable file with headings provided
## by strings @var{h1} to @var{hn} corresponding to columns @var{c1}
## to @var{cn}.
## 
## @end deftypefn

function savedat (varargin)
	file = fopen(varargin{1}, "w");
	if (mod(nargin, 2) == 0)
		error("Needs odd number of arguments")
	endif
	fprintf(file, varargin{2})
	for i=3:((nargin-1)/2 + 1)
		fprintf(file, "\t%s", varargin{i})
	endfor
	fprintf(file, "\n")
	
	table = [];
	for i=((nargin-1)/2 + 2):nargin
		table = [table, varargin{i}(:)];
	endfor
	dlmwrite(file, table, '\t', "-append")
	fclose(file);
endfunction
