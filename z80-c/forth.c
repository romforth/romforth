enum {
	bye=0,
};

int main() {
	char rom[]={
		bye,
	}, w, *ip=rom;

	for (;;) {
		switch (w=*ip++) {
		case bye : return 0;
		default : goto error;
		}
	}
error:
	return 1;
}
