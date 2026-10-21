# E115_01_01 Verilog 版本

本資料夾將 `E115_01_01` 的 9 個 VHDL 模組轉為 Verilog-2001。來源為提交 `6b1275935f1a3d37da391cf71b612d6f711c08a4`；原始資料夾保持不變，設計原作者資訊請參閱原始 VHDL。

以 Quartus 開啟本資料夾的 `E115_01_01.qpf`。裝置維持 Cyclone III `EP3C40Q240C8`，原有 51 個腳位指定保留；模組與訊號統一使用小寫，頂層為 `e115_01_01`。QSF 已同步調整名稱、明列 9 個 `.v`，並移除原電腦的絕對路徑。舊的報告、快取與 SOF 不複製，須重新編譯。

Verilog 保留原有的時脈、重設極性、訊號與程序變數賦值順序、參數和查表內容。多維查表陣列以平坦向量表示，VHDL 左界元素在最高位；UART、WS2812B 緩衝區及 ROM 保留為記憶體陣列。原 ADC 陣列的範圍寫為 `0..635535`，搖桿輸入則為 `0..65536`；連接時明確取 17 位，涵蓋全部 16 位 ADC 數值。

原 VHDL 的部分敏感度清單未包含其非同步控制訊號。因此，`.v` 在一般模擬時保留原敏感度與邊緣事件，定義 `SYNTHESIS` 時則使用可供綜合辨識的時脈／非同步控制事件。QSF 已設定 `SYNTHESIS=1`。這保留來源的模擬與綜合差異，未重新設計控制邏輯。

## ROM 字型檔

來源儲存庫未包含 `E115_01_01_w_2space原始編碼.mif`。請將原始 MIF 放入本資料夾，或調整頂層參數 `ram_init_file_fnset`。ROM 保留 Quartus 的 `ram_init_file` 屬性；未補上資料前無法驗證完整字型畫面。模擬 ROM 可使用 `sim_hex_file` 參數指定每行一個 16 位十六進位字的檔案，MIF 與此 HEX 格式不能混用。

## 驗證

安裝 Python 3、GHDL 與 Icarus Verilog 後，從任意目錄執行：

```sh
python3 E115_01_01_verilog/validation/compare_vhdl.py
```

此腳本以相同輸入比對 7 個周邊模組的原 VHDL 與 Verilog，另外檢查完整頂層在兩個前處理路徑的編譯，以及 ROM 的時脈延遲與相鄰位址讀取。詳細範圍與限制見 [validation/RESULTS.md](validation/RESULTS.md)。尚未執行 Quartus 綜合、布局繞線、時序分析或實板測試。
