import pytest
from app.utils.security import hash_password, check_password
from app.utils.validators import validate_email, validate_password, ValidationError
from app import create_app

@pytest.fixture
def app():
    app = create_app()
    app.config.update({
        "TESTING": True,
    })
    return app

def test_password_hashing(app):
    with app.app_context():
        password = "securePassword123"
        hashed = hash_password(password)
        
        assert hashed != password
        assert check_password(hashed, password) == True
        assert check_password(hashed, "wrongPassword") == False

def test_email_validation():
    # Valid emails
    validate_email("test@example.com")
    validate_email("user.name@domain.co.uk")
    
    # Invalid emails
    with pytest.raises(ValidationError):
        validate_email("invalid-email")
    with pytest.raises(ValidationError):
        validate_email("@domain.com")

def test_password_validation():
    # Valid
    validate_password("12345678")
    
    # Invalid (too short)
    with pytest.raises(ValidationError):
        validate_password("short")
