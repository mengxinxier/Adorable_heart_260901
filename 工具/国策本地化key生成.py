def extract_content_after_id(file_name):
    try:
        with open(file_name, 'r', encoding='utf-8') as file:
            lines = file.readlines()
            in_focus_block = False
            extracted_content = []

            for line in lines:
                line = line.strip()
                if line.startswith('focus ='):
                    in_focus_block = True
                elif line.startswith('}') and in_focus_block:
                    in_focus_block = False
                elif in_focus_block and line.startswith('id =') and 'relative_position_id' not in line:
                    content_after_id = line.split('id =')[1].strip()
                    extracted_content.append(content_after_id)

        repeated_content = []
        for content in extracted_content:
            repeated_content.append(content)
            repeated_content.append(f"{content}_desc")

        with open('output.txt', 'w', encoding='utf-8') as output_file:
            for content in repeated_content:
                output_file.write(f"{content}: \"\"\n ")

        print("Extraction completed. Check 'output.txt' for extracted content.")

    except FileNotFoundError:
        print(f"File '{file_name}' not found.")

extract_content_after_id(r'') #这里头填国策文件路径
