## Models

The human body is modeled as an articulated multi-body system with a certain
 number of links connected by joints.  The model consists of simple geometric
 shapes (parallelepiped, cylinder, sphere) whose dimensions are dependent 
from the Xsens motion acquisition by making the model dimensions 'scalable'
 for different subjects.  Due to the strong dependency from the Xsens model
 (23-links biomechanical model), we reconstruct our model in a very similar
 way for a better matching with the data coming from the suit. 

**Model without detailed hands**

- `XSensModelStyle_48URDFtemplate.urdf`: combination of  48 1-DoF revolute joints;
- `XSensModelStyle_66URDFtemplate.urdf`: combination of  66 1-DoF revolute joints;
![Screenshot 2019-12-03 at 15 38 19](https://user-images.githubusercontent.com/10923418/70060897-a0566f00-15e3-11ea-8abb-6d0d0dd38553.png)

**Model with detailed hands**

- `XSensModelStyle_48URDFhands_template.urdf`: combination of  48 1-DoF revolute joints + the hands
![Screenshot 2019-12-03 at 15 39 04](https://user-images.githubusercontent.com/10923418/70060904-a2203280-15e3-11ea-92a8-f56b02ccdbc4.png)
