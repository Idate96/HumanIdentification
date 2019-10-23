function y_out = separated_pilot_fun(x, freq)
    y_out = zeros(length(freq), 2);
    out = x(1) * (x(2)*1i*freq + 1) .* exp(-1i * freq * x(3)) .* ...
      x(4)^2./((1i * freq).^2 + 2i * x(5) * x(4) * freq + x(4)^2);
    y_out(:, 1) = real(out);
    y_out(:, 2) = imag(out);
end