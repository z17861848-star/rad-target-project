/*
  Aerial drone silhouette — cosmetic non-operational scale model.
  Original parametric design inspired by the general appearance of
  a quadcopter; not a reproduction of a commercial product.
  IMPORTANT: Not a flight item, tow target, firearm target, load-bearing
  rig, or safety-rated article. No tow hardware is provided.

  Export parts:
    openscad -o mesh/body.stl -D 'part="body"' model/drone_silhouette.scad
    openscad -o mesh/accent.stl -D 'part="accent"' model/drone_silhouette.scad
*/

$fn = 48;
part = "assembly";          // "assembly", "body", "accent"
scale_factor = 1;          // overall cosmetic size multiplier
body_thickness = 6;       // mm
accent_thickness = 2;     // mm

module link2d(a,b,r) {
    hull() {
        translate(a) circle(r = r);
        translate(b) circle(r = r);
    }
}

module pill2d(x,y,w,h) {
    translate([x,y]) hull() {
        translate([-(w-h)/2,0]) circle(d=h);
        translate([(w-h)/2,0]) circle(d=h);
    }
}

module outline2d() {
    union() {
        // Main block, upper body, and tapering lower camera-like nose.
        polygon(points=[[-45,15],[45,15],[55,-30],[46,-74],
                        [29,-94],[-29,-94],[-46,-74],[-55,-30]]);
        // Broad side arms and curved structural-looking branches.
        for (s=[-1,1]) {
            link2d([s*34,-22],[s*104,-19],11);
            link2d([s*98,-19],[s*135,12],12);
            link2d([s*135,12],[s*139,35],10);
            link2d([s*45,-61],[s*94,-42],10);
            link2d([s*94,-42],[s*108,-13],9);
            // Distinctive stretched propeller silhouettes.
            pill2d(s*131,39,100,12);
            pill2d(s*107,7,75,10);
        }
        // Center ridge for quadcopter visual reference.
        pill2d(0,18,85,12);
    }
}

module body() {
    linear_extrude(height=body_thickness, center=true, convexity=10)
        difference() {
            outline2d();
            // decorative nonfunctional side recesses, not fixtures
            for(s=[-1,1]) {
                translate([s*73,-7]) circle(d=14);
            }
        }
}

module rounded_rect2d(w,h,r) {
    offset(r=r) offset(delta=-r) square([w,h],center=true);
}

module accent() {
    translate([0,-17,(body_thickness+accent_thickness)/2])
        linear_extrude(height=accent_thickness,center=true)
            rounded_rect2d(70,24,4);
}

scale([scale_factor,scale_factor,scale_factor]) {
    if (part=="body" || part=="assembly") color([0.10,0.11,0.12]) body();
    if (part=="accent" || part=="assembly") color([0.96,0.31,0.09]) accent();
}
