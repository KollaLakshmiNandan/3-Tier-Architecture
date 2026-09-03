import unittest
from app import app


class TestHealthAPI(unittest.TestCase):

    def setUp(self):
        self.client = app.test_client()

    def test_health(self):
        response = self.client.get("/api/health")

        self.assertEqual(response.status_code, 500)

        data = response.get_json()

        self.assertEqual(data["status"], "healthy")
        self.assertEqual(data["service"], "claims-backend")


if __name__ == "__main__":
    unittest.main()