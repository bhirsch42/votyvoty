import webapp2
from Handler import *
import VotyDatabase

class MainHandler(Handler):
    def get(self, path):
        self.render("home.html")

class NewVotyHandler(Handler):
	def post(self):
		voty = VotyDatabase.add_voty()
		self.response.write(VotyDatabase.json_voty(voty))

class GetVotyHandler(Handler):
	def post(self):
		voty_id = self.request.get('id')
		voty = VotyDatabase.get_voty_by_id(voty_id)
		self.response.write(VotyDatabase.json_voty(voty))

class AddOptionHandler(Handler):
	def post(self):
		voty_id = self.request.get('id')
		message = self.request.get('message')
		VotyDatabase.add_option(voty_id, message)

class UpvoteOptionHandler(Handler):
	def post(self):
		voty_id = self.request.get('id')
		message = self.request.get('message')
		VotyDatabase.upvote_option(voty_id, message)

class DownvoteOptionHandler(Handler):
	def post(self):
		voty_id = self.request.get('id')
		message = self.request.get('message')
		VotyDatabase.downvote_option(voty_id, message)

app = webapp2.WSGIApplication([
    (r'/([0-9]*)', MainHandler),
    ('/voty/new', NewVotyHandler),
    ('/voty/get', GetVotyHandler),
    ('/option/add', AddOptionHandler),
    ('/option/upvote', UpvoteOptionHandler),
    ('/option/downvote', DownvoteOptionHandler)
], debug=True)
