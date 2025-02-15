from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
import models, schemas
from security import get_password_hash

import logging

logger = logging.getLogger(__name__)

async def get_user_by_email(db: AsyncSession, email: str):
    result = await db.execute(select(models.User).where(models.User.email == email))
    return result.scalars().first()

async def create_user(db: AsyncSession, user: schemas.UserCreate):
    logger.debug("Creating user with email: %s", user.email)
    hashed_password = get_password_hash(user.password)
    db_user = models.User(email=user.email, hashed_password=hashed_password)
    db.add(db_user)
    await db.commit()
    await db.refresh(db_user)
    logger.debug("User created successfully: %s", db_user.email)
    return db_user