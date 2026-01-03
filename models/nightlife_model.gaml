/**
* Name: NightlifeModel
* Based on the internal empty template. 
* Author: pshvaiko
* Tags: 
*/


model NightlifeModel

global {
	
	float world_width <- 100.0;
    float world_height <- 100.0;
    
    int party_guests_count <- 10;
    int introvert_guests_count <- 10;
    int foodie_guests_count <- 10;
    int music_guests_count <- 10;
    int vegan_guests_count <- 10;
    
    list<PlaceBase> ALL_PLACES;
    
    // ---- COLOR PALETTE ----
    rgb COLOR_BAR        <- rgb(255, 140, 0);    // Dark Orange
	rgb COLOR_CONCERT    <- rgb(138, 43, 226);   // Blue Violet / Purple
	rgb COLOR_CAFE       <- rgb(139, 69, 19);    // Saddle Brown
	rgb COLOR_RESTAURANT <- rgb(46, 139, 87);    // Sea Green
	rgb COLOR_CLUB       <- rgb(220, 20, 60);    // Crimson Red
	rgb COLOR_DEFAULT    <- rgb(200, 200, 200);  // Light Gray
	rgb COLOR_BORDER     <- rgb(204, 204, 204);  // Gray
	
	// ---- GUEST COLOR PALETTE ----
	rgb COLOR_PARTY_GUEST     <- rgb(255, 69, 0);     // Orange Red (energetic, loud)
	rgb COLOR_INTROVERT       <- rgb(65, 105, 225);   // Royal Blue (calm, reserved)
	rgb COLOR_MUSIC_FAN       <- rgb(186, 85, 211);   // Medium Purple (music / creativity)
	rgb COLOR_FOODIE          <- rgb(50, 205, 50);    // Lime Green (food, generosity)
	rgb COLOR_VEGAN_ACTIVIST  <- rgb(154, 205, 50);   // Yellow Green (eco / ethics)
	rgb COLOR_GUEST_DEFAULT   <- rgb(220, 220, 220);  // Light Gray
	
	string FIPA_HELLO_MSG <- "hello_msg";
	string FIPA_HELLO_REPLY <- "hello_reply";
	
	int LOG_LEVEL_DEBUG <- 0;
	int LOG_LEVEL_INFO <- 1;
	int LOG_LEVEL_PRESENTATION <- 2;
	int LOG_LEVEL_WARNING <- 3;

	int min_log_level <- LOG_LEVEL_PRESENTATION;
	
	int guestIdGenerator <- 0;
	
    init {
    	// ===== ENVIRONMENT =====
        create Background {
            location <- {world_width / 2, world_height / 2};
        }

        // ===== PLACES =====
        create Bar {
            location <- {20, 45};
        }

        create Concert {
            location <- {20, 80};
        }

        create Cafe {
            location <- {20, 20};
        }

        create Restaurant {
            location <- {80, 65};
        }

        create Club {
            location <- {80, 20};
        }
        
        ALL_PLACES <- (Bar + Concert + Cafe + Restaurant + Club);

        // ===== GUESTS (example) =====
        // Party guests
		create PartyGuest number: party_guests_count {
		    location <- { rnd(5, world_width - 5), rnd(5, world_height - 5) };
		    guestId <- guestIdGenerator;
		    guestIdGenerator <- guestIdGenerator + 1;
		}
		
		// Introverts
		create GuestIntrovert number: introvert_guests_count {
		    location <- { rnd(5, world_width - 5), rnd(5, world_height - 5) };
		    guestId <- guestIdGenerator;
		    guestIdGenerator <- guestIdGenerator + 1;
		}
		
		// Foodies
		create GuestFoodie number: foodie_guests_count {
		    location <- { rnd(5, world_width - 5), rnd(5, world_height - 5) };
		    guestId <- guestIdGenerator;
		    guestIdGenerator <- guestIdGenerator + 1;
		}
		
		// Music fans
		create GuestMusicFan number: music_guests_count {
		    location <- { rnd(5, world_width - 5), rnd(5, world_height - 5) };
		    guestId <- guestIdGenerator;
		    guestIdGenerator <- guestIdGenerator + 1;
		}
		
		// Vegan activists
		create GuestVeganActivist number: vegan_guests_count {
		    location <- { rnd(5, world_width - 5), rnd(5, world_height - 5) };
		    guestId <- guestIdGenerator;
		    guestIdGenerator <- guestIdGenerator + 1;
		}
    }
    
    action write_happiness_stats(string prefix, list<float> data) {
    	
    	float min_val <- min(data);
    	float max_val <- max(data);
    	float mean_val <- mean(data);
    	float median_val <- median(data);
    	
    	write "cycle: " + cycle + "|| " + prefix
	        + " | min=" + min_val
	        + " max=" + max_val
	        + " mean=" + mean_val
	        + " median=" + median_val;
    }
    
    reflex write_statistics when: cycle mod 10 = 0 {
    	// Redundant code but I did not find a better to do this.
		list<GuestBase> all_party <- PartyGuest;
        list<GuestBase> all_introvert <- GuestIntrovert;
        list<GuestBase> all_music_fan <- GuestMusicFan;
        list<GuestBase> all_foodie <- GuestFoodie;
        list<GuestBase> all_vegan_activist <- GuestVeganActivist;

		// concatenate all lists
	    list<GuestBase> all_guests <- all_party + all_introvert + 
	    	all_music_fan + all_foodie + all_vegan_activist;

	   list<float> all_happiness <- all_guests collect each.happiness;
	   do write_happiness_stats("HAPPINESS STATS: ALL GUESTS:", all_happiness);
	   
	   // ---- per-type stats ----
	    list<float> party_happiness <- all_party collect each.happiness;
	    do write_happiness_stats("HAPPINESS STATS: PARTY GUESTS", party_happiness);
	
	    list<float> introvert_happiness <- all_introvert collect each.happiness;
	    do write_happiness_stats("HAPPINESS STATS: INTROVERTS", introvert_happiness);
	
	    list<float> music_happiness <- all_music_fan collect each.happiness;
	    do write_happiness_stats("HAPPINESS STATS: MUSIC FANS", music_happiness);
	
	    list<float> foodie_happiness <- all_foodie collect each.happiness;
	    do write_happiness_stats("HAPPINESS STATS: FOODIES", foodie_happiness);
	
	    list<float> vegan_happiness <- all_vegan_activist collect each.happiness;
	    do write_happiness_stats("HAPPINESS STATS: VEGAN ACTIVISTS", vegan_happiness);
    }
}

