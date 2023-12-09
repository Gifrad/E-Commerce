<?php

namespace App\Http\Controllers\API;

use App\Helpers\ResponseFormatter;
use App\Http\Controllers\Controller;
use App\Models\Transaction;
use App\Models\TransactionItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class TransactionController extends Controller
{
    public function all(Request $request)
    {
        $id = $request->input('id');
        $limit = $request->input('limit', 6);
        $status = $request->input('status');
        $user_id = $request->input('user_id');

        if ($id) {
            $transaction = Transaction::with(['items.product'])->find($id);
            if ($transaction) {
                return ResponseFormatter::success(
                    $transaction,
                    'Data transaksi berhasil diambil'
                );
            } else {
                return ResponseFormatter::error(
                    null,
                    'Data transaksi tidak ada',
                    404
                );
            }
        }

        $transaction = Transaction::with(['items.product'])->where('users_id', Auth::user()->id);

        if ($status) {
            $transaction->where('status', $status);
        }

        return ResponseFormatter::success(
            $transaction->latest()->get(),
            'Data list transaksi berhasil diambil',
        );
    }

    public function checkout(Request $request)
    {
        $request->validate([
            'items' => 'required|array',
            'items.*.id' => 'exists:products,id',
            'total_price' => 'required',
            'shipping_price' => 'required',
            'status' => 'required|in:PENDING,SUCCESS,CANCELLED,FAILED,SHIPPING,SHIPPED',
        ]);

        $transaction = Transaction::create([
            'users_id' => Auth::user()->id,
            'address' => $request->address,
            'total_price' => $request->total_price,
            'shipping_price' => $request->shipping_price,
            'status' => $request->status,
        ]);

        foreach ($request->items as $product) {
            TransactionItem::create([
                'users_id' => Auth::user()->id,
                'products_id' => $product['id'],
                'transactions_id' => $transaction->id,
                'quantity' => $product['quantity'],
            ]);
        }

        return ResponseFormatter::success(
            $transaction->load('items.product'),
            'Transaksi berhasil',
        );
    }


    public function fetch()
    {

        $data = Transaction::with(['user', 'items.product.category'])->latest()->get();
        if ($data) {
            return ResponseFormatter::success(
                $data,
                "Get All Data Transactions",
            );
        } else {
            return ResponseFormatter::error(
                null,
                'Failed Get Data'
            );
        }
    }

    public function update($id, Request $request)
    {
        $transaction = Transaction::find($id);
        $transaction->update($request->only('status'));
        return ResponseFormatter::success(
            $transaction,
            'Success Update Transaction'
        );
    }

    public function updateTf($id, Request $request)
    {
        $transaction = Transaction::find($id);
        if ($request->hasFile('transfer')) {

            $validator = Validator::make($request->all(), [
                'transfer' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            ]);

            if ($validator->fails()) {
                return ResponseFormatter::error(
                    response()->json($validator->errors()),
                    'Failed Update Pict',
                    422,
                );
                // response()->json($validator->errors(), 422);
            }

            //upload image
            $transfer = $request->file('transfer');
            $transfer->storeAs('public/transfer', $transfer->hashName());

            //delete old image
            // Storage::delete('public/transfer/' . basename($transaction->transfer));

            //update post with new image
            $transaction->update([
                'transfer' => $transfer->hashName(),
            ]);
        }
        return ResponseFormatter::success($transaction, 'Success Upload Transfer');
    }

    // public function uploadTf(Request $request)
    // {
    //     $validator = Validator::make($request->all(), [
    //         'transfer' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
    //     ]);

    //     if ($validator->fails()) {
    //         return ResponseFormatter::error(
    //             response()->json($validator->errors()),
    //             'Failed Upload Transfer',
    //             422,
    //         );
    //         // response()->json($validator->errors(), 422);
    //     }

    //     $transfer = $request->file('transfer');
    //     $transfer->storeAs('public/transfer', $transfer->hashName());

    //     $transaction = Transaction::create([
    //         'transfer' => $transfer->hashName(),
    //     ]);

    //     return ResponseFormatter::success(
    //         $transaction,
    //         'Success Upload Transfer'
    //     );
    // }


    public function destroy($id){
        $data = Transaction::find($id);
        $data->delete();
        return ResponseFormatter::success(
            null,
            'Success Delete Transaction'
        );
    }
}
