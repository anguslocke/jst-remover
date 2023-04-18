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

module remover(w, d, gw, gd, go, gh, gt, label="", wt=1.2, pad=0.2) {
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
        rotate([-90,0,90]) difference() {
            lex(cw, center=true) for (i = [0:len(hkp)-2]) {
                hull() for (j = [i:i+1]) {
                    translate(hkp[j]) circle(d=d + wt, $fn=24);
                }
            }
            translate(hkp[1] + [0,-(d+wt)/2]) rotate([90,0,atan(1/4)]) translate([3,0])
                lex(0.2, center=true) text(label, size=8, valign="center");
        }
    }
    
    difference() {
        base();
        ztr(d + wt) rotate([-90,0,0]) scale([gw,2*d,1]) cylinder(d=1, h=100, $fn=32);
    }
}

//           w,    d,   gw,  gd,  go, gh, gt
// To be verified:
function JST_PHD(n) = let(_w = 2 * floor((n-10)/2))
    [11.8 + _w, 5, 10.3 + _w, 2.6, 0.7, 1, 0.7, str("PHD", n)];
function JST_PH(n) = let(_w = 2 * (n - 3))
    [7.8 + _w, 4.8, 6.6 + _w,   4, 1, 0.8, 0.5, str("PH", n)];

module remover_v(v) {
    remover(v[0], v[1], v[2], v[3], v[4], v[5], v[6], v[7]);
}

//remover_v(JST_PHD10);
//translate([20, 0]) remover_v(JST_PH3);

export() {
    remover_v(JST_PH(2)); //#PH2
    remover_v(JST_PH(3)); //#PH3
    remover_v(JST_PH(4)); //#PH4
    remover_v(JST_PH(5)); //#PH5
    remover_v(JST_PH(6)); //#PH6
    remover_v(JST_PH(7)); //#PH7
    remover_v(JST_PH(8)); //#PH8
    remover_v(JST_PH(9)); //#PH9
    remover_v(JST_PH(10)); //#PH10
    remover_v(JST_PHD(8)); //#PHD8
    remover_v(JST_PHD(10)); //#PHD10
    remover_v(JST_PHD(12)); //#PHD12
    remover_v(JST_PHD(14)); //#PHD14
    remover_v(JST_PHD(16)); //#PHD16
    remover_v(JST_PHD(18)); //#PHD18
    remover_v(JST_PHD(20)); //#PHD20
    remover_v(JST_PHD(22)); //#PHD22
    remover_v(JST_PHD(24)); //#PHD24
}