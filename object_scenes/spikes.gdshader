shader_type canvas_item;

varying vec2 wrldVertex;

void vertex() {
	wrldVertex = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	bool worldY = wrldVertex.y > 350.0;
	vec4 col = texture(TEXTURE, UV);
	
	if(worldY){
		COLOR = vec4(1.0 - col.g, 0.9294117647058824 - 0.9294117647058824 * col.g, 0.42745098039215684 - 0.42745098039215684 * col.g, col.a);
	}else{
		COLOR = vec4(0.43529411764705883 + 0.5647058823529412 * col.g, col.g, 0.796078431372549 + 0.20392156862745103 * col.g, col.a);
	}
}


//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}