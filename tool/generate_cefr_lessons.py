#!/usr/bin/env python3
"""Generate all 180 CEFR lesson JSON files and manifest.json for Fluentta-AI."""

from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUTPUT = ROOT / "assets" / "lessons"

LEVELS = ("a1", "a2", "b1", "b2", "c1", "c2")
TYPE_FOLDERS = {
    "vocabulary": "vocabulary",
    "grammar": "grammar",
    "reading": "reading",
}
TYPE_CODES = {
    "vocabulary": "vocab",
    "grammar": "grammar",
    "reading": "reading",
}


def slugify(title: str) -> str:
    slug = title.lower()
    slug = slug.replace("&", "and")
    slug = re.sub(r"[^a-z0-9]+", "_", slug)
    return slug.strip("_")


def word(entry: tuple[str, str, str, str, str]) -> dict:
    w, phonetic, pos, definition, example = entry
    return {
        "word": w,
        "phonetic": phonetic,
        "partOfSpeech": pos,
        "definition": definition,
        "example": example,
    }


def grammar_example(text: str, highlight: str) -> dict:
    return {"text": text, "highlight": highlight}


def reading_line(speaker: str, text: str, is_user: bool = False) -> dict:
    return {"speaker": speaker, "text": text, "isUser": is_user}


def mcq(prompt: str, options: list[str], correct_index: int) -> dict:
    return {"prompt": prompt, "options": options, "correctIndex": correct_index}


# ---------------------------------------------------------------------------
# Curriculum: 10 vocabulary, 10 grammar, 10 reading lessons per CEFR level
# ---------------------------------------------------------------------------

