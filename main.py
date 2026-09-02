"""
Stage 0: Hello Server
Basic FastAPI setup with a simple hello endpoint.
"""
from fastapi import FastAPI

app = FastAPI(title="Task API", version="1.0")