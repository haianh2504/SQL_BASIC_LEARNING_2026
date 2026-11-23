-- a
SELECT lb.MaLB, lb.SoHieuCB, cb.SoGioBay, lb.TTLichBay FROM LICHBAY AS lb
INNER JOIN CHUYENBAY AS cb ON lb.SoHieuCB = cb.SoHieuCB
WHERE cb.TTKhaiThac = 'Hằng ngày'
ORDER BY cb.SoGioBay ASC;

-- b. Liệt kê số hiệu chuyến bay, mã sân bay đi, mã sân bay đến của những chuyến bay xuất phát
-- từ sân bay có tên “Tân Sơn Nhất” và có giờ khởi hành là 10:30:00 ngày 20/12/2024
SELECT cb.SoHieuCB, cb.SBDi, cb.SBDen FROM CHUYENBAY AS cb
INNER JOIN SANBAY AS sb ON cb.SBDI = sb.MaSB
WHERE sb.TenSB = 'Tân Sơn Nhất' AND EXISTS(
    SELECT 1 FROM LICHBAY AS lb
    WHERE lb.SoHieuCB = cb.SoHieuCB AND GioDi = '10:30:00-2024-12-20'
);


-- c Cho biết mã đặt vé, mã lịch bay, mã khách hàng thành viên của các lượt đặt vé có tình trạng
-- “Đã thanh toán”, và đồng thời đặt cả 2 loại vé có hạng ghế “Thương gia” và “Phổ thông” trong năm 2024
SELECT dv.MaDV, dv.MaLB, dv.MaTV FROM DATVE AS dv
WHERE dv.TTDatVe = 'Đã thanh toán' AND YEAR(dv.ThoiGianDV) = 2024 AND EXISTS(
    SELECT 1 FROM CTDV AS ctdv
    INNER JOIN LOAIVE AS lv ON ctdv.MaLV = lv.MaLV
    WHERE dv.MaDV = ctdv.MaDV AND v.MaLB = dv.MaLB AND lv.HangGhe = 'Thương gia'
)AND EXISTS(
    SELECT 1 FROM CTDV AS ctdv
    INNER JOIN LOAIVE AS lv ON ctdv.MaLV = lv.MaLV
    WHERE dv.MaDV = ctdv.MaDV AND v.MaLB = dv.MaLB AND lv.HangGhe = 'Phổ thông'
)

-- d Trong các lịch bay có số hiệu chuyến bay “VN121”, thống kê số lượng các chi tiết đặt vé
-- của từng loại vé đã được đặt trong năm 2024. Thông tin hiển thị: Mã loại vé, hạng ghế, số lượng.
SELECT lv.MaLV, lv.HangGhe, COUNT(ct.MaDV) AS SoLuong FROM LOAIVE AS lv
INNER JOIN LICHBAY AS lb ON lv.MaLB = lb.MaLB
INNER JOIN DATVE AS dv ON lb.MaLB = dv.MaLB
INNER JOIN CTDV AS ct ON ct.MaDV = dv.MaDV
WHERE MaLB = 'VN121' AND YEAR(dv.ThoiGianDV) = 2024
GROUP BY lv.MaLV, lv.HangGhe;


-- e Tìm mã và tên của khách hàng thành viên đã thanh toán đặt vé và đã đặt tất cả các loại vé
-- của lịch bay có mã “VN101-080125” trong lần đặt vé đó


-- f Trong các chuyến bay khởi hành từ sân bay có mã “SGN” trong năm 2025, tìm các lịch bay
-- đã được đặt hết vé. Thông tin hiển thị: Số hiệu chuyến bay, mã lịch bay, thời gian khởi hành.
SELECT lb.SoHieuCB, lb.MaLB, lb.GioDi FROM LICHBAY AS lb
INNER JOIN CHUYENBAY AS cb ON lb.SoHieuCB = cb.SoHieuCB
WHERE cb.SBDi = 'SGN' AND YEAR(lb.GioDi) = 2025 AND EXISTS(
    SELECT 1 FROM DATVE AS dv
    WHERE dv.MaLB = lb.MaLB AND TTDatVe <> 'Huỷ'
    GROUP BY dv.MaDV
    HAVING SUM(SLVe) >= lb.SLVeKT
);























