<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" 
    rel="stylesheet" integrity="sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD" 
    crossorigin="anonymous">
</head>

<style>
    body {
        background: #d3d3d3;
    }
    .main {
        height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .form {
        background: #fff;
        padding: 50px 30px;
        width: 500px;
    }
</style>

<body>
    <div class="main">
        <div class="form">
            @if ($errors->any())
                <div class="alert alert-danger">
                    <ul>
                        @foreach (@errors->all() as $error)
                            <li>{{ $error }}</li>
                        @endforeach
                    </ul>
                </div>
            @endif
            @if(session()->has('status'))
                <div class="alert alert-success">
                    {{ session()->get('status') }}
                </div>
            @endif

            <form action="{{ route('password.update') }}" method="post">
                @csrf
                <input type="hidden" name="token" value="{{ request()->token }}">
                <input type="hidden" name="email" value="{{ request()->email }}">

                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" name="password">
                <br>
                <label for="password_confirmation" class="form-label">Password Confirmation</label>
                <input type="password" class="form-control" name="password_confirmation">
                <br>
                <input type="submit" value="Update Password" class="btn btn-primary w-100 mt-3">
            </form>
        </div>
    </body>
    </html>