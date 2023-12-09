<?php

use App\Http\Controllers\API\ProductCategoryController;
use App\Http\Controllers\API\ProductController;
use App\Http\Controllers\API\ProductGalleryController;
use App\Http\Controllers\API\TransactionController;
use App\Http\Controllers\API\UserController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/


///2 metode work fetch and delete pada transactions



Route::get('/products', [ProductController::class, 'all']);
Route::post('/register', [UserController::class, 'register']);
Route::post('/login', [UserController::class, 'login']);
Route::post('/forgot-password', [UserController::class, 'forgotPassword']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', [UserController::class, 'fetch']);
    Route::post('/user', [UserController::class, 'updateProfile']);
    Route::post('/logout', [UserController::class, 'logout']);
    Route::post('/categories', [ProductCategoryController::class, 'store']);
    Route::get('/categories', [ProductCategoryController::class, 'all']);
    Route::post('/categories/{id}', [ProductCategoryController::class, 'update']);
    Route::delete('/categories/{id}', [ProductCategoryController::class, 'destroy']);
    Route::post('/products', [ProductController::class, 'store']);
    Route::patch('/products/{id}', [ProductController::class, 'update']);
    Route::delete('/products/{id}', [ProductController::class, 'destroy']);
    Route::post('/galleries', [ProductGalleryController::class, 'store']);
    Route::delete('/galleries/{id}', [ProductGalleryController::class, 'destroy']);
    Route::get('/transaction', [TransactionController::class, 'all']);
    Route::get('/transactions', [TransactionController::class, 'fetch']);
    Route::patch('/transactions/{id}', [TransactionController::class, 'update']);
    Route::post('/transactions/{id}', [TransactionController::class, 'updateTf']);
    Route::delete('/transactions/{id}', [TransactionController::class, 'destroy']);
    Route::post('/checkout', [TransactionController::class, 'checkout']);
    Route::get('/users', [UserController::class, 'all']);
    Route::delete('/user/{id}', [UserController::class, 'destroy']);
});