// ==================================================
// ===================== PLACES =====================
// ==================================================

species Background {

    aspect base {
        // Background fill
        draw rectangle(world_width, world_height)
            color: rgb(20, 20, 20);

        // Border
        draw rectangle(world_width, world_height)
            border: rgb(120, 120, 120);

        // Title (TOP CENTER)
		draw string("NIGHTLIFE DISTRICT")
	        at: {world_width / 2 - 20, 5}
	        color: rgb(0, 0, 0)
	        font: font("Arial", 56);
    }
}

species PlaceBase {
	string kind;			// "bar", "concert", "cafe", "restaurant", "club"
	float noise;
	float social_pressure;
	
	int min_length_stay;	// min number of cycles a guest has to stay at a place
	int arrival_radius;
	
	aspect base {
        draw square(15) color: COLOR_DEFAULT border: COLOR_BORDER;
    }
}

species Bar parent: PlaceBase {

    init {
        kind <- "bar";
        noise <- 0.7;
        social_pressure <- 0.6;
        min_length_stay <- 10;
        arrival_radius <- 8;
    }
    
    aspect base {
        draw square(20) color: COLOR_BAR border: COLOR_BORDER;
        draw string("BAR")
	        at: (location + {-3, -6})
	        color: rgb(0, 0, 0)
	        font: font("Arial", 48);
    }
}

species Concert parent: PlaceBase {

    init {
        kind <- "concert";
        noise <- 0.9;
        social_pressure <- 0.8;
        min_length_stay <- 50;
        arrival_radius <- 15;
    }
    
    aspect base {
        draw square(38) color: COLOR_CONCERT border: COLOR_BORDER;
        draw string("CONCERT")
	        at: (location + {-3, -6})
	        color: rgb(0, 0, 0)
	        font: font("Arial", 48);
    }
}

