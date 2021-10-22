declare QuadraticEquation RealSol X1 X2 in

    proc {QuadraticEquation A B C ?RealSol ?X1 ?X2} D Sq in
        D = {Number.pow B 2.} - 4. * A * C
        {Show 'D: ' # D}
        RealSol = D >= 0.
        if RealSol then
            Sq = {Float.sqrt {Number.pow B 2.} - 4. * A * C}
            X1 = (~B - Sq)/ (2. * A)
            X2 = (~B + Sq)/ (2. * A)
        end
    end
    
{QuadraticEquation 42. 73. ~137. RealSol X1 X2}
{Show 'RealSol: ' # RealSol}
{Show 'x1: ' # X1}
{Show 'X2: ' # X2}