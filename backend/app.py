from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
import os

app = Flask(__name__)
# Enable CORS for all routes, allowing requests from any origin (for dev)
CORS(app)

# Database Config (SQLite)
basedir = os.path.abspath(os.path.dirname(__file__))
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'wallet_v3.db')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
# Database reset trigger


db = SQLAlchemy(app)

# --- Models ---

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=True) # Added name field
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(128))

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    price = db.Column(db.Float, nullable=False)
    description = db.Column(db.String(200))
    type = db.Column(db.String(20), nullable=False, default='expense')
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=True) # Linked to User

class Budget(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    monthly_budget = db.Column(db.Float, nullable=False, default=0.0)
    month = db.Column(db.Integer, nullable=False)  # 1-12
    year = db.Column(db.Integer, nullable=False)
    created_at = db.Column(db.String(50))

# --- Routes ---

@app.route('/api/register', methods=['POST'])
def register():
    data = request.get_json()
    name = data.get('name')
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({'error': 'Email and password required'}), 400

    if User.query.filter_by(email=email).first():
        return jsonify({'error': 'User already exists'}), 400

    new_user = User(email=email, name=name)
    new_user.set_password(password)
    
    db.session.add(new_user)
    db.session.commit()

    return jsonify({'message': 'User registered successfully'}), 201

@app.route('/api/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    user = User.query.filter_by(email=email).first()

    if user and user.check_password(password):
        # Return name and id logic
        return jsonify({
            'message': 'Login successful', 
            'user_id': user.id,
            'name': user.name or 'Usuario'
        }), 200
    else:
        return jsonify({'error': 'Invalid credentials'}), 401

@app.route('/api/change-password', methods=['POST'])
def change_password():
    data = request.get_json()
    user_id = data.get('user_id')
    old_password = data.get('old_password')
    new_password = data.get('new_password')

    if not user_id or not old_password or not new_password:
        return jsonify({'error': 'Missing required fields'}), 400

    user = User.query.get(user_id)

    if user and user.check_password(old_password):
        user.set_password(new_password)
        db.session.commit()
        return jsonify({'message': 'Password changed successfully'}), 200
    else:
        return jsonify({'error': 'Invalid current password'}), 401

@app.route('/api/products', methods=['GET'])
def get_products():
    user_id = request.args.get('user_id')
    if user_id:
        products = Product.query.filter_by(user_id=user_id).all()
    else:
        # Fallback or global (could limit this in real app)
        products = Product.query.all()
        
    output = []
    for product in products:
        product_data = {
            'id': product.id, 
            'name': product.name, 
            'price': product.price, 
            'description': product.description,
            'type': product.type,
            'user_id': product.user_id
        }
        output.append(product_data)
    return jsonify(output)

@app.route('/api/products', methods=['POST'])
def add_product():
    data = request.get_json()
    name = data.get('name')
    price = data.get('price')
    description = data.get('description', '')
    p_type = data.get('type', 'expense') # Default to expense
    user_id = data.get('user_id') # Expect user_id

    new_product = Product(name=name, price=price, description=description, type=p_type, user_id=user_id)
    db.session.add(new_product)
    db.session.commit()

    return jsonify({'message': 'Product added'}), 201

@app.route('/api/budget', methods=['GET'])
def get_budget():
    user_id = request.args.get('user_id')
    if not user_id:
        return jsonify({'error': 'user_id required'}), 400
    
    from datetime import datetime
    now = datetime.now()
    current_month = now.month
    current_year = now.year
    
    # Get budget for current month/year
    budget = Budget.query.filter_by(
        user_id=user_id,
        month=current_month,
        year=current_year
    ).first()
    
    if budget:
        return jsonify({
            'id': budget.id,
            'user_id': budget.user_id,
            'monthly_budget': budget.monthly_budget,
            'month': budget.month,
            'year': budget.year
        }), 200
    else:
        # Return default budget if none exists
        return jsonify({
            'id': None,
            'user_id': int(user_id),
            'monthly_budget': 800.0,  # Default
            'month': current_month,
            'year': current_year
        }), 200

@app.route('/api/budget', methods=['POST'])
def create_or_update_budget():
    data = request.get_json()
    user_id = data.get('user_id')
    monthly_budget = data.get('monthly_budget')
    
    if not user_id or monthly_budget is None:
        return jsonify({'error': 'user_id and monthly_budget required'}), 400
    
    from datetime import datetime
    now = datetime.now()
    current_month = now.month
    current_year = now.year
    
    # Check if budget exists for this month/year
    budget = Budget.query.filter_by(
        user_id=user_id,
        month=current_month,
        year=current_year
    ).first()
    
    if budget:
        # Update existing
        budget.monthly_budget = monthly_budget
        db.session.commit()
        return jsonify({'message': 'Budget updated', 'id': budget.id}), 200
    else:
        # Create new
        new_budget = Budget(
            user_id=user_id,
            monthly_budget=monthly_budget,
            month=current_month,
            year=current_year,
            created_at=now.isoformat()
        )
        db.session.add(new_budget)
        db.session.commit()
        return jsonify({'message': 'Budget created', 'id': new_budget.id}), 201

# --- Init DB ---
with app.app_context():
    db.create_all()
    # No auto-seeding of products now, we want it empty for new users
    
    # Seed default user if needed
    if not User.query.filter_by(email="admin@test.com").first():
        user = User(email="admin@test.com", name="Administrador")
        user.set_password("123456")
        db.session.add(user)
        db.session.commit()

if __name__ == '__main__':
    # Host 0.0.0.0 is important for Android emulator to access (via 10.0.2.2)
    app.run(debug=True, host='0.0.0.0', port=5001)
