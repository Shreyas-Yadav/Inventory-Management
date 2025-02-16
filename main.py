from fastapi import FastAPI, Depends, HTTPException, status, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordRequestForm
from datetime import timedelta
from fastapi.responses import FileResponse, RedirectResponse
from fastapi.staticfiles import StaticFiles
from auth import get_current_user
from config import settings
import auth, schemas, crud
from sqlalchemy.ext.asyncio import AsyncSession
from database import get_db

app = FastAPI()

# Serve static files
app.mount("/static", StaticFiles(directory="static"), name="static")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Root route - serves the authentication page
@app.get("/")
async def serve_auth():
    return FileResponse("static/authentication.html")

# Protected index route - requires authentication
@app.get("/index")
async def serve_index(current_user: schemas.UserResponse = Depends(get_current_user)):
    return FileResponse("static/index.html")

# User registration endpoint
@app.post("/register", response_model=schemas.UserResponse)
async def create_user(user: schemas.UserCreate, db: AsyncSession = Depends(get_db)):
    db_user = await crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    return await crud.create_user(db=db, user=user)

# Login endpoint - replaces /token
@app.post("/login", response_model=schemas.Token)
async def login_for_access_token(
    form_data: OAuth2PasswordRequestForm = Depends(),
    db: AsyncSession = Depends(get_db)
):
    user = await auth.authenticate_user(db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = auth.create_access_token(
        data={"sub": user.email}, expires_delta=access_token_expires
    )
    response = RedirectResponse(url="/index", status_code=status.HTTP_303_SEE_OTHER)
    response.set_cookie(
        key="access_token",
        value=f"Bearer {access_token}",
        httponly=True,
        secure=True,
        samesite="Lax",
        max_age=1800
    )
    return response

# Current user endpoint
@app.get("/me", response_model=schemas.UserResponse)
async def read_users_me(current_user: schemas.UserResponse = Depends(get_current_user)):
    return current_user

# Exception handler for unauthorized access
@app.exception_handler(HTTPException)
async def handle_unauthorized(request: Request, exc: HTTPException):
    if exc.status_code == 401:
        return RedirectResponse(url="/", status_code=status.HTTP_303_SEE_OTHER)
    return exc