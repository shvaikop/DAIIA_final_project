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

	
	// Party group invitations (FIPA message keys)
	string PROTOCOL_PARTY_INVITE <- "fipa-request";
	string FIPA_PARTY_INVITE <- "party_invite";
	string FIPA_PARTY_INVITE_REPLY <- "party_invite_reply";
	
	// Music Genre
	string FIPA_GENRE_ASK <- "genre_ask";
	string FIPA_GENRE_REPLY <- "genre_reply";
	string PROTOCOL_GENRE_CHAT <- "fipa-request";
	
	
	// Share food
	string FIPA_FOOD_OFFER <- "food_offer";
	string FIPA_FOOD_REPLY <- "food_reply";
	string PROTOCOL_FOOD <- "fipa-request";
	
	
	// Vegan ↔ Restaurant
	string FIPA_VEGAN_MENU_ASK   <- "vegan_menu_ask";
	string FIPA_VEGAN_MENU_REPLY <- "vegan_menu_reply";
	string PROTOCOL_VEGAN_MENU   <- "fipa-request";
	
	// Vegan ↔ Guests (what are you eating?)
	string FIPA_FOOD_QUERY_ASK   <- "food_query_ask";
	string FIPA_FOOD_QUERY_REPLY <- "food_query_reply";
	string PROTOCOL_FOOD_QUERY   <- "fipa-request";
	
	
	
	
	
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

