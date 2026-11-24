-- a 
SELECT nv.MaNV, nv.HoTen, p.TenPhong FROM NHANVIEN AS nv
INNER JOIN PHONG AS p ON nv.MaPhong = p.MaPhong
WHERE p.NhiemVu = 'Nghiên cứu' ORDER BY nv.MaNV DESC;

-- b
SELECT nv.MaNV, nv.HoTen, dt.LoaiDT FROM NHANVIEN AS nv
INNER JOIN THAMGIADT AS tgdt ON nv.MaNV = tgdt.MaNV
INNER JOIN DETAI AS dt ON tgdt.MaDT = dt.MaDT
WHERE YEAR(dt.NgayBD) = 2023 AND tgdt.VaiTroDT = 'chủ nhiệm';

-- c
SELECT nv.MaNV, nv.HoTEN FROM NHANVIEN AS nv
WHERE EXISTS(
  SELECT 1 FROM CONGBOBB AS cbbb
  WHERE nv.MaNV = cbbb.MaNV AND NOT EXISTS(
    SELECT 1 FROM CONGBOBB WHERE nv.MaNV = CONGBOBB.MaNV AND VaiTroBB = 'tác giả chính'
  )
);

-- d
SELECT dt.MaDT, dt.TenDT, COUNT(*) AS SoLuongBBKH
FROM DETAI AS dt
INNER JOIN BAIBAOKH AS bbkh ON bbkh.MaDT = dt.MaDT
WHERE bbkh.NgayCB >= '20230101'
  AND bbkh.NgayCB <  '20240101'
GROUP BY dt.MaDT, dt.TenDT;

-- e Tìm nhân viên (HOTEN) 
-- đã công bố tất cả các bài báo khoa học trên ‘tạp chí quốctế’ của đề tài có mã đề tài ‘DT01’.
SELECT nv.HoTen FROM NHANVIEN AS nv
INNER JOIN CONGBOBB AS cbbb ON nv.MaNV = cbbb.MaNV
WHERE EXISTS(
  SELECT 1 FROM BAIBAOKH AS bbkh
  WHERE bbkh.MaDT = 'DT01' AND LoaiBB = 'tạp chí quốc tế'
  AND bbkh.MaBB = cbbb.MaBB
) AND NOT EXISTS(
  SELECT 1 FROM BAIBAOKH as bbkh
  WHERE bbkh.MaDT = 'DT01'
  AND bbkh.LoaiBB = 'tạp chí quốc tế'
  AND NOT EXISTS(
    SELECT 1 FROM CONGBOBB AS cb1
    WHERE cb1.MaNV = nv.MaNV
    AND cb2.MaBB = bbkh.MaBB
  )
)


-- f Với mỗi phòng, tìm nhân viên (MaNV, HoTen) tham gia ít đề tài nhất
SELECT p.MaPhong, nv.MaNV, nv.HoTen FROM NHANVIEN AS nv
INNER JOIN PHONG AS p ON nv.MaPhong = p.MaPhong
LEFT JOIN THAMGIADT AS tgdt ON nv.MaNV = tgdt.MaNV
HAVING COUNT(DISTINCT tgdt.MaDT) = (
  SELECT TOP 1 COUNT(DISTINCT tgdt2.MaDT)
  FROM NHANVIEN AS nv1
  INNER JOIN THAMGIADT AS tgdt2 ON nv1.MaNV = tgdt2.MaNV
  WHERE nv1.MaPhong = p.MaPhong
  GROUP BY nv1.MaNV
  ORDER BY COUNT(DISTINCT tgdt2.MaDT) ASC
)
















