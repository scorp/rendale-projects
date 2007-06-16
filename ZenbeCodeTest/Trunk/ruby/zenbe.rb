module Zenbe  
  
  #models a particle in the chamber
  class Particle
    attr_accessor :direction, :speed
    attr_reader :velocity, :position
    
    # setup the properties that will control the particles movement
    def initialize direction, speed, start_position
      @direction = direction
      @speed = speed
      @position = start_position
      @chamber = @position.chamber
      set_velocity
    end
  
    def set_velocity
      @velocity = speed.to_i * (direction == "L" ? -1 : 1)
    end
  
    # move the particle by velocity positions
    def move   
      @position.remove_particle(self)
      if (0..(@chamber.length - 1)).include? @position.location + @velocity         
        @position = @chamber.positions[@position.location + @velocity].add_particle(self)
      else
        @position = nil?
      end      
      self
    end      
  end
  
  # models a position within the chamber that may be occupied by 0 to many particles
  class Position
    attr_accessor :particles
    attr_reader :chamber, :location

    def initialize i, chamber
      @chamber = chamber
      @location = i
      @particles = []
      self
    end

    # add a particle to this position
    def add_particle particle
      @particles << particle
      self
    end       
    
    # remove a particle from this position
    def remove_particle particle
      @particles.delete particle      
    end
    
    # is this position empty
    def empty?
      @particles.empty?
    end
  end

  # models the particle chamber
  class ParticleChamber
    attr_accessor :positions
    attr_reader :states, :length
    
    #create arrays to hold positions and states
    def initialize
      @positions=[]
      @states = []
    end
        
    #build the chamber and load in the particles
    def prepare speed=1, initial_state="L....R"
      #clear from any previous runs
      @positions.clear
      @states.clear

      #read the initial state
      @initial_state = initial_state.split("")
      @length = initial_state.length  
      
      #load the array with particles
      @initial_state.each_with_index do |starting_contents, i|
        position = Position.new(i, self)
        position.add_particle(Particle.new(starting_contents, speed, position)) unless starting_contents == "."
        @positions << position
      end
      self
    end
    
    #run the simulation
    def animate
      while particles.length > 0
        @states << self.to_s
        particles.each{|particle| particle.move }
      end
      #add one more state to show completion
      @states << self.to_s
    end

    #render a string of the current situation
    def to_s
      result = ""
      @positions.each do |position| 
        result+=position.empty? ? "." : "X"
      end
      result
    end

    #return all the particles that are still in the chamber
    def particles
      particles = []
      @positions.each do |position|
        position.particles.each do |particle|
          particles<<particle
        end
      end
      particles
    end

    #check if the chamber is empty
    def empty?
      @positions.each do |position| 
        return false if ! position.empty?
      end
    end

  end
end

if __FILE__ == $0
  begin
    particle_chamber = Zenbe::ParticleChamber.new  
    particle_chamber.prepare(ARGV[0],ARGV[1]).animate
    puts particle_chamber.states
  rescue
    puts "usage error"
  end
end
