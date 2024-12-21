from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.contrib.auth.forms import PasswordChangeForm
from .forms import ProfileUpdateForm 
from django.contrib.auth import update_session_auth_hash
from wishlist.models import Wishlist
from details.models import Review
from django.http import JsonResponse
from .models import Profile

# Create your views here.

@login_required
def show_profile(request):
    user = request.user
    # Fetch or create the wishlist for the user
    wishlist, created = Wishlist.objects.get_or_create(user=user)
    wishlist_items = wishlist.food.all()[:3]
    profile, created = Profile.objects.get_or_create(user=user)  # Buat profil jika belum ada
    last_login = request.COOKIES.get('last_login', 'Not available')

    order = request.GET.get('order', 'latest')
    if order == 'latest':
        reviews = Review.objects.filter(user=user).order_by('-created_at').select_related('food', 'food_alt')
    else:
        reviews = Review.objects.filter(user=user).order_by('created_at').select_related('food', 'food_alt')

    context = {
        'user': user,
        'profile_form': ProfileUpdateForm(instance=profile),
        'wishlist_items': wishlist_items,
        'reviews': reviews,
        'last_login': last_login,
    }
    return render(request, 'profile.html', context)

@login_required
def update_profile(request):
    if request.method == 'POST':
        profile, created = Profile.objects.get_or_create(user=request.user)
        profile_form = ProfileUpdateForm(request.POST, request.FILES, instance=profile)
        delete_photo = request.POST.get('delete_photo', False)

        if profile_form.is_valid():
            new_bio = request.POST.get('bio')
            if new_bio is not None:
                profile.bio = new_bio
            if delete_photo:
                profile.profile_photo.delete()
            profile_form.save()
            return JsonResponse({'success': True})
        else:
            return JsonResponse({'success': False, 'errors': profile_form.errors})
    return JsonResponse({'success': False, 'error': 'Invalid request'})

@login_required
def change_password(request):
    if request.method == 'POST':
        password_form = PasswordChangeForm(user=request.user, data=request.POST)
        if password_form.is_valid():
            password_form.save()
            update_session_auth_hash(request, password_form.user)  # Agar pengguna tidak logout setelah mengganti password
            return JsonResponse({'success': True})
        else:
            return JsonResponse({'success': False, 'errors': password_form.errors})
    return JsonResponse({'success': False, 'error': 'Invalid request'})