species Cafe parent: PlaceBase {

    init {
        kind <- "cafe";
        noise <- 0.2;
        social_pressure <- 0.3;
        min_length_stay <- 10;
        arrival_radius <- 5;
    }
    
    aspect base {
        draw square(16) color: COLOR_CAFE border: COLOR_BORDER;
        draw string("CAFE")
	        at: (location + {-3, -6})
	        color: rgb(0, 0, 0)
	        font: font("Arial", 48);
    }
}

species Restaurant parent: PlaceBase {

    init {
        kind <- "restaurant";
        noise <- 0.3;
        social_pressure <- 0.4;
        min_length_stay <- 15;
        arrival_radius <- 9;
    }
    
    aspect base {
        draw square(24) color: COLOR_RESTAURANT border: COLOR_BORDER;
        draw string("RESTAURANT")
	        at: (location + {-3, -6})
	        color: rgb(0, 0, 0)
	        font: font("Arial", 48);
    }
}

species Club parent: PlaceBase {

    init {
        kind <- "club";
        noise <- 0.85;
        social_pressure <- 0.9;
        min_length_stay <- 20;
        arrival_radius <- 13;
    }
    
    aspect base {
        draw square(32) color: COLOR_CLUB border: COLOR_BORDER;
        draw string("CLUB")
	        at: (location + {-3, -6})
	        color: rgb(0, 0, 0)
	        font: font("Arial", 48);
    }
}


// ==================================================
// ===================== GUESTS =====================
// ==================================================

// 1. Initially guests are wandering around

// 2. Then they have a chance of picking a place to go to randomly
//    chance of picking a place to go is proportional to the number of steps
//    they have been wandering around for

// 3. Then they head to the place they picked
//    Their happiness level right before coming to the place they picked is recorded

// 4. Then they have to stay at a place for some fixed amount of time (different for each place)

// 5. After that time passes they can choose to stay at the place for longer or leave
//    depends whether their happiness level increased or not

// 6. Happiness level increases/decreases inversely proportional to the value.
//    When it becomes high - it increases slower
//    When it becomes low - it decreases slower


// Types of communication:
//
// 1. Saying "Hello"

// 2. Offering food

// 3. Offering drinks

// 3. Offering to party/dance together

// 4. Music fan does not always reply because they are listening to music (might upset other guests)

// 5. 


