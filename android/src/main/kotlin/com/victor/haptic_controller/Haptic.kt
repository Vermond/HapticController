package com.victor.haptic_controller

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import org.jetbrains.annotations.NotNull
import java.time.Duration

class Haptic(@NonNull context: Context) {

    private var vibrator: Vibrator = context.getSystemService(Context.VIBRATOR_SERVICE) as Vibrator

    private val intensityMin = 0
    private val intensityMax = 255

    val canHaptic
    get() = vibrator.hasVibrator()

    fun haptic() {
        if (!canHaptic) return

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            //VibrationEffect.createOneShot(1000, -1)
            vibrator.vibrate(VibrationEffect.createWaveform(longArrayOf(100), intArrayOf(255), -1))
        } else {
            @Suppress("DEPRECATION")
            vibrator.vibrate(100)
        }
    }

    fun hapticPattern(@NonNull delayTime:DoubleArray, @NonNull intensities:DoubleArray, @NotNull duration: DoubleArray) {
        if (!canHaptic) return

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            val effect = makeEffect(delayTime, intensities, duration)
            vibrator.vibrate(effect)
        } else {
            @Suppress("DEPRECATION")
            //cannot change intensity on under 25
            val pattern = makePattern(delayTime, duration)
            vibrator.vibrate(pattern, -1)

        }

    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun makeEffect(delayTime: DoubleArray, intensities: DoubleArray, duration: DoubleArray): VibrationEffect {
        val timings = makePattern(delayTime, duration)
        val intensityList = intensities.toIntensityArray(timings.count())

        return VibrationEffect.createWaveform(timings, intensityList, -1)
    }

    private fun DoubleArray.toIntensityArray(max:Int) : IntArray {
        var result:MutableList<Int> = mutableListOf()

        this.forEach {
            result.add(0)
            result.add(it.toIntensity(min = intensityMin, max = intensityMax))
        }

        while (result.count() > max) {
            if (result.count() % 2 == 0) result.add(0) else result.add(result.last())
        }

        return result.toIntArray()
    }

    private fun makePattern(delayTime:DoubleArray, duration: DoubleArray): LongArray {
        var result:MutableList<Long> = mutableListOf()

        var lastTime:Long = 0

        for (i in delayTime.indices) {
            val index = if (i >= duration.size) duration.lastIndex else i

            //0 1 2
            //0.5 0.5 1

            //.5 .5 .5 .5 1




            result.add(delayTime[i].toMilliSecond())
            result.add(duration[index].toMilliSecond())
        }

        return result.toLongArray()
    }

    private fun Double.toMilliSecond() : Long {
        return (this * 1000.0).toLong()
    }

    private fun Double.toIntensity(min:Int = intensityMin, max:Int = intensityMax) : Int {
        return when {
            this > 1 -> max
            this < 0 -> min
            else -> {
                ((max - min) * this + min).toInt()
            }
        }

    }
}