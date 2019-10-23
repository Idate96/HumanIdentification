function [out] = pilot_fun(frequencies, x)
    out = x(1) * (x(2)*1i*frequencies + 1) .* exp(-1i * frequencies * x(3)) .* ...
          x(4)^2./((1i * frequencies).^2 + 2i * x(5) * x(4) * frequencies + x(4)^2);
end