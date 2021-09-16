declare proc {Circle R} A D C P in
    P = 355.0 / 113.0
    A = P * R * R
    D = 2.0 * R
    C = P * D

    {Show A}
    {Show D}
    {Show C}
end

{Circle 3.4}