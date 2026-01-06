import pytest
import time

# Generate unique timestamp for test data
@pytest.fixture(scope='session', autouse=True)
def setup_test_timestamp():
    """Generate unique timestamp for test isolation"""
    pytest.timestamp = int(time.time())