VOCABULARY: dict[str, list[dict]] = {
    "a1": [
        {
            "title": "Greetings",
            "iconName": "chat",
            "words": [
                ("hello", "/həˈloʊ/", "interjection", "A friendly greeting.", "Hello! Nice to meet you."),
                ("goodbye", "/ɡʊdˈbaɪ/", "interjection", "A word said when leaving.", "Goodbye! See you tomorrow."),
                ("please", "/pliːz/", "adverb", "Used to make a request polite.", "Can I have water, please?"),
                ("thank you", "/θæŋk juː/", "phrase", "An expression of gratitude.", "Thank you for your help."),
                ("sorry", "/ˈsɒri/", "adjective", "An apology or expression of regret.", "Sorry, I am late."),
            ],
        },
        {
            "title": "Numbers",
            "iconName": "chat",
            "words": [
                ("one", "/wʌn/", "numeral", "The number 1.", "I have one brother."),
                ("two", "/tuː/", "numeral", "The number 2.", "She has two cats."),
                ("three", "/θriː/", "numeral", "The number 3.", "We need three chairs."),
                ("four", "/fɔːr/", "numeral", "The number 4.", "There are four seasons."),
                ("five", "/faɪv/", "numeral", "The number 5.", "He works five days a week."),
            ],
        },
        {
            "title": "Family",
            "iconName": "chat",
            "words": [
                ("mother", "/ˈmʌðər/", "noun", "A female parent.", "My mother cooks dinner."),
                ("father", "/ˈfɑːðər/", "noun", "A male parent.", "His father is a teacher."),
                ("sister", "/ˈsɪstər/", "noun", "A female sibling.", "I have one sister."),
                ("brother", "/ˈbrʌðər/", "noun", "A male sibling.", "Her brother plays football."),
                ("child", "/tʃaɪld/", "noun", "A young person.", "The child is happy."),
            ],
        },
        {
            "title": "Colors",
            "iconName": "chat",
            "words": [
                ("red", "/rɛd/", "adjective", "The color of blood or fire.", "She wears a red dress."),
                ("blue", "/bluː/", "adjective", "The color of the sky.", "The sky is blue today."),
                ("green", "/ɡriːn/", "adjective", "The color of grass.", "The grass is green."),
                ("yellow", "/ˈjɛloʊ/", "adjective", "The color of the sun.", "The taxi is yellow."),
                ("black", "/blæk/", "adjective", "The darkest color.", "He has black hair."),
            ],
        },
        {
            "title": "Days",
            "iconName": "chat",
            "words": [
                ("Monday", "/ˈmʌndeɪ/", "noun", "The first day of the work week.", "I start work on Monday."),
                ("Tuesday", "/ˈtuːzdeɪ/", "noun", "The day after Monday.", "We have a meeting on Tuesday."),
                ("Wednesday", "/ˈwɛnzdeɪ/", "noun", "The middle of the work week.", "She goes to the gym on Wednesday."),
                ("Thursday", "/ˈθɜːrzdeɪ/", "noun", "The day before Friday.", "He studies English on Thursday."),
                ("Friday", "/ˈfraɪdeɪ/", "noun", "The last day of the work week.", "We eat pizza on Friday."),
            ],
        },
        {
            "title": "Foods",
            "iconName": "chat",
            "words": [
                ("bread", "/brɛd/", "noun", "A basic baked food.", "I eat bread for breakfast."),
                ("water", "/ˈwɔːtər/", "noun", "A clear liquid for drinking.", "Can I have some water?"),
                ("apple", "/ˈæpəl/", "noun", "A round sweet fruit.", "She likes green apples."),
                ("rice", "/raɪs/", "noun", "Small white or brown grains.", "We cook rice with chicken."),
                ("milk", "/mɪlk/", "noun", "A white drink from cows.", "The child drinks milk."),
            ],
        },
        {
            "title": "Body Parts",
            "iconName": "chat",
            "words": [
                ("head", "/hɛd/", "noun", "The top part of the body.", "My head hurts."),
                ("hand", "/hænd/", "noun", "The part at the end of the arm.", "Wash your hands."),
                ("eye", "/aɪ/", "noun", "The organ used for seeing.", "She has blue eyes."),
                ("foot", "/fʊt/", "noun", "The part at the end of the leg.", "My foot is sore."),
                ("heart", "/hɑːrt/", "noun", "The organ that pumps blood.", "Exercise is good for your heart."),
            ],
        },
        {
            "title": "House",
            "iconName": "chat",
            "words": [
                ("door", "/dɔːr/", "noun", "An entrance to a room or building.", "Please close the door."),
                ("window", "/ˈwɪndoʊ/", "noun", "An opening in a wall with glass.", "Open the window, please."),
                ("kitchen", "/ˈkɪtʃɪn/", "noun", "The room where food is cooked.", "She is in the kitchen."),
                ("bedroom", "/ˈbɛdruːm/", "noun", "A room for sleeping.", "My bedroom is small."),
                ("bathroom", "/ˈbæθruːm/", "noun", "A room with a toilet and shower.", "The bathroom is upstairs."),
            ],
        },
        {
            "title": "Clothing",
            "iconName": "chat",
            "words": [
                ("shirt", "/ʃɜːrt/", "noun", "A piece of clothing for the upper body.", "He wears a white shirt."),
                ("pants", "/pænts/", "noun", "Clothing for the legs.", "These pants are too long."),
                ("shoes", "/ʃuːz/", "noun", "Footwear.", "I need new shoes."),
                ("hat", "/hæt/", "noun", "A covering for the head.", "Wear a hat in the sun."),
                ("coat", "/koʊt/", "noun", "A warm outer garment.", "Take your coat—it is cold."),
            ],
        },
        {
            "title": "Weather",
            "iconName": "chat",
            "words": [
                ("sun", "/sʌn/", "noun", "The star that gives light and heat.", "The sun is bright today."),
                ("rain", "/reɪn/", "noun", "Water falling from clouds.", "I don't like rain."),
                ("snow", "/snoʊ/", "noun", "Soft white frozen water.", "It snows in winter."),
                ("wind", "/wɪnd/", "noun", "Moving air.", "The wind is strong."),
                ("cloud", "/klaʊd/", "noun", "A white or gray mass in the sky.", "There are many clouds."),
            ],
        },
    ],
    "a2": [
        {
            "title": "Jobs",
            "iconName": "chat",
            "words": [
                ("doctor", "/ˈdɒktər/", "noun", "A person who treats sick people.", "The doctor works at the hospital."),
                ("teacher", "/ˈtiːtʃər/", "noun", "A person who helps students learn.", "My teacher is very kind."),
                ("engineer", "/ˌɛndʒɪˈnɪər/", "noun", "A person who designs machines or buildings.", "He is a software engineer."),
                ("nurse", "/nɜːrs/", "noun", "A person who cares for patients.", "The nurse checked my temperature."),
                ("chef", "/ʃɛf/", "noun", "A professional cook.", "The chef makes excellent pasta."),
            ],
        },
        {
            "title": "Transportation",
            "iconName": "travel",
            "words": [
                ("bus", "/bʌs/", "noun", "A large public vehicle.", "I take the bus to work."),
                ("train", "/treɪn/", "noun", "A vehicle that runs on rails.", "The train leaves at nine."),
                ("ticket", "/ˈtɪkɪt/", "noun", "A pass that allows travel.", "Buy a ticket at the station."),
                ("airport", "/ˈɛərpɔːrt/", "noun", "A place where planes take off.", "We arrived at the airport early."),
                ("bicycle", "/ˈbaɪsɪkəl/", "noun", "A two-wheeled vehicle.", "She rides her bicycle every day."),
            ],
        },
        {
            "title": "Hobbies",
            "iconName": "chat",
            "words": [
                ("reading", "/ˈriːdɪŋ/", "noun", "The activity of looking at books.", "Reading helps me relax."),
                ("swimming", "/ˈswɪmɪŋ/", "noun", "Moving through water.", "Swimming is good exercise."),
                ("drawing", "/ˈdrɔːɪŋ/", "noun", "Making pictures with a pencil.", "She enjoys drawing animals."),
                ("cooking", "/ˈkʊkɪŋ/", "noun", "Preparing food.", "Cooking is his favorite hobby."),
                ("dancing", "/ˈdænsɪŋ/", "noun", "Moving to music.", "They go dancing on Saturdays."),
            ],
        },
        {
            "title": "Health and Fitness",
            "iconName": "chat",
            "words": [
                ("exercise", "/ˈɛksərsaɪz/", "noun", "Physical activity to stay healthy.", "I do exercise every morning."),
                ("medicine", "/ˈmɛdɪsɪn/", "noun", "A substance used to treat illness.", "Take this medicine twice a day."),
                ("headache", "/ˈhɛdeɪk/", "noun", "Pain in the head.", "I have a headache."),
                ("healthy", "/ˈhɛlθi/", "adjective", "In good physical condition.", "Eat healthy food every day."),
                ("tired", "/ˈtaɪərd/", "adjective", "Needing rest or sleep.", "I feel tired after work."),
            ],
        },
        {
            "title": "Shopping",
            "iconName": "chat",
            "words": [
                ("price", "/praɪs/", "noun", "The amount of money something costs.", "What is the price of this bag?"),
                ("discount", "/ˈdɪskaʊnt/", "noun", "A reduction in price.", "There is a 20% discount today."),
                ("receipt", "/rɪˈsiːt/", "noun", "A paper showing payment.", "Keep your receipt."),
                ("cash", "/kæʃ/", "noun", "Money in coins or notes.", "Do you pay by cash or card?"),
                ("customer", "/ˈkʌstəmər/", "noun", "A person who buys something.", "The customer is waiting."),
            ],
        },
        {
            "title": "Restaurant",
            "iconName": "chat",
            "words": [
                ("menu", "/ˈmɛnjuː/", "noun", "A list of food and drinks.", "Can I see the menu, please?"),
                ("order", "/ˈɔːrdər/", "verb", "To ask for food or drink.", "Are you ready to order?"),
                ("bill", "/bɪl/", "noun", "The amount you must pay.", "Could we have the bill, please?"),
                ("delicious", "/dɪˈlɪʃəs/", "adjective", "Very tasty.", "This soup is delicious."),
                ("waiter", "/ˈweɪtər/", "noun", "A person who serves food.", "The waiter brought our drinks."),
            ],
        },
        {
            "title": "Travel",
            "iconName": "travel",
            "words": [
                ("passport", "/ˈpæspɔːrt/", "noun", "An official travel document.", "Don't forget your passport."),
                ("hotel", "/hoʊˈtɛl/", "noun", "A place where travelers sleep.", "We stayed at a small hotel."),
                ("luggage", "/ˈlʌɡɪdʒ/", "noun", "Bags used for travel.", "My luggage is heavy."),
                ("map", "/mæp/", "noun", "A drawing that shows places.", "Use a map to find the museum."),
                ("tourist", "/ˈtʊrɪst/", "noun", "A person visiting a place for pleasure.", "Many tourists visit Rome."),
            ],
        },
        {
            "title": "Past Events",
            "iconName": "chat",
            "words": [
                ("yesterday", "/ˈjɛstərdeɪ/", "adverb", "On the day before today.", "I visited my friend yesterday."),
                ("ago", "/əˈɡoʊ/", "adverb", "Before the present time.", "She called me two hours ago."),
                ("last", "/læst/", "adjective", "Most recent.", "We met last week."),
                ("remember", "/rɪˈmɛmbər/", "verb", "To keep something in your mind.", "I remember my first day at school."),
                ("forget", "/fərˈɡɛt/", "verb", "To fail to remember.", "Don't forget your keys."),
            ],
        },
        {
            "title": "Comparisons",
            "iconName": "chat",
            "words": [
                ("bigger", "/ˈbɪɡər/", "adjective", "Comparative of big.", "My house is bigger than yours."),
                ("smaller", "/ˈsmɔːlər/", "adjective", "Comparative of small.", "This phone is smaller."),
                ("better", "/ˈbɛtər/", "adjective", "Comparative of good.", "Exercise makes you feel better."),
                ("worse", "/wɜːrs/", "adjective", "Comparative of bad.", "The weather is worse today."),
                ("than", "/ðæn/", "conjunction", "Used in comparisons.", "She is taller than me."),
            ],
        },
        {
            "title": "Technology",
            "iconName": "chat",
            "words": [
                ("computer", "/kəmˈpjuːtər/", "noun", "An electronic machine for work.", "I use a computer at work."),
                ("internet", "/ˈɪntərnɛt/", "noun", "A global network of computers.", "I found the answer on the internet."),
                ("email", "/ˈiːmeɪl/", "noun", "A message sent electronically.", "Send me an email tomorrow."),
                ("password", "/ˈpæswɜːrd/", "noun", "A secret word for access.", "Choose a strong password."),
                ("website", "/ˈwɛbsaɪt/", "noun", "A location on the internet.", "Visit our website for details."),
            ],
        },
    ],
    "b1": [
        {
            "title": "Work and Office",
            "iconName": "chat",
            "words": [
                ("deadline", "/ˈdɛdlaɪn/", "noun", "The latest time to finish work.", "The deadline is Friday."),
                ("colleague", "/ˈkɒliːɡ/", "noun", "A person you work with.", "My colleague helped me."),
                ("meeting", "/ˈmiːtɪŋ/", "noun", "When people come together to discuss work.", "We have a meeting at ten."),
                ("promotion", "/prəˈmoʊʃən/", "noun", "A move to a higher job.", "She got a promotion last year."),
                ("salary", "/ˈsæləri/", "noun", "Money paid for work.", "His salary increased."),
            ],
        },
        {
            "title": "Education",
            "iconName": "chat",
            "words": [
                ("degree", "/dɪˈɡriː/", "noun", "A qualification from a university.", "She has a degree in biology."),
                ("lecture", "/ˈlɛktʃər/", "noun", "A talk given to students.", "The lecture starts at nine."),
                ("assignment", "/əˈsaɪnmənt/", "noun", "Work given to students.", "I finished my assignment."),
                ("research", "/rɪˈsɜːrtʃ/", "noun", "Careful study to find facts.", "He is doing research on climate."),
                ("graduate", "/ˈɡrædʒueɪt/", "verb", "To complete a degree.", "She will graduate next June."),
            ],
        },
        {
            "title": "Environment",
            "iconName": "chat",
            "words": [
                ("pollution", "/pəˈluːʃən/", "noun", "Harmful substances in air or water.", "Air pollution is a serious problem."),
                ("recycle", "/riːˈsaɪkəl/", "verb", "To use materials again.", "We recycle paper and plastic."),
                ("climate", "/ˈklaɪmət/", "noun", "Weather conditions over time.", "Climate change affects everyone."),
                ("energy", "/ˈɛnərdʒi/", "noun", "Power from fuel or natural sources.", "Solar energy is renewable."),
                ("wildlife", "/ˈwaɪldlaɪf/", "noun", "Animals living in nature.", "We must protect wildlife."),
            ],
        },
        {
            "title": "Media",
            "iconName": "chat",
            "words": [
                ("headline", "/ˈhɛdlaɪn/", "noun", "The title of a news story.", "The headline shocked everyone."),
                ("journalist", "/ˈdʒɜːrnəlɪst/", "noun", "A person who writes news.", "The journalist interviewed the mayor."),
                ("broadcast", "/ˈbrɔːdkæst/", "verb", "To send out on TV or radio.", "They broadcast the game live."),
                ("advertisement", "/ˌædvərˈtaɪzmənt/", "noun", "A public notice to sell something.", "I saw an advertisement online."),
                ("audience", "/ˈɔːdiəns/", "noun", "People who watch or listen.", "The audience applauded loudly."),
            ],
        },
        {
            "title": "Describing People",
            "iconName": "chat",
            "words": [
                ("confident", "/ˈkɒnfɪdənt/", "adjective", "Sure of yourself.", "She is confident in interviews."),
                ("generous", "/ˈdʒɛnərəs/", "adjective", "Willing to give or share.", "He is generous with his time."),
                ("patient", "/ˈpeɪʃənt/", "adjective", "Able to wait calmly.", "Teachers need to be patient."),
                ("reliable", "/rɪˈlaɪəbəl/", "adjective", "Able to be trusted.", "She is a reliable friend."),
                ("ambitious", "/æmˈbɪʃəs/", "adjective", "Wanting to succeed.", "He is ambitious about his career."),
            ],
        },
        {
            "title": "Feelings",
            "iconName": "chat",
            "words": [
                ("anxious", "/ˈæŋkʃəs/", "adjective", "Worried or nervous.", "I feel anxious before exams."),
                ("grateful", "/ˈɡreɪtfəl/", "adjective", "Thankful.", "I am grateful for your support."),
                ("disappointed", "/ˌdɪsəˈpɔɪntɪd/", "adjective", "Sad because expectations were not met.", "She was disappointed by the result."),
                ("relieved", "/rɪˈliːvd/", "adjective", "Feeling less worry.", "I was relieved to hear the news."),
                ("embarrassed", "/ɪmˈbærəst/", "adjective", "Feeling shy or ashamed.", "He felt embarrassed after the mistake."),
            ],
        },
        {
            "title": "Cooking",
            "iconName": "chat",
            "words": [
                ("ingredient", "/ɪnˈɡriːdiənt/", "noun", "A food used in a recipe.", "List all the ingredients."),
                ("recipe", "/ˈrɛsɪpi/", "noun", "Instructions for cooking.", "Follow the recipe carefully."),
                ("chop", "/tʃɒp/", "verb", "To cut into pieces.", "Chop the onions finely."),
                ("boil", "/bɔɪl/", "verb", "To heat liquid until it bubbles.", "Boil the water first."),
                ("season", "/ˈsiːzən/", "verb", "To add salt, pepper, or spices.", "Season the soup to taste."),
            ],
        },
        {
            "title": "Sports",
            "iconName": "chat",
            "words": [
                ("competition", "/ˌkɒmpəˈtɪʃən/", "noun", "An event where people try to win.", "The competition starts tomorrow."),
                ("coach", "/koʊtʃ/", "noun", "A person who trains athletes.", "Our coach is very experienced."),
                ("score", "/skɔːr/", "noun", "Points in a game.", "The final score was 2–1."),
                ("teamwork", "/ˈtiːmwɜːrk/", "noun", "Working well together.", "Teamwork won the match."),
                ("championship", "/ˈtʃæmpiənʃɪp/", "noun", "A major sports contest.", "They won the championship."),
            ],
        },
        {
            "title": "Holidays",
            "iconName": "travel",
            "words": [
                ("celebration", "/ˌsɛlɪˈbreɪʃən/", "noun", "A special enjoyable event.", "The celebration lasted all night."),
                ("tradition", "/trəˈdɪʃən/", "noun", "A custom passed through generations.", "It is a family tradition."),
                ("fireworks", "/ˈfaɪərwɜːrks/", "noun", "Colorful explosions in the sky.", "We watched fireworks on New Year's Eve."),
                ("gift", "/ɡɪft/", "noun", "Something given to someone.", "She bought a gift for her mother."),
                ("festival", "/ˈfɛstɪvəl/", "noun", "A special public event.", "The music festival was amazing."),
            ],
        },
        {
            "title": "Phone and Email",
            "iconName": "chat",
            "words": [
                ("attachment", "/əˈtætʃmənt/", "noun", "A file sent with an email.", "I sent the report as an attachment."),
                ("voicemail", "/ˈvɔɪsmeɪl/", "noun", "A recorded phone message.", "Leave a voicemail if I don't answer."),
                ("reply", "/rɪˈplaɪ/", "verb", "To answer a message.", "Please reply by tomorrow."),
                ("forward", "/fɔːrˈwɜːrd/", "verb", "To send a message to another person.", "Can you forward the email?"),
                ("subject line", "/ˈsʌbdʒɪkt laɪn/", "noun", "The title of an email.", "Write a clear subject line."),
            ],
        },
    ],
    "b2": [
        {
            "title": "Global Issues",
            "iconName": "chat",
            "words": [
                ("inequality", "/ˌɪnɪˈkwɒlɪti/", "noun", "Unfair differences between groups.", "Income inequality is growing."),
                ("poverty", "/ˈpɒvərti/", "noun", "The state of being very poor.", "Programs aim to reduce poverty."),
                ("refugee", "/ˌrɛfjuˈdʒiː/", "noun", "A person forced to leave their country.", "Refugees need safe shelter."),
                ("humanitarian", "/hjuːˌmænɪˈtɛəriən/", "adjective", "Concerned with reducing suffering.", "Humanitarian aid arrived quickly."),
                ("sustainability", "/səˌsteɪnəˈbɪlɪti/", "noun", "Using resources without destroying them.", "Sustainability guides our policy."),
            ],
        },
        {
            "title": "Politics",
            "iconName": "chat",
            "words": [
                ("democracy", "/dɪˈmɒkrəsi/", "noun", "Government by the people.", "Democracy requires active citizens."),
                ("election", "/ɪˈlɛkʃən/", "noun", "A process of choosing leaders.", "The election is in November."),
                ("policy", "/ˈpɒləsi/", "noun", "A plan of action by a government.", "The new policy affects taxes."),
                ("legislation", "/ˌlɛdʒɪsˈleɪʃən/", "noun", "Laws made by a government.", "Parliament passed the legislation."),
                ("campaign", "/kæmˈpeɪn/", "noun", "Organized efforts to achieve a goal.", "The campaign focused on education."),
            ],
        },
        {
            "title": "Business",
            "iconName": "chat",
            "words": [
                ("investment", "/ɪnˈvɛstmənt/", "noun", "Money put into a business.", "The investment paid off."),
                ("profit", "/ˈprɒfɪt/", "noun", "Money earned after costs.", "Profit increased last quarter."),
                ("negotiate", "/nɪˈɡoʊʃieɪt/", "verb", "To discuss to reach agreement.", "They negotiated a better contract."),
                ("entrepreneur", "/ˌɒntrəprəˈnɜːr/", "noun", "A person who starts businesses.", "She is a successful entrepreneur."),
                ("market share", "/ˈmɑːrkɪt ʃɛər/", "noun", "The portion of sales a company has.", "Our market share grew steadily."),
            ],
        },
        {
            "title": "Science",
            "iconName": "chat",
            "words": [
                ("hypothesis", "/haɪˈpɒθəsɪs/", "noun", "An idea tested by experiments.", "The hypothesis was confirmed."),
                ("experiment", "/ɪkˈspɛrɪmənt/", "noun", "A scientific test.", "The experiment lasted six months."),
                ("evidence", "/ˈɛvɪdəns/", "noun", "Facts that support a claim.", "There is strong evidence."),
                ("innovation", "/ˌɪnəˈveɪʃən/", "noun", "A new method or idea.", "Innovation drives progress."),
                ("breakthrough", "/ˈbreɪkθruː/", "noun", "An important discovery.", "Scientists announced a breakthrough."),
            ],
        },
        {
            "title": "Art and Culture",
            "iconName": "chat",
            "words": [
                ("exhibition", "/ˌɛksɪˈbɪʃən/", "noun", "A public display of art.", "The exhibition opens on Friday."),
                ("masterpiece", "/ˈmæstərpiːs/", "noun", "An outstanding work of art.", "The painting is a masterpiece."),
                ("heritage", "/ˈhɛrɪtɪdʒ/", "noun", "Traditions passed from the past.", "We must preserve cultural heritage."),
                ("performance", "/pərˈfɔːrməns/", "noun", "An act of presenting music or drama.", "The performance was moving."),
                ("creativity", "/ˌkriːeɪˈtɪvɪti/", "noun", "The ability to produce new ideas.", "Creativity flourishes in open teams."),
            ],
        },
        {
            "title": "Relationships",
            "iconName": "chat",
            "words": [
                ("commitment", "/kəˈmɪtmənt/", "noun", "A promise to do something.", "Marriage requires commitment."),
                ("trust", "/trʌst/", "noun", "Belief in someone's honesty.", "Trust is essential in friendship."),
                ("conflict", "/ˈkɒnflɪkt/", "noun", "A serious disagreement.", "They resolved the conflict peacefully."),
                ("empathy", "/ˈɛmpəθi/", "noun", "Understanding another person's feelings.", "Empathy improves communication."),
                ("boundaries", "/ˈbaʊndəriz/", "noun", "Limits in relationships.", "Healthy boundaries protect wellbeing."),
            ],
        },
        {
            "title": "Housing",
            "iconName": "chat",
            "words": [
                ("mortgage", "/ˈmɔːrɡɪdʒ/", "noun", "A loan to buy property.", "They applied for a mortgage."),
                ("tenant", "/ˈtɛnənt/", "noun", "A person who rents a home.", "The tenant signed a one-year lease."),
                ("renovation", "/ˌrɛnəˈveɪʃən/", "noun", "Work to improve a building.", "Renovation took three months."),
                ("landlord", "/ˈlændlɔːrd/", "noun", "A person who owns rented property.", "The landlord fixed the heater."),
                ("affordable", "/əˈfɔːrdəbəl/", "adjective", "Not too expensive.", "Affordable housing is scarce."),
            ],
        },
        {
            "title": "Law and Rights",
            "iconName": "chat",
            "words": [
                ("justice", "/ˈdʒʌstɪs/", "noun", "Fair treatment under the law.", "Everyone deserves justice."),
                ("verdict", "/ˈvɜːrdɪkt/", "noun", "A decision in court.", "The jury reached a verdict."),
                ("witness", "/ˈwɪtnəs/", "noun", "A person who saw an event.", "The witness testified in court."),
                ("rights", "/raɪts/", "noun", "Legal or moral freedoms.", "Human rights must be protected."),
                ("regulation", "/ˌrɛɡjuˈleɪʃən/", "noun", "An official rule.", "New regulations take effect Monday."),
            ],
        },
        {
            "title": "Nutrition",
            "iconName": "chat",
            "words": [
                ("nutrient", "/ˈnjuːtriənt/", "noun", "A substance needed for health.", "Vegetables provide essential nutrients."),
                ("balanced", "/ˈbælənst/", "adjective", "Including different types in good amounts.", "Eat a balanced diet."),
                ("calorie", "/ˈkæləri/", "noun", "A unit of energy in food.", "Track your daily calorie intake."),
                ("deficiency", "/dɪˈfɪʃənsi/", "noun", "A lack of something needed.", "Iron deficiency is common."),
                ("organic", "/ɔːrˈɡænɪk/", "adjective", "Produced without artificial chemicals.", "She buys organic vegetables."),
            ],
        },
        {
            "title": "Career Development",
            "iconName": "chat",
            "words": [
                ("networking", "/ˈnɛtwɜːrkɪŋ/", "noun", "Building professional contacts.", "Networking opened new opportunities."),
                ("mentorship", "/ˈmɛntɔːrʃɪp/", "noun", "Guidance from an experienced person.", "Mentorship accelerated her growth."),
                ("portfolio", "/pɔːrtˈfoʊlioʊ/", "noun", "A collection of work samples.", "Update your portfolio regularly."),
                ("resilience", "/rɪˈzɪliəns/", "noun", "Ability to recover from difficulty.", "Resilience helps during setbacks."),
                ("leadership", "/ˈliːdərʃɪp/", "noun", "The ability to guide others.", "Leadership requires clear communication."),
            ],
        },
    ],
    "c1": [
        {
            "title": "Philosophy",
            "iconName": "chat",
            "words": [
                ("ethics", "/ˈɛθɪks/", "noun", "Moral principles that guide behavior.", "Ethics shapes public debate."),
                ("paradox", "/ˈpærədɒks/", "noun", "A statement that seems contradictory.", "The paradox puzzled philosophers."),
                ("existential", "/ˌɛɡzɪˈstɛnʃəl/", "adjective", "Related to human existence.", "She raised an existential question."),
                ("rational", "/ˈræʃənəl/", "adjective", "Based on reason.", "We need a rational explanation."),
                ("ideology", "/ˌaɪdiˈɒlədʒi/", "noun", "A system of ideas.", "Ideology influenced the reform."),
            ],
        },
        {
            "title": "Economics",
            "iconName": "chat",
            "words": [
                ("inflation", "/ɪnˈfleɪʃən/", "noun", "A general rise in prices.", "Inflation reduced purchasing power."),
                ("recession", "/rɪˈsɛʃən/", "noun", "A period of economic decline.", "The recession affected employment."),
                ("fiscal", "/ˈfɪskəl/", "adjective", "Related to government revenue.", "Fiscal policy was tightened."),
                ("commodity", "/kəˈmɒdɪti/", "noun", "A basic good traded widely.", "Oil is a valuable commodity."),
                ("stimulus", "/ˈstɪmjələs/", "noun", "Government spending to boost the economy.", "The stimulus package passed quickly."),
            ],
        },
        {
            "title": "Psychology",
            "iconName": "chat",
            "words": [
                ("cognition", "/kɒɡˈnɪʃən/", "noun", "Mental processes of knowing.", "Cognition declines with age."),
                ("subconscious", "/sʌbˈkɒnʃəs/", "adjective", "Below conscious awareness.", "Subconscious fears can surface."),
                ("behavioral", "/bɪˈheɪvjərəl/", "adjective", "Related to actions and conduct.", "Behavioral therapy helped him."),
                ("motivation", "/ˌmoʊtɪˈveɪʃən/", "noun", "Reason for acting.", "Motivation drives performance."),
                ("perception", "/pərˈsɛpʃən/", "noun", "The way something is understood.", "Perception varies by culture."),
            ],
        },
        {
            "title": "Literature",
            "iconName": "chat",
            "words": [
                ("protagonist", "/proʊˈtæɡənɪst/", "noun", "The main character.", "The protagonist faces a dilemma."),
                ("metaphor", "/ˈmɛtəfər/", "noun", "A figure of speech comparing things.", "The author uses a powerful metaphor."),
                ("narrative", "/ˈnærətɪv/", "noun", "A spoken or written account.", "The narrative shifts perspective."),
                ("symbolism", "/ˈsɪmbəlɪzəm/", "noun", "Use of symbols to represent ideas.", "Symbolism enriches the poem."),
                ("satire", "/ˈsætaɪər/", "noun", "Humor criticizing society.", "The novel is sharp social satire."),
            ],
        },
        {
            "title": "Academic Writing",
            "iconName": "chat",
            "words": [
                ("thesis", "/ˈθiːsɪs/", "noun", "A central argument in writing.", "State your thesis clearly."),
                ("citation", "/saɪˈteɪʃən/", "noun", "A reference to a source.", "Include a citation for each claim."),
                ("coherence", "/koʊˈhɪərəns/", "noun", "Logical connection of ideas.", "Coherence improves readability."),
                ("methodology", "/ˌmɛθəˈdɒlədʒi/", "noun", "A system of methods used.", "Explain your methodology."),
                ("peer-reviewed", "/pɪər rɪˈvjuːd/", "adjective", "Evaluated by experts.", "Use peer-reviewed sources."),
            ],
        },
        {
            "title": "Debate",
            "iconName": "chat",
            "words": [
                ("rhetoric", "/ˈrɛtərɪk/", "noun", "The art of persuasive speaking.", "His rhetoric swayed the audience."),
                ("rebuttal", "/rɪˈbʌtəl/", "noun", "An argument against a claim.", "She offered a strong rebuttal."),
                ("contentious", "/kənˈtɛnʃəs/", "adjective", "Causing disagreement.", "It is a contentious issue."),
                ("consensus", "/kənˈsɛnsəs/", "noun", "General agreement.", "They reached a consensus."),
                ("fallacy", "/ˈfæləsi/", "noun", "A mistaken belief or argument.", "Avoid logical fallacies."),
            ],
        },
        {
            "title": "Ethics",
            "iconName": "chat",
            "words": [
                ("integrity", "/ɪnˈtɛɡrɪti/", "noun", "Honesty and strong principles.", "Integrity builds trust."),
                ("accountability", "/əˌkaʊntəˈbɪlɪti/", "noun", "Responsibility for actions.", "Leaders need accountability."),
                ("transparency", "/trænsˈpærənsi/", "noun", "Openness in actions.", "Transparency reduces suspicion."),
                ("dilemma", "/dɪˈlɛmə/", "noun", "A difficult choice.", "She faced an ethical dilemma."),
                ("whistleblower", "/ˈwɪsəlˌbloʊər/", "noun", "A person who reports wrongdoing.", "The whistleblower protected the public."),
            ],
        },
        {
            "title": "Innovation",
            "iconName": "chat",
            "words": [
                ("disruptive", "/dɪsˈrʌptɪv/", "adjective", "Causing major change in an industry.", "Disruptive technology reshaped retail."),
                ("prototype", "/ˈproʊtətaɪp/", "noun", "An early model of a product.", "They tested a working prototype."),
                ("scalable", "/ˈskeɪləbəl/", "adjective", "Able to grow efficiently.", "The platform is highly scalable."),
                ("iteration", "/ˌɪtəˈreɪʃən/", "noun", "A repeated version improving on the last.", "Each iteration fixed bugs."),
                ("automation", "/ˌɔːtəˈmeɪʃən/", "noun", "Use of machines to do work.", "Automation increased productivity."),
            ],
        },
        {
            "title": "Social Media Impact",
            "iconName": "chat",
            "words": [
                ("algorithm", "/ˈælɡərɪðəm/", "noun", "A set of rules used by software.", "The algorithm shows personalized content."),
                ("viral", "/ˈvaɪrəl/", "adjective", "Spreading rapidly online.", "The video went viral."),
                ("misinformation", "/ˌmɪsɪnfərˈmeɪʃən/", "noun", "False or inaccurate information.", "Misinformation spreads quickly."),
                ("engagement", "/ɪnˈɡeɪdʒmənt/", "noun", "Interaction with online content.", "Engagement rates rose sharply."),
                ("polarization", "/ˌpoʊlərəˈzeɪʃən/", "noun", "Division into opposing groups.", "Polarization worsened online debate."),
            ],
        },
        {
            "title": "Migration",
            "iconName": "travel",
            "words": [
                (" diaspora", "/daɪˈæspərə/", "noun", "A community living outside its homeland.", "The diaspora maintained traditions."),
                ("assimilation", "/əˌsɪmɪˈleɪʃən/", "noun", "Adopting a new culture.", "Assimilation can take generations."),
                ("xenophobia", "/ˌzɛnəˈfoʊbiə/", "noun", "Dislike of foreigners.", "Xenophobia fuels discrimination."),
                ("remittance", "/rɪˈmɪtəns/", "noun", "Money sent home by migrants.", "Remittances support families abroad."),
                ("integration", "/ˌɪntɪˈɡreɪʃən/", "noun", "Becoming part of a society.", "Integration programs help newcomers."),
            ],
        },
    ],
    "c2": [
        {
            "title": "Current Affairs",
            "iconName": "chat",
            "words": [
                ("geopolitical", "/ˌdʒiːoʊpəˈlɪtɪkəl/", "adjective", "Relating to politics and geography.", "Geopolitical tensions escalated."),
                ("sanction", "/ˈsæŋkʃən/", "noun", "A penalty imposed on a country.", "Sanctions affected trade."),
                ("diplomacy", "/dɪˈploʊməsi/", "noun", "Managing international relations.", "Diplomacy prevented conflict."),
                ("sovereignty", "/ˈsɒvrɪnti/", "noun", "Supreme authority of a state.", "Sovereignty was fiercely defended."),
                ("multilateral", "/ˌmʌltiˈlætərəl/", "adjective", "Involving many countries.", "A multilateral agreement was signed."),
            ],
        },
        {
            "title": "Climate Policy",
            "iconName": "chat",
            "words": [
                ("decarbonization", "/diːˌkɑːrbənaɪˈzeɪʃən/", "noun", "Reducing carbon emissions.", "Decarbonization requires investment."),
                ("mitigation", "/ˌmɪtɪˈɡeɪʃən/", "noun", "Action to reduce harm.", "Mitigation plans were approved."),
                ("adaptation", "/ˌædæpˈteɪʃən/", "noun", "Adjusting to new conditions.", "Coastal adaptation is urgent."),
                ("biodiversity", "/ˌbaɪoʊdaɪˈvɜːrsɪti/", "noun", "Variety of life on Earth.", "Biodiversity loss accelerates extinction."),
                ("net-zero", "/nɛt ˈzɪroʊ/", "adjective", "Balancing emissions with removal.", "The company pledged net-zero by 2040."),
            ],
        },
        {
            "title": "Medical Ethics",
            "iconName": "chat",
            "words": [
                ("autonomy", "/ɔːˈtɒnəmi/", "noun", "The right to make one's own decisions.", "Patient autonomy must be respected."),
                ("consent", "/kənˈsɛnt/", "noun", "Permission given voluntarily.", "Informed consent is required."),
                ("euthanasia", "/ˌjuːθəˈneɪʒə/", "noun", "Ending life to stop suffering.", "Euthanasia remains legally contested."),
                ("triage", "/triˈɑːʒ/", "noun", "Prioritizing patients by urgency.", "Triage saved lives during the crisis."),
                ("placebo", "/pləˈsiːboʊ/", "noun", "A treatment with no active drug.", "The placebo effect was significant."),
            ],
        },
        {
            "title": "Corporate Strategy",
            "iconName": "chat",
            "words": [
                ("acquisition", "/ˌækwɪˈzɪʃən/", "noun", "Buying another company.", "The acquisition expanded market reach."),
                ("diversification", "/daɪˌvɜːrsɪfɪˈkeɪʃən/", "noun", "Expanding into new areas.", "Diversification reduced risk."),
                ("synergy", "/ˈsɪnərdʒi/", "noun", "Combined effect greater than parts.", "The merger created synergy."),
                ("stakeholder", "/ˈsteɪkˌhoʊldər/", "noun", "A person with interest in a company.", "Stakeholders demanded transparency."),
                ("due diligence", "/djuː ˈdɪlɪdʒəns/", "noun", "Careful investigation before a deal.", "Due diligence revealed liabilities."),
            ],
        },
        {
            "title": "International Relations",
            "iconName": "travel",
            "words": [
                ("hegemony", "/hɪˈdʒɛməni/", "noun", "Dominance of one state over others.", "Regional hegemony shifted gradually."),
                ("treaty", "/ˈtriːti/", "noun", "A formal agreement between states.", "The treaty ended hostilities."),
                ("embargo", "/ɪmˈbɑːrɡoʊ/", "noun", "A ban on trade with a country.", "The embargo disrupted supply chains."),
                ("asylum", "/əˈsaɪləm/", "noun", "Protection given to refugees.", "She sought political asylum."),
                ("unilateral", "/ˌjuːnɪˈlætərəl/", "adjective", "Done by one party alone.", "The unilateral decision provoked criticism."),
            ],
        },
        {
            "title": "Cultural Identity",
            "iconName": "chat",
            "words": [
                ("cosmopolitan", "/ˌkɒzməˈpɒlɪtən/", "adjective", "Including people from many cultures.", "London is a cosmopolitan city."),
                ("assimilationist", "/əˌsɪmɪˈleɪʃənɪst/", "adjective", "Favoring cultural absorption.", "Assimilationist policies were debated."),
                ("multiculturalism", "/ˌmʌltiˈkʌltʃərəlɪzəm/", "noun", "Coexistence of diverse cultures.", "Multiculturalism enriches society."),
                ("indigenous", "/ɪnˈdɪdʒənəs/", "adjective", "Native to a place.", "Indigenous rights were recognized."),
                ("hybridity", "/haɪˈbrɪdɪti/", "noun", "Mixing of cultural elements.", "Hybridity appears in modern art."),
            ],
        },
        {
            "title": "Artificial Intelligence",
            "iconName": "chat",
            "words": [
                ("algorithmic bias", "/ˌælɡəˈrɪðmɪk ˈbaɪəs/", "noun", "Unfair outcomes from AI systems.", "Algorithmic bias must be addressed."),
                ("autonomous", "/ɔːˈtɒnəməs/", "adjective", "Operating independently.", "Autonomous vehicles are being tested."),
                ("generalization", "/ˌdʒɛnərəlɪˈzeɪʃən/", "noun", "Applying learned patterns broadly.", "Poor generalization limits the model."),
                ("interpretability", "/ɪnˌtɜːrprɪtəˈbɪlɪti/", "noun", "Ability to explain AI decisions.", "Interpretability builds user trust."),
                ("singularity", "/ˌsɪŋɡjuˈlærɪti/", "noun", "Hypothetical AI surpassing humans.", "The singularity remains speculative."),
            ],
        },
        {
            "title": "Human Rights",
            "iconName": "chat",
            "words": [
                ("jurisdiction", "/ˌdʒʊərɪsˈdɪkʃən/", "noun", "Official power to make legal decisions.", "The court lacked jurisdiction."),
                ("persecution", "/ˌpɜːrsɪˈkjuːʃən/", "noun", "Hostile treatment of a group.", "They fled religious persecution."),
                ("restitution", "/ˌrɛstɪˈtuːʃən/", "noun", "Compensation for loss or harm.", "Restitution was ordered by the court."),
                ("impunity", "/ɪmˈpjuːnɪti/", "noun", "Freedom from punishment.", "Violations occurred with impunity."),
                ("ratification", "/ˌrætɪfɪˈkeɪʃən/", "noun", "Formal approval of a treaty.", "Ratification took several years."),
            ],
        },
        {
            "title": "Globalization",
            "iconName": "chat",
            "words": [
                ("interdependence", "/ˌɪntərdɪˈpɛndəns/", "noun", "Mutual reliance between nations.", "Economic interdependence increased."),
                ("protectionism", "/prəˈtɛkʃənɪzəm/", "noun", "Shielding domestic industry from trade.", "Protectionism rose during the crisis."),
                ("outsourcing", "/ˈaʊtsɔːrsɪŋ/", "noun", "Hiring external companies for work.", "Outsourcing cut operational costs."),
                ("supply chain", "/səˈplaɪ tʃeɪn/", "noun", "The network producing and delivering goods.", "The supply chain broke down."),
                ("comparative advantage", "/kəmˈpærətɪv ədˈvæntɪdʒ/", "noun", "Ability to produce at lower cost.", "Comparative advantage drives trade."),
            ],
        },
        {
            "title": "Leadership",
            "iconName": "chat",
            "words": [
                ("visionary", "/ˈvɪʒənəri/", "adjective", "Thinking creatively about the future.", "A visionary leader inspires change."),
                ("delegation", "/ˌdɛlɪˈɡeɪʃən/", "noun", "Assigning tasks to others.", "Effective delegation empowers teams."),
                ("accountable", "/əˈkaʊntəbəl/", "adjective", "Responsible for decisions.", "Leaders must remain accountable."),
                ("charisma", "/kəˈrɪzmə/", "noun", "Compelling personal appeal.", "Her charisma united the organization."),
                ("succession", "/səkˈsɛʃən/", "noun", "The process of replacing a leader.", "Succession planning began early."),
            ],
        },
    ],
}

