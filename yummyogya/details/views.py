# details/views.py
from django.shortcuts import render, get_object_or_404, redirect
from django.contrib import messages
from .models import Review  # Pastikan Anda memiliki model Review
from main.models import Makanan
from dashboard.models import Food
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
import json
from django.db import models


@csrf_exempt
def add_review(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        rating = data.get('rating')
        review_text = data.get('review')
        food_id = data.get('food_id')

        # Ambil objek food dan simpan ulasan
        food = Makanan.objects.get(id=food_id) if food_id else None
        if food and request.user.is_authenticated:
            review = Review.objects.create(
                user=request.user,
                food=food,
                review=review_text,
                rating=rating
            )

            # Hitung rata-rata rating
            all_reviews = Review.objects.filter(food=food)
            average_rating = all_reviews.aggregate(models.Avg('rating'))['rating__avg']
            food.rating = average_rating  # Update rating di objek food
            food.save()  # Simpan perubahan ke database

            return JsonResponse({'message': 'Review added successfully!', 'status': 'success'})
        return JsonResponse({'message': 'Failed to add review', 'status': 'error'})
    return JsonResponse({'message': 'Invalid request method', 'status': 'error'})

@csrf_exempt
def food_detail_flutter_query(request):
    if request.method == "GET":
        food_id = request.GET.get('food_id')
        if not food_id:
            return JsonResponse({"status": "error", "message": "food_id is required"}, status=400)

        try:
            food = Food.objects.get(id=food_id)
            reviews = Review.objects.filter(food_alt=food).values(
                "user__username", "rating", "review", "created_at"
            )  # Ambil semua review terkait dengan `food`

            data = {
                "id": food.id,
                "name": food.name,
                "description": food.description,
                "price": food.price,
                "rating": food.rating,
                "restaurant": food.restaurant,
                "image_url": food.image_url,
                "reviews": list(reviews),  # Tambahkan daftar review ke dalam respons
            }
            return JsonResponse({"status": "success", "data": data}, status=200)
        except Food.DoesNotExist:
            return JsonResponse({"status": "error", "message": "Makanan tidak ditemukan"}, status=404)

    return JsonResponse({"status": "error", "message": "Method not allowed"}, status=405)

def food_detail(request, id):
    item = Makanan.objects.filter(pk=id).first() or Food.objects.filter(pk=id).first()
    if not item:
        return render(request, '404.html')

    reviews = item.review_set.all()  # Ambil semua ulasan untuk item ini
    context = {
        'item': {
            'id': item.id,
            'nama': item.nama if hasattr(item, 'nama') else item.name,
            'deskripsi': item.deskripsi if hasattr(item, 'deskripsi') else item.description,
            'harga': item.harga if hasattr(item, 'harga') else item.price,
            'rating': item.rating,
            'gambar': item.gambar if hasattr(item, 'gambar') else item.image_url,
            'restoran': item.restoran if hasattr(item, 'restoran') else item.restaurant,
        },
        'reviews': reviews  # Tambahkan daftar ulasan ke konteks
    }
    return render(request, 'food_detail.html', context)
