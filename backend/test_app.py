import unittest
class TestBasicMath(unittest.TestCase):
    def test_addition(self):
        result = 2 + 2
        self.assertEqual(result, 5)
if __name__ == "__main__":
    unittest.main()