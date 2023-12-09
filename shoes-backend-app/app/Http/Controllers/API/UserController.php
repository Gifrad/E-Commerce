<?php

namespace App\Http\Controllers\API;

use App\Helpers\ResponseFormatter;
use App\Http\Controllers\Controller;
use App\Models\User;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Password as FacadesPassword;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rules\Password;

class UserController extends Controller
{
    public function register(Request $request)
    {
        try {
            $request->validate([
                'name' => ['required', 'string', 'max:255'],
                'username' => ['required', 'string', 'max:255', 'unique:users'],
                'email' => ['required', 'string', 'email', 'max:255', 'unique:users'],
                'roles' => 'required|in:USER,ADMIN',
                'phone' => ['nullable', 'string', 'max:255'],
                'password' => ['required', 'string', new Password(6)],
            ]);
            User::create([
                'name' => $request->name,
                'username' => $request->username,
                'email' => $request->email,
                'roles' => $request->roles,
                'phone' => $request->phone,
                'password' => Hash::make($request->password),
            ]);

            $user = User::where('email', $request->email)->first();

            // $tokenResult = $user->createToken('authToken')->plainTextToken;

            return ResponseFormatter::success([
                // 'access_token' => $tokenResult,
                // 'token_type' => 'Bearer',
                'user' => $user,
            ], 'User Registered');
        } catch (Exception $err) {
            return ResponseFormatter::error([
                'message' => 'Something went wrong',
                'error' => $err,
            ], 'Authentication Failed', 505);
        }
    }

    public function login(Request $request)
    {
        try {

            $request->validate([
                'email' => 'email|required',
                'password' => 'required',
            ]);

            $credentials = request(['email', 'password']);
            if (!Auth::attempt($credentials)) {
                return ResponseFormatter::error([
                    'message' => 'Unauthorized',
                ], 'Authentication Failed', 505);
            }

            $user = User::where('email', $request->email)->first();

            if (!Hash::check($request->password, $user->password)) {
                throw new Exception('Invalid Credentials');
            }

            $tokenResult = $user->createToken('authToken')->plainTextToken;

            return ResponseFormatter::success([
                'access_token' => $tokenResult,
                'token_type' => 'Bearer',
                'user' => $user,
            ], 'Authenticated');
        } catch (Exception $err) {
            return ResponseFormatter::error([
                'message' => 'Something went wrong',
                'error' => $err,
            ], 'Authentication Failed', 505);
        }
    }

    public function fetch(Request $request)
    {
        return ResponseFormatter::success($request->user(), 'Data Profile User Berhasil diambil');
    }

    public function updateProfile(Request $request)
    {

        $user = Auth::user();

        if ($request->hasFile('photo')) {

            $validator = Validator::make($request->all(), [
                'photo' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            ]);

            if ($validator->fails()) {
                return ResponseFormatter::error(
                    response()->json($validator->errors()),
                    'Failed Update Data',
                    422,
                );
                // response()->json($validator->errors(), 422);
            }

            //upload image
            $photo = $request->file('photo');
            $photo->storeAs('public/photo', $photo->hashName());

            //delete old image
            Storage::delete('public/photo/' . basename($user->photo));

            //update post with new image
            $user->update([
                'name' => $request->name,
                'username' => $request->username,
                'email' => $request->email,
                'phone' => $request->phone,
                'photo' => $photo->hashName(),
            ]);
        } else {
            //update post without image
            $user->update([
                'name' => $request->name,
                'username' => $request->username,
                'email' => $request->email,
                'phone' => $request->phone,
            ]);
        }
        return ResponseFormatter::success($user, 'Profile Updated');
    }

    public function logout(Request $request)
    {
        $token = $request->user()->currentAccessToken()->delete();
        return ResponseFormatter::success($token, 'Token Revoke');
    }

    public function all(Request $request)
    {
        $roles = $request->input('roles');
        if ($roles) {
            $user = User::where('roles', $roles);
            return ResponseFormatter::success(
                $user->get(),
                'Success get all user'
            );
        }
    }

    public function destroy($id)
    {

        $user = User::find($id);

        Storage::delete('public/photo/' . basename($user->photo));

        $user->delete();

        return ResponseFormatter::success(null, 'Data User Berhasil Dihapus!');
    }

    public function forgotPassword(Request $request)
    {
        $request->validate(['email' => 'required|email']);

        $status = FacadesPassword::sendResetLink(
            $request->only('email')
        );

        return $status === FacadesPassword::RESET_LINK_SENT ?
            response()->json(back()->with(['status' => __($status)]))  :
            response()->json(back()->withErrors(['email' => __($status)]));
    }

   
}
