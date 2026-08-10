/* WHEELTEC H30 Enclosed assembly with corrected physical component counts. */

// NARYS_MATERIAL: housing=#D7DBDE
// NARYS_MATERIAL: pcb=#143C34
// NARYS_MATERIAL: cover_fasteners=#636A70
// NARYS_MATERIAL: dampers=#202629
// NARYS_MATERIAL: markings=#2D3338

narys_material = is_undef(narys_material) ? "all" : narys_material;
include <_h30-enclosure-model.scad>

module wheeltec_h30_enclosed() {
    if (narys_material == "all" || narys_material == "housing")
        color("#D7DBDE") {
            h30_main_housing();
            h30_cover();
        }
    if (narys_material == "all" || narys_material == "pcb")
        h30_internal_pcb();
    if (narys_material == "all" || narys_material == "cover_fasteners")
        color("#636A70") h30_four_cover_screws();
    if (narys_material == "all" || narys_material == "dampers")
        color("#202629") h30_four_plastic_dampers();
    if (narys_material == "all" || narys_material == "markings")
        color("#2D3338") h30_top_markings();
}

wheeltec_h30_enclosed();
