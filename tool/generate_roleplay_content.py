#!/usr/bin/env python3
"""Generate roleplay JSON assets from the Fluenta AI Roleplay Scenario Content Library."""

import json
import os

BASE_DIR = os.path.join(os.path.dirname(__file__), "..", "assets", "roleplay")

LEVEL_LABELS = {
    "A1": "Beginner",
    "A2": "Elementary",
    "B1": "Intermediate",
    "B2": "Upper-Intermediate",
    "C1": "Advanced",
    "C2": "Proficient",
}


def level_label(cefr_level: str, override: str | None = None) -> str:
    if override:
        return override
    return LEVEL_LABELS.get(cefr_level, cefr_level)


def line(speaker: str, text: str) -> dict:
    return {"speaker": speaker, "text": text, "isUser": speaker == "You"}


def word(
    word_text: str,
    phonetic: str,
    part_of_speech: str,
    definition: str,
    example: str,
) -> dict:
    return {
        "word": word_text,
        "phonetic": phonetic,
        "partOfSpeech": part_of_speech,
        "definition": definition,
        "example": example,
    }


def question(prompt: str, options: list[str], correct_index: int, feedback: str) -> dict:
    return {
        "prompt": prompt,
        "options": options,
        "correctIndex": correct_index,
        "feedback": feedback,
    }


