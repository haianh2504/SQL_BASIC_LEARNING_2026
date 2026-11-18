<!-- 2a -->
SELECT nv.MaNV, nv.HoTen, p.TenPhong FROM NHANVIEN AS nv
INNER JOIN PHONG AS p ON nv.MaPhong = p.MaPhong
WHERE p.NhiemVu = 'Nghiên cứu' ORDER BY nv.MaNV DESC;

<!-- 2b cách 1 -->
SELECT nv.MaNV, nv.HoTen, dt.LoaiDT FROM NHANVIEN AS nv
INNER JOIN THAMGIADT AS tgdt ON nv.MaNV = tgdt.MaNV
INNER JOIN DETAI AS dt ON tgdt.MaDT = dt.MaDT
WHERE YEAR(dt.NgayBD) = 2023 AND tgdt.VaiTroDT = 'chủ nhiệm';

<!-- 2c -->
SELECT nv.MaNV, nv.HoTEN FROM NHANVIEN AS nv
WHERE EXISTS(
  SELECT 1 FROM CONGBOBB AS cbbb
  WHERE nv.MaNV = cbbb.MaNV AND NOT EXISTS(
    SELECT 1 FROM CONGBOBB WHERE nv.MaNV = CONGBOBB.MaNV AND VaiTroBB = 'tác giả chính'
  )
);

SELECT dt.MaDT, dt.TenDT, COUNT(*) AS SoLuongBBKH
FROM DETAI AS dt
INNER JOIN BAIBAOKH AS bbkh ON bbkh.MaDT = dt.MaDT
WHERE bbkh.NgayCB >= '20230101'
  AND bbkh.NgayCB <  '20240101'
GROUP BY dt.MaDT, dt.TenDT;

<!-- 2e -->
SELECT nv.HoTen FROM NHANVIEN AS nv
WHERE NOT EXISTS(
  SELECT 1 FROM BAIBAOKH AS bbkh
  WHERE bbkh.LoaiBB = 'tạp chí quốc tế'
  AND bbkh.MaDT = 'DT01' AND NOT EXISTS(
    SELECT 1 FROM CONGBOBB AS cbbb
    WHERE nv.MaNV = cbbb.MaNV
    AND bbkh.MaBB = cbbb.MaBB 
  )
);

<!-- 2f - TÌM MIN CỦA CÁC PHÒNG GROUP BY -->
SELECT p.MaPhong, nv.MaNV, nv.HoTen, MIN(COUNT(*)) AS SoLuongDeTai FROM NHANVIEN AS nv
INNER JOIN PHONG AS p ON nv.MaPhong = p.MaPhong
INNER JOIN THAMGIADT AS tgdt ON nv.MaNV = tgdt.MaNV
GROUP BY p.MaPhong, nv.MaNV, nv.HoTen;















