image:
	sudo $(HOME)/bin/singularity create --size 5000 singularity-fenics-dev-env.img
	sudo $(HOME)/bin/singularity bootstrap singularity-fenics-dev-env.img Singularity
	sudo $(HOME)/bin/singularity copy singularity-fenics-dev-env.img fenics-build /fenics/bin/fenics-build

clean:
	rm -rf singularity-fenics-dev-env.img

shell:
	env -i $(HOME)/bin/singularity shell -H $(HOME)/SingularityHome -s /bin/bash singularity-fenics-dev-env.img

run:
	env -i $(HOME)/bin/singularity run -H $(HOME)/SingularityHome singularity-fenics-dev-env.img

