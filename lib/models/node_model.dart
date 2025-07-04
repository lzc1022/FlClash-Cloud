import 'dart:convert';

import 'package:dio/dio.dart';

import 'node_sub_model.dart';

const Map<String, String> countryCodeMap = {
  '中国': 'cn',
  '日本': 'jp',
  '美国': 'us',
  '英国': 'gb',
  '法国': 'fr',
  '德国': 'de',
  '香港': 'hk',
  '澳门': 'mo',
  '台湾': 'tw',
  '韩国': 'kr',
  '印度': 'in',
  '俄罗斯': 'ru',
  '加拿大': 'ca',
  '澳大利亚': 'au',
  '巴西': 'br',
  '西班牙': 'es',
  '意大利': 'it',
  '荷兰': 'nl',
  '瑞典': 'se',
  '丹麦': 'dk',
  '挪威': 'no',
  '芬兰': 'fi',
  '新加坡': 'sg',
  '泰国': 'th',
  '马来西亚': 'my',
  '越南': 'vn',
  '印度尼西亚': 'id',
  '菲律宾': 'ph',
};

class NodeModel {
  String? name;
  String? url;
  bool isChoosed;
  List<NodeSubModel> subData = [];

  NodeModel(
      {this.name, this.url, this.isChoosed = false, required this.subData});

  NodeModel.fromJson(Map<String, dynamic> json)
      : isChoosed = json['isChoosed'] ?? false {
    // 初始化列表显式赋值
    name = json['name'];
    url = json['url'];
    if (json['subData'] != null) {
      subData = [];
      json['subData'].forEach((v) {
        subData.add(NodeSubModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['url'] = url;
    data['isChoosed'] = isChoosed;
    data['subData'] = subData.map((v) => v.toJson()).toList();
    return data;
  }

  static String? getCountryCode(String name) {
    return countryCodeMap[name];
  }
}

class NodeParser {
  // 解析 VLESS 和 VMESS 节点
  Future<List<NodeSubModel>> parseVlessOrVmessNodes(String url) async {
    Dio dio = Dio();
    List<NodeSubModel> nodeList = [];
    try {
      var response = await dio.get(url,
          options: Options(responseType: ResponseType.plain));
      String subString2 = utf8.decode(base64Decode(response.data.trim()));

      if (subString2.isNotEmpty) {
        List<String> array =
            subString2.split('\n').where((e) => e.isNotEmpty).toList();
        for (var element in array) {
          if (element.contains('vmess://')) {
            final encoded = element.split('vmess://')[1].trim();
            try {
              final sanitized = encoded
                  .replaceAll('\n', '')
                  .replaceAll(' ', '')
                  .replaceAll('\r', '');
              final fixed = _fixBase64(sanitized);
              final jsonString = utf8.decode(base64Decode(fixed));
              final config = jsonDecode(jsonString);

              String name = config["ps"] ?? "Unknown";
              String url = element;
              nodeList.add(NodeSubModel(name: name, url: url));
              // ignore: empty_catches
            } catch (e) {}
          } else if (element.contains('vless://')) {
            try {
              final uri = Uri.parse(element.trim());
              final tag = Uri.decodeComponent(uri.fragment);
              print(element);
              nodeList.add(NodeSubModel(name: tag, url: element));
              // ignore: empty_catches
            } catch (e) {}
          }
        }
      }
      // ignore: empty_catches
    } catch (e) {}

    return nodeList;
  }

  // 修复 Base64 填充错误
  String _fixBase64(String base64String) {
    int mod = base64String.length % 4;
    if (mod != 0) {
      base64String = base64String.padRight(base64String.length + 4 - mod, '=');
    }
    return base64String;
  }

  // 根据节点的标签或名称提取国家
  String _extractCountry(String tag) {
    if (tag.contains("美国")) return "美国";
    if (tag.contains("韩国")) return "韩国";
    if (tag.contains("日本")) return "日本";
    if (tag.contains("香港")) return "香港";
    if (tag.contains("新加坡")) return "新加坡";
    if (tag.contains("台湾")) return "台湾";
    if (tag.contains("菲律宾")) return "菲律宾";
    if (tag.contains("印度尼西亚")) return "印度尼西亚";
    if (tag.contains("越南")) return "越南";
    if (tag.contains("泰国")) return "泰国";
    if (tag.contains("马来西亚")) return "马来西亚";
    if (tag.contains("中国")) return "中国";
    if (tag.contains("英国")) return "英国";
    if (tag.contains("法国")) return "法国";
    if (tag.contains("德国")) return "德国";
    if (tag.contains("澳大利亚")) return "澳大利亚";
    if (tag.contains("加拿大")) return "加拿大";
    if (tag.contains("巴西")) return "巴西";
    if (tag.contains("西班牙")) return "西班牙";
    if (tag.contains("意大利")) return "意大利";
    if (tag.contains("荷兰")) return "荷兰";
    if (tag.contains("瑞典")) return "瑞典";
    if (tag.contains("丹麦")) return "丹麦";
    if (tag.contains("挪威")) return "挪威";
    if (tag.contains("芬兰")) return "芬兰";
    if (tag.contains("俄罗斯")) return "俄罗斯";
    if (tag.contains("印度")) return "印度";
    if (tag.contains("澳门")) return "澳门";

    return "其他";
  }

  // 按国家分组节点
  List<NodeModel> groupByCountry(List<NodeSubModel> subData) {
    Map<String, List<NodeSubModel>> countryGroups = {};

    for (var node in subData) {
      String country = _extractCountry(node.name ?? "");

      if (!countryGroups.containsKey(country)) {
        countryGroups[country] = [];
      }

      countryGroups[country]?.add(node);
    }

    List<NodeModel> nodeModels = [];
    countryGroups.forEach((country, nodes) {
      nodeModels.add(NodeModel(name: country, subData: nodes));
    });

    return nodeModels;
  }
}
