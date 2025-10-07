#include "spiral_matrix.h"

#include <stddef.h>
#include <stdlib.h>
#include <stdbool.h>

static void f(spiral_matrix_t* mat, int side, int xpos, int ypos, int xspeed, int yspeed, int counter) {
	if (counter > (side*side))
		return;

	mat->matrix[xpos][ypos] = counter;

	int nxpos = xpos+xspeed;
	int nypos = ypos+yspeed;

	bool outside_bounds = nxpos < 0 || nxpos > (side-1) || nypos < 0 || nypos > (side-1);
	if (outside_bounds || mat->matrix[nxpos][nypos] != -1) {
		int nxspeed = yspeed;
		int nyspeed = -xspeed;
		xspeed = nxspeed;
		yspeed = nyspeed;
	}
	f(mat, side, xpos+xspeed, ypos+yspeed, xspeed, yspeed, counter+1);
}

spiral_matrix_t* spiral_matrix_create(int size) {
	spiral_matrix_t* mat = malloc(sizeof(spiral_matrix_t));
	mat->size = size;
	if (size == 0) {
		mat->matrix = NULL;
		return mat;
	}
	mat->matrix = malloc(sizeof(int*) * size);
	for (size_t i = 0; i < (size_t)size; i++) {
		mat->matrix[i] = malloc(sizeof(int) * size);
		for (size_t j = 0; j < (size_t)size; j++)
			mat->matrix[i][j] = -1;
	}
	f(mat, size, 0, 0, 0, 1, 1);
	return mat;
}

/* void f(std::vector<std::vector<std::uint32_t>>& mat, int side, std::pair<int, int> pos, std::pair<int, int> speed, int counter) { */
/* 	if (counter > (side*side)) { */
/* 		return; */
/* 	} */

/* 	mat[pos.first][pos.second] = counter; */

/* 	auto npos = std::make_pair(pos.first+speed.first, pos.second+speed.second); */
/* 	auto outside_bounds = npos.first < 0 or npos.first > (side-1) or npos.second < 0 or npos.second > (side-1); */
/* 	if (outside_bounds or mat[npos.first][npos.second] != std::numeric_limits<std::uint32_t>::max()) { */
/* 		// rotate clock-wise */
/* 		speed = {speed.second, -speed.first}; */
/* 	} */
/* 	f(mat, side, {pos.first+speed.first, pos.second+speed.second}, speed, counter+1); */
/* } */

/* std::vector<std::vector<std::uint32_t>> spiral_matrix(std::size_t size) { */
/* 	std::vector<std::vector<std::uint32_t>> mat {}; */
/* 	for (auto i = 0ul; i < size; i++) { */
/* 		std::vector<std::uint32_t> row {}; */
/* 		for (auto j = 0ul; j < size; j++) { */
/* 			row.push_back(std::numeric_limits<std::uint32_t>::max()); */
/* 		} */
/* 		mat.push_back(row); */
/* 	} */
/* 	f(mat, size, {0, 0}, {0, 1}, 1); */
/* 	return mat; */
/* }; */

void spiral_matrix_destroy(spiral_matrix_t* mat) {
	if (mat->size > 0) {
		for (size_t i = 0; i < (size_t)mat->size; i++)
			free(mat->matrix[i]);
		free(mat->matrix);
	}
	free(mat);
}
