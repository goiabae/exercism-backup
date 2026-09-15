#include "flower_field.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct { int first; int second; } pair;

static pair offsets[8] = {
	{-1, -1}, {-1, 0}, {-1, 1},
	{0, -1},           {0, 1},
	{1, -1},  {1, 0},  {1, 1},
};

char **annotate(const char **garden, const size_t rows) {
	if (rows == 0) return 0x0;
	char **res = malloc(sizeof(char*) * 100);
	int sz2 = 0;
	int height = rows;
	int width = (rows > 0) ? strlen(garden[0]) : 0;
	for (int i = 0; i < height; i++) {
		char *row = malloc(sizeof(char) * 100);
		int sz = 0;
		for (int j = 0; j < width; j++) {
			int neighbours = 0;
			for (int k = 0; k < 8; k++) {
				pair p = offsets[k];
				int dx = p.first;
				int dy = p.second;
				int ni = i+dx, nj = j+dy;
				neighbours += ! (ni < 0 || ni > (height-1) || nj < 0 || nj > (width-1) || garden[ni][nj] == ' ');
			}
			if (garden[i][j] == '*')
				row[sz++] = '*', row[sz] = '\0';
			else if (neighbours == 0)
				row[sz++] = ' ', row[sz] = '\0';
			else {
				char buf[50];
				sprintf(buf, "%d", neighbours);
				strcat(row, buf);
				sz = strlen(row);
			}
		}
		res[sz2++] = row;
		res[sz2] = 0x0;
	}
	return res;
}

void free_annotation(char **annotation) {
	(void)annotation;
}