species GuestBase skills: [moving, fipa]  {
	int guestId;
	float sociability;
   	float tolerance;
    float generosity;
    float happiness <- 0.5;
    
    float hello_agree_happiness_delta;
	float hello_refuse_happiness_delta;
    
    // Last time-step the guest said "hello"
    int last_hello_step <- -1000;   // long a
    // The number of time-steps to not say "hello" after saying "hello"
	int HELLO_COOLDOWN  <- 20;      // steps between hellos
	// The radius to consider during FIPA communication
	float COMMUNICATION_RADIUS  <- 10.0;
	
	// The radius that Guests consider to decide whether a place is crowded or not
	float SOCIAL_DENSITY_RADIUS <- 20.0;
	
	// variables related to choosing and going to locations
	int num_cycles_to_wander;
	int leave_place_cycle <- nil;	// cycle number when agent can leave the current place
	int last_in_place_cycle <- 0;	// cycle number when agent was last in a place, updated when agent leaves a place
	float choose_place_probability;	// probability of choosing to go to a place instead of keeping on wandering around
	float leave_place_probability <- 0.3;
    
    PlaceBase current_place <- nil;
    
    aspect base {
        draw circle(1.8) color: COLOR_GUEST_DEFAULT;
    }
    
    // Guests wander around randomly if they have no specific place to go to
    reflex wander_around when: current_place = nil {
    	do wander;
    }

    reflex go_or_stay_or_leave_place when: current_place != nil {
    	// distance to target place
    	float d <- location distance_to current_place.location;
    	
    	// ---- NOT YET AT PLACE → MOVE ----
	    if (d > current_place.arrival_radius) {
	        do goto target: current_place.location;
	    }
	    // ---- AT THE PLACE ----
	    else {	// at the place so just move around
	    	do wander;
	    	if (leave_place_cycle = nil) {
	    		leave_place_cycle <- cycle + current_place.min_length_stay;
	    	}
	    	if (cycle > leave_place_cycle and rnd(0.0, 1.0) <= leave_place_probability) {
	    		// Leave place
	    		do log(LOG_LEVEL_INFO, guestId,
	    			"Guest " + guestId + " is leaving a place " + current_place.kind
	    		);
	    		last_in_place_cycle <- cycle;
	    		leave_place_cycle <- nil;
	    		current_place <- nil;
	    	}
	    } 
    }
   	
   	// An action to log an event to the conosole
   	// shoudld be a global action but I didn't manage to make it work.
    action log(int level, int guestIdParam, string event) {
		if (level >= min_log_level) {
			write "[step=" + cycle + "] [agent=" + guestIdParam + "] " + event;
		}
	}
    
    // Returns a list of all guests in the COMMUNICATION_RADIUS
    list<GuestBase> get_nearby_guests(int radius) {
    	// Redundant code but I did not find a better to do this.
		list<GuestBase> nearby_party <- PartyGuest
        where (each != self and
               (location distance_to each.location) <= radius);
        list<GuestBase> nearby_introvert <- GuestIntrovert
        where (each != self and
               (location distance_to each.location) <= radius);
        list<GuestBase> nearby_music_fan <- GuestMusicFan
        where (each != self and
               (location distance_to each.location) <= radius);
        list<GuestBase> nearby_foodie <- GuestFoodie
        where (each != self and
               (location distance_to each.location) <= radius);
        list<GuestBase> nearby_vegan_activist <- GuestVeganActivist
        where (each != self and
               (location distance_to each.location) <= radius);

		// concatenate all lists
	    list<GuestBase> all_nearby <- nearby_party + nearby_introvert + 
	    	nearby_music_fan + nearby_foodie + nearby_vegan_activist;

	    // shuffle to avoid type bias
	    return shuffle(all_nearby);
    }
    
    
	/**
	 * Compute a base desirability score for a place based on
	 * compatibility between agent traits and place properties.
	 *
	 * - tolerance determines how well the agent handles noise
	 * - sociability determines how much the agent enjoys social pressure
	 *
	 * The (trait - 0.5) term amplifies preference:
	 *   - agents above 0.5 prefer high values
	 *   - agents below 0.5 prefer low values
	 *
	 * The result is an unbounded real-valued score (can be negative).
	 */
	float score_place_base(PlaceBase p) {
	
	    // Noise compatibility:
	    //  - high tolerance → likes noisy places
	    //  - low tolerance → prefers quiet places
	    float noise_score <- tolerance + (tolerance - 0.5) * p.noise;
	
	    // Social compatibility:
	    //  - sociable agents prefer high social pressure
	    //  - introverted agents prefer calm environments
	    float social_score <- sociability + (sociability - 0.5) * p.social_pressure;
	
	    // Combine both factors with equal importance
		float score <- (0.5 * noise_score) + (0.5 * social_score);
	
	    return score;
	}
	
	// TODO: move to individual Guest types
	float score_place_specific(PlaceBase p) {
		return 0.0;
	}
	

     /**
	 * Normalize a list of raw place scores into a probability distribution.
	 *
	 * Steps:
	 * 1. Shift scores by a constant offset if needed so all values are ≥ 0
	 *    (this preserves relative preferences).
	 * 2. Normalize by dividing each score by the total sum.
	 *
	 * If all scores collapse to zero, fall back to a uniform distribution.
	 */
	list<float> normalize_place_probs(list<float> place_scores) {
	
		// Shift scores if any are negative so the minimum becomes 0
	    float min_score <- min(place_scores);
	    float offset <- max(0.0, -min_score);
	
	    list<float> shifted_scores <- place_scores collect (each + offset);
	
	    do log(
	        LOG_LEVEL_DEBUG,
	        guestId,
	        "Score offset applied: " + offset
	    );
	
	    // Convert shifted scores into probabilities
	    float sum_weights <- sum(shifted_scores);
	
	    // Safety fallback: uniform probabilities if all scores are zero
	    if (sum_weights <= 0.0) {
	        shifted_scores <- place_scores collect 1.0;
	        sum_weights <- length(place_scores);
	
	        do log(
	            LOG_LEVEL_WARNING,
	            guestId,
	            "All place scores were zero after shift; using uniform distribution"
	        );
	    }
	
	    list<float> probs <- shifted_scores collect (each / sum_weights);
	
	    do log(
	        LOG_LEVEL_DEBUG,
	        guestId,
	        "Normalized probabilities: " + probs
	    );
	
	    return probs;
	}

	/**
	 * Sample a place using a weighted random choice.
	 *
	 * The algorithm:
	 *  - Draw a random number r ∈ [0,1)
	 *  - Walk through cumulative probabilities
	 *  - Select the first place whose cumulative probability exceeds r
	 *
	 * This implements roulette-wheel (fitness-proportionate) selection.
	 */
	PlaceBase pick_place_by_weighted_probs(list<float> normalized_place_probs) {
	
	    list<PlaceBase> places <- ALL_PLACES;
	
	    do log(
	        LOG_LEVEL_DEBUG,
	        guestId,
	        "Normalized place probabilities: "
	        + (places collect (each.kind + "="))
	        + normalized_place_probs
	    );
	
	    float r <- rnd(0.0, 1.0);
	    float acc <- 0.0;
	    int idx <- 0;
	
	    // Cumulative probability scan
	    loop i from: 0 to: length(normalized_place_probs) - 1 {
	        acc <- acc + normalized_place_probs[i];
	        if (r <= acc) {
	            idx <- i;
	            break;
	        }
	    }
	
	    do log(
	        LOG_LEVEL_INFO,
	        guestId,
	        "Agent " + guestId + " chose place "
	        + places[idx].kind
	        + " (p=" + normalized_place_probs[idx] + ")"
	    );
	
	    return places[idx];
	}
	
	PlaceBase pick_place_random {
		list<PlaceBase> places <- ALL_PLACES;
		int idx <- rnd(0, 4);
		return places[idx];
	}


	/**
	 * Decide whether to choose a new place and select it probabilistically.
	 *
	 * This reflex:
	 *  - Computes raw desirability scores for all places
	 *  - Normalizes them into probabilities
	 *  - Samples one place using weighted random selection
	 *
	 * The stochastic decision allows heterogeneous but non-deterministic behavior.
	 */
	reflex choose_place
	when: current_place = nil
	  and cycle > last_in_place_cycle + num_cycles_to_wander
	  and rnd(0.0, 1.0) < choose_place_probability
	{
	
	    list<PlaceBase> places <- ALL_PLACES;
	
	    // Compute raw desirability scores (can be negative)
	    list<float> weights <- places collect score_place_base(each);
	
	    do log(
	        LOG_LEVEL_DEBUG,
	        guestId,
	        "Raw place scores: "
	        + (places collect (each.kind + "="))
	        + weights
	    );
	
	    // Convert raw scores into a valid probability distribution
	    list<float> normalized_weights <- normalize_place_probs(weights);
	
	    // Sample one place according to probabilities
	    current_place <- pick_place_by_weighted_probs(normalized_weights);
	}
    
    action handle_hello_request(message m) {
    	do log(LOG_LEVEL_DEBUG, guestId,
    		   "RECEIVED_HELLO from agent " + (m.sender as GuestBase).guestId
    	);
    	if (rnd(0.0, 1.0) < sociability) {
    		do agree message: m contents: [FIPA_HELLO_REPLY, "Hello back!"];
    		do log(LOG_LEVEL_DEBUG, guestId, "AGREES_HELLO to agent " + (m.sender as GuestBase).guestId);
    	}
    	else {
    		do refuse message: m contents: [FIPA_HELLO_REPLY, "I do not want to talk with people right now."];
    		do log(LOG_LEVEL_DEBUG, guestId, "REFUSES_HELLO to agent " + (m.sender as GuestBase).guestId);
    	}
    }
    
    action handle_hello_agree(message m) {
    	happiness <- happiness + (1.0 - happiness) * hello_agree_happiness_delta;
    	do log(LOG_LEVEL_DEBUG, guestId,
    		   "Ending conversation with guest: " + (m.sender as GuestBase).guestId + " due to AGREE."
    	);
    	do end_conversation message: m contents: ['End!'];
    }
    
    action handle_hello_refuse(message m) {
    	happiness <- happiness - (happiness * hello_refuse_happiness_delta);
    	do log(LOG_LEVEL_DEBUG, guestId,
    		   "Ending conversation with guest: " + (m.sender as GuestBase).guestId + " due to REFUSE"
    	);
    	do end_conversation message: m contents: ['End'];
    }
    
    reflex say_hello {
    	// must be in a place
	    if (current_place = nil) { 
	        return; 
	    }
	    // cooldown check
	    if (cycle - last_hello_step < HELLO_COOLDOWN) {
	        return;
	    }
	    // nearby guests (excluding self)
	    list<GuestBase> nearby <- get_nearby_guests(COMMUNICATION_RADIUS);
		int n <- length(nearby);
    	if (n = 0) { 
    		return;
    	}
    	
    	// TODO: log p_hello and check that it is reasonable
    	float crowd_factor <- min(1.0, n / 6.0);
	    float place_factor <- current_place.social_pressure;
	    float p_hello <- sociability * crowd_factor * place_factor;
	    
	    if (rnd(0.0, 1.0) < p_hello) {
	    	GuestBase target <- one_of(nearby);
	    	
	    	do start_conversation(
	    		to: [target],
	    		performative: "request",
	    		protocol: "no-protocol",
	    		contents: [FIPA_HELLO_MSG, "Hello!"]
	    	);
	    	do log(LOG_LEVEL_DEBUG, guestId,
	    		   "SAY_HELLO to agent " + target.guestId + " (p=" + p_hello + ")"
	    	);
	    	last_hello_step <- cycle;
	    }
    }
}

