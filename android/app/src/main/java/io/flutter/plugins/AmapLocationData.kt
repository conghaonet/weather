package io.flutter.plugins

import android.os.Parcelable
import com.amap.api.location.AMapLocation
import kotlinx.android.parcel.Parcelize

/**
 * 定位信息类。定位完成后的位置信息
 */
@Parcelize
data class AmapLocationData(
        val location: AMapLocation,
        val accuracy: Float = location.accuracy, //获取定位精度 单位:米
        val adCode: String = location.adCode, //获取区域编码
        val address: String = location.address, //获取地址
        val altitude: Double = location.altitude, //获取海拔高度(单位：米) 默认值：0.0
        val aoiName: String = location.aoiName, //获取兴趣面名称
        val bearing: Float = location.bearing, //获取方向角(单位：度） 默认值：0.0
        val buildingId: String = location.buildingId, //返回支持室内定位的建筑物ID信息
        val city: String = location.city, //城市名称
        val cityCode: String = location.cityCode, //城市编码
        /**
         * 室内外置信度 室内：且置信度取值在[1 ～ 100]，值越大在在室内的可能性越大 室
         * 外：且置信度取值在[-100 ～ -1] ,值越小在在室内的可能性越大 无法识别室内外：置信度返回值为 0
         */
        val conScenario: Int = location.conScenario,
        /**
         * 获取坐标系类型 高德定位sdk会返回两种坐标系
         * AMapLocation.COORD_TYPE_GCJ02 -- GCJ02坐标系
         * AMapLocation.COORD_TYPE_WGS84 -- WGS84坐标系,国外定位时返回的是WGS84坐标系
         */
        val coordType: String = location.coordType,
        val country: String = location.country, //国家名称
        val description: String = location.description, //位置语义信息
        val district: String = location.district, //获取区的名称
        val errorCode: Int = location.errorCode, //错误码
        val errorInfo: String = location.errorInfo, //错误信息
        val floor: String = location.floor, //室内定位的楼层信息
        val latitude: Double = location.latitude, //纬度
        val locationDetail: String = location.locationDetail, //定位信息描述
//        val locationQualityReport: AMapLocationQualityReport = location.locationQualityReport, //定位质量
        val locationType: Int = location.locationType, //定位结果来源
        val longitude: Double = location.longitude, //经度
        val poiName: String = location.poiName, //兴趣点名称
        val provider: String  = location.provider, //定位提供者
        val province: String = location.province, //省的名称
        val satellites: Int = location.satellites, //当前可用卫星数量, 仅在卫星定位时有效
        val speed: Float = location.speed, //获取当前速度(单位：米/秒) 默认值：0.0
        val street: String = location.street, //街道名称
        val streetNum: String = location.streetNum, //门牌号
        /**
         * 获取定位结果的可信度 只有在定位成功时才有意义
         * 非常可信 AMapLocation.TRUSTED_LEVEL_HIGH
         * 可信度一般AMapLocation.TRUSTED_LEVEL_NORMAL
         * 可信度较低 AMapLocation.TRUSTED_LEVEL_LOW
         * 非常不可信 AMapLocation.TRUSTED_LEVEL_BAD
         */
        val trustedLevel: Int = location.trustedLevel) : Parcelable