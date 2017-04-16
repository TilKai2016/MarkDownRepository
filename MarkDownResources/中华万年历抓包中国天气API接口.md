---
title: 中华万年历抓包中国天气API接口
date: 2016-12-09 16:45:36
tags: [Weather, API]
---

## JSON格式数据的API
<!-- more -->
```
// 通过城市名字获得天气数据
http://wthrcdn.etouch.cn/weather_mini?city=北京
// 通过城市ID获取天气数据
http://wthrcdn.etouch.cn/weather_mini?citykey=101010100
```

返回数据:

```
{"desc":"OK","status":1000,"data":{"wendu":"-2","ganmao":"天气较凉，较易发生感冒，请适当增加衣服。体质较弱的朋友尤其应该注意防护。","forecast":[{"fengxiang":"无持续风向","fengli":"微风级","high":"高温 3℃","type":"晴","low":"低温 -6℃","date":"23日星期三"},{"fengxiang":"无持续风向","fengli":"微风级","high":"高温 4℃","type":"晴","low":"低温 -6℃","date":"24日星期四"},{"fengxiang":"无持续风向","fengli":"微风级","high":"高温 4℃","type":"多云","low":"低温 -5℃","date":"25日星期五"},{"fengxiang":"无持续风向","fengli":"微风级","high":"高温 5℃","type":"霾","low":"低温 -5℃","date":"26日星期六"},{"fengxiang":"无持续风向","fengli":"微风级","high":"高温 5℃","type":"晴","low":"低温 -5℃","date":"27日星期天"}],"yesterday":{"fl":"3-4级","fx":"北风","high":"高温 0℃","type":"晴","low":"低温 -8℃","date":"22日星期二"},"aqi":"37","city":"北京"}}
```

