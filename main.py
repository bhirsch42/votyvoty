import webapp2
from Handler import *
import VotyDatabase

class MainHandler(Handler):
    def get(self):
        self.render("home.html")


class NewVoty(Handler):
	def post(self):
		voty = VotyDatabase.addVoty()
		self.response.write(VotyDatabase.jsonVoty(voty))

app = webapp2.WSGIApplication([
    ('/', MainHandler),
    ('/new', NewVoty)
], debug=True)