species PartyGuest parent: GuestBase {

	// Invites people to party together when at club until group number reaches some max number
	//   the larger the number of people the faster happiness increases
	// Only send invites to party, music people. Occasionally send invites also to other
	
	// If offered food, when accepting food invites to party together
	
	// Say hi to people often, not always

    init {
        sociability <- rnd(0.7, 1.0);
        tolerance <- rnd(0.6, 1.0);
        generosity <- rnd(0.4, 0.9);
        // Small happiness update when others say hi back
		// PartyGuest says hi often and it is not a big deal for them
        hello_agree_happiness_delta <- 0.05;
        hello_refuse_happiness_delta <- 0.05;
        
        num_cycles_to_wander <- 5;
		choose_place_probability <- 0.5;
    }
    
    aspect base {
        draw circle(2.0) color: COLOR_PARTY_GUEST;
    }
    
    reflex adjust_happiness {
    	// TODO
    }
    
    reflex handle_requests when: !empty(requests) {
    	// Take the first pending request message
    	message m <- requests[0];
        list args <- m.contents;
        string msg_str <- args[0] as string;
        
        if (msg_str = FIPA_HELLO_MSG) {
        	do handle_hello_request(m);
        }
    }
    
    reflex handle_agrees when: !empty(agrees) {
    	// Take the first pending agree message
    	message m <- agrees[0];
    	list args <- m.contents;
    	string msg_str <- args[0] as string;
    	
    	if (msg_str = FIPA_HELLO_REPLY) {
    		do handle_hello_agree(m);
    	}
    }
    
    reflex handle_refuses when: !empty(refuses) {
    	message m <- refuses[0];
    	list args <- m.contents;
    	string msg_str <- args[0] as string;
    	
    	if (msg_str = FIPA_HELLO_REPLY) {
    		do handle_hello_refuse(m);
    	}
    }

    reflex enjoy_noise when: current_place != nil {
        if (current_place.noise > 0.6) {
            happiness <- happiness + 0.01;
        }
    }
}

