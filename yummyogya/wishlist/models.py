from django.contrib.auth.models import User
from django.db import models
from main.models import Makanan

class Wishlist(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    food = models.ManyToManyField(Makanan, related_name='wishlists')

    def __str__(self):
        return f"{self.user.username}'s Wishlist"


