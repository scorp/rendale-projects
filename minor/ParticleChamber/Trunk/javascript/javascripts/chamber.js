var Zenbe = {};
Zenbe.Particle = Class.create();
Zenbe.Particle.prototype = {
	initialize: function(direction, speed, start_position){
		this.direction = direction
		this.speed = speed
		this.position = start_position
		this.chamber = this.position.chamber
		this.set_velocity()
	},
	
	set_velocity: function(){
		this.velocity = parseInt(this.speed) * (this.direction == "L" ? -1 : 1)
	},
	
	move: function(){
		if (this.position != null && (this.position.location + this.velocity) >= 0 && this.position.location <= (this.chamber.length - 1))
		{
			this.position = this.chamber.positions[this.position.location + this.velocity]
		}
		else
		{
			this.position = null
		}
	}	
}

Zenbe.Position = Class.create();
Zenbe.Position.prototype = {
	initialize: function(position, chamber){
		this.chamber = chamber
		this.location = position
		this.particles = []
		this
	},
	
	is_empty: function(){
		this_position = this
		var result = true
		this.chamber.active_particles().each(function(particle, i){
			if (particle.position == this_position)
			{
			  result = false;
			}  
		})
		return result;
	}		
}

Zenbe.ParticleChamber = Class.create();
Zenbe.ParticleChamber.prototype = {
	initialize: function(){
		this.positions = []
		this.particles = []
		this.states = []
	},
	
	prepare: function(speed, initial_state){
		var this_particle_chamber = this

		this.positions.clear()
		this.states.clear()
		
		this.initial_state = initial_state.toArray()
		this.length = initial_state.length
		
		this.initial_state.each(function(starting_contents, i){
			position = new Zenbe.Position(i, this_particle_chamber)
			if (starting_contents != ".")
			{
				this_particle_chamber.particles.push(new Zenbe.Particle(starting_contents, speed, position))
			}
			this_particle_chamber.positions.push(position)
		})
		return this_particle_chamber
	},
	
	animate: function(){
		while(!this.is_empty())
		{
			this.states.push(this.to_s())
			this.active_particles().each(function(particle, i){particle.move()})

		}
		this.states.push(this.to_s())
	},
	
	
	to_s: function(){
		var result = ""
		this.positions.each(function(position, i){
			result += position.is_empty() ? "." : "X"
		})
		return result
	},
	
	active_particles: function(){
		this.particles.select(function(particle){
			return particle.position != null
		})
		return this.particles
	},
	
	is_empty: function(){
		var result = true
		this.positions.each(function(position, i){
			if (!position.is_empty()) 
				result = false
		})
		return result
	}	
};


Event.observe(window, 'load', function(){
	Event.observe($("run"), 'click', function(){
		
		var particle_chamber = new Zenbe.ParticleChamber
		particle_chamber.prepare($("particle_speed").value,$("initial_string").value ).animate()
		var explanation = ""
		$("explanation").setStyle(
			{display: "block"}
		).update("")
		particle_chamber.states.each(function(state,i){	
			setTimeout(
				function(){
					$("animated_sim").setStyle({display: "block"})
					var positions = state.toArray()
					var html = "<div id=\"sim_wrapper\" style=\"width:" + positions.length * 28 + "px\">"
					var state_row = ""
					positions.each(function(position,i){
						if (position == "X")
						{
							html += "<div class=\"position full\" style=\"width:20px\"></div>"						
							state_row += "<div class=\"exp_position\" style=\"width:20px\">X</div>"
						}
						else
						{
							html += "<div class=\"position empty\" style=\"width:20px\"></div>"						
							state_row += "<div class=\"exp_position\" style=\"width:20px\">.</div>"						
						}
					})
					html += "</div><div style=\"clear:both\"></div>"
					explanation = "<div class=\"explanation_row\"><div style=\"height:30px; margin:auto; width:" + positions.length * 24 + "px\">" + state_row + "</div></div>"
					$("explanation").setStyle(
						{display: "block"}
					).innerHTML += explanation		
					$("animated_sim").innerHTML=html
				},i*$("simulation_speed").value)
		})
	})
})