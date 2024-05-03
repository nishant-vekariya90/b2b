package com.b2b

import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import java.util.*

object JsonConverter {
    @Throws(JSONException::class)
    fun convertToMap(json: JSONObject): Map<String, Any?> {
        var retMap: Map<String, Any?> = emptyMap()
        if (json !== JSONObject.NULL) {
            retMap = toMap(json)
        }
        return retMap
    }

    @Throws(JSONException::class)
    private fun toMap(`object`: JSONObject): Map<String, Any?> {
        val map: MutableMap<String, Any?> = HashMap()
        val keysItr = `object`.keys()
        while (keysItr.hasNext()) {
            val key = keysItr.next()
            val value = `object`.opt(key)
            if (value is JSONArray) {
                map[key] = toList(value)
            } else if (value is JSONObject) {
                map[key] = toMap(value)
            } else {
                map[key] = value
            }
        }
        return map
    }

    @Throws(JSONException::class)
    private fun toList(array: JSONArray): List<Any?> {
        val list: MutableList<Any?> = ArrayList()
        for (i in 0 until array.length()) {
            val value = array.opt(i)
            if (value is JSONArray) {
                list.add(toList(value))
            } else if (value is JSONObject) {
                list.add(toMap(value))
            } else {
                list.add(value)
            }
        }
        return list
    }
}