species GuestIntrovert parent: GuestBase {

	// With high probability happiness decreases when [party, music] try to interact
	// With 50/50 probability happiness decreases when others try to interact
	
	// Does not initiate any communication

    init {
        sociability <- rnd(0.1, 0.3);
        tolerance <- rnd(0.1, 0.4);
        generosity <- rnd(0.1, 0.3);
        // If an introvert says hi then the reply affects their happiness a lot
        hello_agree_happiness_delta <- 0.2;
        hello_refuse_happiness_delta <- 0.2;
        
        num_cycles_to_wander <- 25;
		choose_place_probability <- 0.3;
    }
    
    aspect base {
        draw circle(2) color: COLOR_INTROVERT;
    }
    
    reflex adjust_happiness {
    	// React to noise
    	happiness <- happiness - max(0, current_place.noise - tolerance) * 0.02;
    }
    
    reflex handle_requests when: !empty(requests) {
    	// Take the first pending request message
    	message m <- requests[0];
        list args <- m.contents;
        string msg_str <- args[0] as string;
        
        if (msg_str = FIPA_HELLO_MSG) {
        	do handle_hello_request(m);
        }
    }
    
    reflex handle_agrees when: !empty(agrees) {
    	// Take the first pending agree message
    	message m <- agrees[0];
    	list args <- m.contents;
    	string msg_str <- args[0] as string;
    	
    	if (msg_str = FIPA_HELLO_REPLY) {
    		do handle_hello_agree(m);
    	}
    }
    
    reflex handle_refuses when: !empty(refuses) {
    	message m <- refuses[0];
    	list args <- m.contents;
    	string msg_str <- args[0] as string;
    	
    	if (msg_str = FIPA_HELLO_REPLY) {
    		do handle_hello_refuse(m);
    	}
    }
}

