# Prim_MIPS
Thuật toán Prim tìm cây khung nhỏ nhất trong đồ thị vô hướng trọng số nguyên dương viết bằng hợp ngữ.

### Input
Đồ thị vô hướng trọng số nguyên dương được nhập từ file hoặc nhập trực tiếp

 - Nhập từ file: lựa chọn 1 và nhập địa chỉ đầy đủ đến file. Ví dụ đầu vào từ file `D:/MST_input.txt`

```txt
0 2 0 6 0
2 0 3 8 5
0 3 0 0 7
6 8 0 0 9
0 5 7 9 0
```
  - Nhập trực tiếp: lựa chọn 2 rồi nhập số lượng đỉnh $V$, số lượng cạnh $M$ và sau đó nhập lần lượt các cạnh kèm với trọng số của nó. Nhãn của các đỉnh được đánh số từ $0 \to |V| - 1$.
```
Nhap so luong dinh V = 3
Nhap so luong canh M = 2
Nhap canh thu #0
Dinh dau: 0
Dinh cuoi: 1
Trong so canh: 1

Nhap canh thu #1
Dinh dau: 1
Dinh cuoi: 2
Trong so canh: 3
```

### Output

Sau khi nhập dữ liệu thành công thì chọn 3 để chạy thuật toán. Kết quả cho ra danh sách các cạnh trong cây khung nhỏ nhất.
