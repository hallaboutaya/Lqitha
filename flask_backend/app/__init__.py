from flask import Flask
from flask_cors import CORS
from flask_bcrypt import Bcrypt
import os
from dotenv import load_dotenv
from supabase import create_client, Client

# Initialize extensions
bcrypt = Bcrypt()
supabase: Client = None

from app.utils.fcm import init_fcm

def create_app():
    load_dotenv()
    init_fcm()
    
    app = Flask(__name__)
    app.url_map.strict_slashes = False
    CORS(app)
    
    # Configuration
    app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', 'default-dev-key')
    app.config['SUPABASE_URL'] = os.getenv('SUPABASE_URL')
    app.config['SUPABASE_KEY'] = os.getenv('SUPABASE_KEY')
    
    # Initialize extensions
    bcrypt.init_app(app)
    
    # Initialize Supabase
    global supabase
    try:
        if app.config['SUPABASE_URL'] and app.config['SUPABASE_KEY']:
            supabase = create_client(
                app.config['SUPABASE_URL'],
                app.config['SUPABASE_KEY']
            )
            print("Supabase initialized successfully")
        else:
            print("WARNING: Supabase credentials missing")
    except Exception as e:
        print(f"ERROR: Supabase initialization failed: {e}")

    # Register Blueprints
    from app.routes.auth import auth_bp
    from app.routes.users import users_bp
    from app.routes.posts import posts_bp
    from app.routes.notifications import notifications_bp
    from app.routes.admin import admin_bp
    from app.routes.rewards import rewards_bp
    from app.routes.unlocks import unlocks_bp

    app.register_blueprint(auth_bp, url_prefix='/auth')
    app.register_blueprint(users_bp, url_prefix='/users')
    app.register_blueprint(posts_bp) # Shared root for /found-posts and /lost-posts
    app.register_blueprint(notifications_bp, url_prefix='/notifications')
    app.register_blueprint(admin_bp, url_prefix='/admin')
    app.register_blueprint(rewards_bp, url_prefix='/rewards')
    app.register_blueprint(unlocks_bp, url_prefix='/unlocks')
    
    @app.route('/health')
    def health_check():
        return {'status': 'healthy', 'version': '1.0.0'}

    return app
