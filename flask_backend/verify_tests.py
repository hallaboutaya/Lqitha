import pytest
import sys

# Run tests and return exit code
retcode = pytest.main(["-v", "tests/test_unit.py"])

if retcode == 0:
    print("\n\n>>> ALL TESTS PASSED SUCCESSFULLY <<<")
else:
    print("\n\n>>> TESTS FAILED <<<")
    sys.exit(1)
