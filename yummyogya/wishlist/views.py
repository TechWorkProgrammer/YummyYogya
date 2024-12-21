from django.shortcuts import render, redirect
from main.models import Makanan
from .models import Wishlist
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.http import JsonResponse

@login_required
def add_to_wishlist(request, food_id):
    if request.method == 'POST':
        food_item = Makanan.objects.get(id=food_id)
        wishlist, created = Wishlist.objects.get_or_create(user=request.user)
        wishlist.food.add(food_item)
        wishlist_count = wishlist.food.count()
        return JsonResponse({'wishlist_count': wishlist_count})
    return JsonResponse({'error': 'Invalid request'}, status=400)

@login_required
def view_wishlist(request): 
    wishlist, created = Wishlist.objects.get_or_create(user=request.user)

    context = {'wishlist': wishlist}
    return render(request, 'wishlist.html', context)

@login_required
def remove_from_wishlist(request, food_id):
    food = Makanan.objects.filter(id=food_id).first()
    
    if food is None:
        messages.error(request, "Food item not found.")
        return redirect('wishlist:view_wishlist')

    wishlist, created = Wishlist.objects.get_or_create(user=request.user)
    wishlist.food.remove(food)
    messages.success(request, f'{food.nama} has been removed from your wishlist.')
    return redirect('wishlist:view_wishlist')

@login_required
def get_wishlist_json(request):
    try:
        wishlist = Wishlist.objects.get(user=request.user)
        foods = wishlist.food.all().values('id', 'nama', 'harga', 'deskripsi', 'rating', 'gambar')
        return JsonResponse(list(foods), safe=False)  
    except Wishlist.DoesNotExist:
        return JsonResponse({'error': 'Wishlist not found'}, status=404)