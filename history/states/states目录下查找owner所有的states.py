import pyradox as pyx
from pathlib import Path
import sys
from collections import defaultdict

def process_file():
	"""处理目录下的所有txt文件"""
	input_dir = Path.cwd()
	# 递归遍历所有txt文件
	for file_path in input_dir.rglob("*.txt"):
		try:
			with file_path.open('r', encoding='utf-8') as f:
				content = f.read()
			pyxContent = pyx.parse(content)
			state = pyxContent["state"]
			state_id = state["id"]
			state_id = str(state_id)
			state_id = int(state_id)
			state_id_list.append(state_id)
			history = state["history"]
			owner = history["owner"]
			owner = str(owner)
			owner_list.append(owner)
		except Exception as e:
			print(f"处理 {file_path.name} 时出错: {str(e)}")
	return state_id_list, owner_list

def build_reverse_mapping(state_id_list, owner_list):
	"""
	构建字符串到数字列表的反向映射字典。
	使用 zip 和 defaultdict 在底层 C 层面高效完成。
	"""
	str_to_ids = defaultdict(list)
	for sid, owner in zip(state_id_list, owner_list):
		str_to_ids[owner].append(sid)
	return str_to_ids

def query_countries(str_to_ids, target_country):
	"""
	根据反向映射字典，批量查询目标国家对应的所有数字。
	返回一个字典，键为查询字符串，值为对应的数字列表。
	"""
	result = {}
	for country in target_country:
		# dict.get 避免 KeyError，如果查不到返回空列表
		result[country] = str_to_ids.get(country, [])
	return result

def query_countries_ordered(str_to_ids, target_country):
	"""
	返回一个与 target_country 顺序一致的列表的列表（方便后续处理）。
	"""
	return [str_to_ids.get(country, []) for country in target_country]

def flatten_results(list_of_lists):
	"""将查询得到的多个子列表汇聚/扁平化为一个一维列表"""
	return [item for sublist in list_of_lists for item in sublist]

if __name__ == "__main__":
	target_country = []
	state_id_list = []
	owner_list = []
	# 1. 读取命令行参数
	if len(sys.argv) < 2:
		print("错误：请至少输入一个要查询的字符串参数。")
		print("用法: python this_file.py <字符串1> <字符串2> ...")
		print("示例: python this_file.py JAP USA RUS")
		sys.exit(1)

	# sys.argv[0] 是脚本名，sys.argv[1:] 是所有传入的参数
	target_country = sys.argv[1:]

	print("开始处理文件...")
	state_id_list, owner_list = process_file()
	# 2. 构建反向索引（只需一次，可重复使用）
	reverse_map = build_reverse_mapping(state_id_list, owner_list)

	# 3. 执行查询
	query_result = query_countries(reverse_map, target_country)
	query_result_ordered = query_countries_ordered(reverse_map, target_country)
	query_result_ordered_converge = [reverse_map.get(country, []) for country in target_country]
	merged_list = flatten_results(query_result_ordered_converge)

	# 4. 输出结果
	print("=== 反向映射字典 ===")
	for k, v in reverse_map.items():
		print(f"  '{k}': {v}")

	print("\n=== 查询结果（按 target_country 顺序的列表） ===")
	print(query_result_ordered)

	print("\n=== 查询结果（按 target_country 顺序汇聚成一个列表） ===")
	print(merged_list)

	print("\n=== 查询结果（字典形式） ===")
	for country, ids in query_result.items():
		print(f"  '{country}' -> {ids}")

	print("处理完成！")