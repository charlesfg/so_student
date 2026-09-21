.PHONY: validate guide-pdf slides-pdf pdf clean

validate:
	bash scripts/validate_environment.sh

guide-pdf:
	bash scripts/build_guide_pdf.sh

slides-pdf:
	bash scripts/build_slides_pdf.sh

pdf: guide-pdf slides-pdf

clean:
	rm -f guide/PL1.pdf slides/PL1.pdf