species GuestMusicFan parent: GuestBase {
	
	// happiness increases at concert or club when their genre matches
	//   the genre in the places must switch every some number of steps

    string favorite_genre <- one_of(["rock", "pop"]);

    init {
        sociability <- rnd(0.4, 0.7);
        tolerance <- rnd(0.5, 0.8);
        generosity <- rnd(0.2, 0.5);
        // A music fan is not much affected by replies to hello
        hello_agree_happiness_delta <- 0.05;
        hello_refuse_happiness_delta <- 0.05;
        
        num_cycles_to_wander <- 10;
		choose_place_probability <- 0.5;
    }
    
    aspect base {
        draw circle(2) color: COLOR_MUSIC_FAN;
    }
    
    reflex adjust_happiness {
    	// concert happiness
    	if (current_place != nil) {
    		happiness <- happiness + 0.03;
    	}
    }

    reflex handle_requests when: !empty(requests) {
    	// Take the first pending request message
    	message m <- requests[0];
        list args <- m.contents;
        string msg_str <- args[0] as string;
        
        if (msg_str = FIPA_HELLO_MSG) {
        	do handle_hello_request(m);
        }
    }
    
    reflex handle_agrees when: !empty(agrees) {
    	// Take the first pending agree message
    	message m <- agrees[0];
    	list args <- m.contents;
    	string msg_str <- args[0] as string;
    	
    	if (msg_str = FIPA_HELLO_REPLY) {
    		do handle_hello_agree(m);
    	}
    }
    
    reflex handle_refuses when: !empty(refuses) {
    	message m <- refuses[0];
    	list args <- m.contents;
    	string msg_str <- args[0] as string;
    	
    	if (msg_str = FIPA_HELLO_REPLY) {
    		do handle_hello_refuse(m);
    	}
    }
}

species GuestFoodie parent: GuestBase {
	
	// happiness increases at restaurant, bar, cafe
	
	// 
	
	init {
        sociability <- rnd(0.4, 0.7);
        tolerance <- rnd(0.4, 0.7);
        generosity <- rnd(0.6, 1.0);
        // A foodie is moderately affected by hello replies
        hello_agree_happiness_delta <- 0.1;
        hello_refuse_happiness_delta <- 0.1;
        
        num_cycles_to_wander <- 10;
		choose_place_probability <- 0.3;
    }
    
    aspect base {
        draw circle(2) color: COLOR_FOODIE;
    }
    
    reflex adjust_happiness {
		// TODO
    }

	reflex handle_requests when: !empty(requests) {
    	// Take the first pending request message
    	message m <- requests[0];
        list args <- m.contents;
        string msg_str <- args[0] as string;
        
        if (msg_str = FIPA_HELLO_MSG) {
        	do handle_hello_request(m);
        }
    }
    
    reflex handle_agrees when: !empty(agrees) {
    	// Take the first pending agree message
    	message m <- agrees[0];
    	list args <- m.contents;
    	string msg_str <- args[0] as string;
    	
    	if (msg_str = FIPA_HELLO_REPLY) {
    		do handle_hello_agree(m);
    	}
    }
    
    reflex handle_refuses when: !empty(refuses) {
    	message m <- refuses[0];
    	list args <- m.contents;
    	string msg_str <- args[0] as string;
    	
    	if (msg_str = FIPA_HELLO_REPLY) {
    		do handle_hello_refuse(m);
    	}
    }

    reflex share_food {
        // TODO: using FIPA
    }
}

