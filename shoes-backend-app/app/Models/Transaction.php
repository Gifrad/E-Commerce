<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;


class Transaction extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'users_id',
        'address',
        'payment',
        'total_price',
        'shipping_price',
        'transfer',
        'status'
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'users_id', 'id');
    }

    public function items()
    {
        return $this->hasMany(TransactionItem::class, 'transactions_id', 'id');
    }

    protected function transfer(): Attribute
    {
        return Attribute::make(
            get: fn ($transfer) => asset('/storage/transfer/' . $transfer),
        );
    }
}
