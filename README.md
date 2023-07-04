# OpenCL Particle System
![ScreenRecorderProject3](https://github.com/EvgenyOvechnikov/OpenCLParticleSystem/assets/61941266/eec3dc60-2b93-45e7-a7df-19aeb5bea9b0)
<br/>
(Please check the video demo here: https://media.oregonstate.edu/media/t/1_s6fvrbtp)
<br/>
<br/>
In the initial state each particle is assigned with random color, and also with random initial direction. After a particle bounces any of the spheres, it changes its color in a circular manner: random color → green → blue → red → green → blue → etc.
<br/>
<br/>
The number of particles is 1024x1024. It was observed that there was almost no overhead for parallel computations with the OpenCL/OpenGL capabilities. There is potental to run even more particles on Nvidia 2070 GPU.