species GuestVeganActivist parent: GuestBase {
	
	float conviction <- rnd(0.6, 1.0);
	
	aspect base {
        draw circle(2) color: COLOR_VEGAN_ACTIVIST;
    }
    
    reflex adjust_happiness {
    	// TODO
    }

    init {
        sociability <- rnd(0.3, 0.6);
        tolerance <- rnd(0.2, 0.5);
        generosity <- rnd(0.2, 0.4);
        // A vegan is moderately affected by replies to hello
        // A negative reply has a greater affect
        hello_agree_happiness_delta <- 0.07;
        hello_refuse_happiness_delta <- 0.15;
        
        num_cycles_to_wander <- 15;
		choose_place_probability <- 0.3;
    }
    
    reflex handle_requests when: !empty(requests) {
    	// Take the first pending request message
    	message m <- requests[0];
        list args <- m.contents;
        string msg_str <- args[0] as string;
        
        if (msg_str = FIPA_HELLO_MSG) {
        	do handle_hello_request(m);
        }
    }
    
    reflex handle_agrees when: !empty(agrees) {
    	// Take the first pending agree message
    	message m <- agrees[0];
    	list args <- m.contents;
    	string msg_str <- args[0] as string;
    	
    	if (msg_str = FIPA_HELLO_REPLY) {
    		do handle_hello_agree(m);
    	}
    }
    
    reflex handle_refuses when: !empty(refuses) {
    	message m <- refuses[0];
    	list args <- m.contents;
    	string msg_str <- args[0] as string;
    	
    	if (msg_str = FIPA_HELLO_REPLY) {
    		do handle_hello_refuse(m);
    	}
    }

    reflex confront_foodies {
        // TODO: using FIPA
    }
}


// =======================================================
// ===================== EXPERIMENTS =====================

experiment NightlifeGUI type: gui {

    // ---------- PARAMETERS ----------
    parameter "Party people" var: party_guests_count
    	min: 0 max: 30 step: 1 category: "Population";
    parameter "Introverts" var: introvert_guests_count
    	min: 0 max: 30 step: 1 category: "Population";
    parameter "Foodies" var: foodie_guests_count
    	min: 0 max: 30 step: 1 category: "Population";
    parameter "Music fans" var: music_guests_count
    	min: 0 max: 30 step: 1 category: "Population";
    parameter "Vegans" var: vegan_guests_count
    	min: 0 max: 30 step: 1 category: "Population";

    // ---------- OUTPUT ----------
    output {
		display night_district {
			species Background aspect: base;
			species Bar aspect: base;
			species Concert aspect: base;
			species Cafe aspect: base;
			species Restaurant aspect: base;
			species Club aspect: base;
			
			species PartyGuest aspect: base;
			species GuestIntrovert aspect: base;
			species GuestMusicFan aspect: base;
			species GuestFoodie aspect: base;
			species GuestVeganActivist aspect: base;
		}
    }
}


// TODO:
// 1. Add functionality of going to places

// 1.1. Display statistics information

// 2.1 In a club party guests invite others to their groups, happiness changes based on response
//     Introverts also become less happy when invited to groups

// 2.2 Menu inquiry in Bar, Restaurant, Cafe (VeganActivist), ordering food

// 2.3 Vegan activist inquires what food the guests are eating

// 3. Add functionality of sharing food / drinks (vegan/ not vegan)

// 3.3 Music genre debate in club and concert:
//     Music fan sends an inform or request about what genre they like







// 5.5 Music fans getting into their own groups and staying in them for longer

// 6. From time to time calculate statistics and show them

// 7. Change happiness based on guest type and how many people there are nearby



// 2. Add functionality of becoming hungry and going to get food/drinks
//    Choosing to go to bar/restaurant is less likely when guest is full

// 4. Add functionality of getting in groups in bar, club, concert


// 5. Add functionality of club/concert playing different type of music (rock/pop) and affecting the music fans




