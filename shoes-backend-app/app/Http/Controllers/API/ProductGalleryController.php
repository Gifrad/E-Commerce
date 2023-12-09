<?php

namespace App\Http\Controllers\API;

use App\Helpers\ResponseFormatter;
use App\Http\Controllers\Controller;
use App\Models\ProductGalery;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class ProductGalleryController extends Controller
{


    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'url' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
        ]);

        if ($validator->fails()) {
            return ResponseFormatter::error(
                response()->json($validator->errors()),
                'Failed Add Data',
                422,
            );
            // response()->json($validator->errors(), 422);
        }

        $url = $request->file('url');
        $url->storeAs('public/products', $url->hashName());

        $productGallery = ProductGalery::create([
            'url' => $url->hashName(),
            'products_id' => $request->products_id,
        ]);

        return ResponseFormatter::success(
            $productGallery,
            'Success Add Data Gallery'
        );
    }

    public function destroy($id)
    {

        //find post by ID
        $productGallery = ProductGalery::find($id);

        //delete image
        Storage::delete('public/products/' . basename($productGallery->url));

        //delete productGallery
        $productGallery->delete();

        //return response

        return ResponseFormatter::success(
            null,
            'Success Delete Photo Gallery'
        );
    }
}
