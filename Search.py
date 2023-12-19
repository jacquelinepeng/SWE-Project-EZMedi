import requests
import xml.etree.ElementTree as ET
import os
# import sys

# if len(sys.argv) > 1:
#     arg = sys.argv[1]
#     print(f"Test {arg}")

# Setting up global variables
global root_path, ID_path
root_path = 'D:/trash'
log_file_path = ''
ID_path = 'D:/trash/RXCUI.txt'
input_name = 'Ibuprofen' 

def search_by_name(input):
    
    name = input.strip()

    if not os.path.exists(root_path):
        print("Can not find assigned storage path")
        return None
    if not os.path.exists(ID_path):
        print( "ID storage path not found")
        return None
        
    
    def get_RXCUI_byname(drug_name = name):     
        # Input Name output RXCUI(the id in RxNorm)
        global log_file_path
        base_url = "https://rxnav.nlm.nih.gov"
        path = "/REST/rxcui.xml"
        query_params = {
            "name": drug_name,
            "allsrc": 0,
            "search": 2
        }
        url = f"{base_url}{path}"
        

        try:
            # try getting API
            response = requests.get(url, params=query_params)
            response.raise_for_status()  # raise http error
            print("Success 1")
            xml_data = response.content
        except requests.RequestException as error:
            # print the error
            print("Error: ", error)
            return None
        
        # Parse the XML data
        root = ET.fromstring(xml_data)
        
        processed = root.find('.//rxnormId')
        if processed == None:
            print("Information Not Found Online. Please try again")
            return None    
        
        # Extract the rxnormId
        rxnorm_id = processed.text    
        # 打开日志文件以追加模式写入
        with open(ID_path, 'a', encoding='utf-8') as f:
            f.write(f"\nRxNorm ID: {rxnorm_id}")
        
        log_file_path = F'{root_path}/log#{rxnorm_id}.txt'      # global variable

        # Print the result
        print(f"RxNorm ID: {rxnorm_id}")
        return rxnorm_id 

    def check_Input(name):
        
        if len(name) == 0:
            print(f"Empty Input [{name}], please enter again")
            return 0, None
        elif len(name) >= 50:
            print("Input is too long, please enter again")
            return 0, None
        if name.isdigit():
            print("Wrong Input Type")
            return 0, None
        
        try: 
            lower_case = name.lower()
        except:
            print('Input consists unidentified characters')

        # check if existed
        with open(ID_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
            for line in lines:
                lst1 = line.strip().split(' ')
                if lst1[-1].split(':')[-1].strip() == lower_case:
                    RXCUI_id = lst1[0].split(':')[-1].strip()
                    print("Found In Search History")
                    return 2, RXCUI_id
                
        return 1, None
    
    flag, value = check_Input(name)
    if flag == 1:    # if the input is valid and have not searched before
        id = get_RXCUI_byname()
        Get_All_Properties(id)
        get_Concept_properties(id)
        return id
    elif flag == 2:
        print("Information Found in Search History")
        return value
    else:       # if the input is valid and have not searched before
        return value

def Get_All_Properties(rxcui, prop = 'ALL'):    

    # RxNorm API base URL
    base_url = "https://rxnav.nlm.nih.gov"
    
    # API endpoint path
    path = f"/REST/rxcui/{rxcui}/allProperties.xml"
    
    # Constructing query parameters
    query_params = {
        "prop": prop  
    }
    
    # Constructing the full URL
    url = f"{base_url}{path}"

    try:
        # Sending a GET request to the API
        response = requests.get(url, params=query_params)
        response.raise_for_status()  # Raises HTTPError for bad responses
        
        # Parsing and returning the API response content
        xml_data = response.text
    except requests.RequestException as error:
        # Handling network request errors
        print(f"Error making API request: {error}")
        return None


    # open log file to store in append mode
    with open(log_file_path, 'a', encoding='utf-8') as log_file:
        # 解析XML数据
        root = ET.fromstring(xml_data)

        cnt = 1
        # 遍历XML元素
        for prop_concept_group in root.findall('.//propConceptGroup'):
            # 遍历propConcept元素
            for prop_concept in prop_concept_group.findall('.//propConcept'):
                # 获取属性类别、属性名称和属性值元素的文本内容
                prop_category = prop_concept.find('propCategory').text
                prop_name = prop_concept.find('propName').text
                prop_value = prop_concept.find('propValue').text

                if prop_category == 'CODES' or prop_category == 'SOURCES':
                    continue

                if prop_category == 'NAMES' and prop_name == 'RxNorm Name':
                    with open(ID_path, 'a', encoding='utf-8') as f:
                        f.write(f'\t\t{prop_name}: {prop_value}\n')

                # 写入属性信息到日志文件
                log_file.write(f"Property #{cnt} {prop_name}: {prop_value}\n")
                cnt += 1
    
    print("Success in Properies Acquisition")
    print(log_file_path)

def get_Concept_properties(rxcui):     

    base_url = "https://rxnav.nlm.nih.gov"
    path = f"/REST/rxcui/{rxcui}/properties.xml"
    url = f"{base_url}{path}"

    try:
        # 发起GET请求
        response = requests.get(url)
        response.raise_for_status()  # 抛出HTTP错误，如果有的话
        xml_data = response.content
        # print(xml_data)
    except requests.RequestException as error:
        # 处理网络请求错误
        print("Error: ", error)
        return None

    root = ET.fromstring(xml_data)

    # 获取同义词信息
    synonym_element = root.find(".//synonym")

    # 检查同义词是否存在
    if synonym_element.text is not None:
        synonym = synonym_element.text
    else:
        synonym = 'Not Mentioned'


    with open(f'{root_path}/log#{rxcui}.txt', 'r', encoding='utf-8') as f1:
        rank = sum(1 for line in f1)+1

    print("Success In Finding Synonyms. Synonyms ", synonym)

    with open(f'{root_path}/log#{rxcui}.txt', 'a', encoding='utf-8') as f2:
        f2.write(f'Property #{rank} Synonyms: {synonym}\n')
        

def search_by_barcode(code):

    for i in code:
        if i.isdigit() or i == '-':
            continue
        else:
            print('Invalid Input of ', code)
            return None

    length = len(code)    
    if length < 8:
        print('Input Length too short', code)
        return None
    elif length > 14:
        print('Input Length exceeded', length)
        return None
    
    def NDC2RXCUI(code):
        # Base URL for RxNorm API
        global log_file_path
        base_url = "https://rxnav.nlm.nih.gov/REST/rxcui.xml"

        # Parameters for the GET request
        params = {
            'idtype': 'NDC',         # So far we could only realize NDC. We are yet to achieve UPCA
            'id': code,           # The barcode number
            'allsrc': '0'            # or '1' depending on your requirement
        }

        # Sending GET request to the RxNorm API
        try:
            response = requests.get(base_url, params=params)
            response.raise_for_status()  # Raises HTTPError for bad responses
        except:   
            print("API Error with NDC")
            return None
        # Parsing and returning the API response content
        xml_data = response.text
        root = ET.fromstring(xml_data)
        processed = root.find('.//rxnormId')
        if processed == None:
            print("NDC Not Found Online. Please try again")
            return None   
        
        # Extract the rxnormId
        rxnorm_id = processed.text
        with open(ID_path, 'a', encoding='utf-8') as f:
            f.write(f"\nRxNorm ID: {rxnorm_id}")
        
        log_file_path = F'{root_path}/log#{rxnorm_id}.txt'      # global variable

        # Print the result
        print(f"RxNorm ID: {rxnorm_id}")
        return rxnorm_id
        
    id = NDC2RXCUI(code)
    print("RXCUI corresponding to NDC is", id)
    Get_All_Properties(id)
    get_Concept_properties(id)
    return id

if __name__ == '__main__':
    # search_by_name(input_name)
    # Example usage
    barcode_number = "00904629161"  # Replace with a real barcode number
    result = search_by_barcode(barcode_number)
    # print(result)    