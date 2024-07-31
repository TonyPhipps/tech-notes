Cheat Sheet
https://openscad.org/cheatsheet/

Set Resolution
```
$fn=100;
```

# Oval
```
module oval(g,h,r){
    hull() {
        translate([g,0,0]) cylinder(h=h, r=r);
        cylinder(h=h, r=r);
    }
}
oval(16, 1.45, 8.95);
```

