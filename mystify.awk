#!/usr/bin/awk -f
function draw_line (x1, y1, x2, y2, chr, col) {
  x1 = int(x1);
  y1 = int(y1);
  x2 = int(x2);
  y2 = int(y2);

  delta_x = (x2 - x1);
  ix = (delta_x > 0) ? 1 : -1;
  delta_x = (2 * delta_x);
  delta_x = (delta_x < 0) ? (delta_x * -1.0) : delta_x;

  delta_y = (y2 - y1);
  iy = (delta_y > 0) ? 1 : -1;
  delta_y = (2 * delta_y);
  delta_y = (delta_y < 0) ? (delta_y * -1.0) : delta_y;

  printf "\033[0%d;%dH\033[%s%s", y1, x1, col, chr;

  if (delta_x >= delta_y) {
    error = (delta_y - delta_x / 2);
 
    while (x1 != x2) {
      if ((error >= 0) && ((error != 0) || (ix > 0))) {
        error = error - delta_x
        y1 = y1 + iy
      }
 
      error = error + delta_y
      x1 = x1 + ix
 
      printf "\033[0%d;%dH\033[%s%s", y1, x1, col, chr;

    }
  } else {
    error = delta_x - delta_y / 2;
 
    while (y1 != y2) {
      if ((error >= 0) && ((error != 0) || (iy > 0))) {
        error = error - delta_y
        x1 = x1 + ix
      }
 
      error = error + delta_x
      y1 = y1 + iy
 
      printf "\033[0%d;%dH\033[%s%s", y1, x1, col, chr;
    }
  }
}

BEGIN {
  srand();
  ("tput lines" | getline LINES);
  ("tput cols" | getline COLUMNS);
  LINES=(int(LINES) - 1);
  HEIGHT=LINES
  COLUMNS=(int(COLUMNS) - 1);
  YOFFSET = ((70 - LINES) / 2);
  YOFFSET = int((YOFFSET > 0) ? (YOFFSET + 1) : 0);
  CURSORHOME=(LINES-HEIGHT+1+YOFFSET);
  idx = int(0);
  iteration = int(0);
  color = int(0);
  colors[0,0] = "0;31m";
  colors[0,1] = "0;31m";
  colors[1,0] = "0;32m";
  colors[1,1] = "1;32m";
  colors[2,0] = "0;33m";
  colors[2,1] = "1;33m";
  colors[3,0] = "0;34m";
  colors[3,1] = "1;34m";
  colors[4,0] = "0;35m";
  colors[4,1] = "1;35m";
  colors[5,0] = "0;36m";
  colors[5,1] = "1;36m";
  colors[6,0] = "0;37m";
  colors[6,1] = "1;37m";
  for (ii = 0; ii < 4; ++ii) {
    for (jj = 0; jj < 4; ++jj) {
      shape_x[jj,ii] = int(rand() * COLUMNS);
      shape_y[jj,ii] = CURSORHOME + int(rand() * LINES);
    }
    speed_x[ii] = (2 + int(rand() * 5.0));
    speed_y[ii] = (2 + int(rand() * 5.0));
  }
  for (ii = 0; ii < HEIGHT; ++ii) {
    printf "\n";
  }

  while (1) {
    iteration = ((iteration + 1) % 50);
    if (0 == iteration) {
      color = ((color + 1) % 7);
    }

    oldidx = ((idx + 1) % 4);
    draw_line(shape_x[oldidx,0], shape_y[oldidx,0], shape_x[oldidx,1], shape_y[oldidx,1], " ", colors[color,0]);
    draw_line(shape_x[oldidx,1], shape_y[oldidx,1], shape_x[oldidx,2], shape_y[oldidx,2], " ", colors[color,0]);
    draw_line(shape_x[oldidx,2], shape_y[oldidx,2], shape_x[oldidx,3], shape_y[oldidx,3], " ", colors[color,0]);
    draw_line(shape_x[oldidx,3], shape_y[oldidx,3], shape_x[oldidx,0], shape_y[oldidx,0], " ", colors[color,0]);

    oldidx = ((oldidx + 1) % 4);
    draw_line(shape_x[oldidx,0], shape_y[oldidx,0], shape_x[oldidx,1], shape_y[oldidx,1], ".", colors[color,0]);
    draw_line(shape_x[oldidx,1], shape_y[oldidx,1], shape_x[oldidx,2], shape_y[oldidx,2], ".", colors[color,0]);
    draw_line(shape_x[oldidx,2], shape_y[oldidx,2], shape_x[oldidx,3], shape_y[oldidx,3], ".", colors[color,0]);
    draw_line(shape_x[oldidx,3], shape_y[oldidx,3], shape_x[oldidx,0], shape_y[oldidx,0], ".", colors[color,0]);

    oldidx = ((oldidx + 1) % 4);
    draw_line(shape_x[oldidx,0], shape_y[oldidx,0], shape_x[oldidx,1], shape_y[oldidx,1], "-", colors[color,1]);
    draw_line(shape_x[oldidx,1], shape_y[oldidx,1], shape_x[oldidx,2], shape_y[oldidx,2], "-", colors[color,1]);
    draw_line(shape_x[oldidx,2], shape_y[oldidx,2], shape_x[oldidx,3], shape_y[oldidx,3], "-", colors[color,1]);
    draw_line(shape_x[oldidx,3], shape_y[oldidx,3], shape_x[oldidx,0], shape_y[oldidx,0], "-", colors[color,1]);

    for (ii = 0; ii < 4; ++ii) {
      shape_x[idx,ii] = (shape_x[oldidx, ii] + speed_x[ii]);
      shape_y[idx,ii] = (shape_y[oldidx, ii] + speed_y[ii]);
      if (shape_x[idx,ii] > COLUMNS) {
        shape_x[idx,ii] = COLUMNS;
        speed_x[ii] = (-2 - int(rand() * 5.0));
      } else if (shape_x[idx,ii] < 0) {
        shape_x[idx,ii] = 0;
        speed_x[ii] = (2 + int(rand() * 5.0));
      }
      if (shape_y[idx,ii] > LINES) {
        shape_y[idx,ii] = LINES;
        speed_y[ii] = (-2 - int(rand() * 5.0));
      } else if (shape_y[idx,ii] < CURSORHOME) {
        shape_y[idx,ii] = CURSORHOME;
        speed_y[ii] = (2 + int(rand() * 5.0));
      }
    }
    draw_line(shape_x[idx,0], shape_y[idx,0], shape_x[idx,1], shape_y[idx,1], "+", "1;37m");
    draw_line(shape_x[idx,1], shape_y[idx,1], shape_x[idx,2], shape_y[idx,2], "+", "1;37m");
    draw_line(shape_x[idx,2], shape_y[idx,2], shape_x[idx,3], shape_y[idx,3], "+", "1;37m");
    draw_line(shape_x[idx,3], shape_y[idx,3], shape_x[idx,0], shape_y[idx,0], "+", "1;37m");
    rc = system("sleep 0.06");
    if (rc) {
      printf "\x1b[0%dH", (CURSORHOME+HEIGHT);
      exit;
    }
    idx = ((idx + 1) % 4);
  }
}
