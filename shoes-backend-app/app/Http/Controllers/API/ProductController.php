<?php

namespace App\Http\Controllers\API;

use App\Helpers\ResponseFormatter;
use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function all(Request $request)
    {
        $id = $request->input('id');
        $limit = $request->input('limit');
        $name = $request->input('name');
        $description = $request->input('description');
        $tags = $request->input('tags');
        // $categories = $request->input('categories');
        $categories_id = $request->input('categories_id');
        $price_from = $request->input('price_from');
        $price_to = $request->input('price_to');

        if ($id) {
            $product = Product::with(['galeries', 'category'])->find($id);

            if ($product) {
                return ResponseFormatter::success(
                    $product,
                    'Data produk berhasil diambil'
                );
            } else {
                return ResponseFormatter::error(
                    null,
                    'Data tidak ada',
                    404
                );
            }
        }

        if ($limit) {
            $product = Product::with(['galeries', 'category'])->latest()->take($limit)->get();
            return ResponseFormatter::success(
                $product,
                'Data produk berhasil diambil'
            );
        }
        $product = Product::with(['galeries', 'category']);

        if ($name) {
            $product->where('name', 'like', '%' . $name . '%');
        }

        if ($description) {
            $product->where('description', 'like', '%' . $description . '%');
        }

        if ($tags) {
            $product->where('tags', 'like', '%' . $tags . '%');
        }

        if ($price_from) {
            $product->where('price', '>=', $price_from);
        }


        if ($price_to) {
            $product->where('price', '<=', $price_to);
        }

        if ($categories_id) {
            $product->where('categories_id', $categories_id);
        }

        return ResponseFormatter::success(
            $product->get(),
            'Data produk berhasil diambil'
        );
    }

    public function store(Request $request)
    {
        $product = Product::create($request->all());
        return ResponseFormatter::success(
            $product,
            'Success Add Data Product',
        );
    }

    public function update($id, Request $request)
    {
        $product = Product::find($id);
        $product->update($request->all());
        return ResponseFormatter::success(
            $product,
            'Success Update Product'
        );
    }

    public function destroy($id)
    {
        $productNow = Product::with('galeries')->find($id);
        if ($productNow->delete()) {
            $productNow->galeries()->delete();
            return ResponseFormatter::success(
                $productNow,
                'Success Delete product id ' . $id
            );
        }
        return ResponseFormatter::error(
            null,
            'Data not found',
            404,
        );
    }
}
