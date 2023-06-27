// Types are defined for float4's to make more sense
typedef float4 point;
typedef float4 vector;
typedef float4 color;
typedef float4 sphere;

vector
Bounce(vector in, vector n)
{
    vector out = in - n * (vector)(2. * dot(in.xyz, n.xyz));
    out.w = 0.;
    return out;
}

vector
BounceSphere(point p, vector v, sphere s)
{
    vector n;
    n.xyz = fast_normalize(p.xyz - s.xyz);
    n.w = 0.;
    return Bounce(v, n);
}

bool
IsInsideSphere(point p, sphere s)
{
    float r = fast_length(p.xyz - s.xyz);
    return  (r < s.w);
}

// This function rotates color in curcular manner
// random -> green -> blue -> red -> green -> blue -> red ...
// AMD systems do not understand .r, .g, .b notation. Changed to .x, .y, .z
color
RotateColor(color c) {
    color res;
    if (c.x == 0. && c.y == 1. && c.z == 0) {
        res.x = 0.;     // res.r = 0.;
        res.y = 0.;     // res.g = 0.;
        res.z = 1.;     // res.b = 1.;
    }
    else if (c.x == 0. && c.y == 0. && c.z == 1) {
        res.x = 1.;     // res.r = 1.;
        res.y = 0.;     // res.g = 0.;
        res.z = 0.;     // res.b = 0.;
    }
    else {
        res.x = 0.;     // res.r = 0.;
        res.y = 1.;     // res.g = 1.;
        res.z = 0.;     // res.b = 0.;
    }
    return res;
}

kernel
void
Particle(global point* dPobj, global vector* dVel, global color* dCobj)
{
    const float4 G = (float4)(0., -9.8, 0., 0.);
    const float DT = 0.1;
    const sphere Sphere1 = (sphere)(-100., -800., 0., 600.);
    const sphere Sphere2 = (sphere)(1700., -800., 0., 600.);
    int gid = get_global_id(0);

    // extract the position, velocity and color for this particle:
    point  p = dPobj[gid];
    vector v = dVel[gid];
    color c = dCobj[gid];

    // advance the particle:
    point  pp = p + v * DT + G * (point)(.5 * DT * DT);
    vector vp = v + G * DT;
    pp.w = 1.;
    vp.w = 0.;

    // define the structure for advancing the color:
    color cp = c;

    // test against the first sphere here:
    if (IsInsideSphere(pp, Sphere1))
    {
        vp = BounceSphere(p, v, Sphere1);
        pp = p + vp * DT + G * (point)(.5 * DT * DT);
        cp = RotateColor(c);
    }

    // test against the second sphere here:
    if (IsInsideSphere(pp, Sphere2))
    {
        vp = BounceSphere(p, v, Sphere2);
        pp = p + vp * DT + G * (point)(.5 * DT * DT);
        cp = RotateColor(c);
    }

    dPobj[gid] = pp;
    dVel[gid] = vp;
    dCobj[gid] = cp;
}