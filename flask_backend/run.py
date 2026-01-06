from app import create_app

app = create_app()

if __name__ == '__main__':
    print("\n" + "="*50)
    print("Starting Lqitha Flask API Server (Modular)")
    print("="*50)
    print(f"Server: http://localhost:5000")
    print(f"Database: Supabase PostgreSQL")
    print("="*50 + "\n")
    
    app.run(debug=True, host='0.0.0.0', port=5000)
