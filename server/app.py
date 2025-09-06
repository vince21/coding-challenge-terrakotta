from flask import Flask, request, jsonify
from flask_cors import CORS
from dotenv import load_dotenv
from prompting import normalize_with_ai
import logging
import os

# Load environment variables
load_dotenv()

app = Flask(__name__)
CORS(app)

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.route('/normalize', methods=['POST'])
def normalize():
    try:
        # Parse request
        data = request.get_json()

        name = data.get('name', '')
        address = data.get('address', '')
        
        # This is not currently implemented
        ai_response = normalize_with_ai(name, address)
        
        return jsonify(ai_response)
        
    except Exception as e:
        logger.error(f"Error in normalize: {str(e)}")
        return jsonify({"error": str(e)}), 500

@app.route('/test-cases', methods=['GET'])
def test_cases():
    """Returns test cases for the frontend to try"""
    return jsonify({
        "easy": [
            {"name": "John Smith", "address": "123 Main St, Seattle, WA 98101"},
            {"name": "Jane Doe", "address": "456 Park Ave, New York, NY 10001"}
        ],
        "medium": [
            {"name": "María García-López", "address": "456 Oak Ave Apt 3B, San Francisco, CA 94102"},
            {"name": "Dr. James O'Brien Jr.", "address": "PO Box 789, Boston, MA 02101"}
        ],
        "hard": [
            {"name": "李明 (Li Ming)", "address": "1-2-3 Shibuya, Tokyo, Japan 150-0002"},
            {"name": "Jean-Baptiste de la Fontaine", "address": "15 Rue de la Paix, 75002 Paris, France"}
        ]
    })

if __name__ == '__main__':
    app.run(port=8001, debug=True)