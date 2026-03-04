{
  "name": "refly-visual-designer",
  "version": "1.0.0",
  "description": "Refly 视觉设计工作流集成 - AI驱动的设计素材生成",
  "author": "OpenClaw Community",
  "license": "MIT",
  "main": "dist/handler.js",
  "types": "dist/handler.d.ts",
  "hooks": {
    "message": {
      "handler": "dist/handler.js",
      "permissions": [
        "message:send",
        "cron:add",
        "cron:run"
      ]
    }
  },
  "dependencies": {
    "@types/node": "^20.0.0",
    "typescript": "^5.0.0",
    "axios": "^1.6.0"
  },
  "devDependencies": {
    "@openclaw/sdk": "latest"
  },
  "scripts": {
    "build": "tsc",
    "dev": "tsc --watch",
    "test": "node dist/test.js"
  }
}
