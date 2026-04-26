# Porcelain Theme Plugin — optional backend API routes.
#
# File location after install:
# ~/.hermes/plugins/porcelain-theme/dashboard/plugin_api.py
#
# Route prefix:
# /api/plugins/porcelain-theme/<route>

from fastapi import APIRouter

router = APIRouter()


@router.get("/health")
def health():
    """Health check endpoint."""
    return {"ok": True, "plugin": "porcelain-theme"}
