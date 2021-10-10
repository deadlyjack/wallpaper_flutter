package com.example.wallpaper

import android.Manifest
import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import android.app.WallpaperManager
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.BitmapDrawable
import android.os.Build
import android.os.ParcelFileDescriptor
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.foxdebug.wallpaper"
        private const val REQ_PERMISSION_CODE = 1
    }

    private var result: MethodChannel.Result? = null
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
                .setMethodCallHandler { call, result ->
                    this.result = result
                    when (call.method) {
                        "getHomeScreenWallpaper" -> getHomeScreenWallpaper()
                        "getLockScreenWallpaper" -> getLockScreenWallpaper()
                        "hasPermission" -> hasPermission(call.argument<String>("permission"))
                        "getPermission" -> getPermission(call.argument<String>("permission"))
                        else -> result.notImplemented()
                    }
                }
    }

    private fun getHomeScreenWallpaper() {
        getAWallpaper("home")
    }

    private fun getLockScreenWallpaper() {
        getAWallpaper("lock")
    }

    private fun hasPermission(permission: String?) {
        permission?.let { it ->
            result?.success(
                    ActivityCompat.checkSelfPermission(
                            this,
                            it
                    ) == PackageManager.PERMISSION_GRANTED
            )
        } ?: run {
            result?.error("MISSING_ARG", "Permission argument is missing", "")
        }
    }

    private fun getPermission(permission: String?) {
        permission?.let { it ->
            if (ContextCompat.checkSelfPermission(context, it) == PackageManager.PERMISSION_GRANTED) {
                result?.success(true)
            } else {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    requestPermissions(arrayOf(permission), REQ_PERMISSION_CODE)
                } else {
                    TODO("VERSION.SDK_INT < M")
                }
            }
        } ?: run {
            result?.error("MISSING_ARG", "Permission argument is missing", "")
        }
    }

    override fun onRequestPermissionsResult(
            requestCode: Int,
            permissions: Array<out String>,
            grantResults: IntArray
    ) {
        when (requestCode) {
            REQ_PERMISSION_CODE -> {
                result?.success(grantResults[0] == PackageManager.PERMISSION_GRANTED)
            }
        }
    }

    private fun getAWallpaper(which: String) {
        var bitmap: Bitmap? = null
        val wallpaperManager = WallpaperManager.getInstance(context)

        if (ActivityCompat.checkSelfPermission(
                        this,
                        Manifest.permission.READ_EXTERNAL_STORAGE
                ) == PackageManager.PERMISSION_GRANTED
        ) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                val wallpaperFile: ParcelFileDescriptor? = when (which) {
                    "home" -> WallpaperManager.FLAG_SYSTEM
                    "lock" -> WallpaperManager.FLAG_LOCK
                    else -> null
                }?.let { it -> wallpaperManager.getWallpaperFile(it) }

                if (wallpaperFile == null) {
                    result?.success("")
                    return
                }

                bitmap = BitmapFactory.decodeFileDescriptor(
                        wallpaperFile.fileDescriptor
                )
            } else {
                val drawable = wallpaperManager.drawable
                val instrinsicWidth = drawable.intrinsicWidth
                val instrinsicHeight = drawable.intrinsicHeight
                if (drawable is BitmapDrawable) {
                    drawable.bitmap?.let { bitmap = it }
                } else {
                    bitmap = Bitmap.createBitmap(
                            if (instrinsicWidth <= 0) 1 else instrinsicWidth,
                            if (instrinsicHeight <= 0) 1 else instrinsicHeight,
                            Bitmap.Config.ARGB_8888
                    )
                }
            }

            if (bitmap == null) {
                result?.error(
                        "WALLPAPER_ERROR",
                        "Cannot get wallpaper.",
                        "Unable to get bitmap of wallpaper"
                )
                return
            }
            val file = File.createTempFile(".wallpaper", ".jpg", context.cacheDir)
            val fileOutputStream = FileOutputStream(file)
            val format = Bitmap.CompressFormat.JPEG

            if (bitmap!!.compress(format, 100, fileOutputStream)) {
                result?.success(file.absolutePath)
            } else {
                result?.error(
                        "WALLPAPER_ERROR",
                        "Cannot get wallpaper.",
                        "Unable to compress wallpaper"
                )
            }

        } else {
            result?.error("PERMISSION_ERROR", "READ_EXTERNAL_STORAGE permission required.", "")
        }
    }
}
