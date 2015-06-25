from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from flask import Flask, jsonify, Response, json, send_from_directory, send_file, request

from note import Note

app = Flask(__name__, static_url_path='/public')
app.debug = True
engine = create_engine('sqlite:///sqlalchemy.db')
Base = declarative_base()
Base.metadata.bind = engine
DBSession = sessionmaker(bind=engine)
session = DBSession()

note = Note(text='Hello world')
session.add(note)
session.commit()

@app.route('/')
def index():
    return send_file('public/index.html')

@app.route('/<path>')
@app.route('/<directory>/<path>')
def root(path, directory=None):
    if directory != None:
        path = directory + '/' + path
    return send_from_directory('public', path)

@app.route('/api/', methods=['GET'])
def api_index():
    notes = session.query(Note).all()
    notes_array = []
    for note in notes:
        notes_array.append(note.as_dict())
    return Response(json.dumps(notes_array), mimetype='application/json')

@app.route('/api/', methods=['POST'])
def api_new():
    text = request.json['text']
    note = Note(text=text)
    session.add(note)
    session.commit()
    return jsonify(id=note.id, text=note.text)

@app.route('/api/<id>', methods=['DELETE'])
def api_delete(id):
    session.query(Note).filter(Note.id == id).delete()
    return '', 200

if __name__ == '__main__':
    app.run(port=4567)

