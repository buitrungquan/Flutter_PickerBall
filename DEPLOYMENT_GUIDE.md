# Hướng dẫn Deploy Backend lên Render.com

## Bước 1: Chuẩn bị Repository GitHub
✅ Đã hoàn thành - Code đã push lên: https://github.com/buitrungquan/Flutter_PickerBall

## Bước 2: Tạo Web Service trên Render

1. **Truy cập** https://dashboard.render.com/
2. **Chọn** "New Web Service"
3. **Kết nối GitHub** - Chọn repo `Flutter_PickerBall`

## Bước 3: Cấu hình Service

Trên form "New Web Service", điền như sau:

| Field | Giá trị |
|-------|--------|
| **Name** | `flutter-pickleball-backend` |
| **Language** | `Docker` |
| **Branch** | `main` |
| **Root Directory** | `MOBILE_FLUTTER_1771020559` |
| **Dockerfile Path** | `./Backend/Dockerfile` |
| **Instance Type** | `Free` (hoặc `Starter` nếu muốn performance tốt hơn) |

## Bước 4: Environment Variables

Thêm các biến môi trường sau:

```
ASPNETCORE_URLS=http://0.0.0.0:8080
ASPNETCORE_ENVIRONMENT=Production
```

(Nếu sử dụng `render.yaml`, các biến này đã được định nghĩa)

## Bước 5: Deploy

1. Chọn **"Create Web Service"**
2. Render sẽ tự động:
   - Pull code từ GitHub
   - Build Docker image
   - Deploy lên server
   - Cung cấp URL public (dạng: `https://flutter-pickleball-backend.onrender.com`)

## Bước 6: Kiểm tra

Sau khi deploy thành công (khoảng 3-5 phút), kiểm tra:

```
https://flutter-pickleball-backend.onrender.com/swagger
```

Nếu thấy Swagger UI → Backend chạy thành công ✅

## Bước 7: Update Frontend API Config

Sửa file `Frontend/lib/config/api_config.dart`:

```dart
class ApiConfig {
  static const String _baseUrlProd =
      'https://flutter-pickleball-backend.onrender.com/api';
  static const String _baseUrlDev = 'http://localhost:8000/api';
  
  // ... rest of code
}
```

## Troubleshooting

### Lỗi: "SQLite database not found"
- Đảm bảo `pcm.db` đã được commit lên GitHub
- Kiểm tra Dockerfile có `COPY pcm.db ./`

### Lỗi: Port không match
- Render sẽ override port environment variable
- Dockerfile đã thiết lập `EXPOSE 8080` ✅

### Build chậm
- Lần đầu build có thể mất 5-10 phút (size Docker image ~700MB)
- Lần tiếp theo nhanh hơn (dùng cache)

---

**Note:** Nếu muốn tự động deploy (mỗi khi push lên GitHub), bật "Auto-Deploy" trong Render settings.
