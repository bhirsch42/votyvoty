import webapp2
from Handler import *

class MainHandler(Handler):
    def get(self):
        self.render("home.html")


app = webapp2.WSGIApplication([
    ('/', MainHandler),
], debug=True)
