from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.contrib.auth.forms import PasswordChangeForm
from .forms import ProfileUpdateForm
from django.contrib.auth import update_session_auth_hash
from wishlist.models import Wishlist, WishlistItem
from details.models import Review
from django.http import JsonResponse
from .models import Profile
from django.views.decorators.csrf import csrf_exempt
import json
from django.contrib.auth.models import User


@login_required
def show_profile(request):
    user = request.user
    wishlist, created = Wishlist.objects.get_or_create(user=user)
    wishlist_items = WishlistItem.objects.filter(wishlist=wishlist)[:3]
    food_items = [item.food for item in wishlist_items]
    profile, created = Profile.objects.get_or_create(user=user)
    last_login = request.COOKIES.get('last_login', 'Not available')

    order = request.GET.get('order', 'latest')
    if order == 'latest':
        reviews = Review.objects.filter(user=user).order_by('-created_at').select_related('food', 'food_alt')
    else:
        reviews = Review.objects.filter(user=user).order_by('created_at').select_related('food', 'food_alt')

    context = {
        'user': user,
        'profile_form': ProfileUpdateForm(instance=profile),
        'food_items': food_items,
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
            update_session_auth_hash(request, password_form.user)
            return JsonResponse({'success': True})
        else:
            return JsonResponse({'success': False, 'errors': password_form.errors})
    return JsonResponse({'success': False, 'error': 'Invalid request'})

@csrf_exempt
def get_profile_flutter(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            username = data.get('username')

            if not username:
                return JsonResponse({'status': 'error', 'message': 'Username is required'}, status=400)

            user = User.objects.filter(username=username).first()
            if not user:
                return JsonResponse({'status': 'error', 'message': 'User not found'}, status=404)

            profile = Profile.objects.get(user=user)
            wishlist_items = WishlistItem.objects.filter(wishlist__user=user)[:3]

            wishlist = [
                {
                    "id": item.food.id,
                    "name": item.food.nama if hasattr(item.food, 'nama') else item.food.name,
                    "price": item.food.harga if hasattr(item.food, 'harga') else item.food.price,
                    "image": item.food.gambar.url if hasattr(item.food, 'gambar') else item.food.image_url,
                }
                for item in wishlist_items
            ]

            reviews = Review.objects.filter(user=user).order_by('-created_at')
            review_data = [
                {
                    "id": review.id,
                    "food_name": review.food.nama if review.food else "Tidak ada",
                    "rating": review.rating,
                    "review": review.review,
                    "date": review.created_at.strftime("%Y-%m-%d"),
                }
                for review in reviews
            ]

            profile_data = {
                "username": user.username,
                "email": user.email,
                "date_joined": user.date_joined.strftime("%Y-%m-%d"),
                "bio": profile.bio,
                "profile_photo": profile.profile_photo.url if profile.profile_photo else None,
                "wishlist": wishlist,
                "reviews": review_data,
            }
            return JsonResponse({'status': 'success', 'data': profile_data}, status=200)

        except Exception as e:
            return JsonResponse({'status': 'error', 'message': str(e)}, status=500)

    return JsonResponse({'status': 'error', 'message': 'Method not allowed'}, status=405)


@csrf_exempt
def update_profile_flutter(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            username = data.get('username')

            if not username:
                return JsonResponse({'status': 'error', 'message': 'Username is required'}, status=400)

            user = User.objects.filter(username=username).first()
            if not user:
                return JsonResponse({'status': 'error', 'message': 'User not found'}, status=404)

            profile = Profile.objects.get(user=user)

            bio = data.get('bio', None)
            delete_photo = data.get('delete_photo', False)

            if bio:
                profile.bio = bio
            if delete_photo:
                profile.profile_photo.delete()

            profile.save()
            return JsonResponse({'status': 'success', 'message': 'Profile updated successfully'}, status=200)

        except Exception as e:
            return JsonResponse({'status': 'error', 'message': str(e)}, status=500)

    return JsonResponse({'status': 'error', 'message': 'Method not allowed'}, status=405)


@csrf_exempt
def change_password_flutter(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            username = data.get('username')
            old_password = data.get('old_password')
            new_password1 = data.get('new_password1')
            new_password2 = data.get('new_password2')

            if not username or not old_password or not new_password1 or not new_password2:
                return JsonResponse({'status': 'error', 'message': 'All fields are required'}, status=400)

            if new_password1 != new_password2:
                return JsonResponse({'status': 'error', 'message': 'Passwords do not match'}, status=400)

            user = User.objects.filter(username=username).first()
            if not user:
                return JsonResponse({'status': 'error', 'message': 'User not found'}, status=404)

            if not user.check_password(old_password):
                return JsonResponse({'status': 'error', 'message': 'Old password is incorrect'}, status=400)

            user.set_password(new_password1)
            user.save()
            return JsonResponse({'status': 'success', 'message': 'Password changed successfully'}, status=200)

        except Exception as e:
            return JsonResponse({'status': 'error', 'message': str(e)}, status=500)

    return JsonResponse({'status': 'error', 'message': 'Method not allowed'}, status=405)