# Fix typo in c1 Migration diaspora entry
for entry in VOCABULARY["c1"]:
    if entry["title"] == "Migration":
        entry["words"] = [
            ("diaspora", "/daɪˈæspərə/", "noun", "A community living outside its homeland.", "The diaspora maintained traditions."),
            ("assimilation", "/əˌsɪmɪˈleɪʃən/", "noun", "Adopting a new culture.", "Assimilation can take generations."),
            ("xenophobia", "/ˌzɛnəˈfoʊbiə/", "noun", "Dislike of foreigners.", "Xenophobia fuels discrimination."),
            ("remittance", "/rɪˈmɪtəns/", "noun", "Money sent home by migrants.", "Remittances support families abroad."),
            ("integration", "/ˌɪntɪˈɡreɪʃən/", "noun", "Becoming part of a society.", "Integration programs help newcomers."),
        ]
        break


GRAMMAR: dict[str, list[dict]] = {
    "a1": [
        {
            "title": "Subject Pronouns",
            "iconName": "grammar",
            "rule": "Subject pronouns replace the name of the person or thing doing the action.",
            "pattern": "Subject + verb",
            "learnedPoints": "I, you, he, she, it, we, they",
            "examples": [
                grammar_example("I am a student.", "I"),
                grammar_example("You are my friend.", "You"),
                grammar_example("He works in a shop.", "He"),
                grammar_example("She likes music.", "She"),
                grammar_example("It is a small cat.", "It"),
                grammar_example("We live in London.", "We"),
                grammar_example("They are happy.", "They"),
            ],
            "practicePrompt": "Complete: ___ am happy.",
            "practiceAnswer": "I",
        },
        {
            "title": "To Be",
            "iconName": "grammar",
            "rule": "Use am, is, or are to describe people, places, and feelings.",
            "pattern": "Subject + am/is/are + complement",
            "examples": [
                grammar_example("I am tired.", "am"),
                grammar_example("She is a doctor.", "is"),
                grammar_example("They are at home.", "are"),
                grammar_example("It is cold today.", "is"),
                grammar_example("We are ready.", "are"),
            ],
            "practicePrompt": "Complete: She ___ a teacher.",
            "practiceAnswer": "is",
        },
        {
            "title": "Simple Present",
            "iconName": "grammar",
            "rule": "Use the simple present for habits, facts, and routines.",
            "pattern": "Subject + base verb (+ s/es for he/she/it)",
            "examples": [
                grammar_example("I drink coffee every morning.", "drink"),
                grammar_example("He plays football on Sundays.", "plays"),
                grammar_example("They work near the station.", "work"),
                grammar_example("She reads before bed.", "reads"),
                grammar_example("We speak English in class.", "speak"),
            ],
            "practicePrompt": "Complete: He ___ TV every evening.",
            "practiceAnswer": "watches",
        },
        {
            "title": "Articles",
            "iconName": "grammar",
            "rule": "Use a/an before singular countable nouns; use the for specific things.",
            "pattern": "a/an + singular noun; the + specific noun",
            "examples": [
                grammar_example("I have a cat.", "a"),
                grammar_example("She is an engineer.", "an"),
                grammar_example("The book is on the table.", "The"),
                grammar_example("He wants a new phone.", "a"),
                grammar_example("Open the window, please.", "the"),
            ],
            "practicePrompt": "Complete: I need ___ umbrella.",
            "practiceAnswer": "an",
        },
        {
            "title": "Plurals",
            "iconName": "grammar",
            "rule": "Most nouns add -s; nouns ending in -s, -sh, -ch, -x add -es.",
            "pattern": "singular noun + s/es",
            "examples": [
                grammar_example("One book, two books.", "books"),
                grammar_example("A box and three boxes.", "boxes"),
                grammar_example("She has many friends.", "friends"),
                grammar_example("The buses are late.", "buses"),
                grammar_example("These watches are expensive.", "watches"),
            ],
            "practicePrompt": "Complete: three ___ (child)",
            "practiceAnswer": "children",
        },
        {
            "title": "Possessives",
            "iconName": "grammar",
            "rule": "Possessive adjectives show who something belongs to.",
            "pattern": "my / your / his / her / its / our / their + noun",
            "examples": [
                grammar_example("This is my house.", "my"),
                grammar_example("Is that your bag?", "your"),
                grammar_example("His name is Tom.", "His"),
                grammar_example("Her phone is new.", "Her"),
                grammar_example("Their dog is friendly.", "Their"),
            ],
            "practicePrompt": "Complete: ___ name is Anna. (she)",
            "practiceAnswer": "Her",
        },
        {
            "title": "This and That",
            "iconName": "grammar",
            "rule": "Use this/these for things near you; that/those for things farther away.",
            "pattern": "this/that + singular; these/those + plural",
            "examples": [
                grammar_example("This is my pen.", "This"),
                grammar_example("That is her car.", "That"),
                grammar_example("These shoes are mine.", "These"),
                grammar_example("Those trees are old.", "Those"),
                grammar_example("Is this your key?", "this"),
            ],
            "practicePrompt": "Complete: ___ books are heavy. (near)",
            "practiceAnswer": "These",
        },
        {
            "title": "Have and Has",
            "iconName": "grammar",
            "rule": "Use have with I/you/we/they; use has with he/she/it.",
            "pattern": "Subject + have/has + object",
            "examples": [
                grammar_example("I have a bike.", "have"),
                grammar_example("She has two brothers.", "has"),
                grammar_example("We have time.", "have"),
                grammar_example("He has a meeting.", "has"),
                grammar_example("They have a small garden.", "have"),
            ],
            "practicePrompt": "Complete: He ___ a new job.",
            "practiceAnswer": "has",
        },
        {
            "title": "Can",
            "iconName": "grammar",
            "rule": "Use can to talk about ability and permission.",
            "pattern": "Subject + can + base verb",
            "examples": [
                grammar_example("I can swim.", "can"),
                grammar_example("She can speak Spanish.", "can"),
                grammar_example("Can you help me?", "Can"),
                grammar_example("We can meet tomorrow.", "can"),
                grammar_example("He can't drive yet.", "can't"),
            ],
            "practicePrompt": "Complete: They ___ play the guitar.",
            "practiceAnswer": "can",
        },
        {
            "title": "Question Words",
            "iconName": "grammar",
            "rule": "Question words start information questions.",
            "pattern": "Question word + auxiliary + subject + verb",
            "examples": [
                grammar_example("What is your name?", "What"),
                grammar_example("Where do you live?", "Where"),
                grammar_example("When does the shop open?", "When"),
                grammar_example("Who is your teacher?", "Who"),
                grammar_example("How old are you?", "How"),
            ],
            "practicePrompt": "Complete: ___ is your phone number?",
            "practiceAnswer": "What",
        },
    ],
    "a2": [
        {
            "title": "Past Simple",
            "iconName": "grammar",
            "rule": "Use the past simple for completed actions in the past.",
            "pattern": "Subject + past verb (+ed or irregular)",
            "examples": [
                grammar_example("I visited Paris last year.", "visited"),
                grammar_example("She didn't go to work.", "didn't"),
                grammar_example("Did you see the film?", "Did"),
                grammar_example("They arrived late.", "arrived"),
                grammar_example("He bought a new coat.", "bought"),
            ],
            "practicePrompt": "Complete: We ___ (walk) to school yesterday.",
            "practiceAnswer": "walked",
        },
        {
            "title": "Past Continuous",
            "iconName": "grammar",
            "rule": "Use the past continuous for actions in progress at a past time.",
            "pattern": "Subject + was/were + verb-ing",
            "examples": [
                grammar_example("I was reading at eight.", "was reading"),
                grammar_example("They were watching TV.", "were watching"),
                grammar_example("Was she working?", "Was"),
                grammar_example("It was raining all morning.", "was raining"),
                grammar_example("We weren't sleeping.", "weren't sleeping"),
            ],
            "practicePrompt": "Complete: He ___ (study) when I called.",
            "practiceAnswer": "was studying",
        },
        {
            "title": "Future with Will",
            "iconName": "grammar",
            "rule": "Use will for predictions, promises, and instant decisions.",
            "pattern": "Subject + will + base verb",
            "examples": [
                grammar_example("I will call you later.", "will"),
                grammar_example("It will rain tomorrow.", "will"),
                grammar_example("She won't be late.", "won't"),
                grammar_example("Will they join us?", "Will"),
                grammar_example("I'll help you.", "I'll"),
            ],
            "practicePrompt": "Complete: I think it ___ be sunny.",
            "practiceAnswer": "will",
        },
        {
            "title": "Going To",
            "iconName": "grammar",
            "rule": "Use going to for plans and evidence-based predictions.",
            "pattern": "Subject + am/is/are + going to + base verb",
            "examples": [
                grammar_example("We are going to travel in June.", "going to"),
                grammar_example("She is going to study medicine.", "going to"),
                grammar_example("They aren't going to wait.", "going to"),
                grammar_example("Is he going to move?", "going to"),
                grammar_example("Look at those clouds—it is going to rain.", "going to"),
            ],
            "practicePrompt": "Complete: I ___ visit my parents this weekend.",
            "practiceAnswer": "am going to",
        },
        {
            "title": "Comparatives and Superlatives",
            "iconName": "grammar",
            "rule": "Comparatives compare two things; superlatives show the highest degree.",
            "pattern": "adj-er / more + adj; the adj-est / the most + adj",
            "examples": [
                grammar_example("This room is bigger than that one.", "bigger"),
                grammar_example("She is more careful than him.", "more careful"),
                grammar_example("It is the cheapest option.", "cheapest"),
                grammar_example("He is the most talented singer.", "most talented"),
                grammar_example("Today is worse than yesterday.", "worse"),
            ],
            "practicePrompt": "Complete: Mount Everest is the ___ mountain in the world.",
            "practiceAnswer": "highest",
        },
        {
            "title": "Adverbs of Frequency",
            "iconName": "grammar",
            "rule": "Adverbs of frequency show how often something happens.",
            "pattern": "Subject + adverb + verb (or verb + adverb)",
            "examples": [
                grammar_example("I always brush my teeth.", "always"),
                grammar_example("She usually takes the bus.", "usually"),
                grammar_example("We sometimes eat out.", "sometimes"),
                grammar_example("He rarely watches TV.", "rarely"),
                grammar_example("They never arrive early.", "never"),
            ],
            "practicePrompt": "Complete: I ___ go to the gym on Mondays. (often)",
            "practiceAnswer": "often",
        },
        {
            "title": "Countable and Uncountable",
            "iconName": "grammar",
            "rule": "Countable nouns have singular/plural forms; uncountable nouns do not.",
            "pattern": "a/an + countable; some/much + uncountable",
            "examples": [
                grammar_example("I bought an apple.", "an apple"),
                grammar_example("There is some milk in the fridge.", "some milk"),
                grammar_example("How many chairs do we need?", "many"),
                grammar_example("How much sugar do you want?", "much"),
                grammar_example("She has three books.", "three books"),
            ],
            "practicePrompt": "Complete: There isn't ___ water left.",
            "practiceAnswer": "much",
        },
        {
            "title": "Some and Any",
            "iconName": "grammar",
            "rule": "Use some in positive sentences; any in questions and negatives.",
            "pattern": "some/any + noun",
            "examples": [
                grammar_example("I have some friends here.", "some"),
                grammar_example("Do you have any questions?", "any"),
                grammar_example("There aren't any tickets left.", "any"),
                grammar_example("She bought some bread.", "some"),
                grammar_example("Is there any coffee?", "any"),
            ],
            "practicePrompt": "Complete: We don't have ___ time.",
            "practiceAnswer": "any",
        },
        {
            "title": "Prepositions of Time",
            "iconName": "grammar",
            "rule": "Use in for months/years, on for days/dates, at for times.",
            "pattern": "in / on / at + time expression",
            "examples": [
                grammar_example("The meeting is on Monday.", "on"),
                grammar_example("She was born in 1998.", "in"),
                grammar_example("We eat lunch at noon.", "at"),
                grammar_example("I travel in summer.", "in"),
                grammar_example("The party is on July 4th.", "on"),
            ],
            "practicePrompt": "Complete: The train leaves ___ 7:30.",
            "practiceAnswer": "at",
        },
        {
            "title": "Should and Must",
            "iconName": "grammar",
            "rule": "Should gives advice; must shows strong obligation.",
            "pattern": "Subject + should/must + base verb",
            "examples": [
                grammar_example("You should see a doctor.", "should"),
                grammar_example("Students must wear uniforms.", "must"),
                grammar_example("He shouldn't eat so much sugar.", "shouldn't"),
                grammar_example("You mustn't smoke here.", "mustn't"),
                grammar_example("We should leave early.", "should"),
            ],
            "practicePrompt": "Complete: You ___ drink more water.",
            "practiceAnswer": "should",
        },
    ],
    "b1": [
        {
            "title": "Present Perfect",
            "iconName": "grammar",
            "rule": "Use the present perfect for past actions connected to now.",
            "pattern": "Subject + have/has + past participle",
            "examples": [
                grammar_example("I have finished my homework.", "have finished"),
                grammar_example("She has lived here for five years.", "has lived"),
                grammar_example("Have you ever been to Japan?", "Have"),
                grammar_example("They haven't replied yet.", "haven't replied"),
                grammar_example("We have just arrived.", "have just arrived"),
            ],
            "practicePrompt": "Complete: He ___ (see) that movie twice.",
            "practiceAnswer": "has seen",
        },
        {
            "title": "Past Perfect",
            "iconName": "grammar",
            "rule": "Use the past perfect for an action before another past action.",
            "pattern": "Subject + had + past participle",
            "examples": [
                grammar_example("I had eaten before the meeting.", "had eaten"),
                grammar_example("She had left when I arrived.", "had left"),
                grammar_example("Had they finished the report?", "Had"),
                grammar_example("We hadn't met before.", "hadn't met"),
                grammar_example("He realized he had forgotten his wallet.", "had forgotten"),
            ],
            "practicePrompt": "Complete: By 6 p.m., they ___ (close) the shop.",
            "practiceAnswer": "had closed",
        },
        {
            "title": "First Conditional",
            "iconName": "grammar",
            "rule": "Use the first conditional for real future possibilities.",
            "pattern": "If + present simple, will + base verb",
            "examples": [
                grammar_example("If it rains, we will stay home.", "will stay"),
                grammar_example("If you study, you will pass.", "will pass"),
                grammar_example("She will call if she has time.", "will call"),
                grammar_example("If they arrive early, we'll start sooner.", "we'll start"),
                grammar_example("If I see him, I'll tell him.", "I'll tell"),
            ],
            "practicePrompt": "Complete: If you ___ (help) me, I will finish faster.",
            "practiceAnswer": "help",
        },
        {
            "title": "Second Conditional",
            "iconName": "grammar",
            "rule": "Use the second conditional for unreal or unlikely situations.",
            "pattern": "If + past simple, would + base verb",
            "examples": [
                grammar_example("If I had money, I would travel.", "would travel"),
                grammar_example("If she knew, she would help.", "would help"),
                grammar_example("Would you move if you could?", "Would"),
                grammar_example("If we lived near the sea, we would swim daily.", "would swim"),
                grammar_example("He wouldn't buy it if it were expensive.", "wouldn't buy"),
            ],
            "practicePrompt": "Complete: If I ___ (be) you, I would apologize.",
            "practiceAnswer": "were",
        },
        {
            "title": "Passive Voice Intro",
            "iconName": "grammar",
            "rule": "The passive focuses on the action or object, not the doer.",
            "pattern": "Subject + be + past participle (+ by agent)",
            "examples": [
                grammar_example("The letter was sent yesterday.", "was sent"),
                grammar_example("English is spoken worldwide.", "is spoken"),
                grammar_example("The cake was made by Anna.", "was made"),
                grammar_example("These phones are made in Korea.", "are made"),
                grammar_example("The window was broken.", "was broken"),
            ],
            "practicePrompt": "Complete: The book ___ (write) in 1990.",
            "practiceAnswer": "was written",
        },
        {
            "title": "Relative Clauses",
            "iconName": "grammar",
            "rule": "Relative clauses give extra information about a noun.",
            "pattern": "noun + who/which/that + clause",
            "examples": [
                grammar_example("The man who called is my uncle.", "who"),
                grammar_example("This is the book that I recommended.", "that"),
                grammar_example("She met a friend who lives abroad.", "who"),
                grammar_example("The restaurant which we tried was excellent.", "which"),
                grammar_example("People who exercise regularly feel better.", "who"),
            ],
            "practicePrompt": "Complete: The woman ___ lives next door is a nurse.",
            "practiceAnswer": "who",
        },
        {
            "title": "Reported Speech Intro",
            "iconName": "grammar",
            "rule": "Reported speech tells what someone said without exact words.",
            "pattern": "Subject + said/told + (that) + clause (tense shift)",
            "examples": [
                grammar_example("She said she was tired.", "was"),
                grammar_example("He told me he would come.", "would come"),
                grammar_example("They said they had finished.", "had finished"),
                grammar_example("Anna said she liked the film.", "liked"),
                grammar_example("He told us not to wait.", "not to wait"),
            ],
            "practicePrompt": "Complete: Tom said he ___ (can) help us.",
            "practiceAnswer": "could",
        },
        {
            "title": "Modals of Deduction",
            "iconName": "grammar",
            "rule": "Use must, might, and can't to express logical conclusions.",
            "pattern": "Subject + must/might/can't + base verb",
            "examples": [
                grammar_example("She must be at work.", "must be"),
                grammar_example("It might rain later.", "might"),
                grammar_example("He can't be serious.", "can't be"),
                grammar_example("They must have left early.", "must have left"),
                grammar_example("This might be the wrong address.", "might be"),
            ],
            "practicePrompt": "Complete: You ___ be hungry after that walk.",
            "practiceAnswer": "must",
        },
        {
            "title": "Phrasal Verbs 1",
            "iconName": "grammar",
            "rule": "Phrasal verbs combine a verb with a particle.",
            "pattern": "verb + particle (look up, give up, turn on)",
            "examples": [
                grammar_example("Please turn off the lights.", "turn off"),
                grammar_example("I need to look up this word.", "look up"),
                grammar_example("Don't give up!", "give up"),
                grammar_example("She picked up the phone.", "picked up"),
                grammar_example("He ran into an old friend.", "ran into"),
            ],
            "practicePrompt": "Complete: Can you ___ the TV, please?",
            "practiceAnswer": "turn on",
        },
        {
            "title": "Gerunds and Infinitives",
            "iconName": "grammar",
            "rule": "Some verbs are followed by -ing; others by to + verb.",
            "pattern": "verb + gerund / verb + to-infinitive",
            "examples": [
                grammar_example("I enjoy reading.", "reading"),
                grammar_example("She decided to leave.", "to leave"),
                grammar_example("He stopped smoking.", "smoking"),
                grammar_example("They hope to travel soon.", "to travel"),
                grammar_example("I avoid eating late at night.", "eating"),
            ],
            "practicePrompt": "Complete: He promised ___ (call) me.",
            "practiceAnswer": "to call",
        },
    ],
    "b2": [
        {
            "title": "Third Conditional",
            "iconName": "grammar",
            "rule": "Use the third conditional for unreal past situations.",
            "pattern": "If + past perfect, would have + past participle",
            "examples": [
                grammar_example("If I had known, I would have helped.", "would have helped"),
                grammar_example("She would have passed if she had studied.", "would have passed"),
                grammar_example("If they had left earlier, they wouldn't have missed the train.", "wouldn't have missed"),
                grammar_example("Would you have come if you had been invited?", "Would you have come"),
                grammar_example("We would have won with a stronger team.", "would have won"),
            ],
            "practicePrompt": "Complete: If we ___ (leave) earlier, we would have arrived on time.",
            "practiceAnswer": "had left",
        },
        {
            "title": "Mixed Conditionals",
            "iconName": "grammar",
            "rule": "Mixed conditionals combine different time references.",
            "pattern": "If + past perfect, would + base verb (or reverse)",
            "examples": [
                grammar_example("If I had studied law, I would be a lawyer now.", "would be"),
                grammar_example("If she were more confident, she would have spoken up.", "would have spoken"),
                grammar_example("If they hadn't moved, we would still be neighbors.", "would still be"),
                grammar_example("If he were here, he would have fixed it.", "would have fixed"),
                grammar_example("If I had taken that job, I would live abroad.", "would live"),
            ],
            "practicePrompt": "Complete: If I ___ (learn) Spanish, I would travel more in Latin America.",
            "practiceAnswer": "had learned",
        },
        {
            "title": "Passive All Tenses",
            "iconName": "grammar",
            "rule": "Passive forms exist in all major tenses.",
            "pattern": "be (in tense) + past participle",
            "examples": [
                grammar_example("The report is being written.", "is being written"),
                grammar_example("The bridge was built in 1920.", "was built"),
                grammar_example("The results have been published.", "have been published"),
                grammar_example("The issue will be discussed tomorrow.", "will be discussed"),
                grammar_example("The files had been deleted.", "had been deleted"),
            ],
            "practicePrompt": "Complete: A new hospital ___ (build) next year.",
            "practiceAnswer": "will be built",
        },
        {
            "title": "Advanced Modals",
            "iconName": "grammar",
            "rule": "Modals can express degrees of certainty, obligation, and criticism.",
            "pattern": "modal + have + past participle / modal + base verb",
            "examples": [
                grammar_example("You should have told me earlier.", "should have told"),
                grammar_example("He might have forgotten.", "might have forgotten"),
                grammar_example("She needn't have waited.", "needn't have waited"),
                grammar_example("They could have tried harder.", "could have tried"),
                grammar_example("You must not have heard the news.", "must not have heard"),
            ],
            "practicePrompt": "Complete: I ___ (should / call) you yesterday. Sorry!",
            "practiceAnswer": "should have called",
        },
        {
            "title": "Subjunctive",
            "iconName": "grammar",
            "rule": "The subjunctive appears after certain verbs and fixed expressions.",
            "pattern": "It is essential that + subject + base verb",
            "examples": [
                grammar_example("I suggest that he be present.", "be"),
                grammar_example("It is vital that she arrive on time.", "arrive"),
                grammar_example("They insisted that we stay.", "stay"),
                grammar_example("It is important that he not leave early.", "not leave"),
                grammar_example("We recommend that the plan be revised.", "be revised"),
            ],
            "practicePrompt": "Complete: It is crucial that everyone ___ (be) informed.",
            "practiceAnswer": "be",
        },
        {
            "title": "Cleft Sentences",
            "iconName": "grammar",
            "rule": "Cleft sentences emphasize one part of a sentence.",
            "pattern": "It is/was + focus + that/who + clause",
            "examples": [
                grammar_example("It was John who called.", "who"),
                grammar_example("It is today that we must decide.", "that"),
                grammar_example("It was in Paris that they met.", "that"),
                grammar_example("It is honesty that matters most.", "that"),
                grammar_example("It was because of rain that we canceled.", "that"),
            ],
            "practicePrompt": "Complete: It was Maria ___ solved the problem.",
            "practiceAnswer": "who",
        },
        {
            "title": "Inversion",
            "iconName": "grammar",
            "rule": "Inversion adds emphasis in formal English.",
            "pattern": "Negative adverb + auxiliary + subject + verb",
            "examples": [
                grammar_example("Never have I seen such talent.", "have I"),
                grammar_example("Rarely do we get complaints.", "do we"),
                grammar_example("Not only did she win, she broke the record.", "did she"),
                grammar_example("Seldom had he felt so nervous.", "had he"),
                grammar_example("Only then did I understand.", "did I"),
            ],
            "practicePrompt": "Complete: Never ___ I heard such nonsense.",
            "practiceAnswer": "have",
        },
        {
            "title": "Discourse Markers",
            "iconName": "grammar",
            "rule": "Discourse markers connect ideas in speech and writing.",
            "pattern": "marker + clause (however, therefore, moreover)",
            "examples": [
                grammar_example("However, the results were inconclusive.", "However"),
                grammar_example("Therefore, we changed our approach.", "Therefore"),
                grammar_example("Moreover, costs increased sharply.", "Moreover"),
                grammar_example("On the other hand, quality improved.", "On the other hand"),
                grammar_example("Nevertheless, the project continued.", "Nevertheless"),
            ],
            "practicePrompt": "Complete: ___, we need more data before deciding.",
            "practiceAnswer": "Therefore",
        },
        {
            "title": "Nominalization",
            "iconName": "grammar",
            "rule": "Nominalization turns verbs/adjectives into nouns for formal style.",
            "pattern": "verb/adjective → noun (develop → development)",
            "examples": [
                grammar_example("The development of the plan took months.", "development"),
                grammar_example("There was a significant improvement.", "improvement"),
                grammar_example("Their analysis was thorough.", "analysis"),
                grammar_example("The government's decision surprised many.", "decision"),
                grammar_example("Failure to comply may lead to fines.", "Failure"),
            ],
            "practicePrompt": "Complete: The ___ (implement) of the policy starts Monday.",
            "practiceAnswer": "implementation",
        },
        {
            "title": "Ellipsis",
            "iconName": "grammar",
            "rule": "Ellipsis omits words when the meaning remains clear.",
            "pattern": "Omit repeated words in parallel structures",
            "examples": [
                grammar_example("She can swim and he can too.", "can too"),
                grammar_example("I wanted to leave, but couldn't.", "couldn't"),
                grammar_example("Some students passed; others didn't.", "didn't"),
                grammar_example("He likes coffee and she tea.", "she tea"),
                grammar_example("If possible, call me.", "If possible"),
            ],
            "practicePrompt": "Complete: A: Will you join us? B: I'd love ___.",
            "practiceAnswer": "to",
        },
    ],
    "c1": [
        {
            "title": "Advanced Passive",
            "iconName": "grammar",
            "rule": "Advanced passive includes reporting verbs and complex agents.",
            "pattern": "It is said/believed/reported that... / subject + is said to...",
            "examples": [
                grammar_example("The policy is believed to be effective.", "is believed to be"),
                grammar_example("It is reported that prices will rise.", "It is reported"),
                grammar_example("He is said to have resigned.", "is said to have resigned"),
                grammar_example("The site was being monitored closely.", "was being monitored"),
                grammar_example("The issue has long been debated.", "has long been debated"),
            ],
            "practicePrompt": "Complete: The CEO ___ (say) to be planning a merger.",
            "practiceAnswer": "is said",
        },
        {
            "title": "Subjunctive Mood",
            "iconName": "grammar",
            "rule": "The subjunctive expresses hypothetical or formal demands.",
            "pattern": "If I were... / lest + subject + base verb",
            "examples": [
                grammar_example("If I were in charge, I'd reform the system.", "were"),
                grammar_example("He speaks as if he were an expert.", "were"),
                grammar_example("Lest we forget, the deadline is Friday.", "forget"),
                grammar_example("Suppose she were offered the role.", "were"),
                grammar_example("If it were not for your help, we'd fail.", "were"),
            ],
            "practicePrompt": "Complete: If he ___ (be) more cautious, the error would not have occurred.",
            "practiceAnswer": "had been",
        },
        {
            "title": "Fronting",
            "iconName": "grammar",
            "rule": "Fronting moves an element to the start for emphasis.",
            "pattern": "Focused element + clause",
            "examples": [
                grammar_example("This problem we cannot ignore.", "This problem"),
                grammar_example("Such was the demand that stocks ran out.", "Such"),
                grammar_example("More important is long-term stability.", "More important"),
                grammar_example("Into the room walked the director.", "Into the room"),
                grammar_example("Particularly striking was her confidence.", "Particularly striking"),
            ],
            "practicePrompt": "Complete: ___ I cannot accept.",
            "practiceAnswer": "Such behavior",
        },
        {
            "title": "Hedging Language",
            "iconName": "grammar",
            "rule": "Hedging softens claims in academic and professional contexts.",
            "pattern": "modal/adverb + tentative verb (may, tend to, appear to)",
            "examples": [
                grammar_example("The data suggest a possible link.", "suggest"),
                grammar_example("This may indicate a trend.", "may indicate"),
                grammar_example("Results appear to support the theory.", "appear to support"),
                grammar_example("It seems likely that costs will rise.", "seems likely"),
                grammar_example("The effect tends to be temporary.", "tends to be"),
            ],
            "practicePrompt": "Complete: The findings ___ (appear) to confirm earlier research.",
            "practiceAnswer": "appear",
        },
        {
            "title": "Cohesion Devices",
            "iconName": "grammar",
            "rule": "Cohesive devices link sentences into unified text.",
            "pattern": "reference, substitution, conjunction, lexical chains",
            "examples": [
                grammar_example("The proposal was rejected. This outcome surprised many.", "This"),
                grammar_example("Some agreed; others did not.", "others"),
                grammar_example("First, we analyzed the data. Then, we interpreted it.", "Then"),
                grammar_example("The policy changed. Consequently, funding increased.", "Consequently"),
                grammar_example("Renewable energy remains a key theme throughout.", "theme"),
            ],
            "practicePrompt": "Complete: The committee reviewed the plan. ___, it approved minor revisions.",
            "practiceAnswer": "Subsequently",
        },
        {
            "title": "Register Shift",
            "iconName": "grammar",
            "rule": "Register shifts adjust language for audience and context.",
            "pattern": "formal ↔ informal vocabulary and syntax",
            "examples": [
                grammar_example("Formal: We regret the inconvenience.", "regret"),
                grammar_example("Informal: Sorry about the hassle.", "Sorry"),
                grammar_example("Formal: Kindly submit the form.", "Kindly submit"),
                grammar_example("Informal: Send me the form.", "Send me"),
                grammar_example("Formal: The matter will be investigated.", "will be investigated"),
            ],
            "practicePrompt": "Complete: Rewrite formally: 'We can't help right now.' → 'We ___ unable to assist at present.'",
            "practiceAnswer": "are",
        },
        {
            "title": "Ellipsis and Substitution",
            "iconName": "grammar",
            "rule": "Substitution replaces phrases; ellipsis removes them.",
            "pattern": "do so / one / ones / auxiliary ellipsis",
            "examples": [
                grammar_example("She finished early and he did too.", "did too"),
                grammar_example("I prefer the blue one.", "one"),
                grammar_example("They can help if you want them to.", "to"),
                grammar_example("A: Will it rain? B: I hope not.", "not"),
                grammar_example("She runs faster than he does.", "does"),
            ],
            "practicePrompt": "Complete: I asked him to call, but he forgot ___.",
            "practiceAnswer": "to",
        },
        {
            "title": "Complex Noun Phrases",
            "iconName": "grammar",
            "rule": "Complex noun phrases pack information densely.",
            "pattern": "pre-modifiers + head noun + post-modifiers",
            "examples": [
                grammar_example("The recently published research findings", "recently published research findings"),
                grammar_example("A highly controversial policy decision", "highly controversial policy decision"),
                grammar_example("The government's long-term economic strategy", "long-term economic strategy"),
                grammar_example("An unexpectedly strong quarterly performance", "unexpectedly strong quarterly performance"),
                grammar_example("The rapidly evolving technological landscape", "rapidly evolving technological landscape"),
            ],
            "practicePrompt": "Complete: The ___ (recent / market / analysis) shows growth.",
            "practiceAnswer": "recent market analysis",
        },
        {
            "title": "Distancing",
            "iconName": "grammar",
            "rule": "Distancing language creates objectivity or politeness.",
            "pattern": "It appears/seems + that / past forms for present",
            "examples": [
                grammar_example("It would seem that the plan is viable.", "would seem"),
                grammar_example("I was wondering if you could help.", "was wondering"),
                grammar_example("It appears that demand has fallen.", "appears"),
                grammar_example("Could I ask whether you'd reconsider?", "Could I ask"),
                grammar_example("One might argue that the policy failed.", "might argue"),
            ],
            "practicePrompt": "Complete: I ___ (wonder) if you had time to review this.",
            "practiceAnswer": "was wondering",
        },
        {
            "title": "Rhetorical Devices",
            "iconName": "grammar",
            "rule": "Rhetorical devices persuade and emphasize in advanced discourse.",
            "pattern": "anaphora, antithesis, rhetorical questions",
            "examples": [
                grammar_example("We want change. We want justice. We want progress.", "We want"),
                grammar_example("It was not failure, but preparation.", "not failure, but preparation"),
                grammar_example("Who could deny the urgency?", "Who could deny"),
                grammar_example("Ask not what your country can do for you.", "Ask not"),
                grammar_example("To err is human; to forgive, divine.", "To err is human"),
            ],
            "practicePrompt": "Complete: A rhetorical question expects ___ answer.",
            "practiceAnswer": "no",
        },
    ],
    "c2": [
        {
            "title": "Subtle Modals",
            "iconName": "grammar",
            "rule": "At C2, modals convey nuance, criticism, and probability.",
            "pattern": "modal + perfect/progressive + subtle meaning",
            "examples": [
                grammar_example("You might have been more diplomatic.", "might have been"),
                grammar_example("She couldn't have known the outcome.", "couldn't have known"),
                grammar_example("He would rather have remained silent.", "would rather have remained"),
                grammar_example("They needn't have apologized so profusely.", "needn't have apologized"),
                grammar_example("That will have been his final decision.", "will have been"),
            ],
            "practicePrompt": "Complete: You ___ (might / consider) the ethical implications more carefully.",
            "practiceAnswer": "might have considered",
        },
        {
            "title": "Mixed Conditionals Advanced",
            "iconName": "grammar",
            "rule": "Advanced mixed conditionals blend time frames with nuanced meaning.",
            "pattern": "If + past perfect, would + base verb (present result)",
            "examples": [
                grammar_example("If they had invested earlier, they would be wealthy now.", "would be"),
                grammar_example("If I had listened, I wouldn't be in this situation.", "wouldn't be"),
                grammar_example("If she had trained harder, she would hold the record.", "would hold"),
                grammar_example("If the law had passed, we would face fewer risks today.", "would face"),
                grammar_example("If he hadn't emigrated, he would still live here.", "would still live"),
            ],
            "practicePrompt": "Complete: If we ___ (adopt) the policy sooner, outcomes would differ today.",
            "practiceAnswer": "had adopted",
        },
        {
            "title": "Inversion for Emphasis",
            "iconName": "grammar",
            "rule": "Inversion under negative or restrictive adverbs adds dramatic emphasis.",
            "pattern": "Under no circumstances / Little / So + inversion",
            "examples": [
                grammar_example("Under no circumstances should data be shared.", "should data be"),
                grammar_example("Little did they know what awaited.", "did they know"),
                grammar_example("So intense was the debate that talks paused.", "was the debate"),
                grammar_example("Not for a moment did I believe him.", "did I believe"),
                grammar_example("Hardly had we arrived when it began to snow.", "had we arrived"),
            ],
            "practicePrompt": "Complete: Rarely ___ such a compelling argument presented.",
            "practiceAnswer": "has",
        },
        {
            "title": "Cleft and Pseudo-cleft",
            "iconName": "grammar",
            "rule": "Pseudo-cleft sentences (what-clauses) highlight information.",
            "pattern": "What + clause + be + focus",
            "examples": [
                grammar_example("What we need is clearer communication.", "What we need is"),
                grammar_example("What surprised me was his calm response.", "What surprised me was"),
                grammar_example("It was the timing that caused problems.", "the timing"),
                grammar_example("What they did was unacceptable.", "What they did was"),
                grammar_example("All I want is a fair hearing.", "All I want is"),
            ],
            "practicePrompt": "Complete: ___ matters most is transparency.",
            "practiceAnswer": "What",
        },
        {
            "title": "Nominal Style",
            "iconName": "grammar",
            "rule": "Nominal style favors nouns over verbs in formal writing.",
            "pattern": "verb → nominal phrase (conduct an analysis)",
            "examples": [
                grammar_example("We conducted an analysis of the data.", "conducted an analysis"),
                grammar_example("There was a deterioration in relations.", "deterioration"),
                grammar_example("The implementation of reforms proceeded slowly.", "implementation"),
                grammar_example("They expressed disagreement with the proposal.", "disagreement"),
                grammar_example("The accumulation of evidence was decisive.", "accumulation"),
            ],
            "practicePrompt": "Complete: The ___ (evaluate) of the program took six months.",
            "practiceAnswer": "evaluation",
        },
        {
            "title": "Ellipsis Advanced",
            "iconName": "grammar",
            "rule": "Advanced ellipsis removes clauses while preserving precise meaning.",
            "pattern": "gapping, stripping, sluicing",
            "examples": [
                grammar_example("Some supported the plan, others opposed.", "others opposed"),
                grammar_example("He will resign, though reluctantly.", "though reluctantly"),
                grammar_example("She said she would call, but didn't.", "didn't"),
                grammar_example("Who called? — John.", "John"),
                grammar_example("If not now, when?", "If not now"),
            ],
            "practicePrompt": "Complete: A: Finished the report? B: Not yet, but I will ___.",
            "practiceAnswer": "soon",
        },
        {
            "title": "Fronting and Topicalization",
            "iconName": "grammar",
            "rule": "Topicalization places the topic first for focus and flow.",
            "pattern": "Topic + comment structure",
            "examples": [
                grammar_example("This issue, we must address immediately.", "This issue"),
                grammar_example("No greater challenge exists today.", "No greater challenge"),
                grammar_example("Such proposals rarely succeed.", "Such proposals"),
                grammar_example("The report you requested, I have attached.", "The report you requested"),
                grammar_example("Only with cooperation can progress occur.", "Only with cooperation"),
            ],
            "practicePrompt": "Complete: This proposal, the board ___ (reject) unanimously.",
            "practiceAnswer": "rejected",
        },
        {
            "title": "Discourse Structure",
            "iconName": "grammar",
            "rule": "Advanced texts organize argument through clear macro-structure.",
            "pattern": "thesis → development → counterargument → conclusion",
            "examples": [
                grammar_example("To begin with, the premise requires scrutiny.", "To begin with"),
                grammar_example("Having established that, we turn to implications.", "Having established that"),
                grammar_example("Admittedly, the evidence is incomplete.", "Admittedly"),
                grammar_example("By contrast, alternative models perform better.", "By contrast"),
                grammar_example("In conclusion, reform remains necessary.", "In conclusion"),
            ],
            "practicePrompt": "Complete: ___, the evidence supports cautious optimism.",
            "practiceAnswer": "On balance",
        },
        {
            "title": "Register and Tone",
            "iconName": "grammar",
            "rule": "C2 writers control tone: neutral, critical, diplomatic, or ironic.",
            "pattern": "lexical choice + syntactic control",
            "examples": [
                grammar_example("The proposal is, to put it mildly, ambitious.", "to put it mildly"),
                grammar_example("I am compelled to dissent from this view.", "compelled to dissent"),
                grammar_example("The claim is not entirely unfounded.", "not entirely unfounded"),
                grammar_example("With respect, that argument overlooks key facts.", "With respect"),
                grammar_example("The outcome was predictable, if disappointing.", "if disappointing"),
            ],
            "practicePrompt": "Complete: Diplomatic tone: 'You're wrong.' → 'I ___ a different interpretation.'",
            "practiceAnswer": "favor",
        },
        {
            "title": "Precision in Modality",
            "iconName": "grammar",
            "rule": "Precise modality distinguishes certainty, obligation, and permission finely.",
            "pattern": "modal + adverb + context-sensitive meaning",
            "examples": [
                grammar_example("The results must surely influence policy.", "must surely"),
                grammar_example("You may well be right.", "may well be"),
                grammar_example("They ought to have disclosed the conflict.", "ought to have disclosed"),
                grammar_example("That cannot possibly be accurate.", "cannot possibly be"),
                grammar_example("We would ordinarily expect compliance.", "would ordinarily expect"),
            ],
            "practicePrompt": "Complete: The data ___ (would / appear) to corroborate the hypothesis.",
            "practiceAnswer": "would appear",
        },
    ],
}


