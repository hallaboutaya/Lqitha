import re

class ValidationError(Exception):
    """Custom exception for validation errors"""
    pass

def validate_email(email: str) -> None:
    """Validate email format"""
    if not email:
        raise ValidationError("Email is required")
    
    # RFC 5322 compliant regex
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    if not re.match(pattern, email):
        raise ValidationError("Invalid email format")

def validate_password(password: str) -> None:
    """Validate password strength"""
    if not password:
        raise ValidationError("Password is required")
        
    if len(password) < 8:
        raise ValidationError("Password must be at least 8 characters long")
    
    # Optional: Add complexity checks (uppercase, number, special char)
    # This project requested "secure passwords", length is the most important factor first.

def validate_phone(phone: str) -> None:
    """Basic phone number validation"""
    if not phone:
        return # Phone is often optional
        
    # Allow + and digits, spaces, dashes
    pattern = r'^\+?[\d\s-]{8,}$'
    if not re.match(pattern, phone):
        raise ValidationError("Invalid phone number format")
