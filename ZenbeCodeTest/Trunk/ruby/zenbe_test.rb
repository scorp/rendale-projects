require 'test/unit'
require 'zenbe'

class ZenbeTest < Test::Unit::TestCase
  
  def setup
    @chamber = Zenbe::ParticleChamber.new()
    @chamber.prepare(1, "R...L")
    @position = @chamber.positions[0]
    @particle = @position.particles[0]
  end

  def test_examples
    @chamber.prepare(2, "..R....").animate
    assert_equal  ["..X....",  "....X..",  "......X",  "......."], @chamber.states

    @chamber.prepare(3, "RR..LRL").animate
    assert_equal  ["XX..XXX",  ".X.XX..",  "X.....X",  "......."], @chamber.states

    @chamber.prepare(2, "LRLR.LRLR").animate
    assert_equal  ["XXXX.XXXX",  "X..X.X..X",  ".X.X.X.X.",  ".X.....X.",  "........."], @chamber.states

    @chamber.prepare(10, "RLRLRLRLRL").animate
    assert_equal ["XXXXXXXXXX",  ".........." ], @chamber.states
    
    @chamber.prepare(1, "...").animate
    assert_equal ["..."], @chamber.states
    
    @chamber.prepare(1, "LRRL.LR.LRR.R.LRRL.").animate
    assert_equal [
    "XXXX.XX.XXX.X.XXXX.",
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
    "..................."], @chamber.states
  end
  
  #Test Chamber  
  def test_preparation
    @chamber = Zenbe::ParticleChamber.new
    @chamber.prepare(1, "R...L")
    assert_equal 2, @chamber.particles.length
    assert_equal 5, @chamber.positions.length, @chamber.to_s
    assert @chamber.positions[1].empty?
    assert !@chamber.positions[0].empty?
    assert_equal @chamber.prepare(1, "R...L").class, Zenbe::ParticleChamber  
  end
  
  def test_stringify
    assert_equal @chamber.prepare(1, "R...L").to_s, "X...X"
  end
  
  def test_particles
    assert_equal 0, @chamber.prepare(1, "..................................").particles.length
    assert_equal 6, @chamber.prepare(5, ".......L...L.......RRR....L..........").particles.length
    assert_equal @chamber.particles.length, @chamber.particles.find_all{|p| p.speed == 5}.length
    assert_equal 7, @chamber.particles[0].position.location
    assert_equal -5, @chamber.particles[0].velocity
    assert_equal 5, @chamber.particles[2].velocity
  end
  
  def test_empty
    assert @chamber.prepare(1, "..................................").empty?
    assert !@chamber.prepare(1, "....................R..............").empty?
  end
  
  #Test Position
  def test_add_particle
    @chamber.positions[0].add_particle(@chamber.particles[1])
    assert_equal @chamber.positions[0].particles.length, 2
  end
  
  def test_remove_particle
    @chamber.positions[0].remove_particle(@chamber.particles[0])
    assert_equal 0, @chamber.positions[0].particles.length
    assert @chamber.positions[0].empty?
  end
  
  #Test Particle
  def test_particle_movement
    @particle.move.move.move
    assert_equal 3, @particle.position.location
    @particle.speed = 2
    @particle.direction = "L"
    @particle.set_velocity
    @particle.move
    assert_equal 1, @particle.position.location
    @particle.move
    assert 1, @chamber.particles.length
  end
  
end