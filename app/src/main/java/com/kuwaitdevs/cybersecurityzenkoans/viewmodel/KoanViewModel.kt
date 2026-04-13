package com.kuwaitdevs.cybersecurityzenkoans.viewmodel

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.kuwaitdevs.cybersecurityzenkoans.data.KoanWithExplanation
import com.kuwaitdevs.cybersecurityzenkoans.data.KoansRepository

class KoanViewModel(application: Application) : AndroidViewModel(application) {
    private val koansRepository = KoansRepository(application)
    
    // LiveData for the current koan with explanation
    private val _currentKoanWithExplanation = MutableLiveData<KoanWithExplanation>()
    val currentKoanWithExplanation: LiveData<KoanWithExplanation> = _currentKoanWithExplanation
    
    // Animation flag
    private val _showAnimation = MutableLiveData<Boolean>()
    private val _showShakeMessage = MutableLiveData<Boolean>(true)

    val showAnimation: LiveData<Boolean> = _showAnimation
    val showShakeMessage: LiveData<Boolean> = _showShakeMessage
    
    init {
        refreshKoan()
    }

    fun refreshKoan() {
        _showAnimation.value = true
        val newKoan = koansRepository.getRandomKoanWithExplanation()
        _currentKoanWithExplanation.value = newKoan
    }

    fun getKoanByCode(code: String): KoanWithExplanation? {
        return koansRepository.getKoanByCode(code)
    }

    fun resetAnimation() {
        _showAnimation.value = false
    }

    fun hideShakeMessage() {
        _showShakeMessage.value = false
    }
}