READING: dict[str, list[dict]] = {
    "a1": [
        {
            "title": "Meeting Someone",
            "iconName": "chat",
            "contentType": "dialogue",
            "passage": [
                reading_line("Anna", "Hello! My name is Anna."),
                reading_line("Ben", "Hi Anna. I am Ben.", is_user=True),
                reading_line("Anna", "Nice to meet you, Ben."),
                reading_line("Ben", "Nice to meet you too.", is_user=True),
            ],
            "questions": [
                mcq("What is the woman's name?", ["Anna", "Ben", "Tom"], 0),
                mcq("How does Ben feel about meeting Anna?", ["Angry", "Happy", "Sad"], 1),
            ],
        },
        {
            "title": "My Family",
            "iconName": "chat",
            "contentType": "text",
            "passage": [
                reading_line("", "I have a small family. My mother is a nurse. My father is a teacher. I have one sister. Her name is Lily. We live in a small house."),
            ],
            "questions": [
                mcq("What is the father's job?", ["Doctor", "Teacher", "Driver"], 1),
                mcq("How many sisters does the writer have?", ["One", "Two", "Three"], 0),
            ],
        },
        {
            "title": "At Café",
            "iconName": "chat",
            "contentType": "dialogue",
            "passage": [
                reading_line("Waiter", "Good morning. What would you like?"),
                reading_line("Customer", "A coffee and a sandwich, please.", is_user=True),
                reading_line("Waiter", "Small or large coffee?"),
                reading_line("Customer", "Small, please.", is_user=True),
            ],
            "questions": [
                mcq("Where are they?", ["At a café", "At school", "At home"], 0),
                mcq("What size coffee does the customer want?", ["Large", "Small", "Medium"], 1),
            ],
        },
        {
            "title": "Daily Routine",
            "iconName": "chat",
            "contentType": "text",
            "passage": [
                reading_line("", "I wake up at seven o'clock. I eat breakfast and go to work at eight. I finish work at five. In the evening, I read a book and go to bed at ten."),
            ],
            "questions": [
                mcq("What time does the person wake up?", ["Six", "Seven", "Eight"], 1),
                mcq("What does the person do in the evening?", ["Swims", "Reads", "Runs"], 1),
            ],
        },
        {
            "title": "My Home",
            "iconName": "chat",
            "contentType": "text",
            "passage": [
                reading_line("", "My home has three rooms. There is a kitchen, a bedroom, and a bathroom. The kitchen is big. I like to cook there. My bedroom is small but comfortable."),
            ],
            "questions": [
                mcq("How many rooms are in the home?", ["Two", "Three", "Four"], 1),
                mcq("Which room is big?", ["Bedroom", "Bathroom", "Kitchen"], 2),
            ],
        },
        {
            "title": "Shopping Clothes",
            "iconName": "chat",
            "contentType": "dialogue",
            "passage": [
                reading_line("Shop assistant", "Can I help you?"),
                reading_line("Customer", "Yes, I need a new shirt.", is_user=True),
                reading_line("Shop assistant", "What color do you like?"),
                reading_line("Customer", "Blue, please.", is_user=True),
            ],
            "questions": [
                mcq("What does the customer want to buy?", ["Shoes", "A shirt", "A hat"], 1),
                mcq("What color does the customer choose?", ["Red", "Blue", "Green"], 1),
            ],
        },
        {
            "title": "Directions",
            "iconName": "travel",
            "contentType": "dialogue",
            "passage": [
                reading_line("Tourist", "Excuse me, where is the bank?"),
                reading_line("Local", "Go straight and turn left.", is_user=True),
                reading_line("Tourist", "Is it far?"),
                reading_line("Local", "No, it is near the park.", is_user=True),
            ],
            "questions": [
                mcq("What is the tourist looking for?", ["A bank", "A hotel", "A school"], 0),
                mcq("Where is the bank?", ["Near the park", "At the airport", "In the mountains"], 0),
            ],
        },
        {
            "title": "Doctor",
            "iconName": "chat",
            "contentType": "dialogue",
            "passage": [
                reading_line("Doctor", "Hello. How do you feel today?"),
                reading_line("Patient", "I have a headache.", is_user=True),
                reading_line("Doctor", "Do you have a fever?"),
                reading_line("Patient", "No, just a headache.", is_user=True),
            ],
            "questions": [
                mcq("What is wrong with the patient?", ["A headache", "A broken leg", "A cough"], 0),
                mcq("Does the patient have a fever?", ["Yes", "No", "Maybe"], 1),
            ],
        },
        {
            "title": "Weekend Plans",
            "iconName": "chat",
            "contentType": "dialogue",
            "passage": [
                reading_line("Sara", "What are you doing this weekend?"),
                reading_line("Mike", "I am visiting my parents.", is_user=True),
                reading_line("Sara", "That sounds nice!"),
                reading_line("Mike", "Yes, I am happy.", is_user=True),
            ],
            "questions": [
                mcq("When are Mike's plans?", ["This weekend", "On Monday", "Next month"], 0),
                mcq("Who is Mike visiting?", ["Friends", "Parents", "Teachers"], 1),
            ],
        },
        {
            "title": "Weather",
            "iconName": "chat",
            "contentType": "text",
            "passage": [
                reading_line("", "Today the weather is cold and windy. There are many clouds in the sky. Yesterday it was sunny and warm. Tomorrow may bring rain."),
            ],
            "questions": [
                mcq("How is the weather today?", ["Hot and sunny", "Cold and windy", "Warm and dry"], 1),
                mcq("What was the weather like yesterday?", ["Rainy", "Sunny", "Snowy"], 1),
            ],
        },
    ],
    "a2": [
        {"title": "Job Interview", "iconName": "chat", "contentType": "dialogue", "passage": [reading_line("Interviewer", "Tell me about your last job."), reading_line("Applicant", "I worked as a shop assistant for two years.", is_user=True), reading_line("Interviewer", "Why did you leave?"), reading_line("Applicant", "I wanted a new challenge.", is_user=True)], "questions": [mcq("What was the applicant's last job?", ["Teacher", "Shop assistant", "Chef"], 1), mcq("Why did the applicant leave?", ["They moved abroad", "They wanted a new challenge", "They retired"], 1)]},
        {"title": "Train Journey", "iconName": "travel", "contentType": "text", "passage": [reading_line("", "Last Saturday I took the train to the city. I bought my ticket online and arrived at the station early. The journey took one hour. I read a magazine during the trip.")], "questions": [mcq("How did the writer travel?", ["By bus", "By train", "By plane"], 1), mcq("What did the writer do on the train?", ["Slept", "Read a magazine", "Worked"], 1)]},
        {"title": "Restaurant Order", "iconName": "chat", "contentType": "dialogue", "passage": [reading_line("Waiter", "Are you ready to order?"), reading_line("Guest", "Yes, I'd like the chicken soup and salad.", is_user=True), reading_line("Waiter", "Anything to drink?"), reading_line("Guest", "Water, please.", is_user=True)], "questions": [mcq("What food does the guest order?", ["Pizza", "Chicken soup and salad", "Steak"], 1), mcq("What drink does the guest choose?", ["Juice", "Water", "Wine"], 1)]},
        {"title": "Lost Luggage", "iconName": "travel", "contentType": "dialogue", "passage": [reading_line("Traveler", "Excuse me, my bag didn't arrive."), reading_line("Agent", "Can I see your ticket and baggage tag?", is_user=True), reading_line("Traveler", "Here they are."), reading_line("Agent", "We'll contact you when we find it.", is_user=True)], "questions": [mcq("What is the traveler's problem?", ["Missed flight", "Lost luggage", "Wrong seat"], 1), mcq("What will the agent do?", ["Refund the ticket", "Contact the traveler when the bag is found", "Cancel the trip"], 1)]},
        {"title": "Weekend Trip", "iconName": "travel", "contentType": "text", "passage": [reading_line("", "My friends and I drove to the mountains last weekend. We stayed in a small hotel and went hiking on Sunday. The views were beautiful, but it was colder than we expected.")], "questions": [mcq("Where did they go?", ["To the beach", "To the mountains", "To the desert"], 1), mcq("What activity did they do on Sunday?", ["Shopping", "Hiking", "Swimming"], 1)]},
        {"title": "Health Advice", "iconName": "chat", "contentType": "dialogue", "passage": [reading_line("Doctor", "You should exercise three times a week."), reading_line("Patient", "I feel too tired after work.", is_user=True), reading_line("Doctor", "Try walking for twenty minutes."), reading_line("Patient", "OK, I will try.", is_user=True)], "questions": [mcq("How often should the patient exercise?", ["Once a week", "Three times a week", "Every day"], 1), mcq("What does the doctor suggest?", ["Running a marathon", "Walking twenty minutes", "Sleeping more"], 1)]},
        {"title": "Online Shopping", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "I ordered a jacket online because it was cheaper than in the store. It arrived after five days. The size was perfect, so I kept it and wrote a positive review.")], "questions": [mcq("Why did the writer shop online?", ["It was faster", "It was cheaper", "The store was closed"], 1), mcq("Was the jacket the right size?", ["No", "Yes", "It was too big"], 1)]},
        {"title": "Birthday Party", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "We organized a surprise party for Maria's birthday. Twelve friends came to her house with cake and gifts. Maria was shocked but very happy.")], "questions": [mcq("What kind of party was it?", ["A wedding", "A surprise birthday party", "A business meeting"], 1), mcq("How did Maria feel?", ["Angry", "Shocked but happy", "Bored"], 1)]},
        {"title": "Technology Problem", "iconName": "chat", "contentType": "dialogue", "passage": [reading_line("User", "My computer won't start."), reading_line("Support", "Did you try restarting it?", is_user=True), reading_line("User", "Yes, several times."), reading_line("Support", "Please bring it to our service center.", is_user=True)], "questions": [mcq("What is the problem?", ["Broken phone", "Computer won't start", "Lost password"], 1), mcq("What does support suggest?", ["Buy a new computer", "Bring it to the service center", "Wait one week"], 1)]},
        {"title": "Comparing Cities", "iconName": "travel", "contentType": "text", "passage": [reading_line("", "Barcelona is bigger than my hometown, but my hometown is quieter. Barcelona has more museums and restaurants. However, life there is more expensive.")], "questions": [mcq("Which city is bigger?", ["The hometown", "Barcelona", "They are equal"], 1), mcq("What is true about Barcelona?", ["It is cheaper", "It has more museums", "It is quieter"], 1)]},
    ],
    "b1": [
        {"title": "Office Meeting", "iconName": "chat", "contentType": "dialogue", "passage": [reading_line("Manager", "We need to finish the report by Friday."), reading_line("Employee", "I'll complete my section tomorrow.", is_user=True), reading_line("Manager", "Please share it with the team."), reading_line("Employee", "Sure, I'll send an email.", is_user=True)], "questions": [mcq("When is the deadline?", ["Monday", "Friday", "Next month"], 1), mcq("How will the employee share the work?", ["By phone", "By email", "In person only"], 1)]},
        {"title": "University Life", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "During my first semester, I struggled to manage my time. I joined a study group and started using a calendar. My grades improved because I prepared for lectures in advance.")], "questions": [mcq("What was the initial problem?", ["Time management", "Language skills", "Transport"], 0), mcq("What helped improve grades?", ["Skipping classes", "Preparing in advance", "Changing majors"], 1)]},
        {"title": "Environmental Action", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "Our neighborhood launched a recycling program last month. Residents separate plastic, paper, and glass. Although some people were skeptical at first, participation has increased steadily.")], "questions": [mcq("What did the neighborhood start?", ["A sports club", "A recycling program", "A new school"], 1), mcq("How has participation changed?", ["It decreased", "It increased", "It stopped"], 1)]},
        {"title": "News Discussion", "iconName": "chat", "contentType": "dialogue", "passage": [reading_line("Host", "Today's headline is about rising energy prices."), reading_line("Guest", "Many families are worried about heating costs.", is_user=True), reading_line("Host", "What solutions do you suggest?"), reading_line("Guest", "Investing in renewable energy is essential.", is_user=True)], "questions": [mcq("What is the main topic?", ["Sports", "Energy prices", "Tourism"], 1), mcq("What solution does the guest mention?", ["Closing schools", "Renewable energy", "Higher taxes"], 1)]},
        {"title": "Cooking Class", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "In yesterday's cooking class, we learned to make vegetable soup. The instructor emphasized chopping ingredients evenly and seasoning gradually. Everyone tasted the soup at the end.")], "questions": [mcq("What did they cook?", ["Cake", "Vegetable soup", "Pasta"], 1), mcq("What did the instructor emphasize?", ["Using only meat", "Even chopping and gradual seasoning", "Cooking quickly"], 1)]},
        {"title": "Sports Competition", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "Our team reached the regional finals after winning three matches. The coach said teamwork made the difference. Although we lost in the final, we were proud of our progress.")], "questions": [mcq("How many matches did they win before the final?", ["One", "Three", "Five"], 1), mcq("What did the coach highlight?", ["Luck", "Teamwork", "Expensive equipment"], 1)]},
        {"title": "Holiday Traditions", "iconName": "travel", "contentType": "text", "passage": [reading_line("", "In my country, families gather on New Year's Eve for a large meal. At midnight, we watch fireworks and exchange small gifts. It's a tradition that brings generations together.")], "questions": [mcq("When do families gather?", ["Christmas morning", "New Year's Eve", "Every Sunday"], 1), mcq("What happens at midnight?", ["They sleep", "They watch fireworks", "They go to work"], 1)]},
        {"title": "Email Misunderstanding", "iconName": "chat", "contentType": "dialogue", "passage": [reading_line("Colleague A", "Did you receive my email about the meeting time?"), reading_line("Colleague B", "Yes, but I thought it was next Tuesday.", is_user=True), reading_line("Colleague A", "No, it's this Tuesday at ten."), reading_line("Colleague B", "Thanks for clarifying.", is_user=True)], "questions": [mcq("What was misunderstood?", ["The meeting topic", "The meeting time", "The meeting place"], 1), mcq("When is the meeting?", ["Next Tuesday", "This Tuesday at ten", "Friday"], 1)]},
        {"title": "Feelings and Stress", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "When I feel anxious before exams, I take short breaks and breathe slowly. Talking to friends also helps. These habits have made me feel more confident.")], "questions": [mcq("When does the writer feel anxious?", ["Before exams", "After holidays", "During sports"], 0), mcq("What helps the writer?", ["Avoiding study", "Breaks and talking to friends", "Skipping exams"], 1)]},
        {"title": "Media Habits", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "I used to watch TV news every evening, but now I read articles online. I follow several journalists and check sources carefully to avoid misinformation.")], "questions": [mcq("What changed in the writer's habits?", ["They stopped reading", "They switched from TV news to online articles", "They only watch sports"], 1), mcq("Why does the writer check sources?", ["To write books", "To avoid misinformation", "To save money"], 1)]},
    ],
    "b2": [
        {"title": "Global Inequality", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "Despite economic growth in many regions, inequality continues to widen. Access to education and healthcare remains uneven. Policymakers debate whether targeted subsidies or broader tax reform would be more effective.")], "questions": [mcq("What continues despite economic growth?", ["Equality", "Inequality", "Unemployment only"], 1), mcq("What remains uneven?", ["Access to education and healthcare", "Weather patterns", "Sports funding"], 0)]},
        {"title": "Election Debate", "iconName": "chat", "contentType": "dialogue", "passage": [reading_line("Candidate A", "We must invest in public transport."), reading_line("Candidate B", "Tax cuts will stimulate the economy.", is_user=True), reading_line("Moderator", "How would each plan affect rural areas?"), reading_line("Candidate A", "Better buses would connect villages to jobs.", is_user=True)], "questions": [mcq("What does Candidate A prioritize?", ["Public transport", "Space exploration", "Fashion industry"], 0), mcq("What does Candidate A say about rural areas?", ["Nothing", "Better buses would help", "Schools should close"], 1)]},
        {"title": "Business Negotiation", "iconName": "chat", "contentType": "dialogue", "passage": [reading_line("Buyer", "Your price is higher than we expected."), reading_line("Seller", "We can offer a discount for a long contract.", is_user=True), reading_line("Buyer", "We need delivery within thirty days."), reading_line("Seller", "That timeline is acceptable.", is_user=True)], "questions": [mcq("What concern does the buyer raise first?", ["Delivery time", "Price", "Product color"], 1), mcq("What delivery timeline does the buyer need?", ["Ten days", "Thirty days", "One year"], 1)]},
        {"title": "Scientific Discovery", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "Researchers announced a breakthrough in battery technology that could extend electric vehicle range. The team emphasized that further testing is required before commercial production begins.")], "questions": [mcq("What field is the breakthrough in?", ["Fashion", "Battery technology", "Agriculture"], 1), mcq("What do researchers say is still needed?", ["Marketing only", "Further testing", "Government approval only"], 1)]},
        {"title": "Art Exhibition Review", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "The new exhibition combines traditional painting with digital installations. Critics praise its creativity, though some visitors find the layout confusing. Overall, attendance has exceeded expectations.")], "questions": [mcq("What does the exhibition combine?", ["Sports and music", "Painting and digital installations", "Cooking and dance"], 1), mcq("How has attendance been?", ["Lower than expected", "Higher than expected", "Cancelled"], 1)]},
        {"title": "Relationship Conflict", "iconName": "chat", "contentType": "dialogue", "passage": [reading_line("Friend A", "I felt hurt when you canceled our plans."), reading_line("Friend B", "I'm sorry—I didn't explain my situation.", is_user=True), reading_line("Friend A", "I need clearer communication."), reading_line("Friend B", "You're right. I'll be more open.", is_user=True)], "questions": [mcq("Why did Friend A feel hurt?", ["Plans were canceled", "A gift was lost", "A message was deleted"], 0), mcq("What does Friend A want?", ["More money", "Clearer communication", "A longer vacation"], 1)]},
        {"title": "Housing Market", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "Rising interest rates have made mortgages less affordable for first-time buyers. Renters also face pressure as landlords increase prices. Experts predict gradual stabilization next year.")], "questions": [mcq("Who is especially affected?", ["First-time buyers", "Retired athletes", "Tourists only"], 0), mcq("What do experts predict?", ["Immediate collapse", "Gradual stabilization next year", "Free housing"], 1)]},
        {"title": "Court Case Summary", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "The jury deliberated for two days before reaching a verdict. The defendant was found guilty of fraud. The judge scheduled sentencing for the following month.")], "questions": [mcq("How long did deliberation take?", ["Two hours", "Two days", "Two weeks"], 1), mcq("What was the verdict?", ["Not guilty", "Guilty of fraud", "Case dismissed"], 1)]},
        {"title": "Nutrition Research", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "A recent study links balanced diets with improved sleep quality. Participants who reduced sugar reported fewer interruptions at night. Researchers caution that individual results may vary.")], "questions": [mcq("What does the study link to better sleep?", ["Balanced diets", "Late-night TV", "Skipping meals"], 0), mcq("What do researchers caution?", ["Results are identical for everyone", "Individual results may vary", "Sleep is unrelated to diet"], 1)]},
        {"title": "Career Coaching", "iconName": "chat", "contentType": "dialogue", "passage": [reading_line("Coach", "What skills do you want to develop this year?"), reading_line("Client", "I'd like to improve public speaking.", is_user=True), reading_line("Coach", "Let's set monthly practice goals."), reading_line("Client", "That structure would help me.", is_user=True)], "questions": [mcq("What skill does the client want to improve?", ["Cooking", "Public speaking", "Driving"], 1), mcq("What does the coach propose?", ["Monthly practice goals", "Immediate resignation", "Avoiding meetings"], 0)]},
    ],
    "c1": [
        {"title": "Philosophical Essay", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "The author argues that moral responsibility persists even when choices are constrained by circumstance. Rather than denying agency, the essay invites readers to examine the social conditions that shape decisions.")], "questions": [mcq("What does the author argue about moral responsibility?", ["It disappears under constraint", "It persists even when choices are constrained", "It applies only to law"], 1), mcq("What does the essay invite readers to examine?", ["Fashion trends", "Social conditions shaping decisions", "Sports rules"], 1)]},
        {"title": "Economic Outlook", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "Analysts warn that persistent inflation may necessitate tighter fiscal policy. While stimulus measures boosted employment, they also contributed to price pressures that consumers now feel at the checkout.")], "questions": [mcq("What may tighter fiscal policy address?", ["Inflation", "Tourism", "Weather"], 0), mcq("What side effect of stimulus is mentioned?", ["Lower employment", "Price pressures", "Reduced trade"], 1)]},
        {"title": "Psychology Lecture", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "The lecture explored how perception is influenced by prior experience. Participants interpreted ambiguous images differently depending on their background, illustrating that cognition is not purely objective.")], "questions": [mcq("What influences perception according to the lecture?", ["Prior experience", "Shoe size", "Favorite color only"], 0), mcq("What did ambiguous images demonstrate?", ["Cognition is not purely objective", "Everyone sees identically", "Memory is perfect"], 0)]},
        {"title": "Literary Analysis", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "The novel's protagonist embodies conflicting ideals, symbolized by recurring motifs of light and shadow. The critic suggests that this duality reflects the nation's unresolved historical trauma.")], "questions": [mcq("What motifs recur in the novel?", ["Light and shadow", "Cars and boats", "Cats and dogs"], 0), mcq("What might the duality reflect?", ["Unresolved historical trauma", "Cooking techniques", "Sports scores"], 0)]},
        {"title": "Academic Peer Review", "iconName": "chat", "contentType": "dialogue", "passage": [reading_line("Reviewer", "The methodology section lacks sufficient detail."), reading_line("Author", "I'll expand the description of sampling procedures.", is_user=True), reading_line("Reviewer", "Please also clarify limitations."), reading_line("Author", "I'll add a dedicated paragraph.", is_user=True)], "questions": [mcq("What section needs more detail?", ["Methodology", "Title page", "Acknowledgments"], 0), mcq("What will the author add regarding limitations?", ["Nothing", "A dedicated paragraph", "A poem"], 1)]},
        {"title": "Ethics Panel", "iconName": "chat", "contentType": "dialogue", "passage": [reading_line("Panelist", "Transparency alone cannot guarantee accountability."), reading_line("Speaker", "I agree—institutional oversight is also required.", is_user=True), reading_line("Panelist", "Whistleblower protections remain inadequate."), reading_line("Speaker", "Reform must address that gap.", is_user=True)], "questions": [mcq("What does the panelist say transparency cannot guarantee?", ["Profit", "Accountability", "Innovation"], 1), mcq("What protection is described as inadequate?", ["Parking", "Whistleblower protections", "Vacation time"], 1)]},
        {"title": "Innovation Strategy", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "The startup prioritized iterative prototyping over lengthy planning cycles. By releasing early versions to users, the team gathered feedback that shaped subsequent development and reduced costly assumptions.")], "questions": [mcq("What did the startup prioritize?", ["Iterative prototyping", "Avoiding users", "Long planning only"], 0), mcq("What benefit came from early releases?", ["Less feedback", "Feedback shaped development", "Immediate profit guarantee"], 1)]},
        {"title": "Social Media Ethics", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "Platforms face scrutiny over algorithms that amplify sensational content. Critics argue that engagement-driven design erodes public discourse, while companies contend they are improving moderation tools.")], "questions": [mcq("What do algorithms amplify according to critics?", ["Sensational content", "Only academic papers", "Silent posts"], 0), mcq("What do companies say they are improving?", ["Moderation tools", "Shipping speeds", "Restaurant menus"], 0)]},
        {"title": "Migration Policy", "iconName": "travel", "contentType": "text", "passage": [reading_line("", "The policy proposal seeks to balance border security with humanitarian obligations. Advocates highlight economic contributions of migrants, whereas opponents emphasize integration challenges in certain regions.")], "questions": [mcq("What two goals does the proposal balance?", ["Security and humanitarian obligations", "Sports and music", "Taxes and tourism"], 0), mcq("What do advocates highlight?", ["Economic contributions of migrants", "Reduced education", "Closed borders"], 0)]},
        {"title": "Debate Closing Statement", "iconName": "chat", "contentType": "dialogue", "passage": [reading_line("Speaker", "Our opponents overlook the evidence presented today."), reading_line("Opponent", "We question the validity of that evidence.", is_user=True), reading_line("Speaker", "Independent studies confirm the trend."), reading_line("Moderator", "Time is up—thank you both.", is_user=True)], "questions": [mcq("What does the speaker claim opponents overlook?", ["Evidence", "Lunch break", "Audience"], 0), mcq("What supports the trend according to the speaker?", ["Independent studies", "Personal gossip", "Anonymous rumors"], 0)]},
    ],
    "c2": [
        {"title": "Geopolitical Analysis", "iconName": "travel", "contentType": "text", "passage": [reading_line("", "The treaty represents a fragile compromise between rival blocs. Diplomats acknowledge that enforcement mechanisms remain contentious, and any unilateral withdrawal could destabilize the region.")], "questions": [mcq("How is the treaty described?", ["As a fragile compromise", "As irrelevant", "As permanently binding without dispute"], 0), mcq("What could destabilize the region?", ["Unilateral withdrawal", "Cultural festivals", "Sports events"], 0)]},
        {"title": "Climate Summit", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "Delegates committed to accelerated decarbonization targets, yet disagreed over financing for developing nations. The final communique hedges on binding timelines, reflecting divergent national priorities.")], "questions": [mcq("What did delegates commit to?", ["Accelerated decarbonization targets", "Increased coal use", "Eliminating all science funding"], 0), mcq("What does the communique hedge on?", ["Binding timelines", "Hotel locations", "Menu choices"], 0)]},
        {"title": "Medical Ethics Case", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "The ethics committee weighed patient autonomy against potential harm. Clinicians argued that informed consent was valid, while relatives questioned whether distress had compromised decision-making capacity.")], "questions": [mcq("What tension did the committee weigh?", ["Autonomy vs potential harm", "Cost vs color", "Speed vs style"], 0), mcq("What did relatives question?", ["Decision-making capacity", "Hospital architecture", "Parking fees"], 0)]},
        {"title": "Corporate Merger", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "Shareholders approved the merger after due diligence revealed synergies in supply chains. However, regulators warned that market concentration could undermine competition unless divestitures occur.")], "questions": [mcq("Why did shareholders approve the merger?", ["Synergies revealed in due diligence", "Random chance", "Government order only"], 0), mcq("What might undermine competition?", ["Market concentration", "Employee training", "Office plants"], 0)]},
        {"title": "Diplomatic Cable", "iconName": "travel", "contentType": "text", "passage": [reading_line("", "The ambassador cautioned that unilateral sanctions might provoke retaliatory measures. Multilateral coordination, she argued, would lend legitimacy and reduce the risk of escalation.")], "questions": [mcq("What might unilateral sanctions provoke?", ["Retaliatory measures", "Immediate peace", "Free trade only"], 0), mcq("What would multilateral coordination reduce?", ["Risk of escalation", "Need for diplomacy", "All trade"], 0)]},
        {"title": "Cultural Identity Forum", "iconName": "chat", "contentType": "dialogue", "passage": [reading_line("Speaker 1", "Multiculturalism enriches public life."), reading_line("Speaker 2", "Yet integration policies must address inequality.", is_user=True), reading_line("Speaker 1", "Agreed—identity and equity are linked."), reading_line("Moderator", "Let's open the floor to questions.", is_user=True)], "questions": [mcq("What does Speaker 1 say multiculturalism does?", ["Enriches public life", "Eliminates all conflict", "Reduces education"], 0), mcq("What must integration policies address?", ["Inequality", "Weather", "Sports scores"], 0)]},
        {"title": "AI Governance", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "Policymakers grapple with algorithmic bias and accountability in autonomous systems. Experts urge interpretability standards, while industry leaders warn that excessive regulation could stifle innovation.")], "questions": [mcq("What issues do policymakers grapple with?", ["Algorithmic bias and accountability", "Garden design", "Music lyrics only"], 0), mcq("What do industry leaders warn about?", ["Excessive regulation stifling innovation", "Too much transparency always", "Eliminating all AI"], 0)]},
        {"title": "Human Rights Tribunal", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "The tribunal found evidence of systematic persecution and ordered restitution for victims. The state contested jurisdiction, arguing that domestic courts had already adjudicated the matter.")], "questions": [mcq("What did the tribunal order?", ["Restitution for victims", "Closure of all schools", "Cancellation of elections"], 0), mcq("What did the state contest?", ["Jurisdiction", "The existence of courts", "The concept of law"], 0)]},
        {"title": "Globalization Report", "iconName": "chat", "contentType": "text", "passage": [reading_line("", "The report highlights interdependence in supply chains exposed by recent disruptions. It recommends diversifying suppliers while acknowledging that protectionism carries its own economic costs.")], "questions": [mcq("What does the report highlight?", ["Interdependence in supply chains", "Isolation as always best", "Elimination of trade"], 0), mcq("What does the report recommend?", ["Diversifying suppliers", "Single-source dependency", "Ignoring disruptions"], 0)]},
        {"title": "Leadership Symposium", "iconName": "chat", "contentType": "dialogue", "passage": [reading_line("Keynote", "Visionary leadership requires accountability, not charisma alone."), reading_line("Attendee", "Succession planning is often neglected.", is_user=True), reading_line("Keynote", "Delegation empowers teams when done thoughtfully."), reading_line("Attendee", "That balance is difficult in crises.", is_user=True)], "questions": [mcq("What does the keynote say leadership requires?", ["Accountability", "Charisma alone", "Secrecy"], 0), mcq("What is often neglected according to the attendee?", ["Succession planning", "Office furniture", "Coffee breaks"], 0)]},
    ],
}


