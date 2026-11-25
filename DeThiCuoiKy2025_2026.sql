-- a. Liệt kê mã thu nhập, nội dung, ngày phát sinh thu nhập và số tiền của các khoản thu nhập thuộc
-- loại thu nhập có tên là ‘Phụ cấp chức vụ’ phát sinh trong năm 2025. Sắp xếp kết quả trả về theo ngày
-- phát sinh thu nhập và mã thu nhập tăng dần. (1 điểm)
SELECT tn.MaTN, tn.NoiDung, tn.NgTN, tn.SoTien FROM THUNHAP AS tn
INNER JOIN LOAITHUNHAP AS ltn ON tn.MaLTN = ltn.MaLTN
WHERE ltn.TenLTN = 'Phụ cấp chức vụ' AND YEAR(tn.NgTN) = 2025
ORDER BY tn.NgTN, tn.MaTN ASC;

-- b. Liệt kê mã người phụ thuộc, họ tên và quan hệ của người phụ thuôc được giảm trừ với số tháng
-- là 12 tháng cho quyết toán thuế năm 2025 của người nộp thuế có mã số thuế cá nhân là ‘07012026’.
SELECT npt.MaNPT, npt.HoTen, npt.QuanHe FROM NGUOIPHUTHUOC AS npt
INNER JOIN GIAMTRUNPT AS gtnpt ON npt.MaNPT = gtnpt.MaNPT
WHERE gtnpt.SoThangGT = 12 AND EXISTS(
    SELECT 1 FROM NGUOINOPTHUE AS nnt
    INNER JOIN QTTHUE AS qtt ON nnt.MaNNT = qtt.MaNNT
    WHERE qtt.NamTT = 2025 AND qtt.MaQT = gtnpt.MaQT AND nnt.MaNNT = npt.MaNNT AND nnt.MSTCN = '07012026'
);

-- c. Cho biết mã và họ tên người nộp thuế có tổng thu nhập chịu thuế của quyết toán thuế năm 2025
-- lớn hơn 200.000.000 đồng, nhưng không có bất kỳ người phụ thuộc nào được giảm trừ với số tháng
-- là 12 tháng cho quyết toán thuế trong năm đó. (1 điểm)
SELECT nnt.MaNNT, nnt.HoTen FROM NGUOINOPTHUE AS nnt
INNER JOIN QTTHUE AS qtt ON nnt.MaNNT = qtt.MaNNT
WHERE qtt.NamTT = 2025 AND qtt.TNCT > 200000000 AND NOT EXISTS(
    SELECT 1 FROM NGUOIPHUTHUOC AS npt
    WHERE npt.MaNNT = nnt.MaNNT AND EXISTS(
        SELECT 1 FROM GIAMTRUNPT AS gtnpt
        WHERE gtnpt.MaNPT = npt.MaNPT AND gtnpt.MaQT = qtt.MaQT
        AND gtnpt.SoThangGT = 12
    )
);

-- d. Với mỗi quyết toán thuế có trạng thái đã hoàn thành, tính số lượng người phụ thuộc được giảm
-- trừ của từng người nộp thuế. Thông tin hiển thị: Mã và họ tên người nộp thuế, năm tính thuế, số lượng
-- người phụ thuộc. (1 điểm)
SELECT nnt.MaNNT, nnt.HoTen, qtt.NamTT, COUNT(DISTINCT gtnpt.MaNPT) AS SoLuongNPT FROM NGUOINOPTHUE AS nnt
INNER JOIN QTTHUE AS qtt ON nnt.MaNNT = qtt.MaNNT
LEFT JOIN GIAMTRUNPT AS gtnpt ON qtt.MaQT = gtnpt.MaQT
WHERE qtt.TTQT = 'Đã hoàn thành'
GROUP BY nnt.MaNNT, nnt.HoTen, qtt.NamTT
ORDER BY nnt.MaNNT, qtt.NamTT;

-- e. Tìm mã số thuế cá nhân, họ tên của người nộp thuế đã hoàn thành quyết toán thuế năm 2025 và
-- có phát sinh thu nhập thuộc tất cả các loại thu nhập không chịu thuế trong năm đó. (1 điểm)
SELECT nnt.MSTCN, nnt.HoTen FROM NGUOINOPTHUE AS nnt
INNER JOIN QTTHUE AS qtt ON nnt.MaNNT = qtt.MaNNT
WHERE qtt.NamTT = 2025 AND qtt.TTQT = 'Đã hoàn thành' AND EXISTS(
    SELECT 1 FROM THUNHAP AS tn
    WHERE tn.MaQT = qtt.MaQT AND YEAR(tn.NgTN) = qtt.NamTT
    AND NOT EXISTS(
        SELECT 1 FROM LOAITHUNHAP AS ltn
        WHERE tn.MaLTN = ltn.MaLTN AND ltn.ChiuThue <> 0
    )
);

-- f. Trong năm tính thuế 2025, tìm người nộp thuế có tổng thu nhập cao nhất và đã hoàn thành việc
-- quyết toán thuế ngay tại lần đóng tiền đầu tiên. Thông tin hiển thị: Mã và họ tên người nộp thuế, tổng
-- thu nhập. (1 điểm)
SELECT TOP 1 WITH TIES nnt.MaNNT, nnt.HoTen, qtt.TNCT + qtt.TNKCT AS tongThuNhap FROM NGUOINOPTHUE AS nnt
INNER JOIN QTTHUE AS qtt ON nnt.MaNNT = qtt.MaNNT
WHERE qtt.NamTT = 2025 AND qtt.TTQT = 'Đã hoàn thành'
ORDER BY qtt.TNCT + qtt.TNKCT DESC;
