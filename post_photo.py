import os
import sys
from instabot import Bot
import random

bot = Bot()
bot.login(username=os.environ['INSTAGRAM_USERNAME'], password=os.environ['INSTAGRAM_PASSWORD'])

path_to_photo = sys.argv[1]

text = ""
if len(sys.argv) > 2:
	text = sys.argv[2]
if text == "":
	text = random.choice([
		"mew mew mew", 
		"MEW!", 
		"mew", 
		"meow", 
		"nyanyanyanyanaynaynya",
		":^_^:",
		"I liked your mew",
		"very mew"
		"OWWWWWWW",
		"murmurmur murmur mur  m     u         r",
	])
bot.upload_photo(path_to_photo, text)

last_media_id = bot.get_your_medias()[0]
text = "#cat #cats #meow #bestmeow #vsco #awesome #nice #aaw #ny #nya #lovecat #kitty #kittens #kitten #instakitty #hellokitty #cute #cutecats #cutecat #pretty #kitties #kittycat #lovecats #blackcat #mycat"
bot.comment(last_media_id, text)
bot.logout()
