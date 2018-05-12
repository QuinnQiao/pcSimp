pcname = 'bunny.ply';
pc = pcread(pcname);
POINT_NUM = 3000;
PART_NUM = ceil(pc.Count/POINT_NUM);