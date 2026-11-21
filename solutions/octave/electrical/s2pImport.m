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
## @deftypefn {@var{data}, @var{f}, @var{Z0}, @var{type}} s2pImport (@var{file})
## Import data in TouchStone 1.0 format from @var{file}.
##
## Returns @var{data} as a 2x2xM matrix of the parameters in the file
## where the final dimension corresponds to frequency vector @var{f}.
## The impedance(s) the parameters were normalized to are returned in
## @var{Z0}, and the parameter type is returned in @var{type}.
##
## @seealso{s2pExport}
## @end deftypefn

% Goal is to conform to the specification for the 1.0 format in
% https://ibis.org/touchstone_ver2.1/touchstone_ver2_1.pdf
function [data, f, Z0, type] = s2pImport(file)
	[fid, msg] = fopen(file, "r");

	if (fid == -1)
		error([msg ": " file])
	end
	
	ln = 0;
	i = 1;

	while ((line = fgetl(fid)) != -1)
		ln++;
		if (regexp(line, "^\\s*!.*$"))
			continue
		end
		
		if (regexp(line, "#.*"))
			if (exist(format) == 1)
				fclose(fid);
				error(["Repeated option (#) line: " num2str(ln) "\n'" line "'"])
			end
			frequencyScale = 1e9;
			type = "S";
			format = "MA";
			Z0 = 50;

			[tok, rem] = strtok(line);
			rem = toupper(rem);
			[tok, rem] = strtok(rem);
			while (!isempty(tok))
				switch (tok)
					case "HZ"
						frequencyScale = 1;
					case "KHZ"
						frequencyScale = 1e3;
					case "MHZ"
						frequencyScale = 1e6;
					case "GHZ"
						frequencyScale = 1e9;
					case {"RI" "MA" "DB"}
						format = tok;
					case "R"
						[tok, rem] = strtok(rem);
						Z0 = str2num(tok);
						if (isnumeric(str2num(strtok(rem))))
							[tok, rem] = strtok(rem);
							Z0 = [Z0 str2num(tok)]
						endif
					case {"S" "Y" "Z" "H" "G"}
						type = tok;
					otherwise
						fclose(fid);
						error(sprintf("Bad option '%s' in line %d\n'%s'", tok, ln, line))
				endswitch
				[tok, rem] = strtok(rem);
			endwhile
			if (Z0 <= 0)
				fclose(fid);
				error(sprintf("Bad impedance %f in option (#) line: %d\n'%s'", Z0, ln, line))
			endif
			continue
		end
		
		entries = strsplit(strtrim(line));
		if (length(entries) != 9)
			fclose(fid);
			error(sprintf("Data in line %d not right length or not formatted properly in file: '%s'\nLine: '%s'", ln, file, line))
		end
		f(i) = str2double(entries{1});
		for j = 1:8
			if (isnan(tempMat(i, j) = str2double(entries{j + 1})))
				fclose(fid)
				error(["Entry " num2str(j) " in line " num2str(ln) " not a number in file: " file "\nLine:" line])
			end
		end
		i++;
	end
	fclose(fid);
	
	j = sqrt(-1);
	switch (format)
		case "RI"
				data(1, 1, :) = complex(tempMat(:, 1), tempMat(:, 2));
				data(2, 1, :) = complex(tempMat(:, 3), tempMat(:, 4));
				data(1, 2, :) = complex(tempMat(:, 5), tempMat(:, 6));
				data(2, 2, :) = complex(tempMat(:, 7), tempMat(:, 8));
		case "MA"
				data(1, 1, :) = tempMat(:, 1).*exp(j*deg2rad(tempMat(:, 2)));
				data(2, 1, :) = tempMat(:, 3).*exp(j*deg2rad(tempMat(:, 4)));
				data(1, 2, :) = tempMat(:, 5).*exp(j*deg2rad(tempMat(:, 6)));
				data(2, 2, :) = tempMat(:, 7).*exp(j*deg2rad(tempMat(:, 8)));
		case "DB"
				data(1, 1, :) = 10.^(tempMat(:, 1)/20) .* exp(j*deg2rad(tempMat(:, 2)));
				data(2, 1, :) = 10.^(tempMat(:, 3)/20) .* exp(j*deg2rad(tempMat(:, 4)));
				data(1, 2, :) = 10.^(tempMat(:, 5)/20) .* exp(j*deg2rad(tempMat(:, 6)));
				data(2, 2, :) = 10.^(tempMat(:, 7)/20) .* exp(j*deg2rad(tempMat(:, 8)));
	end
	f = f(:)*frequencyScale;
end