def grammar_learned_summary(data: dict) -> str:
    if data.get("learnedPoints"):
        return data["learnedPoints"]
    if data.get("completionSummary"):
        return data["completionSummary"]

    grammar_tokens = {
        "am", "is", "are", "was", "were", "be", "been",
        "a", "an", "the",
        "i", "you", "he", "she", "it", "we", "they",
        "do", "does", "did", "have", "has", "had",
        "can", "could", "will", "would", "should", "must",
    }

    highlights: list[str] = []
    seen: set[str] = set()
    for example in data.get("examples", []):
        highlight = example.get("highlight", "").strip()
        if not highlight:
            continue
        key = highlight.lower()
        if key in seen:
            continue
        seen.add(key)
        highlights.append(highlight)

    if highlights and all(token.lower() in grammar_tokens for token in highlights):
        return ", ".join("I" if token.lower() == "i" else token.lower() for token in highlights)

    pattern = data.get("pattern", "").strip()
    if pattern:
        return pattern

    if highlights:
        return ", ".join("I" if token.lower() == "i" else token.lower() for token in highlights)

    return data.get("rule", data["title"])


def build_grammar_lesson(level: str, number: int, data: dict) -> dict:
    title = data["title"]
    step = {
        "title": data["rule"],
        "description": data["pattern"],
        "formula": data["pattern"],
        "examples": data["examples"],
        "quickTip": f"{data['practicePrompt']} ({data['practiceAnswer']})",
    }
    return {
        "id": f"{level}_{TYPE_CODES['grammar']}_{number:02d}",
        "cefrLevel": level.upper(),
        "number": number,
        "title": title,
        "iconName": data["iconName"],
        "rule": data["rule"],
        "pattern": data["pattern"],
        "examples": data["examples"],
        "practicePrompt": data["practicePrompt"],
        "practiceAnswer": data["practiceAnswer"],
        "steps": [step],
        "completionTitle": data.get("completionTitle", f"{title} Learned"),
        "completionSummary": grammar_learned_summary(data),
    }


