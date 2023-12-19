import unittest
from Search import search_by_name, search_by_barcode

class TestEzmediApp(unittest.TestCase):

    def test_existed_drug_name(self):
        """ Test existed drug name """
        self.assertIsNotNone(search_by_name("Ibuprofen"))

    def test_nonexisted_drug_name(self):
        """ Test non-existed drug name """
        self.assertIsNotNone(search_by_name("Aspirin"))
    
    # Test Normalized Search
    def test_Upper_Case_drug_name(self):
        """ Test drug name with random Upper Case"""
        self.assertIsNotNone(search_by_name("LoRatADinE"))
    
    def test_Upper_Case_drug_name(self):
        """ Test drug name with typo"""
        # Should be prednisone
        self.assertIsNotNone(search_by_name("prednison"))
    
    def test_punctuated_head_drug_name(self):
        """ Test punctuated drug name """
        self.assertIsNotNone(search_by_name("!@#Sertraline"))

    def test_punctuated_tail_drug_name(self):
        """ Test punctuated drug name """
        self.assertIsNotNone(search_by_name("Lisinopril##"))

    def test_punctuated_middle_drug_name(self):
        """ Test punctuated drug name """
        self.assertIsNotNone(search_by_name("Lisin@@opril"))

    def test_abbreviation(self):
        """ Test Abbreviation Names """
        # MTX is the abbreviation for "Methotrexate"
        self.assertIsNotNone(search_by_name("MTX"))   

    def test_saltforms(self):
        """ Test Overspecified Names """
        # Should be revised to for "oxycodone"
        self.assertIsNotNone(search_by_name("oxycodone-hydrochloride"))   
        

    # Should Return None
    def test_invalid_drug_name(self):
        """ Test invalid drug name """
        self.assertIsNone(search_by_name("InvalidDrugName"))

    def test_empty_drug_name(self):
        """ Test empty drug name """
        self.assertIsNone(search_by_name(""))

    def test_numeric_drug_name(self):
        """ Test Name with pure numbers """
        self.assertIsNone(search_by_name("1234"))

    def test_long_drug_name(self):
        """ Test Long Names """
        self.assertIsNone(search_by_name("a" * 1000))

    # Testing With NDC Input
    def test_numeric_NDC(self):
        """ Test purely numeric NDC """
        self.assertIsNotNone(search_by_barcode("00904629161"))
    def test_ten_digits_NDC(self):
        """ Test NDC with '-' in between """
        self.assertIsNotNone(search_by_barcode("11523-7020-1"))
    def test_ten_digits_NDC(self):
        """ Test NDC with ten digits """
        self.assertIsNotNone(search_by_barcode("0781-1506-10"))
    def test_nine_digits_NDC(self):
        """ Test NDC with nine digits """
        self.assertIsNotNone(search_by_barcode("11523-7020"))
    def test_eight_digits_NDC(self):
        """ Test NDC with eight digits """
        self.assertIsNotNone(search_by_barcode("0071-0157"))

    # Should return None
    def test_abnormal_digits_NDC(self):
        """ Test NDC with a lot of digits """
        self.assertIsNone(search_by_barcode("0"*100))
        self.assertIsNone(search_by_barcode("0"))

if __name__ == '__main__':
    unittest.main()