SCENARIOS = {
    "job_interviews": {
        "title": "Job Interview",
        "path_subtitle": (
            "Practice the language of job interviews — from first impressions "
            "to tough questions and salary negotiation."
        ),
        "lessons": [
            {
                "title": "First Impressions",
                "cefr": "A2",
                "level_label": "Beginner",
                "situation": (
                    "You arrive for a job interview at a small company. "
                    "The HR assistant meets you at the door."
                ),
                "dialogue": [
                    line("HR Assistant", "Good morning! Welcome. Please come in."),
                    line("You", "Good morning. Thank you. My name is Sam. I have an interview at ten."),
                    line("HR Assistant", "Yes, of course. Please take a seat. Can I get you some water?"),
                    line("You", "Yes, please. Thank you very much."),
                    line("HR Assistant", "The interviewer will be with you in a few minutes."),
                    line("You", "No problem. I will wait here."),
                ],
                "words": [
                    word("interview", "/ˈɪntəvjuː/", "noun", "a meeting where someone asks you questions for a job", "I have a job interview on Monday."),
                    word("welcome", "/ˈwɛlkəm/", "verb/exclamation", "to greet someone who has arrived", "Welcome to our office!"),
                    word("take a seat", "/teɪk ə siːt/", "phrase", "to sit down", "Please take a seat and wait."),
                    word("interviewer", "/ˈɪntəvjuːər/", "noun", "the person who asks the questions in an interview", "The interviewer smiled and shook my hand."),
                    word("wait", "/weɪt/", "verb", "to stay in one place until something happens", "Please wait outside the room."),
                ],
                "questions": [
                    question(
                        "Why is Sam at the office?",
                        ["To deliver a package", "For a job interview at ten", "To meet a friend"],
                        1,
                        "Correct! Sam is at the office for a job interview at ten.",
                    ),
                    question(
                        "What does the HR assistant offer Sam?",
                        ["Coffee", "Water", "A biscuit"],
                        1,
                        "Correct! The HR assistant offers Sam water.",
                    ),
                ],
            },
            {
                "title": "Tell Me About Yourself",
                "cefr": "B1",
                "level_label": "Intermediate",
                "situation": "The interviewer begins the interview with the most common opening question.",
                "dialogue": [
                    line("Interviewer", "So, tell me a little about yourself."),
                    line("You", "Of course. I studied Business Management at university and graduated two years ago. Since then, I have been working as a sales assistant at a retail company."),
                    line("Interviewer", "And what made you apply for this position?"),
                    line("You", "I want to work in a bigger team and take on more responsibility. I feel this role is the right next step for my career."),
                    line("Interviewer", "That's great. What would you say is your greatest strength?"),
                    line("You", "I am very organized and I work well under pressure. My manager often gives me urgent tasks because she knows I will finish them on time."),
                ],
                "words": [
                    word("apply", "/əˈplaɪ/", "verb", "to make a formal request for a job or course", "I applied for three jobs last week."),
                    word("position", "/pəˈzɪʃən/", "noun", "a job or role in a company", "She is applying for the manager position."),
                    word("responsibility", "/rɪˌspɒnsɪˈbɪləti/", "noun", "a duty or task you are in charge of", "I want more responsibility in my next job."),
                    word("strength", "/strɛŋθ/", "noun", "something you are very good at", "My main strength is communication."),
                    word("under pressure", "/ˈʌndər ˈprɛʃər/", "phrase", "in a stressful situation with tight deadlines", "I work well under pressure."),
                ],
                "questions": [
                    question(
                        "What did the candidate study?",
                        ["Marketing", "Business Management", "Computer Science"],
                        1,
                        "Correct! The candidate studied Business Management.",
                    ),
                    question(
                        "Why does the candidate's manager give them urgent tasks?",
                        ["They are slow", "They are reliable and finish on time", "They have nothing else to do"],
                        1,
                        "Correct! The manager gives them urgent tasks because they are reliable and finish on time.",
                    ),
                ],
            },
            {
                "title": "Handling Tough Questions",
                "cefr": "B1",
                "level_label": "Intermediate",
                "situation": "The interview continues with more challenging questions about weaknesses and past difficulties.",
                "dialogue": [
                    line("Interviewer", "Can you tell me about a time you made a mistake at work?"),
                    line("You", "Yes. Last year, I sent a report to the wrong client by mistake. I realized immediately and told my manager. We contacted the client, apologized, and sent the correct report within an hour."),
                    line("Interviewer", "How did your manager react?"),
                    line("You", "She was not happy at first, but she appreciated that I was honest and acted quickly to fix it."),
                    line("Interviewer", "And what is your greatest weakness?"),
                    line("You", "I sometimes find it difficult to delegate tasks because I like to make sure everything is done correctly. I am working on trusting my colleagues more."),
                ],
                "words": [
                    word("mistake", "/mɪˈsteɪk/", "noun", "something done incorrectly or wrongly", "Everyone makes mistakes — what matters is how you fix them."),
                    word("apologize", "/əˈpɒləʤaɪz/", "verb", "to say sorry for something you did wrong", "I apologized to the client immediately."),
                    word("appreciate", "/əˈpriːʃieɪt/", "verb", "to recognize and value something", "She appreciated my honesty."),
                    word("delegate", "/ˈdɛlɪɡeɪt/", "verb", "to give a task to someone else to do", "A good manager knows how to delegate."),
                    word("weakness", "/ˈwiːknəs/", "noun", "something you are not as good at", "My weakness is public speaking, but I am improving."),
                ],
                "questions": [
                    question(
                        "What mistake did the candidate make?",
                        ["Sent an email to a wrong address", "Sent a report to the wrong client", "Forgot a deadline"],
                        1,
                        "Correct! The candidate sent a report to the wrong client.",
                    ),
                    question(
                        "What is the candidate's weakness?",
                        ["Being too slow", "Difficulty delegating tasks", "Poor communication"],
                        1,
                        "Correct! The candidate's weakness is difficulty delegating tasks.",
                    ),
                ],
            },
            {
                "title": "Salary Negotiation",
                "cefr": "B2",
                "level_label": "Upper-Intermediate",
                "situation": "The interview is going well. The conversation turns to compensation.",
                "dialogue": [
                    line("Interviewer", "We'd like to move forward with you. Before we do, can you share your salary expectations?"),
                    line("You", "Thank you — I'm very pleased to hear that. Based on my research and my four years of experience, I was hoping for something in the range of $55,000 to $60,000."),
                    line("Interviewer", "That's slightly above what we had budgeted. We were thinking closer to $50,000 to start."),
                    line("You", "I understand. Could you tell me more about the full package? I'd like to consider benefits, performance reviews, and any professional development opportunities."),
                    line("Interviewer", "We offer annual reviews with performance bonuses, twenty-five days of holiday, and a training budget of $1,000 per year."),
                    line("You", "That sounds like a strong package. I'm open to discussing the base salary further if there's some flexibility."),
                ],
                "words": [
                    word("salary expectations", "/ˈsæləri ˌɛkspɛkˈteɪʃənz/", "phrase", "the amount of pay you hope to receive", "What are your salary expectations for this role?"),
                    word("budgeted", "/ˈbʌʤɪtɪd/", "verb (past)", "planned a specific amount of money for something", "We budgeted $50,000 for this position."),
                    word("package", "/ˈpækɪʤ/", "noun", "the total set of pay and benefits offered", "The full package includes salary, bonus, and health insurance."),
                    word("performance bonus", "/pəˈfɔːrməns ˈboʊnəs/", "phrase", "extra pay given for good work results", "She received a performance bonus at the end of the year."),
                    word("flexibility", "/ˌflɛksɪˈbɪləti/", "noun", "willingness to change or adapt", "Is there flexibility on the start date?"),
                ],
                "questions": [
                    question(
                        "What salary range does the candidate request?",
                        ["$45,000–$50,000", "$55,000–$60,000", "$60,000–$65,000"],
                        1,
                        "Correct! The candidate requests $55,000–$60,000.",
                    ),
                    question(
                        "What does the candidate ask about when the salary is low?",
                        ["Company size", "The full package and benefits", "Working hours"],
                        1,
                        "Correct! The candidate asks about the full package and benefits.",
                    ),
                ],
            },
            {
                "title": "Senior-Level Strategic Interview",
                "cefr": "C1",
                "level_label": "Advanced",
                "situation": "A final-round interview for a senior management role. The questions are strategic and demanding.",
                "dialogue": [
                    line("Director", "We're looking for someone who can drive transformation across departments. Can you walk me through how you've led change in a previous role?"),
                    line("You", "Certainly. In my last position, I was tasked with overhauling the customer service function — it had a backlog of unresolved cases and poor satisfaction scores. I began by conducting a root-cause analysis, identified three systemic bottlenecks, and proposed a restructuring plan to the board."),
                    line("Director", "How did you manage resistance from the existing team?"),
                    line("You", "That was the most challenging part. I prioritised one-to-one conversations early on to understand concerns, framed the changes around shared goals rather than top-down mandates, and ensured the team had visibility into milestones and outcomes throughout."),
                    line("Director", "And what was the result?"),
                    line("You", "Within six months, case resolution time fell by 40% and customer satisfaction scores rose from 58% to 81%. The restructuring became a model that was adopted by two other departments."),
                ],
                "words": [
                    word("transformation", "/ˌtrænsfəˈmeɪʃən/", "noun", "a fundamental and thorough change in form or character", "The new CEO led a complete transformation of the company."),
                    word("root-cause analysis", "/ruːt kɔːz əˈnæləsɪs/", "phrase", "a method of identifying the original cause of a problem", "We carried out a root-cause analysis before proposing any solutions."),
                    word("bottleneck", "/ˈbɒtəlnɛk/", "noun", "a point of congestion that slows down a process", "The approval process was a major bottleneck."),
                    word("mandate", "/ˈmændeɪt/", "noun", "an official instruction or authority to act", "The board gave him a clear mandate to cut costs."),
                    word("milestone", "/ˈmaɪlstoʊn/", "noun", "an important point in the progress of a project", "We hit every milestone on schedule."),
                ],
                "questions": [
                    question(
                        "What did the candidate do first to tackle the customer service problem?",
                        ["Fired the team", "Conducted a root-cause analysis", "Hired more staff"],
                        1,
                        "Correct! The candidate first conducted a root-cause analysis.",
                    ),
                    question(
                        "How did customer satisfaction scores change?",
                        ["From 58% to 81%", "From 40% to 80%", "From 70% to 90%"],
                        0,
                        "Correct! Customer satisfaction scores rose from 58% to 81%.",
                    ),
                ],
            },
        ],
    },
    "order_food": {
        "title": "Order Food",
        "path_subtitle": (
            "Practice ordering at cafés, restaurants, and food stalls — from simple "
            "requests to handling dietary needs and complaints."
        ),
        "lessons": [
            {
                "title": "At a Café",
                "cefr": "A1",
                "level_label": "Beginner",
                "situation": "You walk into a small café and want to order a drink and something to eat.",
                "dialogue": [
                    line("Barista", "Hello! What can I get you?"),
                    line("You", "Hi. Can I have a coffee, please?"),
                    line("Barista", "Of course. Hot or iced?"),
                    line("You", "Hot, please."),
                    line("Barista", "And anything to eat?"),
                    line("You", "Yes. One chocolate muffin, please."),
                    line("Barista", "That's $5.50. Pay here or at the table?"),
                    line("You", "Here, please. Thank you."),
                ],
                "words": [
                    word("order", "/ˈɔːrdər/", "verb/noun", "to ask for food or drink in a café or restaurant", "Are you ready to order?"),
                    word("menu", "/ˈmɛnjuː/", "noun", "a list of food and drinks available", "Can I see the menu, please?"),
                    word("iced", "/aɪst/", "adjective", "served cold with ice", "I would like an iced coffee."),
                    word("muffin", "/ˈmʌfɪn/", "noun", "a small sweet cake", "The blueberry muffin looks delicious."),
                    word("pay", "/peɪ/", "verb", "to give money for something", "I will pay by card."),
                ],
                "questions": [
                    question(
                        "What does the customer order to drink?",
                        ["Tea", "Iced coffee", "Hot coffee"],
                        2,
                        "Correct! The customer orders hot coffee.",
                    ),
                    question(
                        "How much does it cost?",
                        ["$4.50", "$5.50", "$6.50"],
                        1,
                        "Correct! The total cost is $5.50.",
                    ),
                ],
            },
            {
                "title": "At a Restaurant",
                "cefr": "A2",
                "level_label": "Elementary",
                "situation": "You are at a restaurant for dinner. The waiter comes to take your order.",
                "dialogue": [
                    line("Waiter", "Good evening. Are you ready to order?"),
                    line("You", "Yes, I think so. What is the soup of the day?"),
                    line("Waiter", "It's tomato and basil. It's very popular."),
                    line("You", "Great. I'll start with the soup, and then I'd like the grilled chicken for my main course."),
                    line("Waiter", "Excellent choice. And to drink?"),
                    line("You", "A glass of sparkling water, please."),
                    line("Waiter", "Of course. I'll bring your soup shortly."),
                ],
                "words": [
                    word("starter", "/ˈstɑːrtər/", "noun", "the first course of a meal", "I'll have the salad as a starter."),
                    word("main course", "/meɪn kɔːrs/", "noun", "the biggest and most important part of a meal", "For my main course, I'd like the pasta."),
                    word("grilled", "/ɡrɪld/", "adjective", "cooked on a grill using direct heat", "I prefer grilled fish to fried."),
                    word("sparkling water", "/ˈspɑːrklɪŋ ˈwɔːtər/", "phrase", "water with bubbles in it", "Still or sparkling water?"),
                    word("shortly", "/ˈʃɔːrtli/", "adverb", "in a short time, very soon", "Your food will be ready shortly."),
                ],
                "questions": [
                    question(
                        "What is the soup of the day?",
                        ["Chicken soup", "Tomato and basil", "Mushroom"],
                        1,
                        "Correct! The soup of the day is tomato and basil.",
                    ),
                    question(
                        "What does the customer order as a main course?",
                        ["Grilled fish", "Grilled chicken", "Pasta"],
                        1,
                        "Correct! The customer orders grilled chicken as the main course.",
                    ),
                ],
            },
            {
                "title": "Dietary Requirements",
                "cefr": "B1",
                "level_label": "Intermediate",
                "situation": "You have dietary restrictions and need to communicate them clearly to the waiter.",
                "dialogue": [
                    line("Waiter", "Are you ready to order?"),
                    line("You", "Almost. Before I decide, I have a question. I'm vegetarian — does the risotto contain any meat or chicken stock?"),
                    line("Waiter", "Let me check with the kitchen. I'm pretty sure it's made with vegetable stock, but I want to confirm."),
                    line("You", "Thank you. Also, I'm allergic to nuts. Can you make sure there are no nuts in my dish?"),
                    line("Waiter", "Absolutely. I'll flag that with the chef as well. One moment, please."),
                    line("Waiter", "Good news — the risotto is fully vegetarian and nut-free. Would you like that?"),
                    line("You", "Perfect. Yes, I'll have the risotto, please."),
                ],
                "words": [
                    word("vegetarian", "/ˌvɛʤɪˈtɛəriən/", "noun/adjective", "a person who does not eat meat; food with no meat", "Is there a vegetarian option on the menu?"),
                    word("allergic", "/əˈlɜːrʤɪk/", "adjective", "having a bad reaction to a particular food or substance", "I am allergic to shellfish."),
                    word("stock", "/stɒk/", "noun", "a liquid base made by boiling meat or vegetables, used in cooking", "The soup is made with chicken stock."),
                    word("confirm", "/kənˈfɜːrm/", "verb", "to say definitely that something is true", "Let me confirm your reservation."),
                    word("flag", "/flæɡ/", "verb", "to mark or draw attention to something important", "I'll flag your allergy to the kitchen."),
                ],
                "questions": [
                    question(
                        "Why does the customer ask about the risotto?",
                        ["They don't like rice", "They are vegetarian", "It is too expensive"],
                        1,
                        "Correct! The customer asks because they are vegetarian.",
                    ),
                    question(
                        "What allergy does the customer have?",
                        ["Dairy", "Gluten", "Nuts"],
                        2,
                        "Correct! The customer is allergic to nuts.",
                    ),
                ],
            },
            {
                "title": "Sending Food Back",
                "cefr": "B2",
                "level_label": "Upper-Intermediate",
                "situation": "Your food has arrived but there is a problem. You need to raise it politely but clearly.",
                "dialogue": [
                    line("Waiter", "Here is your steak. Enjoy your meal!"),
                    line("You", "Thank you. Actually, I'm sorry to stop you — I ordered the steak medium-rare, but this appears to be well-done. Could you take it back to the kitchen?"),
                    line("Waiter", "Oh, I'm so sorry about that. Of course. I'll have that corrected right away."),
                    line("You", "I appreciate that. Also, my side salad seems to be missing — I did order one."),
                    line("Waiter", "You're absolutely right, I apologize. I'll bring the salad immediately and make sure the steak is done correctly this time."),
                    line("You", "Thank you. No rush — I just want it right."),
                ],
                "words": [
                    word("medium-rare", "/ˈmiːdiəm ˈrɛər/", "adjective", "a way of cooking meat — pink inside, slightly cooked outside", "I'd like my steak medium-rare, please."),
                    word("well-done", "/ˌwɛl ˈdʌn/", "adjective", "meat that is cooked thoroughly with no pink inside", "She always orders her steak well-done."),
                    word("side", "/saɪd/", "noun", "a small dish served alongside the main meal", "I ordered a side of fries."),
                    word("corrected", "/kəˈrɛktɪd/", "verb (past)", "fixed or made right", "The mistake was corrected quickly."),
                    word("no rush", "/noʊ rʌʃ/", "phrase", "used to say there is no hurry or urgency", "No rush — take your time."),
                ],
                "questions": [
                    question(
                        "How did the customer order their steak?",
                        ["Well-done", "Medium", "Medium-rare"],
                        2,
                        "Correct! The customer ordered their steak medium-rare.",
                    ),
                    question(
                        "What else was missing from the order?",
                        ["Fries", "Side salad", "Bread"],
                        1,
                        "Correct! The side salad was missing from the order.",
                    ),
                ],
            },
            {
                "title": "A Business Dinner",
                "cefr": "C1",
                "level_label": "Advanced",
                "situation": "You are hosting a client at a fine dining restaurant. The conversation blends food choices with professional small talk.",
                "dialogue": [
                    line("Client", "This is a lovely restaurant — excellent choice."),
                    line("You", "I'm glad you like it. They have a wonderful seasonal menu. Please, take your time."),
                    line("Client", "I'm inclined towards the lamb — what do you recommend?"),
                    line("You", "The lamb here is exceptional. I'd also suggest the sea bass if you prefer something lighter. The chef sources it locally, which makes a real difference."),
                    line("Sommelier", "Good evening. May I suggest a wine pairing? The 2019 Bordeaux complements the lamb beautifully."),
                    line("You", "That sounds perfect. We'll go with that. And a sparkling water for the table as well, please."),
                    line("Client", "You clearly know this restaurant well. Do you bring clients here often?"),
                    line("You", "When the occasion calls for it, yes. I find that a good meal sets the right tone for a productive conversation."),
                ],
                "words": [
                    word("seasonal menu", "/ˈsiːzənəl ˈmɛnjuː/", "phrase", "a menu that changes based on ingredients available in the current season", "The seasonal menu features fresh autumn vegetables."),
                    word("inclined towards", "/ɪnˈklaɪnd tʊˈwɔːrdz/", "phrase", "feeling drawn to or favouring a particular option", "I'm inclined towards the fish tonight."),
                    word("exceptional", "/ɪkˈsɛpʃənəl/", "adjective", "unusually good; outstanding", "The service was absolutely exceptional."),
                    word("sommelier", "/ˌsɒməlˈjeɪ/", "noun", "a trained wine expert who works in a restaurant", "The sommelier recommended a full-bodied red."),
                    word("complement", "/ˈkɒmplɪmɛnt/", "verb", "to go well with something and enhance it", "A crisp white wine complements the fish perfectly."),
                ],
                "questions": [
                    question(
                        "What does the client consider ordering?",
                        ["Sea bass", "Lamb", "Chicken"],
                        1,
                        "Correct! The client considers ordering lamb.",
                    ),
                    question(
                        "Why does the host recommend the sea bass?",
                        ["It is cheaper", "It is locally sourced", "It is the chef's favourite"],
                        1,
                        "Correct! The host recommends the sea bass because it is locally sourced.",
                    ),
                ],
            },
        ],
    },
    "at_airport": {
        "title": "At the Airport",
        "path_subtitle": (
            "Navigate check-in, security, boarding, and flight delays with confidence."
        ),
        "lessons": [
            {
                "title": "Check-In Desk",
                "cefr": "A2",
                "level_label": "Elementary",
                "situation": "You arrive at the airport and go to the check-in desk.",
                "dialogue": [
                    line("Agent", "Good morning. Can I see your passport and booking, please?"),
                    line("You", "Of course. Here you are."),
                    line("Agent", "Thank you. Are you checking any bags today?"),
                    line("You", "Yes, one suitcase."),
                    line("Agent", "Please put it on the scale. It's 22 kilograms — that's within the limit. Window or aisle seat?"),
                    line("You", "Window, please."),
                    line("Agent", "Here is your boarding pass. Your gate is B14. Boarding starts at 10:30."),
                    line("You", "Thank you. What time is it now?"),
                    line("Agent", "It's 9:15. You have plenty of time."),
                ],
                "words": [
                    word("check in", "/ʧɛk ɪn/", "phrasal verb", "to register your arrival at an airport or hotel", "I need to check in two hours before the flight."),
                    word("boarding pass", "/ˈbɔːrdɪŋ pɑːs/", "noun", "a document that allows you to board a plane", "Please have your boarding pass ready."),
                    word("aisle", "/aɪl/", "noun", "the walkway between seats on a plane", "I prefer an aisle seat for long flights."),
                    word("gate", "/ɡeɪt/", "noun", "the specific exit in an airport where you board your plane", "Our gate is C22."),
                    word("limit", "/ˈlɪmɪt/", "noun", "the maximum amount allowed", "The baggage limit is 23 kilograms."),
                ],
                "questions": [
                    question("How heavy is the suitcase?", ["20 kg", "22 kg", "25 kg"], 1, "Correct! The suitcase weighs 22 kg."),
                    question("What seat does the passenger choose?", ["Aisle", "Middle", "Window"], 2, "Correct! The passenger chooses a window seat."),
                ],
            },
            {
                "title": "Through Security",
                "cefr": "A2",
                "level_label": "Elementary",
                "situation": "You are going through airport security.",
                "dialogue": [
                    line("Officer", "Please remove your laptop from your bag and put it in a separate tray."),
                    line("You", "OK. Do I need to take off my shoes?"),
                    line("Officer", "Yes, shoes and belts too, please. And any liquids must be in a clear bag."),
                    line("You", "I have a small bottle of water — is that OK?"),
                    line("Officer", "Sorry, liquids over 100ml are not allowed through. You'll need to throw it away."),
                    line("You", "Of course. I understand."),
                    line("Officer", "Thank you. Please walk through the scanner now."),
                ],
                "words": [
                    word("security", "/sɪˈkjʊərɪti/", "noun", "the safety checks at an airport", "The security queue was very long today."),
                    word("tray", "/treɪ/", "noun", "a flat container used to carry or place items", "Put your phone in the tray."),
                    word("liquid", "/ˈlɪkwɪd/", "noun", "a substance that flows, like water or juice", "Liquids must be under 100ml."),
                    word("allowed", "/əˈlaʊd/", "adjective", "permitted; acceptable", "Large bottles are not allowed through security."),
                    word("scanner", "/ˈskænər/", "noun", "a machine that checks what you are carrying", "Walk slowly through the scanner."),
                ],
                "questions": [
                    question("What does the passenger need to put in a separate tray?", ["Phone", "Laptop", "Shoes"], 1, "Correct! The passenger needs to put their laptop in a separate tray."),
                    question("Why can't the passenger keep their water?", ["It is too heavy", "It is over 100ml", "Glass bottles are banned"], 1, "Correct! The water is over 100ml and cannot be kept."),
                ],
            },
            {
                "title": "Flight Delay",
                "cefr": "B1",
                "level_label": "Intermediate",
                "situation": "Your flight has been delayed. You approach the information desk to find out what is happening.",
                "dialogue": [
                    line("You", "Excuse me. I'm on the 14:30 flight to Dubai — the board says it's delayed. Do you know how long?"),
                    line("Agent", "I'm sorry for the inconvenience. There's a technical issue with the aircraft. We're currently estimating a two-hour delay."),
                    line("You", "Two hours? I have a connecting flight in Dubai at 19:00. Will I make it?"),
                    line("Agent", "It's going to be tight. If you miss the connection, the airline will book you on the next available flight at no extra cost."),
                    line("You", "Is there anything I can do now to speed that process up if needed?"),
                    line("Agent", "I'd recommend speaking to the transfer desk in Dubai as soon as you land. They'll have your details on the system."),
                ],
                "words": [
                    word("delay", "/dɪˈleɪ/", "noun/verb", "when something happens later than expected", "The flight has a three-hour delay."),
                    word("inconvenience", "/ˌɪnkənˈviːniəns/", "noun", "trouble or difficulty caused to someone", "We apologize for any inconvenience caused."),
                    word("connecting flight", "/kəˈnɛktɪŋ flaɪt/", "phrase", "a second flight that continues your journey", "I have a connecting flight in Istanbul."),
                    word("tight", "/taɪt/", "adjective", "with little time to spare", "The connection is going to be tight."),
                    word("transfer desk", "/ˈtrænsfɜːr dɛsk/", "phrase", "an airport desk that helps passengers with connecting flights", "Go to the transfer desk to rebook your connection."),
                ],
                "questions": [
                    question("Why is the flight delayed?", ["Bad weather", "A technical issue", "Staff shortage"], 1, "Correct! The flight is delayed due to a technical issue."),
                    question("What does the agent recommend?", ["Book a new ticket", "Speak to the transfer desk in Dubai", "Wait for an announcement"], 1, "Correct! The agent recommends speaking to the transfer desk in Dubai."),
                ],
            },
            {
                "title": "Lost Luggage",
                "cefr": "B2",
                "level_label": "Upper-Intermediate",
                "situation": "You have arrived at your destination but your suitcase has not appeared on the baggage belt.",
                "dialogue": [
                    line("You", "Excuse me. I've been waiting at belt six for forty minutes and my bag still hasn't come through."),
                    line("Agent", "I'm sorry to hear that. Can I take your name, flight number, and a description of the bag?"),
                    line("You", "It's a large black suitcase with a red ribbon tied to the handle. Flight was BA207 from London."),
                    line("Agent", "Thank you. I can see in our system that your bag was loaded but there may have been a scanning error at the transfer point. It's likely on the next flight, arriving in three hours."),
                    line("You", "That's frustrating. I have a business meeting this evening — my work clothes are in that bag."),
                    line("Agent", "I completely understand. We can offer an emergency allowance of $50 for essential items. Here is the claim form and our tracking number for your file."),
                ],
                "words": [
                    word("baggage belt", "/ˈbæɡɪʤ bɛlt/", "phrase", "the moving conveyor where luggage arrives after a flight", "My bag came through on belt three."),
                    word("loaded", "/ˈloʊdɪd/", "adjective", "placed onto a vehicle or aircraft", "All bags were loaded before departure."),
                    word("transfer point", "/ˈtrænsfɜːr pɔɪnt/", "phrase", "the airport where bags move from one flight to another", "There was a delay at the transfer point."),
                    word("allowance", "/əˈlaʊəns/", "noun", "an amount of money or items that is officially permitted", "We received a $50 emergency allowance."),
                    word("claim form", "/kleɪm fɔːrm/", "phrase", "a document you complete to request compensation", "Please fill in this claim form for your lost bag."),
                ],
                "questions": [
                    question("What does the bag look like?", ["Small red bag", "Large black suitcase with a red ribbon", "Blue backpack"], 1, "Correct! It is a large black suitcase with a red ribbon."),
                    question("What does the airline offer?", ["A full refund", "$50 emergency allowance", "A free flight"], 1, "Correct! The airline offers a $50 emergency allowance."),
                ],
            },
            {
                "title": "Upgrade & Premium Travel",
                "cefr": "C1",
                "level_label": "Advanced",
                "situation": "You are at the check-in desk and politely ask about the possibility of an upgrade.",
                "dialogue": [
                    line("Agent", "Good morning. Passport and booking reference, please."),
                    line("You", "Of course. I was wondering — is there any availability in business class today? I'm a frequent flyer with Gold status."),
                    line("Agent", "Let me check. You're in luck — we do have one seat remaining in business class. As a Gold member, you're eligible for a complimentary upgrade subject to availability, which it appears we have."),
                    line("You", "That's wonderful. I have a long-haul flight and I'd genuinely appreciate it."),
                    line("Agent", "Absolutely. I'll reassign your seat. You'll also have access to the premium lounge — it's past security on the left, beside gate A4."),
                    line("You", "Perfect. Is there anything else I should be aware of for the premium cabin?"),
                    line("Agent", "Boarding for business class begins 15 minutes before the general boarding call. You'll have priority disembarkation on arrival as well."),
                ],
                "words": [
                    word("frequent flyer", "/ˈfriːkwənt ˈflaɪər/", "phrase", "a passenger who travels often and earns loyalty rewards", "As a frequent flyer, she always gets priority boarding."),
                    word("complimentary", "/ˌkɒmplɪˈmɛntəri/", "adjective", "given free of charge as a courtesy", "The hotel offered a complimentary breakfast."),
                    word("eligible", "/ˈɛlɪʤɪbəl/", "adjective", "having the right or qualification for something", "You are eligible for a free upgrade."),
                    word("lounge", "/laʊnʤ/", "noun", "a comfortable waiting area at an airport for premium passengers", "Business class passengers can use the lounge."),
                    word("disembarkation", "/ˌdɪsɛmbɑːrˈkeɪʃən/", "noun", "the process of leaving an aircraft after landing", "Priority disembarkation means you exit first."),
                ],
                "questions": [
                    question("Why is the passenger eligible for an upgrade?", ["They paid for it", "They have Gold frequent flyer status", "The flight is overbooked"], 1, "Correct! The passenger has Gold frequent flyer status."),
                    question("When does business class board?", ["At the same time as everyone", "15 minutes before general boarding", "30 minutes before general boarding"], 1, "Correct! Business class boards 15 minutes before general boarding."),
                ],
            },
        ],
    },
    "doctor_visit": {
        "title": "Doctor Visit",
        "path_subtitle": (
            "Communicate health concerns, describe symptoms, and understand medical advice clearly."
        ),
        "lessons": [
            {
                "title": "Describing Basic Symptoms",
                "cefr": "A2",
                "level_label": "Elementary",
                "situation": "You are not feeling well and visit a doctor for the first time.",
                "dialogue": [
                    line("Doctor", "Hello. Come in and have a seat. What brings you in today?"),
                    line("You", "Hello. I don't feel well. I have a headache and a sore throat."),
                    line("Doctor", "I see. How long have you had these symptoms?"),
                    line("You", "About three days."),
                    line("Doctor", "Do you have a temperature?"),
                    line("You", "Yes, a little. And I feel very tired."),
                    line("Doctor", "Let me take a look. Open your mouth, please."),
                ],
                "words": [
                    word("symptom", "/ˈsɪmptəm/", "noun", "a sign of illness felt by a patient", "A sore throat is a common symptom of a cold."),
                    word("sore throat", "/sɔːr θroʊt/", "phrase", "a painful or irritated feeling in the throat", "I have a bad sore throat and can't swallow."),
                    word("headache", "/ˈhɛdeɪk/", "noun", "a pain inside the head", "I've had a headache all day."),
                    word("temperature", "/ˈtɛmpərɪʧər/", "noun", "body heat; a fever when above normal", "The doctor checked my temperature."),
                    word("tired", "/ˈtaɪərd/", "adjective", "feeling a need to rest or sleep", "I feel so tired I can barely stand."),
                ],
                "questions": [
                    question("How long has the patient had symptoms?", ["One day", "Three days", "A week"], 1, "Correct! The patient has had symptoms for three days."),
                    question("What does the doctor ask the patient to do?", ["Lie down", "Open their mouth", "Breathe deeply"], 1, "Correct! The doctor asks the patient to open their mouth."),
                ],
            },
            {
                "title": "Getting a Prescription",
                "cefr": "B1",
                "level_label": "Intermediate",
                "situation": "The doctor has examined you and is explaining the diagnosis and treatment.",
                "dialogue": [
                    line("Doctor", "Based on my examination, you have a throat infection. It's bacterial, so I'm going to prescribe antibiotics."),
                    line("You", "How many times a day should I take them?"),
                    line("Doctor", "Twice a day — morning and evening — with food. It's important to finish the full course even if you feel better before then."),
                    line("You", "Are there any side effects I should know about?"),
                    line("Doctor", "Some people feel nauseous in the first day or two. If you get a rash or have difficulty breathing, stop taking them and come back immediately."),
                    line("You", "Understood. Is there anything else I can do to help with the pain?"),
                    line("Doctor", "Paracetamol for the pain, plenty of water, and rest. You should feel much better within five days."),
                ],
                "words": [
                    word("prescribe", "/prɪˈskraɪb/", "verb", "to officially tell a patient to take a medicine", "The doctor prescribed antibiotics for the infection."),
                    word("antibiotics", "/ˌæntɪbaɪˈɒtɪks/", "noun", "medicines that kill bacterial infections", "Always finish your course of antibiotics."),
                    word("side effect", "/ˈsaɪd ɪˌfɛkt/", "phrase", "an unwanted result of taking a medication", "One side effect of this medicine is dizziness."),
                    word("nauseous", "/ˈnɔːziəs/", "adjective", "feeling like you want to vomit", "The medicine made me feel nauseous."),
                    word("course", "/kɔːrs/", "noun", "the full set of doses of a medicine", "Complete the full course of medication."),
                ],
                "questions": [
                    question("What type of infection does the patient have?", ["Viral", "Bacterial", "Fungal"], 1, "Correct! The patient has a bacterial infection."),
                    question("What should the patient do if they get a rash?", ["Take more medicine", "Stop and return to the doctor", "Drink more water"], 1, "Correct! The patient should stop and return to the doctor."),
                ],
            },
            {
                "title": "Describing Pain",
                "cefr": "B1",
                "level_label": "Intermediate",
                "situation": "You are visiting a doctor for back pain and need to describe it accurately.",
                "dialogue": [
                    line("Doctor", "Where exactly does it hurt?"),
                    line("You", "In my lower back, on the right side. It started after I moved some heavy boxes last week."),
                    line("Doctor", "And how would you describe the pain? Is it sharp, dull, burning?"),
                    line("You", "It's more of a dull, constant ache. But when I bend down, it becomes quite sharp."),
                    line("Doctor", "On a scale of one to ten, how bad is the pain right now?"),
                    line("You", "About a five or six at rest, but an eight when I move."),
                    line("Doctor", "Does it radiate anywhere — down your leg, for example?"),
                    line("You", "Sometimes. I get a tingling feeling down the back of my right leg."),
                ],
                "words": [
                    word("sharp", "/ʃɑːrp/", "adjective", "a sudden, intense pain (like a knife)", "I feel a sharp pain when I breathe in."),
                    word("dull ache", "/dʌl eɪk/", "phrase", "a continuous, low-level pain that is not intense", "I have a dull ache in my shoulder."),
                    word("constant", "/ˈkɒnstənt/", "adjective", "happening all the time without stopping", "The pain is constant — it never goes away."),
                    word("radiate", "/ˈreɪdieɪt/", "verb", "to spread out from a central point", "The pain radiates from my back to my leg."),
                    word("tingling", "/ˈtɪŋɡlɪŋ/", "adjective/noun", "a light prickling sensation in the skin", "I have a tingling feeling in my fingers."),
                ],
                "questions": [
                    question("What caused the back pain?", ["A car accident", "Moving heavy boxes", "A sports injury"], 1, "Correct! The back pain started after moving heavy boxes."),
                    question("Where does the tingling feeling go?", ["Up the back", "Down the right leg", "Into the left arm"], 1, "Correct! The tingling goes down the right leg."),
                ],
            },
            {
                "title": "Mental Health Consultation",
                "cefr": "B2",
                "level_label": "Upper-Intermediate",
                "situation": "You visit your GP to discuss how you have been feeling mentally and emotionally.",
                "dialogue": [
                    line("Doctor", "You mentioned on the form that you've been feeling low. Can you tell me more about that?"),
                    line("You", "Over the past couple of months, I haven't been sleeping well, and I've lost interest in things I used to enjoy. I feel exhausted most of the time, even when I haven't done much."),
                    line("Doctor", "Have you had any thoughts of harming yourself or feeling like life isn't worth living?"),
                    line("You", "No, nothing like that. It's more like a persistent grey feeling — not acute sadness, just flatness."),
                    line("Doctor", "That sounds like it could be depression, though we'd want to rule out physical causes first. How is your appetite, and have you had any significant life changes recently?"),
                    line("You", "My appetite is down. And yes — I changed jobs six months ago and it's been more stressful than I expected."),
                ],
                "words": [
                    word("exhausted", "/ɪɡˈzɔːstɪd/", "adjective", "extremely tired, with no energy left", "I feel completely exhausted, even after a full night's sleep."),
                    word("persistent", "/pəˈsɪstənt/", "adjective", "continuing for a long time; not stopping", "She has a persistent cough that won't go away."),
                    word("acute", "/əˈkjuːt/", "adjective", "severe and sudden in onset (in medical terms)", "The patient arrived with acute chest pain."),
                    word("rule out", "/ruːl aʊt/", "phrasal verb", "to eliminate something as a possibility", "We need to rule out any physical causes first."),
                    word("appetite", "/ˈæpɪtaɪt/", "noun", "the natural desire to eat food", "I've had no appetite this week."),
                ],
                "questions": [
                    question("Which symptom does the patient NOT mention?", ["Poor sleep", "Chest pain", "Loss of interest"], 1, "Correct! The patient does not mention chest pain."),
                    question("What significant life change happened six months ago?", ["They moved house", "They changed jobs", "They ended a relationship"], 1, "Correct! The patient changed jobs six months ago."),
                ],
            },
            {
                "title": "Specialist Referral & Second Opinion",
                "cefr": "C1",
                "level_label": "Advanced",
                "situation": "Your GP is referring you to a specialist. You ask informed questions about the referral process.",
                "dialogue": [
                    line("Doctor", "Based on your test results, I'd like to refer you to a cardiologist. Your ECG shows some irregularities that warrant further investigation."),
                    line("You", "I see. Can you explain what kind of irregularities we're talking about?"),
                    line("Doctor", "There are some anomalies in your heart rhythm — nothing that points definitively to a serious condition, but we shouldn't ignore them."),
                    line("You", "How long is the waiting time for a referral, typically?"),
                    line("Doctor", "Under the NHS, it should be within 18 weeks. However, given the nature of the findings, I'll mark it as urgent, which should accelerate that considerably."),
                    line("You", "I'd also like to consider seeking a private second opinion. Is that something you'd advise against?"),
                    line("Doctor", "Not at all. A second opinion is your right, and for anything cardiac-related, it's entirely reasonable. I can provide you with a full summary of your results."),
                ],
                "words": [
                    word("referral", "/rɪˈfɜːrəl/", "noun", "when a doctor sends a patient to see a specialist", "I have a referral to see a specialist next month."),
                    word("cardiologist", "/ˌkɑːrdiˈɒləʤɪst/", "noun", "a doctor who specialises in the heart", "The cardiologist reviewed my ECG results."),
                    word("anomaly", "/əˈnɒməli/", "noun", "something that is irregular or unexpected", "The scan revealed a small anomaly."),
                    word("second opinion", "/ˈsɛkənd əˈpɪnjən/", "phrase", "asking another doctor to confirm or review a diagnosis", "I decided to get a second opinion before the operation."),
                    word("cardiac", "/ˈkɑːrdiæk/", "adjective", "relating to the heart", "He is in the cardiac care unit."),
                ],
                "questions": [
                    question("Why is the doctor referring the patient?", ["Broken bone", "ECG irregularities", "High blood pressure"], 1, "Correct! The doctor is referring the patient due to ECG irregularities."),
                    question("What does the doctor say about seeking a second opinion?", ["It's not advisable", "It's the patient's right", "It will delay treatment"], 1, "Correct! The doctor says a second opinion is the patient's right."),
                ],
            },
        ],
    },
    "small_talk": {
        "title": "Small Talk",
        "path_subtitle": (
            "Master casual conversation — from talking about the weather to "
            "connecting meaningfully at social events."
        ),
        "lessons": [
            {
                "title": "The Weather",
                "cefr": "A1",
                "level_label": "Beginner",
                "situation": "You are waiting at a bus stop. You start a conversation with the person next to you.",
                "dialogue": [
                    line("You", "What terrible weather today!"),
                    line("Stranger", "I know. It's been raining all morning."),
                    line("You", "Yes. I forgot my umbrella."),
                    line("Stranger", "Oh no! Here, share mine."),
                    line("You", "That's very kind. Thank you!"),
                    line("Stranger", "No problem. The forecast says it will stop by the afternoon."),
                    line("You", "That's good to hear. I hope so."),
                ],
                "words": [
                    word("forecast", "/ˈfɔːrkæst/", "noun", "a prediction of future weather", "The forecast says sun tomorrow."),
                    word("terrible", "/ˈtɛrɪbəl/", "adjective", "very bad", "It's terrible weather for a picnic."),
                    word("umbrella", "/ʌmˈbrɛlə/", "noun", "a device you open to protect yourself from rain", "I always carry an umbrella in winter."),
                    word("share", "/ʃɛər/", "verb", "to use something together with someone", "We shared a taxi to the station."),
                    word("kind", "/kaɪnd/", "adjective", "warm and generous; caring", "That's very kind of you."),
                ],
                "questions": [
                    question("What did the speaker forget?", ["Their coat", "Their umbrella", "Their phone"], 1, "Correct! The speaker forgot their umbrella."),
                    question("What does the forecast say?", ["More rain", "Rain stops by the afternoon", "Wind and cold"], 1, "Correct! The forecast says rain stops by the afternoon."),
                ],
            },
            {
                "title": "Talking About the Weekend",
                "cefr": "A2",
                "level_label": "Elementary",
                "situation": "You are chatting with a colleague at work on Monday morning.",
                "dialogue": [
                    line("Colleague", "Hey! How was your weekend?"),
                    line("You", "It was great, thanks. I went hiking with some friends on Saturday. What about you?"),
                    line("Colleague", "Nice! I mostly stayed in — watched a film and did some cooking."),
                    line("You", "Oh, what film did you watch?"),
                    line("Colleague", "That new thriller on Netflix. Have you seen it?"),
                    line("You", "Not yet. Is it good?"),
                    line("Colleague", "Really good — a bit scary, but worth watching. I'd recommend it."),
                ],
                "words": [
                    word("hiking", "/ˈhaɪkɪŋ/", "noun", "walking in nature for exercise or enjoyment", "We go hiking in the mountains every summer."),
                    word("stayed in", "/steɪd ɪn/", "phrase", "stayed at home instead of going out", "I stayed in on Friday and watched TV."),
                    word("thriller", "/ˈθrɪlər/", "noun", "a film or book with suspense and excitement", "I love a good thriller — they keep me guessing."),
                    word("scary", "/ˈskɛri/", "adjective", "causing fear or fright", "That horror film was too scary for me."),
                    word("recommend", "/ˌrɛkəˈmɛnd/", "verb", "to suggest something as being good", "I highly recommend this restaurant."),
                ],
                "questions": [
                    question("What did the speaker do on Saturday?", ["Watched a film", "Cooked dinner", "Went hiking"], 2, "Correct! The speaker went hiking on Saturday."),
                    question("How does the colleague describe the film?", ["Boring but long", "Scary but worth watching", "Funny and light"], 1, "Correct! The colleague says it is scary but worth watching."),
                ],
            },
            {
                "title": "At a Party",
                "cefr": "B1",
                "level_label": "Intermediate",
                "situation": "You are at a friend's birthday party and meet someone you don't know.",
                "dialogue": [
                    line("You", "Hi, I don't think we've met. I'm Alex."),
                    line("Stranger", "Hi Alex, I'm Jamie. How do you know Sarah?"),
                    line("You", "We went to university together. We studied in the same class for three years. And you?"),
                    line("Jamie", "We worked together at her old company. We've stayed in touch ever since."),
                    line("You", "That's great. What do you do now?"),
                    line("Jamie", "I'm a graphic designer — I work freelance mainly. It's a bit chaotic but I love the freedom."),
                    line("You", "Sounds interesting. I've always admired people who can work for themselves."),
                ],
                "words": [
                    word("stayed in touch", "/steɪd ɪn tʌʧ/", "phrase", "maintained contact with someone over time", "We stayed in touch after school through social media."),
                    word("freelance", "/ˈfriːlæns/", "adjective/adverb", "working independently for different clients, not one employer", "She works freelance as a photographer."),
                    word("chaotic", "/keɪˈɒtɪk/", "adjective", "completely disordered and unpredictable", "The office was chaotic on deadline day."),
                    word("admire", "/ədˈmaɪər/", "verb", "to respect and have a positive opinion of someone", "I really admire her courage."),
                    word("work for yourself", "/wɜːrk fɔːr jɔːrsɛlf/", "phrase", "to be self-employed rather than work for a company", "Working for yourself takes discipline."),
                ],
                "questions": [
                    question("How does Alex know Sarah?", ["They worked together", "They went to university together", "They are family"], 1, "Correct! Alex and Sarah went to university together."),
                    question("What does Jamie like about their job?", ["The salary", "The freedom", "The colleagues"], 1, "Correct! Jamie loves the freedom of freelance work."),
                ],
            },
            {
                "title": "Networking Event",
                "cefr": "B2",
                "level_label": "Upper-Intermediate",
                "situation": "You are at a professional networking event and strike up a conversation with someone in your industry.",
                "dialogue": [
                    line("You", "Hi — I noticed you were at the panel discussion earlier. What did you make of it?"),
                    line("Contact", "Honestly, I found the second speaker more compelling — the first one was a bit light on specifics."),
                    line("You", "I agree. The point about AI in supply chains was the most thought-provoking part for me. I'm actually working in that space."),
                    line("Contact", "Really? What kind of work are you doing?"),
                    line("You", "I lead the digital transformation team at a mid-sized logistics firm. We're about halfway through a three-year overhaul."),
                    line("Contact", "That sounds fascinating — and no doubt challenging. I'd love to hear more. Do you have a card?"),
                    line("You", "I do. And I'd be happy to connect on LinkedIn too. What's the best way to follow up?"),
                ],
                "words": [
                    word("panel discussion", "/ˈpænəl dɪˈskʌʃən/", "phrase", "a group of experts discussing a topic in public", "The panel discussion covered climate policy."),
                    word("compelling", "/kəmˈpɛlɪŋ/", "adjective", "highly persuasive or interesting", "She made a compelling argument for change."),
                    word("thought-provoking", "/ˈθɔːt prəˌvoʊkɪŋ/", "adjective", "causing you to think deeply", "That was a thought-provoking question."),
                    word("overhaul", "/ˈoʊvərˌhɔːl/", "noun", "a complete review and rebuild of a system", "The IT system needs a complete overhaul."),
                    word("follow up", "/ˈfɒloʊ ʌp/", "phrasal verb", "to make further contact after an initial meeting", "I'll follow up by email after the conference."),
                ],
                "questions": [
                    question("Which speaker did the contact find more compelling?", ["The first", "The second", "The third"], 1, "Correct! The contact found the second speaker more compelling."),
                    question("What is the speaker's role?", ["Sales director", "Digital transformation team lead", "IT consultant"], 1, "Correct! The speaker leads the digital transformation team."),
                ],
            },
            {
                "title": "Deep Conversation — Life & Ambitions",
                "cefr": "C1",
                "level_label": "Advanced",
                "situation": "You are with a close friend you haven't seen in a year. The conversation moves beyond surface-level chat.",
                "dialogue": [
                    line("Friend", "So honestly — are you happy with where things are going?"),
                    line("You", "That's a big question for a Tuesday evening. In a lot of ways, yes. But I've been thinking more and more about whether I'm building something that actually matters — or just keeping busy."),
                    line("Friend", "That's something I struggle with too. I think it gets harder to ignore as you get older."),
                    line("You", "Exactly. When I was twenty-five, ambition felt like its own answer. Now I want to know where the ambition is pointing."),
                    line("Friend", "Do you think that's disillusionment, or is it wisdom?"),
                    line("You", "Possibly both. I hope it's the latter — but I suspect disillusionment plays a role when things get hard."),
                ],
                "words": [
                    word("surface-level", "/ˈsɜːrfɪs ˌlɛvəl/", "adjective", "not going deep; only dealing with what is obvious", "We only had a surface-level conversation at the party."),
                    word("ambition", "/æmˈbɪʃən/", "noun", "a strong desire to achieve something", "His ambition drove him to work eighteen-hour days."),
                    word("disillusionment", "/ˌdɪsɪˈluːʒənmənt/", "noun", "disappointment from discovering something is not as good as believed", "There is a growing disillusionment with politics."),
                    word("wisdom", "/ˈwɪzdəm/", "noun", "the ability to make good judgements based on experience", "With age comes wisdom — and also grey hair."),
                    word("the latter", "/ðə ˈlætər/", "phrase", "the second of two things just mentioned", "Between wealth and health, I'd choose the latter."),
                ],
                "questions": [
                    question("What is the speaker questioning about their life?", ["Their salary", "Whether they are building something that matters", "Their relationship"], 1, "Correct! The speaker questions whether they are building something that matters."),
                    question("How did ambition feel at twenty-five?", ["Exhausting", "Its own answer", "Pointless"], 1, "Correct! At twenty-five, ambition felt like its own answer."),
                ],
            },
        ],
    },
    "business_meeting": {
        "title": "Business Meeting",
        "path_subtitle": (
            "Run and participate in meetings — from setting the agenda to handling "
            "disagreements and closing with action points."
        ),
        "lessons": [
            {
                "title": "Starting a Meeting",
                "cefr": "B1",
                "level_label": "Intermediate",
                "situation": "You are the team leader starting a weekly update meeting.",
                "dialogue": [
                    line("You", "OK, let's get started. Thanks everyone for coming. Today's agenda has three points: project update, budget review, and next steps."),
                    line("Colleague A", "Before we begin, can we add one item? We got feedback from the client this morning."),
                    line("You", "Of course. We'll add that as point four. Right — project update first. Where are we?"),
                    line("Colleague B", "We're on track. Phase one is complete and phase two starts next Monday."),
                    line("You", "Great. Any blockers?"),
                    line("Colleague B", "One small one — we're waiting on sign-off from legal. Should be done by Friday."),
                    line("You", "OK. Let's move on to the budget."),
                ],
                "words": [
                    word("agenda", "/əˈʤɛndə/", "noun", "a list of items to discuss at a meeting", "The agenda for today has five points."),
                    word("on track", "/ɒn træk/", "phrase", "progressing as planned", "The project is on track for the October deadline."),
                    word("blocker", "/ˈblɒkər/", "noun", "a problem that stops progress", "We have one blocker — approval from management."),
                    word("sign-off", "/saɪn ɒf/", "noun", "official approval for something", "We need sign-off before we can proceed."),
                    word("move on", "/muːv ɒn/", "phrasal verb", "to go to the next topic or item", "Let's move on to the next agenda point."),
                ],
                "questions": [
                    question("How many original agenda items were there?", ["Two", "Three", "Four"], 1, "Correct! There were three original agenda items."),
                    question("What is the blocker for phase two?", ["Budget issue", "Waiting for sign-off from legal", "Missing team member"], 1, "Correct! The blocker is waiting for sign-off from legal."),
                ],
            },
            {
                "title": "Presenting Data",
                "cefr": "B1",
                "level_label": "Intermediate",
                "situation": "You are presenting quarterly sales data to your manager and team.",
                "dialogue": [
                    line("You", "I'll take you through the Q3 numbers. As you can see on the slide, total revenue was up 12% compared to Q2."),
                    line("Manager", "That's encouraging. What's driving that growth?"),
                    line("You", "Two main factors. First, the new product line launched in August — it performed above expectations. Second, we expanded into the German market, which contributed around 4% of total revenue."),
                    line("Manager", "And what about the North America numbers? They look flat."),
                    line("You", "Yes, North America is a concern. We saw a slowdown in July and August. We believe it's seasonal, but we're monitoring it closely."),
                    line("Manager", "Good. What's the forecast for Q4?"),
                    line("You", "We're projecting 15–18% growth, assuming the new campaign lands well in October."),
                ],
                "words": [
                    word("revenue", "/ˈrɛvənjuː/", "noun", "income from business activity", "Revenue increased by 10% this quarter."),
                    word("performing above expectations", "/pəˈfɔːrmɪŋ əˈbʌv ˌɛkspɛkˈteɪʃənz/", "phrase", "doing better than predicted", "The new product is performing above expectations."),
                    word("flat", "/flæt/", "adjective", "not growing or declining; staying the same", "Sales were flat in the third quarter."),
                    word("seasonal", "/ˈsiːzənəl/", "adjective", "changing regularly with the season", "The slowdown is likely seasonal."),
                    word("projecting", "/prəˈʤɛktɪŋ/", "verb", "predicting or forecasting a future amount", "We are projecting a 20% increase."),
                ],
                "questions": [
                    question("What was total revenue growth in Q3?", ["4%", "12%", "15%"], 1, "Correct! Total revenue was up 12% in Q3."),
                    question("Why are North America numbers flat?", ["Price competition", "Believed to be seasonal slowdown", "Product issues"], 1, "Correct! The slowdown is believed to be seasonal."),
                ],
            },
            {
                "title": "Disagreeing Professionally",
                "cefr": "B2",
                "level_label": "Upper-Intermediate",
                "situation": "During a strategy meeting, you respectfully disagree with a proposal.",
                "dialogue": [
                    line("Colleague", "I think we should move to a fully remote model. It's cheaper and employees seem to prefer it."),
                    line("You", "I take your point on cost, and I agree remote flexibility matters. However, I'd push back on making it fully remote. We've seen a real drop in cross-team collaboration since we shifted last year."),
                    line("Colleague", "That could be a training issue rather than a structural one."),
                    line("You", "Possibly. But the data from our last engagement survey suggests it's more than that — satisfaction in junior staff dropped 15 points, and they specifically cited isolation."),
                    line("Manager", "Both fair points. Could we explore a hybrid model as a middle ground?"),
                    line("You", "That's exactly what I'd propose. Two or three anchor days in the office, flexibility for the rest."),
                ],
                "words": [
                    word("push back", "/pʊʃ bæk/", "phrasal verb", "to express disagreement or resistance to an idea", "I need to push back on that suggestion."),
                    word("collaboration", "/kəˌlæbəˈreɪʃən/", "noun", "working together with others", "Good collaboration is key to project success."),
                    word("engagement survey", "/ɪnˈɡeɪʤmənt ˈsɜːrveɪ/", "phrase", "a questionnaire measuring how committed and motivated employees feel", "The engagement survey results were concerning."),
                    word("hybrid model", "/ˈhaɪbrɪd ˈmɒdəl/", "phrase", "a system combining remote and in-office work", "We moved to a hybrid model after the pandemic."),
                    word("anchor day", "/ˈæŋkər deɪ/", "phrase", "a fixed day that all employees come into the office", "Wednesday is our anchor day for team meetings."),
                ],
                "questions": [
                    question("What does the speaker use to support their argument?", ["Personal opinion", "Data from an engagement survey", "External research"], 1, "Correct! The speaker uses data from an engagement survey."),
                    question("What solution does the speaker propose?", ["Fully remote", "Fully in-office", "Hybrid model"], 2, "Correct! The speaker proposes a hybrid model."),
                ],
            },
            {
                "title": "Closing & Action Points",
                "cefr": "B2",
                "level_label": "Upper-Intermediate",
                "situation": "You are wrapping up a meeting and assigning clear next steps.",
                "dialogue": [
                    line("You", "OK, I think we've covered everything. Let me summarise what we've agreed before we close."),
                    line("You", "David, you're going to finalize the budget proposal by Wednesday. Maria, you'll follow up with the client about their feedback. And I'll set up the legal sign-off call for Thursday."),
                    line("David", "Quick question — for the budget, should I include the contingency line or keep it separate?"),
                    line("You", "Include it but label it clearly. Let's keep everything in one document."),
                    line("Maria", "And for the client follow-up — email or call?"),
                    line("You", "Try the call first. If you can't reach them by Tuesday afternoon, send an email."),
                    line("You", "Great. Minutes will go out by end of day. Thanks everyone — productive session."),
                ],
                "words": [
                    word("summarise", "/ˈsʌməraɪz/", "verb", "to give the main points briefly", "Let me summarise what we discussed."),
                    word("action point", "/ˈækʃən pɔɪnt/", "phrase", "a specific task someone must complete after a meeting", "You have three action points from today's meeting."),
                    word("contingency", "/kənˈtɪnʤənsi/", "noun", "a reserve budget for unexpected costs", "We always include a 10% contingency in project budgets."),
                    word("minutes", "/ˈmɪnɪts/", "noun (plural)", "the official written record of what was said in a meeting", "Can you send the meeting minutes by Thursday?"),
                    word("productive", "/prəˈdʌktɪv/", "adjective", "achieving a lot; effective", "That was a very productive conversation."),
                ],
                "questions": [
                    question("Who is responsible for following up with the client?", ["David", "Maria", "The speaker"], 1, "Correct! Maria is responsible for following up with the client."),
                    question("When should Maria send an email to the client?", ["Immediately", "If the call fails by Tuesday afternoon", "After the meeting minutes"], 1, "Correct! Maria should email if the call fails by Tuesday afternoon."),
                ],
            },
            {
                "title": "High-Stakes Executive Meeting",
                "cefr": "C1",
                "level_label": "Advanced",
                "situation": "You are presenting a major strategic recommendation to the executive board.",
                "dialogue": [
                    line("CEO", "You've had three months to review the acquisition target. What's your recommendation?"),
                    line("You", "Our recommendation is to proceed, subject to the resolution of two outstanding due diligence concerns — their IP ownership structure and the pending litigation in the German subsidiary."),
                    line("CFO", "Walk me through your valuation rationale."),
                    line("You", "We used a DCF model with a WACC of 8.5% and a terminal growth rate of 2.5%, which gives a base-case valuation of $420 million. We stress-tested against a downside scenario where revenue growth is 30% below projection and still saw positive NPV."),
                    line("CEO", "What's your confidence level on the IP issue being resolved before close?"),
                    line("You", "Moderate. Their legal team is engaged and we have a fallback clause in the term sheet that protects our position if it isn't resolved within 60 days."),
                    line("CEO", "Good. We'll put this to a vote next week once the full board has reviewed the deck."),
                ],
                "words": [
                    word("due diligence", "/djuː ˈdɪlɪʤəns/", "phrase", "a thorough investigation before completing a business deal", "We completed due diligence before signing the contract."),
                    word("litigation", "/ˌlɪtɪˈɡeɪʃən/", "noun", "the process of taking legal action", "The company is involved in ongoing litigation."),
                    word("valuation", "/ˌvæljuˈeɪʃən/", "noun", "an estimate of how much something is worth", "The startup's valuation was $500 million."),
                    word("stress-tested", "/strɛs tɛstɪd/", "verb (past)", "evaluated under extreme or unfavourable conditions", "We stress-tested the model against a recession scenario."),
                    word("fallback clause", "/ˈfɔːlbæk klɔːz/", "phrase", "a provision in an agreement that protects a party if something goes wrong", "The contract has a fallback clause in case of delays."),
                ],
                "questions": [
                    question("What are the two outstanding due diligence concerns?", ["Revenue and profit", "IP ownership and pending litigation", "Market size and competition"], 1, "Correct! The concerns are IP ownership and pending litigation."),
                    question("What protects the company if the IP issue isn't resolved in 60 days?", ["A penalty clause", "A fallback clause in the term sheet", "The CEO's decision"], 1, "Correct! A fallback clause in the term sheet protects the company."),
                ],
            },
        ],
    },
}


