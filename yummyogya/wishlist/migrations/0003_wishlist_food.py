# Generated by Django 5.1.1 on 2024-12-15 12:34

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('main', '0006_delete_artikel'),
        ('wishlist', '0002_remove_wishlist_food'),
    ]

    operations = [
        migrations.AddField(
            model_name='wishlist',
            name='food',
            field=models.ManyToManyField(related_name='wishlists', to='main.makanan'),
        ),
    ]
