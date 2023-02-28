import unittest, logging, os

from testutils import test_setup
logger = logging.getLogger()
logger.setLevel(logging.getLevelName(os.environ.get("LOG_LEVEL", "DEBUG")))

# test specific imports
from handler.utils import utils

logging.disable(logging.CRITICAL)

class UtilsTestCase(unittest.TestCase):

    def test_getmessage(self):
        r = utils.getmessage()
        self.assertEqual(r[:6], "Hello!", "Message should start 'Hello!'.")

        r = utils.getmessage("Goodbye?")
        self.assertEqual(r, "Goodbye?", "Message should now read 'Goodbye?'")
