var particle_chamber

setUp = function(){
particle_chamber = new Zenbe.ParticleChamber	
}

test_truth = function(){
}

test_example_1 = function(){
	particle_chamber.prepare(2, "..R....").animate()
	assertEquals(["..X....",  "....X..",  "......X",  "......."].join(), particle_chamber.states.join())
}

test_example_2 = function(){
	particle_chamber.prepare(3, "RR..LRL").animate()
	assertEquals(["XX..XXX",  ".X.XX..",  "X.....X",  "......."].join(), particle_chamber.states.join())
}

test_example_3 = function(){
	particle_chamber.prepare(2, "LRLR.LRLR").animate()
	assertEquals(["XXXX.XXXX",  "X..X.X..X",  ".X.X.X.X.",  ".X.....X.",  "........."].join(), particle_chamber.states.join())
}

test_example_4 = function(){	
	particle_chamber.prepare(10, "RLRLRLRLRL").animate()
	assertEquals(["XXXXXXXXXX",  ".........."].join(), particle_chamber.states.join())
}

test_example_5 = function(){
	particle_chamber.prepare(1, "...").animate()
	assertEquals(["..."].join(), particle_chamber.states.join())
}

test_example_6 = function(){
	particle_chamber.prepare(1, "LRRL.LR.LRR.R.LRRL.").animate()
	assertEquals(["XXXX.XX.XXX.X.XXXX.",
                  "..XXX..X..XX.X..XX.",
                  ".X.XX.X.X..XX.XX.XX",
                  "X.X.XX...X.XXXXX..X",
                  ".X..XXX...X..XX.X..",
                  "X..X..XX.X.XX.XX.X.",
                  "..X....XX..XX..XX.X",
                  ".X.....XXXX..X..XX.",
                  "X.....X..XX...X..XX",
                  ".....X..X.XX...X..X",
                  "....X..X...XX...X..",
                  "...X..X.....XX...X.",
                  "..X..X.......XX...X",
                  ".X..X.........XX...",
                  "X..X...........XX..",
                  "..X.............XX.",
                  ".X...............XX",
                  "X.................X",
                  "..................."].join(), particle_chamber.states.join())
}