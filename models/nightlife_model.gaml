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
    
    int party_guests_count <- 15;
    int introvert_guests_count <- 15;
    int foodie_guests_count <- 0;
    int music_guests_count <- 0;
    int vegan_guests_count <- 0;
    
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
	int LOG_LEVEL_WARNING <- 2;

	int min_log_level <- LOG_LEVEL_DEBUG;
	
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
	// The radius to consider
	float COMMUNICATION_RADIUS  <- 35.0;
    
    PlaceBase current_place <- nil;
    
    aspect base {
        draw circle(1.8) color: COLOR_GUEST_DEFAULT;
    }
    
    // Guests wander around randomly if they have no specific place to go to
    reflex wander_around when: current_place = nil {
    	do wander;
    }
   	
   	// An action to log an event to the conosole
   	// shoudld be a global action but I didn't manage to make it work.
    action log(int level, int guestIdParam, string event) {
		if (level >= min_log_level) {
			write "[step=" + cycle + "] [agent=" + guestIdParam + "] " + event;
		}
	}
    
    // Returns a list of all guests in the COMMUNICATION_RADIUS
    action get_nearby_guests {
    	// Redundant code but I did not find a better to do this.
		list<GuestBase> nearby_party <- PartyGuest
        where (each != self and
               (location distance_to each.location) <= COMMUNICATION_RADIUS);
        list<GuestBase> nearby_introvert <- GuestIntrovert
        where (each != self and
               (location distance_to each.location) <= COMMUNICATION_RADIUS);
        list<GuestBase> nearby_music_fan <- GuestMusicFan
        where (each != self and
               (location distance_to each.location) <= COMMUNICATION_RADIUS);
        list<GuestBase> nearby_foodie <- GuestFoodie
        where (each != self and
               (location distance_to each.location) <= COMMUNICATION_RADIUS);
        list<GuestBase> nearby_vegan_activist <- GuestVeganActivist
        where (each != self and
               (location distance_to each.location) <= COMMUNICATION_RADIUS);

		// concatenate all lists
	    list<GuestBase> all_nearby <- nearby_party + nearby_introvert + 
	    	nearby_music_fan + nearby_foodie + nearby_vegan_activist;

	    // shuffle to avoid type bias
	    return shuffle(all_nearby);
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
//	    if (current_place = nil) { 
//	        return; 
//	    }
	    // cooldown check
	    if (cycle - last_hello_step < HELLO_COOLDOWN) {
	        return;
	    }
	    // nearby guests (excluding self)
	    list<GuestBase> nearby <- get_nearby_guests();
		int n <- length(nearby);
		write "Number of nearby: " + n;
    	if (n = 0) { 
    		return;
    	}
    	
    	// TODO: log p_hello and check that it is reasonable
    	float crowd_factor <- min(1.0, n / 6.0);
//	    float place_factor <- current_place.social_pressure;
		// TODO: fix
		float place_factor <- 1.0;
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
    }
    
    aspect base {
        draw circle(2.0) color: COLOR_PARTY_GUEST;
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
    }
    
    aspect base {
        draw circle(2) color: COLOR_INTROVERT;
    }

    reflex react_to_noise when: current_place != nil {
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
    }
    
    aspect base {
        draw circle(2) color: COLOR_MUSIC_FAN;
    }

    reflex concert_happiness when: current_place != nil {
        if (current_place.kind = "concert") {
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
    }
    
    aspect base {
        draw circle(2) color: COLOR_FOODIE;
    }

//    reflex food_place_bonus {
//        if (current_place.kind = "restaurant" or current_place.kind = "cafe") {
//            happiness <- happiness + 0.02;
//        }
//    }

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

    init {
        sociability <- rnd(0.3, 0.6);
        tolerance <- rnd(0.2, 0.5);
        generosity <- rnd(0.2, 0.4);
        // A vegan is moderately affected by replies to hello
        // A negative reply has a greater affect
        hello_agree_happiness_delta <- 0.07;
        hello_refuse_happiness_delta <- 0.15;
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

// 2. Add functionality of becoming hungry and going to get food/drinks
//    Choosing to go to bar/restaurant is less likely when guest is full

// 3. Add functionality of sharing food (vegan/ not vegan)

// 4. Add functionality of getting in groups in bar, club, concert

// 5. Add functionality of club/concert playing different type of music (rock/pop) and affecting the music fans

// 5.5 Music fans getting into their own groups and staying in them for longer

// 6. From time to time calculate statistics and show them

// 7. Change happiness based on guest type and how many people there are nearby



