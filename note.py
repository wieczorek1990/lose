from sqlalchemy import Column, Integer, UnicodeText
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import create_engine

Base = declarative_base()

class Note(Base):
    __tablename__ = "note"
    id = Column(Integer, primary_key=True)
    text = Column(UnicodeText)

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

engine = create_engine('sqlite:///sqlalchemy.db')

Base.metadata.create_all(engine)