def build_vocabulary_lesson(scenario_id: str, index: int, lesson: dict) -> dict:
    cefr = lesson["cefr"]
    return {
        "id": f"{scenario_id}_vocab_{index:02d}",
        "number": index,
        "title": lesson["title"],
        "cefrLevel": cefr,
        "levelLabel": lesson.get("level_label", level_label(cefr)),
        "situation": lesson["situation"],
        "iconName": "chat",
        "dialogue": lesson["dialogue"],
        "words": lesson["words"],
    }


def build_quick_check_lesson(
    scenario_id: str,
    index: int,
    lesson: dict,
    completion_title: str,
) -> dict:
    return {
        "id": f"{scenario_id}_quick_{index:02d}",
        "number": index,
        "title": lesson["title"],
        "cefrLevel": lesson["cefr"],
        "iconName": "chat",
        "completionTitle": completion_title,
        "completionSummary": f"You have completed {lesson['title']} successfully",
        "questions": lesson["questions"],
    }


def write_json(path: str, data: dict) -> None:
    with open(path, "w", encoding="utf-8") as handle:
        json.dump(data, handle, indent=2, ensure_ascii=False)
        handle.write("\n")


def main() -> None:
    os.makedirs(BASE_DIR, exist_ok=True)
    manifest = {"scenarios": []}

    for scenario_id, scenario in SCENARIOS.items():
        scenario_dir = os.path.join(BASE_DIR, scenario_id)
        os.makedirs(scenario_dir, exist_ok=True)

        title = scenario["title"]
        path_subtitle = scenario["path_subtitle"]
        completion_title = title
        lessons = scenario["lessons"]
        first_cefr = lessons[0]["cefr"]

        vocab_lessons = [
            build_vocabulary_lesson(scenario_id, index, lesson)
            for index, lesson in enumerate(lessons, start=1)
        ]
        vocabulary = {
            "scenarioId": scenario_id,
            "cefrLevel": first_cefr,
            "pathTitle": f"{title} Vocabulary",
            "pathSubtitle": path_subtitle,
            "lessons": vocab_lessons,
        }

        quick_lessons = [
            build_quick_check_lesson(scenario_id, index, lesson, completion_title)
            for index, lesson in enumerate(lessons, start=1)
        ]
        quick_check = {
            "scenarioId": scenario_id,
            "cefrLevel": first_cefr,
            "pathTitle": f"{title} Quick Check",
            "pathSubtitle": path_subtitle,
            "lessons": quick_lessons,
        }

        write_json(os.path.join(scenario_dir, "vocabulary.json"), vocabulary)
        write_json(os.path.join(scenario_dir, "quick_check.json"), quick_check)

        manifest["scenarios"].append(
            {
                "id": scenario_id,
                "cefrLevel": first_cefr,
                "vocabularyAsset": f"assets/roleplay/{scenario_id}/vocabulary.json",
                "quickCheckAsset": f"assets/roleplay/{scenario_id}/quick_check.json",
            }
        )

    write_json(os.path.join(BASE_DIR, "manifest.json"), manifest)

    print("Roleplay content generation complete")
    print(f"  Scenarios: {len(SCENARIOS)}")
    total_lessons = 0
    for scenario_id, scenario in SCENARIOS.items():
        lesson_count = len(scenario["lessons"])
        total_lessons += lesson_count
        print(f"  - {scenario_id}: {lesson_count} lessons")
    print(f"  Total lessons: {total_lessons} (expected 30)")
    if len(SCENARIOS) != 6 or total_lessons != 30:
        raise SystemExit("Verification failed: expected 6 scenarios with 30 lessons total")
    print("  Verification passed: 6 scenarios x 5 lessons each")


if __name__ == "__main__":
    main()
