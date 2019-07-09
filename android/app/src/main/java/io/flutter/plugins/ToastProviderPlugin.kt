package io.flutter.plugins

import android.content.Context
import android.widget.Toast
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

object ToastProviderPlugin {
    /** Channel名称  **/
    private const val ChannelName = "app2m.com/toast"

    /**
     * 注册Toast插件
     * @param context 上下文对象
     * @param messenger 数据信息交流对象
     */
    @JvmStatic
    fun register(context: Context, messenger: BinaryMessenger) = MethodChannel(messenger, ChannelName).setMethodCallHandler { methodCall, result ->
        methodCall.argument<String>("message")?.let {
            when (methodCall.method) {
                "showShortToast" -> showToast(context, it, Toast.LENGTH_SHORT)
                "showLongToast" -> showToast(context, it, Toast.LENGTH_LONG)
                "showToast" -> showToast(context, it, methodCall.argument<Int>("duration") ?: Toast.LENGTH_SHORT)
            }
        }
        result.success(null) //没有返回值，所以直接返回为null
    }

    private fun showToast(context: Context, message: String, duration: Int) = Toast.makeText(context, message, duration).show()

}