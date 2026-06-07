"""add image_data column for base64 storage

Revision ID: add_image_data_base64
Revises: 560811408406
Create Date: 2026-06-07
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = "add_image_data_base64"
down_revision: Union[str, None] = "7172d4fbad79"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # Add image_data column for base64-encoded images
    op.add_column("scans", sa.Column("image_data", sa.Text(), nullable=False, server_default=""))
    # Make image_path nullable (no longer required)
    op.alter_column("scans", "image_path", existing_type=sa.String(500), nullable=True)


def downgrade() -> None:
    # Restore image_path as NOT NULL
    op.alter_column("scans", "image_path", existing_type=sa.String(500), nullable=False)
    # Remove image_data column
    op.drop_column("scans", "image_data")