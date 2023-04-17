use <angutils.scad>

/*
w = width
d = depth
gw = grab inner width  (grab = the little grabby tab bits)
gd = grab depth
go = grab offset
gh = grab height
gt = grab tip

|     ________w_________     |
|  go|.----------------.|_   |
|    \\                // gh |
|     \\              // _   |
|____gt||<---------->||______|
        |     gw     |
        |____________|

All dimensions measured roughly with calipers.
It worked first try with PHD10 and PH4.
*/

module remover(w, d, gw, gd, go, gh, gt, wt=1.2, pad=0.2) {
    cw = w + 2 * (wt + pad);  // total clip width
    cl = 12;                  // clip length, just the end bit
    module _c(grab=true) {
        difference() {
            translate([-cw/2, 0]) square([cw, cl]);
            kpg = [
                [gw/2 + pad, -1],
                [gw/2 + pad, gt],
                [w/2 + pad, gt + gh],
                [w/2 + pad, gt + gh + go],
                [0, gt + gh + go + w / 2 + pad],
                [0, -1],
            ];
            kpng = [
                [w/2 + pad, -1],
                [w/2 + pad, gt + gh + go],
                [0, gt + gh + go + w / 2 + pad],
                [0, -1],
            ];
            mirrorcopy([1, 0, 0]) polygon(grab ? kpg : kpng);
        }
    }
    
    module base() {
        translate([-cw/2, 0]) cube([cw, cl, wt]);  // floor
        lex(wt + gd) _c(true); // grabby
        lex(wt + d) _c(false); // rest
        
        // handle, arbitrary dimension lil S-bend
        hkp = [
            [cl, -(d + wt) / 2],
            [cl + 10, -(d + wt) / 2 + 10],
            [cl + 50, -(d + wt) / 2 + 20],
        ];
        rotate([-90,0,90]) lex(cw, center=true) for (i = [0:len(hkp)-2]) {
            hull() for (j = [i:i+1]) {
                translate(hkp[j]) circle(d=d + wt, $fn=24);
            }
        }
    }
    
    difference() {
        base();
        ztr(d + wt) rotate([-90,0,0]) scale([gw,2*d,1]) cylinder(d=1, h=100, $fn=32);
    }
}

//           w,    d,   gw,  gd,  go, gh, gt
JST_PHD10 = [11.8, 5, 10.3, 2.6, 0.7, 1, 0.7];
JST_PH3   = [7.8, 4.8, 6.7,   4, 1, 0.8, 0.3];
// TODO: maybe can be parameterized to pin count

module remover_v(v) {
    remover(v[0], v[1], v[2], v[3], v[4], v[5], v[6]);
}

remover_v(JST_PHD10);
//translate([20, 0]) remover_v(JST_PH3);