def build_vocabulary_lesson(level: str, number: int, data: dict) -> dict:
    return {
        "id": f"{level}_{TYPE_CODES['vocabulary']}_{number:02d}",
        "cefrLevel": level.upper(),
        "number": number,
        "title": data["title"],
        "iconName": data["iconName"],
        "words": [word(w) for w in data["words"]],
    }


def split_reading_units(text: str) -> list[str]:
    sentences = [
        sentence.strip()
        for sentence in re.split(r"(?<=[.!?])\s+", text.strip())
        if sentence.strip()
    ]
    if len(sentences) >= 2:
        return sentences
    return [
        chunk.strip()
        for chunk in re.split(r",\s*", text.strip())
        if chunk.strip()
    ]


def text_passage_to_dialogue(passage: list[dict]) -> list[dict]:
    """Convert narrative text blocks into Friend / You dialogue for the reading flow."""
    if not passage:
        return passage
    if len(passage) > 1:
        return passage

    first = passage[0]
    if first.get("speaker"):
        return passage

    units = split_reading_units(first["text"])
    if not units:
        return passage

    dialogue = [reading_line("Friend", "Can you tell me about it?", is_user=False)]
    for index, unit in enumerate(units):
        dialogue.append(reading_line("You", unit, is_user=True))
        if index < len(units) - 1:
            dialogue.append(reading_line("Friend", "Go on.", is_user=False))
    return dialogue


