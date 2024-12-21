import datetime
import json

from django.contrib import messages
# Create your views here.
from django.contrib.auth import authenticate, login as auth_login
from django.contrib.auth import login, logout
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
from django.contrib.auth.models import User
from django.http import HttpResponseRedirect
from django.http import JsonResponse
from django.shortcuts import render, redirect
from django.urls import reverse
from django.views.decorators.csrf import csrf_exempt

from profilepage.models import Profile


@csrf_exempt
def login_flutter(request):
    if request.method == "POST":
        username = request.POST.get('username', '')
        password = request.POST.get('password', '')

        user = authenticate(username=username, password=password)
        if user is not None:
            if user.is_active:
                auth_login(request, user)

                try:
                    profile = Profile.objects.get(user=user)
                except Profile.DoesNotExist:
                    profile = None

                user_data = {
                    "id": user.id,
                    "username": user.username,
                    "email": user.email,
                    "first_name": user.first_name,
                    "last_name": user.last_name,
                }

                if profile:
                    user_data["profile"] = {
                        "bio": profile.bio,
                        "profile_photo": profile.profile_photo.url if profile.profile_photo else None,
                    }

                return JsonResponse({
                    "status": True,
                    "message": "Login sukses!",
                    "user_data": user_data
                }, status=200)

            return JsonResponse({
                "status": False,
                "message": "Login gagal, akun dinonaktifkan."
            }, status=401)

        return JsonResponse({
            "status": False,
            "message": "Login gagal, periksa kembali email atau kata sandi."
        }, status=401)

    return JsonResponse({
        "status": False,
        "message": "Hanya metode POST yang diizinkan."
    }, status=405)


@csrf_exempt
def register_flutter(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            username = data.get('username', '')
            password1 = data.get('password1', '')
            password2 = data.get('password2', '')

            if password1 != password2:
                return JsonResponse({
                    "status": False,
                    "message": "Password tidak cocok."
                }, status=400)

            if User.objects.filter(username=username).exists():
                return JsonResponse({
                    "status": False,
                    "message": "Username sudah digunakan."
                }, status=400)

            user = User.objects.create_user(username=username, password=password1)
            user.save()

            profile = Profile.objects.create(user=user)

            user_data = {
                "id": user.id,
                "username": user.username,
                "email": user.email,
                "first_name": user.first_name,
                "last_name": user.last_name,
                "profile": {
                    "bio": profile.bio,
                    "profile_photo": None,
                }
            }

            return JsonResponse({
                "status": True,
                "message": "User berhasil dibuat!",
                "user_data": user_data
            }, status=200)

        except KeyError as e:
            return JsonResponse({
                "status": False,
                "message": f"Field {str(e)} tidak lengkap."
            }, status=400)

        except Exception as e:
            return JsonResponse({
                "status": False,
                "message": f"Terjadi kesalahan: {str(e)}"
            }, status=500)

    return JsonResponse({
        "status": False,
        "message": "Hanya metode POST yang diizinkan."
    }, status=405)


def register(request):
    form = UserCreationForm()

    if request.method == "POST":
        form = UserCreationForm(request.POST)
        if form.is_valid():
            form.save()
            messages.success(request, 'Your account has been successfully created!')
            return redirect('authentication:login')
    context = {'form': form}
    return render(request, 'register.html', context)


def login_user(request):
    if request.method == 'POST':
        form = AuthenticationForm(data=request.POST)

        if form.is_valid():
            user = form.get_user()
            login(request, user)
            response = HttpResponseRedirect(reverse('main:show_main'))
            response.set_cookie('last_login', str(datetime.datetime.now()))
            return response
        else:
            messages.error(request, 'Username atau password salah.')

    else:
        form = AuthenticationForm(request)
    context = {'form': form}
    return render(request, 'login.html', context)


def logout_user(request):
    logout(request)
    response = HttpResponseRedirect(reverse('main:show_main'))
    response.delete_cookie('last_login')
    return response
