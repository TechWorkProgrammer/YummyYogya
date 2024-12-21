from django import forms
from .models import WishlistItem

class WishlistForm(forms.ModelForm):
    class Meta:
        model = WishlistItem
        fields = ['product']  # Field product saja yang perlu dipilih