species Restaurant parent: PlaceBase skills: [fipa] {
	
	bool has_vegan_options <- true;
	int last_menu_toggle_step <- 0;
	int MENU_TOGGLE_PERIOD <- 50;
	

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
    
    reflex handle_requests when: !empty(requests) {

	    message msg_req <- requests[0];
	    list args <- msg_req.contents;
	    if (empty(args)) { return; }
	
	    string topic <- args[0] as string;
	
	    if (topic = FIPA_VEGAN_MENU_ASK) {
	
	        string reply <- (has_vegan_options ? "Yes, we have vegan options." : "No vegan options right now.");
	
	        do agree message: msg_req contents: [FIPA_VEGAN_MENU_REPLY, has_vegan_options, reply];
	
	        // Optional logging (Restaurant doesn't have guestId, so keep it simple)
	        write "[step=" + cycle + "] [restaurant] VEGAN_MENU_REPLY -> " + reply;
	    }
	}
	    
    
    reflex update_menu {
	    if (cycle - last_menu_toggle_step >= MENU_TOGGLE_PERIOD) {
	        has_vegan_options <- (rnd(0.0, 1.0) < 0.7); // 70% chance vegan options available
	        last_menu_toggle_step <- cycle;
	    }
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
	
	float BASELINE_HAPPINESS <- 0.5;
	float HAPPINESS_DECAY_RATE <- 0.005;
    
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
    
    PartyGuest group_leader <- nil;
	int party_join_cycle <- -1;  // cycle when this guest joined the party group (debug/analysis)
	
	string current_food <- "none";
	
	map<string, float> place_preferences;
	float learning_rate <- 0.3;
	
	float happiness_before_place <- nil;

	
    
    aspect base {
        draw circle(1.8) color: COLOR_GUEST_DEFAULT;
    }
    
    // Guests wander around randomly if they have no specific place to go to
    reflex wander_around when: current_place = nil {
    	do wander;
    }
    
    // If I'm in a party group, copy the leader's destination place.
	// This creates a visible effect: members move to the same place.
    reflex follow_party_leader when: group_leader != nil {
    	if (group_leader.current_place != nil and current_place != group_leader.current_place) {
        	current_place <- group_leader.current_place;
    	}
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
			if (current_place != nil) {
			    if (current_place.kind = "restaurant" or current_place.kind = "cafe" or current_place.kind = "bar") {
			        // Simple random meal
			        current_food <- one_of(["salad", "vegan_bowl", "burger", "steak"]);
			    }
			}
				    	
	    	if (leave_place_cycle = nil) {
	    		happiness_before_place <- happiness;
	    		leave_place_cycle <- cycle + current_place.min_length_stay;
	    	}
	    	if (cycle > leave_place_cycle and rnd(0.0, 1.0) <= leave_place_probability) {
	    		// Leave place
	    		do log(LOG_LEVEL_INFO, guestId,
	    			"Guest " + guestId + " is leaving a place " + current_place.kind
	    		);
	    		
	    		float reward <- happiness - happiness_before_place;
				
				string k <- current_place.kind;
				float old_q <- place_preferences[k];
				
				place_preferences[k] <- old_q + learning_rate * (reward - old_q);
				
				do log(LOG_LEVEL_DEBUG, guestId,
				    "RL_UPDATE | place=" + k
				    + " reward=" + reward
				    + " Q=" + place_preferences[k]
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
	
	
	// Applies a bounded happiness delta with diminishing returns
	action apply_happiness_delta(float delta) {
	    if (delta > 0) {
	        happiness <- happiness + (1.0 - happiness) * delta;
	    } else {
	        happiness <- happiness + happiness * delta; // delta < 0
	    }
	    happiness <- max(0.0, min(1.0, happiness));
	}
	
	reflex decay_happiness
	when: cycle mod 5 = 0 {
	
	    // Pull happiness slightly toward baseline
	    happiness <- happiness + (BASELINE_HAPPINESS - happiness) * HAPPINESS_DECAY_RATE;
	
	    happiness <- max(0.0, min(1.0, happiness));
	}
	
	reflex adjust_happiness_social_density
	when: current_place != nil and cycle mod 5 = 0 {
	
	    list<GuestBase> nearby <- get_nearby_guests(SOCIAL_DENSITY_RADIUS);
	
	    // Preferred crowd size based on sociability
		float preferred <- sociability * 6.0;
		
		// Actual crowd
		int n <- length(nearby);
		
		// Difference (positive or negative)
		float diff <- (n - preferred) / 6.0;
		
		// Apply effect symmetrically
		float delta <- 0.04 * diff;
		
		do apply_happiness_delta(delta);
	}
	
	
	
	// By default, all guests refuse party invites.
	// PartyGuest will override this action to allow joining.
	// ------------------------------------------------------------
	action handle_party_invite_request(message m) {
    	do refuse message: m contents: [FIPA_PARTY_INVITE_REPLY, "Not a party guest."];
    	do end_conversation message: m contents: ["End"];
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
		float score <- (0.2 * noise_score) + (0.2 * social_score) + (0.6 * place_preferences[p.kind]);
	
	    return score;
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
    
    action handle_food_query_request(message msg_req) {

	    // Reply with what I currently eat
	    do agree message: msg_req contents: [FIPA_FOOD_QUERY_REPLY, current_food];
	
	    do log(LOG_LEVEL_INFO, guestId,
	        "FOOD_QUERY_REPLIED -> to=" + (msg_req.sender as GuestBase).guestId
	        + " | myFood=" + current_food
	    );
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

    // ============================================================
    // Party grouping (ONLY PartyGuests participate in this mechanic)
    // ============================================================

    // Members that accepted my invite (I am the leader).
    list<PartyGuest> party_group_members <- [];
    int MAX_PARTY_GROUP_SIZE <- 6;

    // Cooldown to avoid spamming invites every cycle.
    int last_invite_step <- -1000;
    int INVITE_COOLDOWN  <- 15;

    init {
        sociability <- rnd(0.7, 1.0);
        tolerance   <- rnd(0.6, 1.0);
        generosity  <- rnd(0.4, 0.9);

        // PartyGuest is not strongly affected by hello replies.
        hello_agree_happiness_delta  <- 0.05;
        hello_refuse_happiness_delta <- 0.05;

        num_cycles_to_wander <- 5;
        choose_place_probability <- 0.5;
        
        place_preferences <- map([]);
		loop p over: ALL_PLACES {
		    place_preferences[p.kind] <- 0.0;
		}
    }

    aspect base {
        draw circle(2.0) color: COLOR_PARTY_GUEST;
    }

    // ============================================================
    // Leader side: send invites in the club
    // ============================================================

    reflex invite_to_party when: current_place != nil and current_place.kind = "club" {
    	
    	// Followers must NOT invite others (only leaders invite)
		if (group_leader != nil) { 
		    do log(LOG_LEVEL_INFO, guestId, "INVITE_BLOCKED (follower) leader=" + group_leader.guestId);
		    return; 
		}
    	

        // Cooldown check
        if (cycle - last_invite_step < INVITE_COOLDOWN) { return; }

        // Capacity check
        if (length(party_group_members) >= MAX_PARTY_GROUP_SIZE) { return; }

        // Find nearby agents
        list<GuestBase> nearby <- get_nearby_guests(COMMUNICATION_RADIUS);

        // Candidates: ONLY PartyGuests, not myself, not already following a leader,
        // and not already in my list.
        list<PartyGuest> candidates <- (nearby where (
            each != self
            and (each is PartyGuest)
            and (each as PartyGuest).group_leader = nil
            and !(party_group_members contains (each as PartyGuest))
        )) collect (each as PartyGuest);

        if (empty(candidates)) { return; }

        PartyGuest target <- one_of(candidates);

        // IMPORTANT:
        // - protocol must be a valid FIPA protocol name -> use "fipa-request"
        // - we keep our own message type in contents[0] = FIPA_PARTY_INVITE
        do start_conversation(
            to: [target],
            performative: "request",
            protocol: PROTOCOL_PARTY_INVITE, // you set this to "fipa-request" in global
            contents: [FIPA_PARTY_INVITE, "Join my party group!"]
        );

        do log(LOG_LEVEL_INFO, guestId,
		    "PARTY_INVITE_SENT -> to=" + target.guestId
		    + " | leaderPlace=" + (current_place != nil ? current_place.kind : "nil")
		    + " | myMembers=" + length(party_group_members)
		);


        last_invite_step <- cycle;
    }

    // ============================================================
    // Participant side: handle invite requests
    // ============================================================

    action handle_party_invite_request_party(message msg_req)  {

        PartyGuest leader <- msg_req.sender as PartyGuest;

        // If I already follow a leader, refuse
        if (group_leader != nil) {
            do refuse message: msg_req contents: [FIPA_PARTY_INVITE_REPLY, "Already in a group."];
            return;
        }

        // Safety: only join if leader is currently in a club
        if (leader.current_place = nil or leader.current_place.kind != "club") {
            do refuse message: msg_req contents: [FIPA_PARTY_INVITE_REPLY, "Leader not at club."];
            return;
        }

        // Acceptance probability (simple): higher sociability -> more likely to join
        float p_accept <- sociability;

        if (rnd(0.0, 1.0) < p_accept) {

            // Join: set my leader pointer
            group_leader <- leader;
            party_join_cycle <- cycle;

            // Immediately aim for the leader's place
            current_place <- leader.current_place;

            do agree message: msg_req contents: [FIPA_PARTY_INVITE_REPLY, "Let's go!"];

            do log(LOG_LEVEL_INFO, guestId,
			    "PARTY_INVITE_ACCEPTED <- from=" + leader.guestId
			    + " | joinCycle=" + cycle
			    + " | leaderMembers=" + length(leader.party_group_members)
);
        }
        else {
            do refuse message: msg_req contents: [FIPA_PARTY_INVITE_REPLY, "No thanks."];
        }
    }

    // ============================================================
    // Happiness dynamics: partying in a group increases happiness faster
    // ============================================================

    reflex adjust_happiness when: current_place != nil {

        // Only apply this logic inside the club
        if (current_place.kind != "club") { return; }

        float base_increase <- 0.005; // alone in club
        float group_bonus   <- 0.0;

        // If I am leader: bigger group -> bigger bonus
        if (!empty(party_group_members)) {
            group_bonus <- 0.003 * length(party_group_members);
        }

        // If I am a follower: small bonus for being in a group
        if (group_leader != nil) {
            group_bonus <- group_bonus + 0.002;
        }

        happiness <- min(1.0, happiness + base_increase + group_bonus);
        
        if (cycle mod 10 = 0) {
		    do log(LOG_LEVEL_INFO, guestId,
		        "HAPPINESS_UPDATE | h=" + happiness
		        + " | members=" + length(party_group_members)
		        + " | follower=" + (group_leader != nil ? "yes" : "no")
		    );
		}
    }

    // ============================================================
    // Cleanup: dissolve group when leaving the club
    // ============================================================

    reflex dissolve_party_group when: current_place = nil or current_place.kind != "club" {
    	
		int released <- length(party_group_members);
		
        // Only leader dissolves its member list
        if (!empty(party_group_members)) {

            loop pg over: party_group_members {
                if (pg != nil and pg.group_leader = self) {
                    pg.group_leader <- nil;
                }
            }

            party_group_members <- [];
				do log(LOG_LEVEL_INFO, guestId, "PARTY_GROUP_DISSOLVED | released=" + released);
            
        }
    }

    // ============================================================
    // Message handling (robust: ignore end_conversation)
    // ============================================================

    reflex handle_requests when: !empty(requests) {

	    // Take the first pending request message
	    message msg_req <- requests[0];
	
	    // ------------------------------------------------------------
	    // Robust parsing: some protocol/system messages may have different contents.
	    // We only process messages that start with a known "topic" string.
	    // ------------------------------------------------------------
	    list args <- msg_req.contents;
	    if (empty(args)) { 
	        return; 
	    }
	
	    string topic <- args[0] as string;
	
	    if (topic = FIPA_HELLO_MSG) {
	        do handle_hello_request(m: msg_req);
	    }
	    else if (topic = FIPA_PARTY_INVITE) {
		    do handle_party_invite_request_party(msg_req: msg_req);
		}
		else if (topic = FIPA_FOOD_QUERY_ASK) {
		    do handle_food_query_request(msg_req: msg_req); // GuestBase
		}
		
	    else {
	        // Unknown topic -> ignore safely
	        return;
	    }
	}


    reflex handle_agrees when: !empty(agrees) {

	    // Take the first pending agree message
	    message msg_agree <- agrees[0];
	
	    list args <- msg_agree.contents;
	    if (empty(args)) { 
	        return; 
	    }
	
	    string topic <- args[0] as string;
	
	    if (topic = FIPA_HELLO_REPLY) {
	        do handle_hello_agree(m: msg_agree);
	    }
	    else if (topic = FIPA_PARTY_INVITE_REPLY) {
	
	        PartyGuest joiner <- msg_agree.sender as PartyGuest;
	
	        // Avoid duplicates and respect capacity
	        if (!(party_group_members contains joiner) and length(party_group_members) < MAX_PARTY_GROUP_SIZE) {
	            party_group_members <- party_group_members + [joiner];
	
	            // Optional: leader feels happier when someone joins
	            happiness <- min(1.0, happiness + 0.02);
	
	            do log(LOG_LEVEL_INFO, guestId,
				    "PARTY_MEMBER_ADDED <- member=" + joiner.guestId
				    + " | newMembers=" + length(party_group_members)
				);

	        }
	
	        // NOTE: Do NOT call end_conversation here when using a real protocol.
	        // The protocol handles termination.
	    }
	    else {
	        return;
	    }
	}


	    reflex handle_refuses when: !empty(refuses) {
	
	    // Take the first pending refuse message
	    message msg_refuse <- refuses[0];
	
	    list args <- msg_refuse.contents;
	    if (empty(args)) { 
	        return; 
	    }
	
	    string topic <- args[0] as string;
	
	    if (topic = FIPA_HELLO_REPLY) {
	        do handle_hello_refuse(m: msg_refuse);
	    }
	    else if (topic = FIPA_PARTY_INVITE_REPLY) {
	        // Invitation refused -> nothing to do
	        do log(LOG_LEVEL_DEBUG, guestId, "PARTY_INVITE_REFUSED by " + (msg_refuse.sender as GuestBase).guestId);
	
	        // NOTE: Do NOT call end_conversation here when using a real protocol.
	    }
	    else {
	        return;
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
		
		place_preferences <- map([]);
		loop p over: ALL_PLACES {
		    place_preferences[p.kind] <- 0.0;
		}
    }
    
    aspect base {
        draw circle(2) color: COLOR_INTROVERT;
    }
    
    reflex adjust_happiness when: current_place != nil {
	    happiness <- happiness - (max(0.0, current_place.noise - tolerance) * 0.02);
	    happiness <- max(0.0, min(1.0, happiness));
	}

    
    reflex handle_requests when: !empty(requests) {

	    // Take the first pending request message
	    message m <- requests[0];
	    list args <- m.contents;
	    if (empty(args)) { return; }
	
	    string msg_str <- args[0] as string;
	
	    if (msg_str = FIPA_HELLO_MSG) {
	        do handle_hello_request(m: m);
	    }
	    else if (msg_str = FIPA_FOOD_QUERY_ASK) {
	        // Uses GuestBase default handler
	        do handle_food_query_request(msg_req: m);
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

    // ============================================================
    // MUSIC FAN TRAITS
    // ============================================================

    // The favorite genre of this music fan.
    string favorite_genre <- one_of(["rock", "pop"]);

    // Prevent spamming genre questions.
    int last_genre_ask_step <- -1000;
    int GENRE_ASK_COOLDOWN <- 25;

    init {
        sociability <- rnd(0.4, 0.7);
        tolerance   <- rnd(0.5, 0.8);
        generosity  <- rnd(0.2, 0.5);

        // Music fans are not strongly affected by hello replies.
        hello_agree_happiness_delta  <- 0.05;
        hello_refuse_happiness_delta <- 0.05;

        num_cycles_to_wander <- 10;
        choose_place_probability <- 0.5;
        
        place_preferences <- map([]);
		loop p over: ALL_PLACES {
		    place_preferences[p.kind] <- 0.0;
		}
    }

    aspect base {
        draw circle(2) color: COLOR_MUSIC_FAN;
    }

    // ============================================================
    // HAPPINESS UPDATE
    // ============================================================

    reflex adjust_happiness when: current_place != nil and cycle mod 3 = 0 {
		float delta <- 0.01;
		
		if (current_place.kind = "concert" or current_place.kind = "club") {
		    delta <- delta + 0.02;
		}
		
		do apply_happiness_delta(delta);
    }

    // ============================================================
    // GENRE CHAT (FIPA)
    // ============================================================

    // Reply with my favorite genre when another music fan asks.
    action handle_genre_ask_request(message msg_req) {

        // Sometimes ignore because I'm "listening to music".
        float p_reply <- 0.75;

        if (rnd(0.0, 1.0) > p_reply) {
            // Refuse with a genre-reply topic (so requester can route it).
            do refuse message: msg_req contents: [FIPA_GENRE_REPLY, "Can't talk right now."];

            do log(LOG_LEVEL_INFO, guestId,
                "GENRE_ASK_IGNORED from=" + (msg_req.sender as GuestBase).guestId
            );
            return;
        }

        // Agree and return the genre in contents[1].
        do agree message: msg_req contents: [FIPA_GENRE_REPLY, favorite_genre];

        do log(LOG_LEVEL_INFO, guestId,
            "GENRE_ASK_REPLIED to=" + (msg_req.sender as GuestBase).guestId
            + " | myGenre=" + favorite_genre
        );
    }

    // Handle an agree reply containing the other agent's favorite genre.
    action handle_genre_reply_agree(message msg_agree) {

        // GAMA: message contents must be treated as a list.
        list args <- msg_agree.contents;

        // Safety check.
        if (length(args) < 2) {
            // End the conversation anyway (requester side should close).
            do end_conversation message: msg_agree contents: ["End"];
            return;
        }

        string other_genre <- args[1] as string;
        GuestBase other <- msg_agree.sender as GuestBase;

        do log(LOG_LEVEL_INFO, guestId,
            "GENRE_REPLY_RECEIVED <- from=" + other.guestId
            + " | theirGenre=" + other_genre
            + " | myGenre=" + favorite_genre
        );

        // happiness boost if genres match.
        if (other_genre = favorite_genre) {
            happiness <- happiness + 0.02;

            // Clamp after bonus too (important, otherwise happiness can exceed 1.0).
            happiness <- max(0.0, min(1.0, happiness));

            do log(LOG_LEVEL_INFO, guestId, "GENRE_MATCH_BONUS (+0.02)");
        }
        else {
        	// happiness decreases if genres do not match
        	happiness <- happiness - 0.02;

            // Clamp after bonus too (important, otherwise happiness can exceed 1.0).
            happiness <- max(0.0, min(1.0, happiness));

            do log(LOG_LEVEL_INFO, guestId, "GENRE_NOT_MATCH_MINUS (-0.02)");
        }

       
    }

    // ============================================================
    // INITIATE GENRE QUESTIONS
    // ============================================================

    reflex ask_other_music_fans_genre when: current_place != nil {

        // Cooldown
        if (cycle - last_genre_ask_step < GENRE_ASK_COOLDOWN) { return; }

        // Find nearby guests and keep ONLY music fans.
        list<GuestBase> nearby <- get_nearby_guests(COMMUNICATION_RADIUS);
        list<GuestMusicFan> music_candidates <- (nearby where (each is GuestMusicFan and each != self))
            collect (each as GuestMusicFan);

        if (empty(music_candidates)) { return; }

        // Random target.
        GuestMusicFan target <- one_of(music_candidates);

        do start_conversation(
            to: [target],
            performative: "request",
            protocol: PROTOCOL_GENRE_CHAT, // should be a valid FIPA protocol name, e.g. "fipa-request"
            contents: [FIPA_GENRE_ASK, "What genre do you like?"]
        );

        do log(LOG_LEVEL_INFO, guestId, "GENRE_ASK_SENT -> to=" + target.guestId);

        last_genre_ask_step <- cycle;
    }

    // ============================================================
    // MESSAGE ROUTING (REQUEST / AGREE / REFUSE)
    // ============================================================

    reflex handle_requests when: !empty(requests) {

        message msg_req <- requests[0];
        list args <- msg_req.contents;
        if (empty(args)) { return; }

        string topic <- args[0] as string;

        if (topic = FIPA_HELLO_MSG) {
            do handle_hello_request(m: msg_req);
        }
        else if (topic = FIPA_GENRE_ASK) {
            do handle_genre_ask_request(msg_req: msg_req);
        }
        else if (topic = FIPA_FOOD_QUERY_ASK) {
	    do handle_food_query_request(msg_req: msg_req); // GuestBase
	}
        
        // else: ignore unknown topics
    }

    reflex handle_agrees when: !empty(agrees) {

        message msg_agree <- agrees[0];
        list args <- msg_agree.contents;
        if (empty(args)) { return; }

        string topic <- args[0] as string;

        if (topic = FIPA_HELLO_REPLY) {
            do handle_hello_agree(m: msg_agree);
        }
        else if (topic = FIPA_GENRE_REPLY) {
            do handle_genre_reply_agree(msg_agree: msg_agree);
        }
        // else: ignore unknown topics
    }

    reflex handle_refuses when: !empty(refuses) {

        message msg_refuse <- refuses[0];
        list args <- msg_refuse.contents;
        if (empty(args)) { return; }

        string topic <- args[0] as string;

        if (topic = FIPA_HELLO_REPLY) {
            do handle_hello_refuse(m: msg_refuse);
        }
        else if (topic = FIPA_GENRE_REPLY) {

            do log(LOG_LEVEL_INFO, guestId,
                "GENRE_REPLY_REFUSED <- from=" + (msg_refuse.sender as GuestBase).guestId
            );

          
        }
        // else: ignore unknown topics
    }
}


species GuestFoodie parent: GuestBase {
	
	// happiness increases at restaurant, bar, cafe
	
	int last_food_offer_step <- -1000;
	int FOOD_OFFER_COOLDOWN <- 30;
	
	
	init {
        sociability <- rnd(0.4, 0.7);
        tolerance <- rnd(0.4, 0.7);
        generosity <- rnd(0.6, 1.0);
        // A foodie is moderately affected by hello replies
        hello_agree_happiness_delta <- 0.1;
        hello_refuse_happiness_delta <- 0.1;
        
        num_cycles_to_wander <- 10;
		choose_place_probability <- 0.3;
		
		place_preferences <- map([]);
		loop p over: ALL_PLACES {
		    place_preferences[p.kind] <- 0.0;
		}
    }
    
    aspect base {
        draw circle(2) color: COLOR_FOODIE;
    }
    
    
    // Default handling of food offers (can be overridden by specific guests)
	action handle_food_offer_request(message msg_req) {
	
	    // Acceptance probability based on generosity
	    float p_accept <- generosity;
	
	    if (rnd(0.0, 1.0) < p_accept) {
	
	        // Accept the food
	        happiness <- happiness + 0.05;
	        happiness <- max(0.0, min(1.0, happiness));
	
	        do agree message: msg_req contents: [FIPA_FOOD_REPLY, "Thanks!"];
	
	        do log(LOG_LEVEL_INFO, guestId,
	            "FOOD_OFFER_ACCEPTED <- from=" + (msg_req.sender as GuestBase).guestId
	        );
	    }
	    else {
	        // Refuse politely
	        do refuse message: msg_req contents: [FIPA_FOOD_REPLY, "No thanks."];
	
	        do log(LOG_LEVEL_INFO, guestId,
	            "FOOD_OFFER_REFUSED <- from=" + (msg_req.sender as GuestBase).guestId
	        );
	    }
	}
	
	action handle_food_reply_agree(message msg_agree) {

	    // Foodie feels good when others accept food
	    happiness <- happiness + 0.04;
	    happiness <- max(0.0, min(1.0, happiness));
	
	    do log(LOG_LEVEL_INFO, guestId,
	        "FOOD_SHARED_SUCCESS <- with=" + (msg_agree.sender as GuestBase).guestId
	    );
	}
	
	action handle_food_reply_refuse(message msg_refuse) {

	    // Small disappointment
	    happiness <- happiness - 0.02;
	    happiness <- max(0.0, min(1.0, happiness));
	
	    do log(LOG_LEVEL_INFO, guestId,
	        "FOOD_SHARED_REFUSED <- by=" + (msg_refuse.sender as GuestBase).guestId
	    );
	}
	
	
    
    
    
    reflex offer_food when: current_place != nil {

    	// Only offer food where food makes sense
	    if (!(current_place.kind = "restaurant"
	        or current_place.kind = "cafe"
	        or current_place.kind = "bar")) {
	        return;
	    }
	
	    // Cooldown to avoid spam
	    if (cycle - last_food_offer_step < FOOD_OFFER_COOLDOWN) { return; }
	
	    // Find nearby guests (any type), excluding myself
	    list<GuestBase> nearby <- get_nearby_guests(COMMUNICATION_RADIUS)
	        where (each != self);
	
	    if (empty(nearby)) { return; }
	
	    GuestBase target <- one_of(nearby);
	
	    do start_conversation(
	        to: [target],
	        performative: "request",
	        protocol: PROTOCOL_FOOD,
	        contents: [FIPA_FOOD_OFFER, "Would you like some food?"]
	    );
	
	    do log(LOG_LEVEL_INFO, guestId,
	        "FOOD_OFFER_SENT -> to=" + target.guestId
	        + " | place=" + current_place.kind
	    );
	
	    last_food_offer_step <- cycle;
	}
    
    
    reflex adjust_happiness
	when: current_place != nil and cycle mod 5 = 0 {
	
	    float delta <- 0.0;
	
	    // Likes food places
	    if (current_place.kind = "restaurant" or current_place.kind = "cafe" or current_place.kind = "bar") {
	        delta <- delta + 0.02;
	    }
	
	    // Likes sharing food with people
	    int n <- length(get_nearby_guests(SOCIAL_DENSITY_RADIUS));
	    delta <- delta + 0.02 * min(1.0, n / 5.0);
	
	    do apply_happiness_delta(delta);
	}

	reflex handle_requests when: !empty(requests) {

	    // Take the first pending request message
	    message msg_req <- requests[0];
	
	    // Safely parse contents
	    list args <- msg_req.contents;
	    if (empty(args)) { return; }
	
	    string topic <- args[0] as string;
	
	    // Route by our topic string (contents[0])
	    if (topic = FIPA_HELLO_MSG) {
	        do handle_hello_request(m: msg_req);
	    }
	    else if (topic = FIPA_FOOD_OFFER) {
	        // Default handler is defined in GuestBase
	        do handle_food_offer_request(msg_req: msg_req);
	    }
	    else {
	        // Unknown topic -> ignore
	        return;
	    }
	}

    
    reflex handle_agrees when: !empty(agrees) {

	    // Take the first pending agree message
	    message msg_agree <- agrees[0];
	
	    list args <- msg_agree.contents;
	    if (empty(args)) { return; }
	
	    string topic <- args[0] as string;
	
	    if (topic = FIPA_HELLO_REPLY) {
	        do handle_hello_agree(m: msg_agree);
	    }
	    else if (topic = FIPA_FOOD_REPLY) {
	        // Foodie-specific: someone accepted my offer
	        do handle_food_reply_agree(msg_agree: msg_agree);
	    }
	    else {
	        return;
	    }
	}

    
    reflex handle_refuses when: !empty(refuses) {

	    // Take the first pending refuse message
	    message msg_refuse <- refuses[0];
	
	    list args <- msg_refuse.contents;
	    if (empty(args)) { return; }
	
	    string topic <- args[0] as string;
	
	    if (topic = FIPA_HELLO_REPLY) {
	        do handle_hello_refuse(m: msg_refuse);
	    }
	    else if (topic = FIPA_FOOD_REPLY) {
	        // Foodie-specific: someone refused my offer
	        do handle_food_reply_refuse(msg_refuse: msg_refuse);
	    }
	    else {
	        return;
	    }
	}
}

species GuestVeganActivist parent: GuestBase {
	
	int last_menu_ask_step <- -1000;
	int VEGAN_MENU_COOLDOWN <- 40;

	int last_food_query_step <- -1000;
	int FOOD_QUERY_COOLDOWN <- 30;

	// Vegan activist's current belief about vegan availability (for behavior/happiness)
	bool believes_vegan_available <- false;
	
	
	float conviction <- rnd(0.6, 1.0);
	
	aspect base {
        draw circle(2) color: COLOR_VEGAN_ACTIVIST;
    }
    
    action handle_vegan_menu_reply_agree(message msg_agree) {

	    list args <- msg_agree.contents;
	    if (length(args) < 3) { return; }
	
	    bool available <- args[1] as bool;
	    string text <- args[2] as string;
	
	    believes_vegan_available <- available;
	
	    do log(LOG_LEVEL_INFO, guestId,
	        "VEGAN_MENU_REPLY_RECEIVED <- available=" + available + " | msg=" + text
	    );
	
	    // Adjust happiness based on the answer + conviction
	    if (available) {
	        happiness <- happiness + (0.03 * conviction);
	    } else {
	        happiness <- happiness - (0.05 * conviction);
	    }
	
	    happiness <- max(0.0, min(1.0, happiness));
	}
	
	action handle_food_query_reply_agree(message msg_agree) {

    	list args <- msg_agree.contents;
	    if (length(args) < 2) { return; }
	
	    string their_food <- args[1] as string;
	    GuestBase other <- msg_agree.sender as GuestBase;
	
	    do log(LOG_LEVEL_INFO, guestId,
	        "FOOD_QUERY_REPLY_RECEIVED <- from=" + other.guestId + " | food=" + their_food
	    );
	
	    // If they eat meat: activist gets upset and reduces tolerance toward them
	    bool is_meat <- (their_food = "burger" or their_food = "steak");
	
	    if (is_meat) {
	        happiness <- happiness - (0.04 * conviction);
	        happiness <- max(0.0, min(1.0, happiness));
	
	        do log(LOG_LEVEL_INFO, guestId,
	            "VEGAN_TELL_OFF -> target=" + other.guestId + " | reason=" + their_food
	        );
	    } else {
	        // Positive reinforcement
	        happiness <- happiness + (0.02 * conviction);
	        happiness <- max(0.0, min(1.0, happiness));
	    }
	}
	
	    
    
    reflex adjust_happiness
	when: current_place != nil and cycle mod 5 = 0 {
	
	    float delta <- 0.0;
	
	    // Vegan likes restaurants only if vegan options believed available
	    if (current_place.kind = "restaurant") {
	        delta <- delta + (believes_vegan_available ? 0.04 : -0.04) * conviction;
	    }
	
	    // Dislikes crowds if low tolerance
	    int n <- length(get_nearby_guests(SOCIAL_DENSITY_RADIUS));
	    float crowd_penalty <- max(0.0, n - 3) / 6.0;
	    delta <- delta - crowd_penalty * (1.0 - tolerance) * 0.05;
	
	    do apply_happiness_delta(delta);
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
		
		place_preferences <- map([]);
		loop p over: ALL_PLACES {
		    place_preferences[p.kind] <- 0.0;
		}
    }
    
    reflex ask_restaurant_for_vegan_food when: current_place != nil {

	    // Only ask when at restaurant
	    if (current_place.kind != "restaurant") { return; }
	
	    if (cycle - last_menu_ask_step < VEGAN_MENU_COOLDOWN) { return; }
	
	    // Find the actual Restaurant agent (you have exactly one Restaurant in ALL_PLACES)
	    // Safer: pick the place instance that is Restaurant
	    Restaurant r <- one_of(Restaurant);
	
	    do start_conversation(
	        to: [r],
	        performative: "request",
	        protocol: PROTOCOL_VEGAN_MENU,
	        contents: [FIPA_VEGAN_MENU_ASK, "Do you have vegan options?"]
	    );
	
	    do log(LOG_LEVEL_INFO, guestId, "VEGAN_MENU_ASK_SENT -> to=restaurant");
	
	    last_menu_ask_step <- cycle;
	}
	
	reflex ask_others_what_they_eat when: current_place != nil {

	    if (cycle - last_food_query_step < FOOD_QUERY_COOLDOWN) { return; }
	
	    list<GuestBase> nearby <- get_nearby_guests(COMMUNICATION_RADIUS)
	        where (each != self);
	
	    if (empty(nearby)) { return; }
	
	    GuestBase target <- one_of(nearby);
	
	    do start_conversation(
	        to: [target],
	        performative: "request",
	        protocol: PROTOCOL_FOOD_QUERY,
	        contents: [FIPA_FOOD_QUERY_ASK, "What are you eating?"]
	    );
	
	    do log(LOG_LEVEL_INFO, guestId, "FOOD_QUERY_SENT -> to=" + target.guestId);
	
	    last_food_query_step <- cycle;
	}
	
    
    
    reflex handle_requests when: !empty(requests) {

	    message m <- requests[0];
	    list args <- m.contents;
	    if (empty(args)) { return; }
	
	    string msg_str <- args[0] as string;
	
	    if (msg_str = FIPA_HELLO_MSG) {
	        do handle_hello_request(m: m);
	    }
	    else if (msg_str = FIPA_FOOD_QUERY_ASK) {
	        do handle_food_query_request(msg_req: m); // GuestBase
	    }
	    // Vegan menu ask is sent TO restaurant, so Vegan usually won't receive FIPA_VEGAN_MENU_ASK
	}

    
    reflex handle_agrees when: !empty(agrees) {

    message m <- agrees[0];
    list args <- m.contents;
	    if (empty(args)) { return; }
	
	    string msg_str <- args[0] as string;
	
	    if (msg_str = FIPA_HELLO_REPLY) {
	        do handle_hello_agree(m: m);
	    }
	    else if (msg_str = FIPA_VEGAN_MENU_REPLY) {
	        do handle_vegan_menu_reply_agree(msg_agree: m);
	    }
	    else if (msg_str = FIPA_FOOD_QUERY_REPLY) {
	        do handle_food_query_reply_agree(msg_agree: m);
	    }
	}

    
    reflex handle_refuses when: !empty(refuses) {

	    message m <- refuses[0];
	    list args <- m.contents;
	    if (empty(args)) { return; }
	
	    string msg_str <- args[0] as string;
	
	    if (msg_str = FIPA_HELLO_REPLY) {
	        do handle_hello_refuse(m: m);
	    }
	    else if (msg_str = FIPA_VEGAN_MENU_REPLY) {
	        do log(LOG_LEVEL_INFO, guestId, "VEGAN_MENU_REPLY_REFUSED");
	    }
	    else if (msg_str = FIPA_FOOD_QUERY_REPLY) {
	        do log(LOG_LEVEL_INFO, guestId, "FOOD_QUERY_REPLY_REFUSED");
	    }
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


