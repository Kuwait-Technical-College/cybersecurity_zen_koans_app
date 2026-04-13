package com.kuwaitdevs.cybersecurityzenkoans.data

import android.content.Context
import com.kuwaitdevs.cybersecurityzenkoans.R
import org.json.JSONArray

data class KoanWithExplanation(
    val koanText: String,
    val technicalExplanation: String,
    val uniqueCode: String
)

class KoansRepository(context: Context) {

    val koansWithExplanations: List<KoanWithExplanation>
    private val koansByCode: Map<String, KoanWithExplanation>

    init {
        val json = context.resources.openRawResource(R.raw.koans)
            .bufferedReader().use { it.readText() }
        val array = JSONArray(json)
        val list = mutableListOf<KoanWithExplanation>()
        for (i in 0 until array.length()) {
            val obj = array.getJSONObject(i)
            list.add(
                KoanWithExplanation(
                    koanText = obj.getString("koanText"),
                    technicalExplanation = obj.getString("technicalExplanation"),
                    uniqueCode = obj.getString("uniqueCode")
                )
            )
        }
        koansWithExplanations = list
        koansByCode = list.associateBy { it.uniqueCode }
    }

    fun getRandomKoanWithExplanation(): KoanWithExplanation {
        return koansWithExplanations.random()
    }

    fun getKoanByCode(code: String): KoanWithExplanation? {
        return koansByCode[code]
    }

    fun getRandomKoan(): String {
        return getRandomKoanWithExplanation().koanText
    }

    val koans: List<String>
        get() = koansWithExplanations.map { it.koanText }
}
