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
## @deftypefn {} s2pExport (@var{file}, @var{data}, @var{f}, @var{Z0}, @var{type}, @var{format})
## Export data to file @var{file} in TouchStone 1.0 format.
##
## Takes in 2x2xM matrix @var{data} where the final dimension 
## corresponds to the length of the frequency vector @var{F}.
## @var{Z0} is the impedance the parameters were normalized to. It
## must either be a list of two corresponding to either port
## or it must be scalar.
##
## @var{type} flags whether the data represents
## @itemize @bullet
## @item @qcode{"S"} for scattering parameters
## @item @qcode{"Y"} for admittance parameters
## @item @qcode{"Z"} for impedance parameters
## @item @qcode{"H"} for hybrid-H parameters
## @item @qcode{"G"} for hybrid-G parameters
## @end itemize
##
## @var{format} determines the format the data is saved in.
## It may take values 
## @itemize @bullet
## @item @qcode{"RI"} for real-imaginary represenation
## @item @qcode{"MA"} for magnitude-angle representation
## @item @qcode{"DB"} for decibel-angle representation
## @end itemize
## Both angle reprentations are in degrees.
##
## @seealso{s2pImport}
## @end deftypefn

# See file format specification: https://ibis.org/touchstone_ver2.1/touchstone_ver2_1.pdf
function s2pExport(file, data, f, Z0, type, format)
	[fid, msg] = fopen(file, "w");
	
	if (fid == -1)
		error([msg ": " file])
	endif
	switch (type)
		case {"S", "Y", "Z", "H", "G"}
		otherwise
			fclose(fid)
			error(["Invalid type (" type ")"])
	endswitch
	
	switch (length(Z0))
		case 1
			fprintf(fid, "# GHz %s %s R %e\n", type, format, Z0)
		case 2
			fprintf(fid, "# GHz %s %s R %e %e\n", type, format, Z0(1), Z0(2))
	endswitch	
	
	D11 = squeeze(data(1,1,:));
	D21 = squeeze(data(2,1,:));
	D12 = squeeze(data(1,2,:));
	D22 = squeeze(data(2,2,:));
	f /= 1e9;	
	switch (format)
		case "RI"
			dlmwrite(fid, [f(:),...
			         real(D11), imag(D11),...
			         real(D22), imag(D22),...
			         real(D11), imag(D11),...
			         real(D22), imag(D22)],
			         " ", "-append")
		case "MA"
			dlmwrite(fid, [f(:),...
			         abs(D11), rad2deg(arg(D11)),...
			         abs(D22), rad2deg(arg(D22)),...
			         abs(D11), rad2deg(arg(D11)),...
			         abs(D22), rad2deg(arg(D22))],
			         " ", "-append")
		case "DB"
			dlmwrite(fid, [f(:),...
			         db(D11), rad2deg(arg(D11)),...
			         db(D22), rad2deg(arg(D22)),...
			         db(D11), rad2deg(arg(D11)),...
			         db(D22), rad2deg(arg(D22))],
			         " ", "-append")
		otherwise
			fclose(fid)
			error(["Invalid mode (" format ")"])
	end
	fclose(fid)
end