def expand_dialogue_passage(passage: list[dict], min_lines: int = 6) -> list[dict]:
    """Add closing exchanges so five progressive parts can reveal new content."""
    if len(passage) >= min_lines:
        return passage

    result = list(passage)
    npc_name = next((line["speaker"] for line in result if not line.get("isUser")), "Friend")
    extras = [
        (npc_name, "Do you have any questions?", False),
        ("You", "No, I think I understand.", True),
        (npc_name, "Perfect. Let's continue.", False),
        ("You", "Sounds good to me.", True),
        (npc_name, "Great talking with you.", False),
        ("You", "Same here. Thank you!", True),
    ]

    for speaker, text, is_user in extras:
        if len(result) >= min_lines:
            break
        result.append(reading_line(speaker, text, is_user=is_user))

    return result


def build_reading_lesson(level: str, number: int, data: dict) -> dict:
    title = data["title"]
    content_type = data["contentType"]
    passage = data["passage"]
    if content_type == "text":
        passage = text_passage_to_dialogue(passage)
        content_type = "dialogue"
    if content_type == "dialogue":
        passage = expand_dialogue_passage(passage)
    return {
        "id": f"{level}_{TYPE_CODES['reading']}_{number:02d}",
        "cefrLevel": level.upper(),
        "number": number,
        "title": title,
        "iconName": data["iconName"],
        "contentType": content_type,
        "passage": passage,
        "questions": data["questions"],
        "dialoguePartCount": data.get("dialoguePartCount", 5),
        "tip": data.get(
            "tip",
            "Try speaking the 'You' response out loud to practice your pronunciation!"
            if content_type == "dialogue"
            else "Read the passage carefully before answering the questions.",
        ),
        "completionTitle": data.get("completionTitle", f"{title} Learned"),
        "completionSummary": data.get(
            "completionSummary",
            f"General {title.lower()} conversation"
            if content_type == "dialogue"
            else title,
        ),
    }


