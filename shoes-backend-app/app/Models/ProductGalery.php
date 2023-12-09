<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Facades\Storage;

class ProductGalery extends Model
{
    use HasFactory /*SoftDeletes*/;

    protected $fillable = [
        'products_id',
        'url'
    ];

    protected function url(): Attribute
    {
        return Attribute::make(
            get: fn ($url) => asset('/storage/products/' . $url),
        );
    }

    // public function getUrlAttribute($url)
    // {
    //     return config('app.url') . Storage::url($url);
    // }
}