![Network](http://ohx3k2vj3.bkt.clouddn.com/weather01.jpg)

## XML格式的API

```
// 通过城市ID获得天气数据
http://wthrcdn.etouch.cn/WeatherApi?citykey=101010100
// 通过城市名字获得天气数据
http://wthrcdn.etouch.cn/WeatherApi?city=北京
```

返回数据:

```
<resp>
<city>北京</city>
<updatetime>09:45</updatetime>
<wendu>-1</wendu>
<fengli>2级</fengli>
<shidu>37%</shidu>
<fengxiang>西风</fengxiang>
<sunrise_1>07:08</sunrise_1>
<sunset_1>16:53</sunset_1>
<sunrise_2/>
<sunset_2/>
<environment>
<aqi>43</aqi>
<pm25>20</pm25>
<suggest>各类人群可自由活动</suggest>
<quality>优</quality>
<MajorPollutants/>
<o3>15</o3>
<co>1</co>
<pm10>42</pm10>
<so2>12</so2>
<no2>45</no2>
<time>10:00:00</time>
</environment>
<yesterday>
<date_1>22日星期二</date_1>
<high_1>高温 0℃</high_1>
<low_1>低温 -8℃</low_1>
<day_1>
<type_1>晴</type_1>
<fx_1>北风</fx_1>
<fl_1>3-4级</fl_1>
</day_1>
<night_1>
<type_1>多云</type_1>
<fx_1>无持续风向</fx_1>
<fl_1>微风</fl_1>
</night_1>
</yesterday>
<forecast>
<weather>
<date>23日星期三</date>
<high>高温 3℃</high>
<low>低温 -6℃</low>
<day>
<type>晴</type>
<fengxiang>无持续风向</fengxiang>
<fengli>微风级</fengli>
</day>
<night>
<type>晴</type>
<fengxiang>无持续风向</fengxiang>
<fengli>微风级</fengli>
</night>
</weather>
<weather>
<date>24日星期四</date>
<high>高温 4℃</high>
<low>低温 -6℃</low>
<day>
<type>晴</type>
<fengxiang>无持续风向</fengxiang>
<fengli>微风级</fengli>
</day>
<night>
<type>晴</type>
<fengxiang>无持续风向</fengxiang>
<fengli>微风级</fengli>
</night>
</weather>
<weather>
<date>25日星期五</date>
<high>高温 4℃</high>
<low>低温 -5℃</low>
<day>
<type>多云</type>
<fengxiang>无持续风向</fengxiang>
<fengli>微风级</fengli>
</day>
<night>
<type>雾</type>
<fengxiang>无持续风向</fengxiang>
<fengli>微风级</fengli>
</night>
</weather>
<weather>
<date>26日星期六</date>
<high>高温 5℃</high>
<low>低温 -5℃</low>
<day>
<type>雾</type>
<fengxiang>无持续风向</fengxiang>
<fengli>微风级</fengli>
</day>
<night>
<type>晴</type>
<fengxiang>无持续风向</fengxiang>
<fengli>微风级</fengli>
</night>
</weather>
<weather>
<date>27日星期天</date>
<high>高温 5℃</high>
<low>低温 -5℃</low>
<day>
<type>晴</type>
<fengxiang>无持续风向</fengxiang>
<fengli>微风级</fengli>
</day>
<night>
<type>晴</type>
<fengxiang>无持续风向</fengxiang>
<fengli>微风级</fengli>
</night>
</weather>
</forecast>
<zhishus>
<zhishu>
<name>晨练指数</name>
<value>不宜</value>
<detail>早晨天气寒冷，请尽量避免户外晨练，若坚持室外晨练请注意保暖防冻，建议年老体弱人群适当减少晨练时间。</detail>
</zhishu>
<zhishu>
<name>舒适度</name>
<value>较不舒适</value>
<detail>白天天气晴好，但仍会使您感觉偏冷，不很舒适，请注意适时添加衣物，以防感冒。</detail>
</zhishu>
<zhishu>
<name>穿衣指数</name>
<value>冷</value>
<detail>天气冷，建议着棉服、羽绒服、皮夹克加羊毛衫等冬季服装。年老体弱者宜着厚棉衣、冬大衣或厚羽绒服。</detail>
</zhishu>
<zhishu>
<name>感冒指数</name>
<value>较易发</value>
<detail>天气较凉，较易发生感冒，请适当增加衣服。体质较弱的朋友尤其应该注意防护。</detail>
</zhishu>
<zhishu>
<name>晾晒指数</name>
<value>基本适宜</value>
<detail>天气不错，午后温暖的阳光仍能满足你驱潮消霉杀菌的晾晒需求。</detail>
</zhishu>
<zhishu>
<name>旅游指数</name>
<value>较适宜</value>
<detail>天气较好，同时又有微风伴您一路同行。稍冷，较适宜旅游，您仍可陶醉于大自然的美丽风光中。</detail>
</zhishu>
<zhishu>
<name>紫外线强度</name>
<value>弱</value>
<detail>紫外线强度较弱，建议出门前涂擦SPF在12-15之间、PA+的防晒护肤品。</detail>
</zhishu>
<zhishu>
<name>洗车指数</name>
<value>较适宜</value>
<detail>较适宜洗车，未来一天无雨，风力较小，擦洗一新的汽车至少能保持一天。</detail>
</zhishu>
<zhishu>
<name>运动指数</name>
<value>较不宜</value>
<detail>天气较好，但考虑天气寒冷，推荐您进行各种室内运动，若在户外运动请注意保暖并做好准备活动。</detail>
</zhishu>
<zhishu>
<name>约会指数</name>
<value>较不适宜</value>
<detail>天气较冷，室外约会可能会让恋人们受些苦，可在温暖的室内促膝谈心。</detail>
</zhishu>
<zhishu>
<name>雨伞指数</name>
<value>不带伞</value>
<detail>天气较好，您在出门的时候无须带雨伞。</detail>
</zhishu>
</zhishus>
</resp>
<!--
 10.10.156.163(10.10.156.163):57635 ; 10.10.156.163:8080
-->
```

* 其他:聚合数据

```
// 网站地址 站内提供不限次免费API接口
https://www.juhe.cn/docs/api/id/73
```
---
## 抓包中华万年历Java代码实现

```
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.HttpClientBuilder;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 抓取中华万年历天气接口,可用接口包括
 *  ①通过城市名字获取天气
 *  URL http://wthrcdn.etouch.cn/weather_mini?city=北京
 *  return JSON
 *  URL http://wthrcdn.etouch.cn/WeatherApi?city=北京
 *  return XML
 *  ②通过城市代码(中国天气网城市代码)获取天气
 *  URL http://wthrcdn.etouch.cn/weather_mini?citykey=101010100
 *  return JSON
 *  URL http://wthrcdn.etouch.cn/WeatherApi?citykey=101010100
 *  return XML
 * 可选聚合数据免费不限次API
 *  URL https://www.juhe.cn/docs/api/id/73
 * @author TilKai
 */
public class WthrcdnWeatherUtils {

    public static Map<String, String> getWeatherByCityName (String cityName) {
        String wthrcdnWeatherUrl = "http://wthrcdn.etouch.cn/weather_mini?city=" + cityName;
        HttpGet request = new HttpGet(wthrcdnWeatherUrl);
        request.addHeader("User-Agent", "Mozilla/5.0  (Macintosh; Intel Mac OS X 10_11_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36");
        List<Map<String, String>> weatherListInfo = null;
        Map<String,String> weatherMap = new HashMap<String, String>();
        try {
            HttpResponse response = HttpClientBuilder.create().build().execute(request);

            if (response.getStatusLine().getStatusCode() == 200) {
                BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(response.getEntity().getContent(), "utf-8"));

                StringBuffer resultStr = new StringBuffer();
                String line;

                while ((line = bufferedReader.readLine()) != null) {
                    resultStr.append(line);
                }

                System.out.println(resultStr);


                JSONObject tempJsonObject1 = JSONObject.fromObject(resultStr.toString());
                String tempStr = tempJsonObject1.get("data").toString();

                JSONObject tempJsonObject2 = JSONObject.fromObject(tempStr);
                String tempStr1 = tempJsonObject2.get("forecast").toString();

                String city = tempJsonObject2.get("city").toString(); // 城市
                String week = ((JSONObject) JSONArray.fromObject(tempStr1).get(0)).get("date").toString().split("日")[1]; // 星期
                String highTemperature = ((JSONObject) JSONArray.fromObject(tempStr1).get(0)).get("high").toString().substring(3); // 最高温
                String lowTemperature = ((JSONObject) JSONArray.fromObject(tempStr1).get(0)).get("low").toString().substring(3); // 最低温
                String type = ((JSONObject) JSONArray.fromObject(tempStr1).get(0)).get("type").toString(); // 天气类型

                weatherMap.put("week", week);
                weatherMap.put("city_name", city);
                weatherMap.put("s1s2", type);
                weatherMap.put("t1", highTemperature);
                weatherMap.put("t2", lowTemperature);
            }

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            return weatherMap;
        }
    }

    public static void main (String []args) {
        WthrcdnWeatherUtils wthrcdnWeatherUtils = new WthrcdnWeatherUtils();
        Map<String, String> weatherList = wthrcdnWeatherUtils.getWeatherByCityName("北京");
        System.out.println(weatherList);
    }
}
```