def write_json(path: Path, payload: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as handle:
        json.dump(payload, handle, indent=2, ensure_ascii=False)
        handle.write("\n")


def generate() -> None:
    manifest_entries: list[dict] = []

    for level in LEVELS:
        for lesson_type, folder in TYPE_FOLDERS.items():
            if lesson_type == "vocabulary":
                lessons = VOCABULARY[level]
                builder = build_vocabulary_lesson
            elif lesson_type == "grammar":
                lessons = GRAMMAR[level]
                builder = build_grammar_lesson
            else:
                lessons = READING[level]
                builder = build_reading_lesson

            for index, lesson_data in enumerate(lessons, start=1):
                slug = slugify(lesson_data["title"])
                filename = f"{index:02d}_{slug}.json"
                asset_path = f"assets/lessons/{level}/{folder}/{filename}"
                payload = builder(level, index, lesson_data)

                write_json(OUTPUT / level / folder / filename, payload)

                manifest_entries.append(
                    {
                        "id": payload["id"],
                        "cefrLevel": payload["cefrLevel"],
                        "type": lesson_type,
                        "number": index,
                        "title": lesson_data["title"],
                        "assetPath": asset_path,
                        "iconName": lesson_data["iconName"],
                    }
                )

    write_json(OUTPUT / "manifest.json", {"lessons": manifest_entries})

    print(f"Generated {len(manifest_entries)} lessons in {OUTPUT}")


if __name__ == "__main__":
    generate()
