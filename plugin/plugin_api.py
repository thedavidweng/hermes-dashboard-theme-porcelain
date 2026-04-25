# Minimalist Theme Plugin — Backend API Routes (optional)
# 如果你需要自定义后端端点，在此处定义 FastAPI routes。
# 文件位置: ~/.hermes/plugins/porcelain-theme/dashboard/plugin_api.py
#
# 参考官方文档:
# https://hermes-agent.nousresearch.com/docs/user-guide/features/extending-the-dashboard#backend-api-routes
#
# 访问路径: /api/plugins/porcelain-theme/<your-route>

from fastapi import APIRouter, HTTPException

router = APIRouter()


@router.get("/ping")
async def ping():
    """健康检查端点"""
    return {"ok": True, "plugin": "porcelain-theme"}


@router.get("/stats")
async def get_stats():
    """示例：返回一些统计信息（可以连接到 hermes_state 等内部模块）"""
    # 注意：可以直接 import hermes 内部 module，因为插件运行在 dashboard 进程内
    # from hermes_state import SessionDB
    # db = SessionDB()
    # count = len(db.list_sessions(limit=9999))
    # db.close()
    # return {"session_count": count}
    return {"session_count": 0, "note": "implement your own logic"}


# 你可以添加更多路由...
# @router.post("/action")
# async def do_something(body: dict):
#     return {"status": "ok", "received": body}
