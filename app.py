from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

# OpenAI API key
OPENAI_API_KEY = "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"

# إنشاء Thread
@app.route('/create_thread', methods=['POST'])
def create_thread():
    url = "https://api.openai.com/v1/threads"
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {OPENAI_API_KEY}",
        "OpenAI-Beta": "assistants=v2"
    }
    response = requests.post(url, headers=headers, json={})
    return jsonify(response.json())

# إضافة رسالة
@app.route('/add_message/<thread_id>', methods=['POST'])
def add_message(thread_id):
    data = request.json
    url = f"https://api.openai.com/v1/threads/{thread_id}/messages"
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {OPENAI_API_KEY}",
        "OpenAI-Beta": "assistants=v2"
    }
    response = requests.post(url, headers=headers, json=data)
    return jsonify(response.json())

# تشغيل Assistant
@app.route('/run_assistant/<thread_id>', methods=['POST'])
def run_assistant(thread_id):
    data = request.json
    url = f"https://api.openai.com/v1/threads/{thread_id}/runs"
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {OPENAI_API_KEY}",
        "OpenAI-Beta": "assistants=v2"
    }
    response = requests.post(url, headers=headers, json=data)
    return jsonify(response.json())

# التحقق من حالة التشغيل
@app.route('/check_run/<thread_id>/<run_id>', methods=['GET'])
def check_run(thread_id, run_id):
    url = f"https://api.openai.com/v1/threads/{thread_id}/runs/{run_id}"
    headers = {
        "Authorization": f"Bearer {OPENAI_API_KEY}",
        "OpenAI-Beta": "assistants=v2"
    }
    response = requests.get(url, headers=headers)
    return jsonify(response.json())

# استرجاع الرسائل
@app.route('/get_messages/<thread_id>', methods=['GET'])
def get_messages(thread_id):
    url = f"https://api.openai.com/v1/threads/{thread_id}/messages"
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {OPENAI_API_KEY}",
        "OpenAI-Beta": "assistants=v2"
    }
    response = requests.get(url, headers=headers)
    return jsonify(response.json())

if __name__ == 'main':
    app.run(debug=True)