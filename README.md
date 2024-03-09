Code for implementing quasi-experimental approach of paired design within fires that have areas that were affected and not affected by insect disturbance.

Steps:

- Fork this repository (Github docs)

- update the _targets.R file to include paths to files under the directories subheader 
  - fire_path <- "<path/to/my/fire/shpfile>"
  - defol_path <- "<path/to/my/insect/shpfile>"
  - RES_DIR <- "<path/to/my/results/folder>"

- update the _targets.R file to input the max, min and gap year for intersection function.

- **make sure to save targets file**

- Run the pipeline, using tar_make() from the targets package



















 [![CC BY 4.0][cc-by-shield]][cc-by]

This work is licensed under a
[Creative Commons Attribution 4.0 International License][cc-by].

[![CC BY 4.0][cc-by-image]][cc-by]

[cc-by]: http://creativecommons.org/licenses/by/4.0/
[cc-by-image]: https://i.creativecommons.org/l/by/4.0/88x31.png
[cc-by-shield]: https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg
