shader_type canvas_item;

varying vec2 wrldVertex;

void vertex() {
	wrldVertex = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	bool worldY = wrldVertex.y > 350.0;
	if(worldY){
		COLOR = vec4(1.0, 0.9294117647058824, 0.42745098039215684, 1.0);
	}else{
		COLOR = vec4(0.43529411764705883, 0.0, 0.796078431372549, 1.0);
	}
}


//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}