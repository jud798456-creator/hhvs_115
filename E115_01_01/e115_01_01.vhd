--115工科技藝競賽數位電子職種
--115工科技藝競賽數位電子術科模擬試題一:資訊顯示與座標控制系統
--115.07.xx
--DHT11溫濕度感測器測試:1 wire

--k4x4: kn->kv
--(0:s1啟動/停止鍵, 1:s2開始鍵, 2:s3旋轉鍵, 7:s4檢查鍵) (3:s5上鍵, 4:s6下鍵, 5:s7左鍵, 6:s8右鍵)
	--k4x4:
	--位置碼kn	鍵值kv X
--	0123		01xx =>	16		16		16		16
--	4567	->	27xx =>	16		 0		 1		16
--	89AB	->	xxxx =>	16		 2		 7		16
--	CDEF		xxxx =>	16		16		16		16 

--TFT_LCD128x160(132x162)(st7735)
--st7735_spi_tft_lcd_4w_driver_4(109版範例秀:E109_01_01_4_1_E109_01_01_rom_4)

--SD178BMI2C 語音播放模組
--SD178B address = 0b0100 000 (7 bits)
--SD178BMI2C指令表
--80H:停止、結束(即時執行命令碼)
--81H:增加音量0.5db(即時執行命令碼)
--82H:減少音量0.5db(即時執行命令碼)
--送完每個即刻執行的命令碼後，須等20ms後，才能再傳送I2C資料
--===========================================================
--以下2019 02 12 V2.2 版(修正舊版錯誤及新增指令)
--新增8F xx 2byte 指令
--02 8F 00 --Pause暫停
--02 8F 01 --Resume取消暫停
--02 8F 02 --Skip 提前結束正執行的87H或88H指令，跳至下一指令
--02 8F 03 --Soft Reset 重新開機
--
--===========================================================
--83H U8:調整播放速度比原始速度快U8%(00H~28H=0~40%)
--86H U8:設定輸出音量大小為U8(FFH FEH~01H 00H:0db,-0.5db,...,-127db,靜音無聲)預設音量值為D2H
--87H U32:延遲U32 ms時間(單位:ms)(高byte~低byte 00H00H00H80H=128ms)
--88H U16A U16B:播放microSD卡的wave音檔(U16A為檔名:1001~9999.wav 03E9H~270FH ,U16B:為循環播放次數，0表示無限次)
--1001:03E9,2000:07D0,3000:0BB8,4000:0FA0,5000:1388,6000:1770,7000:1B58,8000:1F40,9000:2328
--8AH U8:控制輸出接腳MO2~MO0狀態(U8[b2:b0]對應MO2~MO0狀態)

--8BH U8:Audio Amplifier WM8960 輸出通道控制
--	        WM8960 Audio 輸出通道開/關表
--通道	 Line Out 	  耳機		      喇叭
--代號	HP_R  HP_L 	HP_R  HP_L	 SPK_RN  SPK_LN
--U8	   AGND	 	OUT3(HP_C)	 SPK_RP  SPK_LP
--01H 	...................................Ⅴ
--02H 	...........................Ⅴ
--03H 	...........................Ⅴ......Ⅴ
--04H 	.............Ⅴ....Ⅴ
--05H 	...................Ⅴ..............Ⅴ
--06H 	.............Ⅴ............Ⅴ
--07H(預設)..........Ⅴ....Ⅴ......Ⅴ......Ⅴ
--08H 	.Ⅴ...Ⅴ
--09H 	......Ⅴ...........................Ⅴ
--0AH 	.Ⅴ........................Ⅴ
--0BH 	.Ⅴ...Ⅴ...................Ⅴ......Ⅴ

--wifi uart:use x1

--115.07.xx版
--creator bye HGL

--請使用秉華科技有限公司 TEL:04-26229199 www.be-friend.com.tw
--產品編號:BF-CYC3-S40APVC (EP3C40Q240C8 50MHz LEs:39,600 PINs:161)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

-- -----------------------------------------------------
entity E115_01_01 is
generic(
--		addr_length_N : natural:= 2687;--定義記憶體深度:0~addr_length_N
--		--24*32 x15(0)=>0123456789space[],:
--		--32*32 *27(960)=>ABCDEFGHIJKLMNOPQRSTUVWXYZspace
--		ram_init_file_fnset : string:="E115_01_01_w_1原始編碼.mif";--定義記憶體初始值設定檔名
		
		addr_length_N : natural:= 2751;--定義記憶體深度:0~addr_length_N
		--24*32 x15(0)=>0123456789space[],:
		--32*32 *27(960)=>ABCDEFGHIJKLMNOPQRSTUVWXYZspacespace
		ram_init_file_fnset : string:="E115_01_01_w_2space原始編碼.mif";--定義記憶體初始值設定檔名

		TXRD_buff_N:natural:=511;
		OV2640_image_WS:natural:=128;
		OV2640_image_HS:natural:=160
		);
port(SCLK,S_RESET:in std_logic;			--系統 clk,reset

	 M7_0:in std_logic_vector(8 downto 0);--搖桿SW8+指撥開關76543210 

	 --k4x4鍵盤
	 ko:buffer std_logic_vector(1 downto 0);--偵測掃瞄線
	 ki:in std_logic_vector(1 downto 0);	--檢查回饋線
	 koo,kxx,Joystickxx:buffer std_logic;				--觀察用(可有可無或不接線)
	 kout:out integer range 0 to 16;		--觀察用

	 --D7S
	 SCANo:buffer std_logic_vector(7 downto 0);	--掃瞄信號
	 D7LED:buffer std_logic_vector(7 downto 0);	--顯示資料
--
--	 --串列式4位七段顯示器模組(4位or8位:74HC595 & 74HC595)驅動器
--	 D74HC595_SCLK: buffer std_logic;--74HC595_SCLK
--	 D74HC595_RCLK: buffer std_logic;--74HC595_RCLK
--	 D74HC595_SDi: out std_logic;	--74HC595_SDi
--
--	 --串列式8位七段顯示器模組(MAX7219)驅動器
--	 MAX7219_DIN: out std_logic;
--	 MAX7219_CLK: buffer std_logic;
--	 MAX7219_LOAD: out std_logic;

	 --WS2812B
	 WS2812Bout:out std_logic;		--WS2812B_Di信號輸出:色彩資料發射輸出

--	 --MPU6050
--	 --MPU6050_AD0:in std_logic;		--裝置碼:選位
--	 MPU6050_INT:in std_logic;		--INT
--	 MPU6050_SCL:out std_logic;		--介面IO:SCL,如有接提升電阻時可設成inout
--	 MPU6050_SDA:inout std_logic;	--介面IO:SDA
--
--	 --ov2640
--	 OV2640_SCL:out std_logic;				--介面IO:SCL,如有接提升電阻時可設成inout
--     OV2640_SDA:inout std_logic;			--介面IO:SDA
--     OV2640_Dx:in std_logic_vector(7 downto 0);
--     OV2640_PLCK,OV2640_VSYNC,OV2640_HREF:in std_logic;--,OV2640_HREF
--     OV2640_RESET:buffer std_logic;	--OV2640_PWDN不接

     --ADS1115
	 ADS1115_SCL:out std_logic;					--介面IO:SCL,如有接提升電阻時可設成inout
	 ADS1115_SDA:inout std_logic;				--介面IO:SDA
	 ADS1115_ALERT_RDY:in std_logic;			--ready
--	 --電阻式觸控板
--	 TouchPAD_Vud_Hlr:inout std_logic_vector(3 downto 0):="ZZZZ";

	 --tft_lcd_st7735_4w(CS,DC,SCL,SDA)+RES+BL----1.8'133x162 RGB TFT_LCD--108.07.20
     st7735_RESX:out std_logic;				--介面IO:RESx輸出
     st7735_CS:buffer std_logic;			--介面IO:CSx輸出
     st7735_DC:out std_logic;				--介面IO:DCx輸出
     st7735_SCL:buffer std_logic;			--介面IO:SCL輸出
     st7735_SDA:out std_logic;				--介面IO:SDA輸出
     st7735_BL:out std_logic;				--介面IO:SDA輸出

--     --L293D DC motor 驅動IC
--     --直流馬達可單向或雙向運轉驅動,或雙極性步進馬達驅動
--     --輸出電流可達1A/L293 (600mA/L293D),電流要加倍時可將Y輸出並聯
--     --目前使用方式:12組:直流馬達--34組:電源輸出控制(SD178BMI2C語音模組)
--	 L293D_1A:buffer std_logic;		--介面IO:1A輸出:high ->1Y high
--	 L293D_2A:buffer std_logic;		--介面IO:2A輸出:high ->2Y high
--	 L293D_12EN:buffer std_logic;	--介面IO:12EN輸出:active high,low->1Y&2Y->Hz
--	 L293D_3A:buffer std_logic;		--介面IO:3A輸出:high ->3Y high
--	 L293D_4A:buffer std_logic;		--介面IO:4A輸出:high ->4Y high
--	 L293D_34EN:buffer std_logic;	--介面IO:34EN輸出:active high,low->3Y&4Y->Hz

	 --2025.07.30
	 --RS232(UART)
--	 S_RESET_T:buffer std_logic;
	 RD:in std_logic;
	 TX:out std_logic
    );
end E115_01_01;

-- -----------------------------------------------------
architecture HGL of E115_01_01 is
	--2024.03.30
	--RS232_T1 & RS232_R2
	--RS232_T1
	component RS232_T4 is
	generic(TXRD_buff : natural:= TXRD_buff_N);
	port(clk,Reset:in std_logic;--clk:25MHz
		 DL:in std_logic_vector(1 downto 0);	 --00:5,01:6,10:7,11:8 Bit
		 ParityN:in std_logic_vector(2 downto 0);--000:None,100:Even,101:Odd,110:Space,111:Mark
		 StopN:in std_logic_vector(1 downto 0);	 --0x:1Bit,10:2Bit,11:1.5Bit
		 F_Set:in std_logic_vector(3 downto 0);	--BaudRate:000:1200,001:2400,010:4800,011:9600,100:19200,101:38400,110:57600,111:115200
		 Status_s:out std_logic_vector(1 downto 0);
		 TX_W:in std_logic;
		 TXData:in std_logic_vector(7 downto 0);
		 TX:out std_logic);
	end component;
	--RS232_R3
	component RS232_R4 is
	generic(TXRD_buff : natural:= TXRD_buff_N);
	port(Clk,Reset:in std_logic;--clk:25MHz
		 DL:in std_logic_vector(1 downto 0);	 --00:5,01:6,10:7,11:8 Bit
		 ParityN:in std_logic_vector(2 downto 0);--0xx:None,100:Even,101:Odd,110:Space,111:Mark
		 StopN:in std_logic_vector(1 downto 0);	 --0x:1Bit,10:2Bit,11:1.5Bit
		 F_Set:in std_logic_vector(3 downto 0);	--BaudRate:000:1200,001:2400,010:4800,011:9600,100:19200,101:38400,110:57600,111:115200
		 Status_s:out std_logic_vector(2 downto 0);
		 RX_BBN:buffer integer range 0 to TXRD_buff_N+1;--511;	--buffer 現有資料量--2024.03.30
		 Rx_R:in std_logic;
		 RD:in std_logic;
		 RxDs:out std_logic_vector(7 downto 0));
	end component;
	---1
	constant DL:std_logic_vector(1 downto 0):="11";	 	 --00:5,01:6,10:7,11:8 Bit
	constant ParityN:std_logic_vector(2 downto 0):="000";--0xx:None,100:Even,101:Odd,110:Space,111:Mark
	constant StopN:std_logic_vector(1 downto 0):="00";	 --0x>1Bit,10>2Bit,11>1.5Bit
	constant F_Set:std_logic_vector(3 downto 0):="1011";
	--BaudRate:0000:300,0001:600,0010:1200,0011:2400,0100:4800,0101:9600,0101:19200,0111:28800,
	--		   1000:38400,1001:57600,1010:76800,1011:115200,1100:230400,1101:460800,1110:576000,1111:921600

	
	signal S_RESET_T:std_logic;						--Rs232 reset傳送
	signal TX_W:std_logic;							--寫入緩衝區
	signal Status_Ts:std_logic_vector(1 downto 0);	--傳送狀態
	signal TXData:std_logic_vector(7 downto 0);		--傳送資料
	
	signal S_RESET_R:std_logic;						--Rs232 reset接收
	signal Rx_R:std_logic;							--讀出緩衝區
	signal Status_Rs:std_logic_vector(2 downto 0);	--接收狀態
	signal RxDs:std_logic_vector(7 downto 0);		--接收資料
	---2
	constant DL2:std_logic_vector(1 downto 0):="11";	 	 --00:5,01:6,10:7,11:8 Bit
	constant ParityN2:std_logic_vector(2 downto 0):="000";--0xx:None,100:Even,101:Odd,110:Space,111:Mark
	constant StopN2:std_logic_vector(1 downto 0):="00";	 --0x>1Bit,10>2Bit,11>1.5Bit
	constant F_Set2:std_logic_vector(3 downto 0):="1011";
	--BaudRate:0000:300,0001:600,0010:1200,0011:2400,0100:4800,0101:9600,0101:19200,0111:28800,
	--		   1000:38400,1001:57600,1010:76800,1011:115200,1100:230400,1101:460800,1110:576000,1111:921600
	
	--signal S_RESET_T2:std_logic;						--Rs232 reset傳送
	signal TX_W2:std_logic;							--寫入緩衝區
	signal Status_Ts2:std_logic_vector(1 downto 0);	--傳送狀態
	signal TXData2:std_logic_vector(7 downto 0);		--傳送資料
	
	signal S_RESET_R2:std_logic;						--Rs232 reset接收
	signal Rx_R2:std_logic;							--讀出緩衝區
	signal Status_Rs2:std_logic_vector(2 downto 0);	--接收狀態
	signal RxDs2:std_logic_vector(7 downto 0);		--接收資料	
		
	--2024.03.30
	signal Rdatalength,Rdatalength2:integer range 0 to TXRD_buff_N+1;--511;	--buffer 現有資料量--2024.03.30
	type ESP8266com_T is array (0 to TXRD_buff_N) of std_logic_vector(7 Downto 0);
	signal FPGA_ESP8266,ESP8266_FPGA,FPGA_ESP82662,ESP8266_FPGA2:ESP8266com_T;
	
	type ESP8266com_T2 is array (0 to TXRD_buff_N) of integer range 0 to 255;
	signal ESP8266_FPGA_int:ESP8266com_T2;
	signal pre_item:std_logic_vector(7 downto 0);
	
	--指令
	signal instruction,instruction2:std_logic_vector(7 downto 0);
	signal CMDn,CMDn_R,CMDnS,CMDn_RS:integer range 0 to TXRD_buff_N;	--Rs232傳出數,接收數
	--signal CMDn2,CMDn_R2,CMDnS2,CMDn_RS2:integer range 0 to TXRD_buff_N;	--Rs232傳出數,接收數
	signal ESP8266RESETtime:integer range 0 to 1000;
	signal ESP8266_POWER:std_logic:='0';	--經由L293D提供可控電源
	
	signal sys_uartFs:std_logic:='0';	--系統操作頻率選擇
	-- component=================================================================
	--tft_lcd_t7735 driver: 1.8'128x160 RGB TFT_LCD特急超飆速版
	component st7735_spi_tft_lcd_4w_driver_3 is
	   port(  st7735_CLK,st7735_RESET:in std_logic;		--系統時脈,系統重置
			  st7735_RES:in std_logic;					--介面控制:RESx輸入
			  st7735_BLS:in std_logic;					--介面控制:BL輸入
			  DCi:in std_logic_vector(1 downto 0);		--00:命令 01:命令參數 11:g資料
			  cmpai:in std_logic_vector(15 downto 0);	--命令_參數 輸入,水平16點image
			  cbi:in std_logic_vector(3 downto 0);		--色盤(4bit):xx01(12bit)、xx10(16bit)、xx11(18bit)
			  fcri,fcgi,fcbi:in std_logic_vector(7 downto 0);--色系
			  bcri,bcgi,bcbi:in std_logic_vector(7 downto 0);--色系
			  d8_1i:in integer range 0 to 16;			--水平剩餘點數1~16
			  shift_Hdni:integer range 0 to 15;			--水平shift點數0..15
			  --------------------------------------------------------------
			  st7735_RESX:out std_logic;				--介面IO:RESx輸出
			  st7735_CS:buffer std_logic;				--介面IO:CSx輸出
			  st7735_DC:out std_logic;					--介面IO:DCx輸出
			  st7735_SCL:buffer std_logic;				--介面IO:SCL輸出
			  st7735_SDA:out std_logic;					--介面IO:SDA輸出
			  st7735_BL:out std_logic;					--介面IO:BL輸出
			  --------------------------------------------------------------
			  st7735_reLOAD:out std_logic;				--載入旗標:0 可載入
			  st7735_LoadCK:in std_logic;				--載入時脈
			  st7735_spi_ok:buffer std_logic 			--完成旗標
			);
	end component st7735_spi_tft_lcd_4w_driver_3;
	signal st7735_CLK,st7735_RESET: std_logic;		--系統時脈,系統重置
	signal st7735_RES: std_logic;					--介面IO:RESx輸入
	signal st7735_BLS: std_logic;					--介面IO:BL輸入
	signal DCi: std_logic_vector(1 downto 0);		--00:命令 01:命令參數 11:g資料
	signal cmpai: std_logic_vector(15 downto 0);	--命令_參數 輸入,水平16點image
	signal cbi: std_logic_vector(3 downto 0);		--色盤(4bit):xx01(12bit)、xx10(16bit)、xx11(18bit)
	signal fcri,fcgi,fcbi: std_logic_vector(7 downto 0);--色系
	signal bcri,bcgi,bcbi: std_logic_vector(7 downto 0);--色系
	signal d8_1i:integer range 0 to 16;				--水平剩餘點數1~16
	signal shift_Hdni:integer range 0 to 15;			--水平shift點數0..15
	signal st7735_reLOAD: std_logic;				--載入旗標:0 可載入
	signal st7735_LoadCK: std_logic;				--載入時脈
	signal st7735_spi_ok: std_logic;				--完成旗標

	---------------------------------------------------
	Component E111_01_01_rom is
	generic(addr_length : natural:= addr_length_N;--定義記憶體深度:0~addr_length_N個
			ram_init_file_set : string:=ram_init_file_fnset);--定義記憶體初始值設定檔名
	Port(addr:in natural range 0 to addr_length;--定義記憶體深度:0~addr_length個
		 clk:in std_logic;
		 q:out std_logic_vector(15 downto 0);
		 qq:out std_logic_vector(15 downto 0));
	End Component;
	Signal q:std_logic_vector(15 downto 0);

	---------------------------------------------------
	component k4x4 is
	port 
	(	kf,reset: in std_logic;
		ki: in std_logic_vector(1 downto 0);
		ko: buffer std_logic_vector(1 downto 0);
		kn,kv: buffer integer range 0 to 16;
		kASCII: out std_logic_vector(7 downto 0);
		kok,koo: buffer std_logic	--koo測試觀察用169
	);
	end component;
	signal kf,kreset:std_logic;
	signal kn,kv:integer range 0 to 16;--鍵盤操作
	signal kASCII:std_logic_vector(7 downto 0);
	signal kok:std_logic;

--	--串列式4位七段顯示器模組(4位or8位:74HC595 & 74HC595)驅動器-----
--	component D74HC595_serial_driver is
--		port 
--		(	D7Sx4f,reset: in std_logic;		--移位速率,重置
--			Ds7x4_s_D: in std_logic_vector(7 downto 0);--本次字形
--			Ds7x4_s_N: in integer range 0 to 7;--本次位數
--			D74HC595_SCLK: buffer std_logic;	--74HC595_SCLK
--			D74HC595_RCLK: buffer std_logic;	--74HC595_RCLK
--			D74HC595_SDi: out std_logic			--74HC595_SDi
--		);
--	end component;

--	--串列式8位七段顯示器模組(MAX7219)驅動器-------------------------
--	component max7219_D7Sx8_serial_driver is
--		port 
--		(	MAX7219f,reset: in std_logic;			--移位速率,重置
--			MAX7219_s_D: in std_logic_vector(7 downto 0);--本次信息
--			MAX7219_s_A: in integer range 0 to 15;	--本次置
--			MAX7219_DIN: out std_logic;
--			MAX7219_CLK: buffer std_logic;
--			MAX7219_LOAD: out std_logic
--		);
--	end component;
--	Signal MAX7219_s_D:std_logic_vector(7 downto 0):="11111111";
--	Signal MAX7219_s_A:integer range 0 to 15:=1;
--	Signal isMAX7219_s_intensity,isMAX7219_s_scan:boolean:=false;--亮度,掃瞄位數
--	Signal MAX7219_s_intensity:integer range 0 to 15:=8;--0~15亮度
--	Signal MAX7219_s_scan:integer range 0 to 7:=7;--0~7

	--WS2812B_Driver-------------------------------------------------
	component WS2812B_Driver is
		port(	WS2812BCLK,WS2812BRESET,WS2812B_loadck:in std_logic;--操作頻率,重置,載入ck
				WS2812B_LEDGRBdata:in std_logic_vector(23 downto 0);--色彩資料
				WS2812B_reload,WS2812B_emitter_ok,WS2812Bout:out std_logic		--要求載入,發射狀態,發射輸出 
		);
	end component;
	Signal WS2812BCLK,WS2812BRESET,WS2812B_loadck:std_logic;--操作頻率,載入ck
	Signal WS2812B_LEDGRBdata:std_logic_vector(23 downto 0);--色彩資料
	Signal WS2812B_reload,WS2812B_emitter_ok:std_logic;	--要求載入,發射狀態
	signal FD2:std_logic_vector(3 downto 0);	--WS2812B_Driver除頻器
	signal WS2812BP_reset,WS2812BP_ok,WS2812BPCK:std_logic;
	signal WS2812BP_time_Dn:integer range 0 to 5000:=0;--5s

	type WS2812B_cT0 is array (0 to 2) of std_logic_vector(7 Downto 0);--(R,G,B)
	type WS2812B_cT1 is array (0 to 15) of WS2812B_cT0;
	signal WS2812B_8baseCOLOR:WS2812B_cT1:=((X"00",X"00",X"00"),--0 BLACK
										    (X"FF",X"00",X"00"),--1 RED
										    (X"00",X"FF",X"00"),--2 GREEN
										    (X"00",X"00",X"FF"),--3 BLUE
										    (X"FF",X"FF",X"00"),--4 YELLOW
										    (X"FF",X"00",X"FF"),--5 MAGENTA
										    (X"00",X"FF",X"FF"),--6 CYAN
										    (X"FF",X"FF",X"FF"),--7 WHITE
										    (X"9E",X"AA",X"29"),--8 user defined
										    (X"D2",X"CC",X"63"),--9 user defined
										    (X"BD",X"FD",X"C4"),--10 user defined
										    (X"00",X"00",X"00"),--11 user defined
										    (X"00",X"00",X"00"),--12 user defined
										    (X"00",X"00",X"00"),--13 user defined
										    (X"00",X"00",X"00"),--14 user defined
										    (X"00",X"00",X"FF")--15 user defined
										   );--user defined

	--色彩轉換表
	type WS2812B_8cT is array (0 to 7) of integer range 0 to 7;	
									-- 0,1,2,3,4,5,6,7
	signal WS2812B_8cRGB:WS2812B_8cT:=(0,3,2,6,1,5,4,7);--RGB
	signal WS2812B_8cGRB:WS2812B_8cT:=(0,3,1,5,2,6,4,7);--GRB

	--單色配色指定
	signal WS2812B_B1_COLORi:integer range 0 to 15:=1;
	signal WS2812B_B0_COLORi:integer range 0 to 15:=2;

	signal WS2812B_dir:integer range 0 to 15:=0;--傳送順序
	signal WS2812B_xyshift:integer range 0 to 63:=0;
	signal WS2812B_flash_enable,WS2812B_flashNES:std_logic;--閃爍致能，回原始
	signal WS2812B_flashNS:integer range 0 to 15;--閃爍次數:0:結束，1~14次，15無限次數	
	signal WS2812B_flash_add:std_logic_vector(0 to 63);
	signal WS2812B_flash_adds:integer range 0 to 15;	--0:原狀 1:圖1 2:LED硬體1 3:圖雙1-2 4:LED硬體雙1-2 5:顏色1 6:雙顏色1-2 7:不等於顏色1 8:不等於雙顏色1-2
	signal WS2812B_ColorS1,WS2812B_ColorD1,WS2812B_ColorS2,WS2812B_ColorD2:std_logic_vector(23 downto 0);
	signal WS2812B_flash_speed:integer range 0 to 7;

	signal WS2812B_mask_enable:std_logic;--mask致能
	signal WS2812B_mask_add:std_logic_vector(0 to 63);--mask addr
	signal WS2812B_mask_adds:integer range 0 to 3;	--1:圖1 2:LED硬體1
	signal WS2812B_mask_Ms:integer range 0 to 15;--0:原狀 1:not 2:and 3:or 4:xor
	signal WS2812B_maskColorS1or2:integer range 0 to 15;--0:無 1:ColorS1 2:ColorS1 & ColorS2 3:/=ColorS1 4:/=(ColorS1 & ColorS2)
	signal WS2812B_maskColorS1,WS2812B_maskColorS2:std_logic_vector(23 downto 0);
	signal WS2812B_mask_R,WS2812B_mask_G,WS2812B_mask_B:std_logic_vector(7 downto 0);--mask


	signal WS2812B_xy:integer range 0 to 63;
	signal WS2812B_reset0:std_logic;			--啟動WS2812B首次清空

	--色彩操作方法選定:0~8
	signal WS2812BP_Ms:integer range 0 to 15;
	--0:基本色指定色:WS2812B_COLORsc1:0~15
	signal WS2812B_COLORsc1:integer range 0 to 15;

	--1:單色圖64bit指定色
	type WS2812B_t64 is array (0 to 1) of std_logic_vector(63 Downto 0);
	signal WS2812B_64:WS2812B_t64:=("0000000000000000000010000000100000001000000010000000100011111111","0000000000001000000010000000100001111110000010000000100000000000");
	signal WS2812B_64P:integer range 0 to 1:=0;

	--2:單色圖(8x8bit)指定色:0~7
	type WS2812B_t8x8_1 is array (0 to 7) of std_logic_vector(7 Downto 0);
	type WS2812B_t8x8 is array (0 to 1) of WS2812B_t8x8_1;
	signal WS2812B_8x8:WS2812B_t8x8:=((X"00",X"08",X"08",X"08",X"7E",X"08",X"08",X"00"),(X"00",X"08",X"08",X"08",X"7E",X"08",X"08",X"FF"));
	signal WS2812B_8x8P:integer range 0 to 1:=0;

	--3:單色圖(16x4bit)指定色:0~3
	type WS2812B_t16x4_1 is array (0 to 3) of std_logic_vector(15 Downto 0);
	type WS2812B_t16x4 is array (0 to 1) of WS2812B_t16x4_1;
	signal WS2812B_16x4:WS2812B_t16x4:=((X"0008",X"0808",X"7E08",X"08FF"),(X"0008",X"FE08",X"7E08",X"08FF"));
	signal WS2812B_16x4P:integer range 0 to 1:=0;

	--4:RGB 8色圖:RGB3bitx64:0~63
	type WS2812B_tRGB3bit_1 is array (0 to 63) of std_logic_vector(2 Downto 0);
	type WS2812B_tRGB3bit is array (0 to 1) of WS2812B_tRGB3bit_1;
	signal WS2812B_RGB3bitx64:WS2812B_tRGB3bit:=(
	("111","111","111","111","111","111","111","111","000","000","000","000","000","000","000","000","011","011","011","011","011","011","011","011","101","101","101","101","101","101","101","101","110","110","110","110","110","110","110","110","001","001","001","001","001","001","001","001","010","010","010","010","010","010","010","010","100","100","100","100","100","100","100","100"),
	("000","000","000","000","000","000","000","000","011","011","011","011","011","011","011","011","101","101","101","101","101","101","101","101","110","110","110","110","110","110","110","110","001","001","001","001","001","001","001","001","010","010","010","010","010","010","010","010","100","100","100","100","100","100","100","100","111","111","111","111","111","111","111","111")
	);
	signal WS2812B_RGB3bitx64P:integer range 0 to 1:=0;
	
	--5:RGB 8色圖(3bit:0~7):0~63
	type WS2812B_tRGB3bit_2 is array (0 to 63) of integer range 0 to 7;
	type WS2812B_tRGB3bit2 is array (0 to 2) of WS2812B_tRGB3bit_2;
	signal WS2812B_RGB3bitNx64:WS2812B_tRGB3bit2:=(
	(1,2,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
	(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,4,0,0,0,0,0,0,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
	((others=>0))
	);
	signal WS2812B_RGB3bitNx64P:integer range 0 to 2:=0;

	--6:RGB 8色圖(RGB轉色表N:3bit:0~7):0~63 
	type WS2812B_tRGB3bit_3 is array (0 to 63) of integer range 0 to 7;
	type WS2812B_tRGB3bit3 is array (0 to 1) of WS2812B_tRGB3bit_3;
	signal WS2812B_RGB3bitTNx64:WS2812B_tRGB3bit3:=(
	(5,1,1,1,1,1,2,2,2,2,2,1,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,1,2,2,2,2,2,2,2,1,2,1,2,2,2,2,2,1,1,2,2,2,2,2,2,1,2,2,2,3),
	(1,2,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,6,5,4,3,2,1,0)
	);
	signal WS2812B_RGB3bitTNx64P:integer range 0 to 1:=0;

	--7:RGB 8色圖:RGB3bitx64:0~63
	type WS2812B_tGRB3bit_1 is array (0 to 63) of std_logic_vector(2 Downto 0);
	type WS2812B_tGRB3bit is array (0 to 1) of WS2812B_tGRB3bit_1;
	signal WS2812B_GRB3bitx64:WS2812B_tGRB3bit:=(
	("111","111","111","111","111","111","111","111","000","000","000","000","000","000","000","000","011","011","011","011","011","011","011","011","101","101","101","101","101","101","101","101","110","110","110","110","110","110","110","110","001","001","001","001","001","001","001","001","010","010","010","010","010","010","010","010","100","100","100","100","100","100","100","100"),
	("000","000","000","000","000","000","000","000","011","011","011","011","011","011","011","011","101","101","101","101","101","101","101","101","110","110","110","110","110","110","110","110","001","001","001","001","001","001","001","001","010","010","010","010","010","010","010","010","100","100","100","100","100","100","100","100","111","111","111","111","111","111","111","111")
	);
	signal WS2812B_GRB3bitx64P:integer range 0 to 1:=0;

	--8:RGB 8色圖(3bit:0~7):0~63
	type WS2812B_tGRB3bit_2 is array (0 to 63) of integer range 0 to 7;
	type WS2812B_tGRB3bit2 is array (0 to 2) of WS2812B_tGRB3bit_2;
	signal WS2812B_GRB3bitNx64:WS2812B_tGRB3bit2:=(
	(1,2,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
	(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,4,0,0,0,0,0,0,4,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
	((others=>0))
	);
	signal WS2812B_GRB3bitNx64P:integer range 0 to 2:=0;

	--9:全彩色圖RGB :8R8G/8B80=16bitx2 x64:0~127
	type WS2812B_t8R8G_8B16bit_1 is array (0 to 127) of std_logic_vector(15 Downto 0);
	type WS2812B_t8R8G_8B16bit is array (0 to 1) of WS2812B_t8R8G_8B16bit_1;
	signal WS2812B_8R8G_8B16bit:WS2812B_t8R8G_8B16bit:=(
	(X"FFFF",X"FF00",X"FFFF",X"FF00",X"FFFF",X"FF00",X"FFFF",X"FF00",X"FFFF",X"FF00",X"FFFF",X"FF00",X"FFFF",X"FF00",X"FFFF",X"FF00",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"00FF",X"FF00",X"00FF",X"FF00",X"00FF",X"FF00",X"00FF",X"FF00",X"00FF",X"FF00",X"00FF",X"FF00",X"00FF",X"FF00",X"00FF",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FFFF",X"0000",X"FFFF",X"0000",X"FFFF",X"0000",X"FFFF",X"0000",X"FFFF",X"0000",X"FFFF",X"0000",X"FFFF",X"0000",X"FFFF",X"0000",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"00FF",X"0000",X"00FF",X"0000",X"00FF",X"0000",X"00FF",X"0000",X"00FF",X"0000",X"00FF",X"0000",X"00FF",X"0000",X"00FF",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"0000"),
	(X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"00FF",X"FF00",X"00FF",X"FF00",X"00FF",X"FF00",X"00FF",X"FF00",X"00FF",X"FF00",X"00FF",X"FF00",X"00FF",X"FF00",X"00FF",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FF00",X"FFFF",X"0000",X"FFFF",X"0000",X"FFFF",X"0000",X"FFFF",X"0000",X"FFFF",X"0000",X"FFFF",X"0000",X"FFFF",X"0000",X"FFFF",X"0000",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"00FF",X"0000",X"00FF",X"0000",X"00FF",X"0000",X"00FF",X"0000",X"00FF",X"0000",X"00FF",X"0000",X"00FF",X"0000",X"00FF",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FF00",X"0000",X"FFFF",X"FF00",X"FFFF",X"FF00",X"FFFF",X"FF00",X"FFFF",X"FF00",X"FFFF",X"FF00",X"FFFF",X"FF00",X"FFFF",X"FF00",X"FFFF",X"FF00")
	);
	signal WS2812B_8R8G_8B16bitP:integer range 0 to 1:=0;

	--10:全彩色圖GRB :8G8R8B24bit:0~63
	type WS2812B_t8G8R8B24bit_1 is array (0 to 63) of std_logic_vector(23 Downto 0);
	type WS2812B_t8G8R8B24bit is array (0 to 1) of WS2812B_t8G8R8B24bit_1;
	signal WS2812B_8G8R8B24bit:WS2812B_t8G8R8B24bit:=(
	(X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"FFFF00",X"FF00FF",X"000000",X"00FFFF",X"00FFFF",X"000000",X"FF00FF",X"00FF00",X"FFFF00",X"000000",X"FF00FF",X"00FFFF",X"00FFFF",X"FF00FF",X"000000",X"00FF00",X"FFFF00",X"FFFFFF",X"FFFFFF",X"0000FF",X"FFFFFF",X"FFFFFF",X"FFFFFF",X"00FF00",X"FFFF00",X"FFFFFF",X"FFFFFF",X"FFFFFF",X"FF0000",X"FFFFFF",X"FFFFFF",X"00FF00",X"FFFF00",X"000000",X"FF00FF",X"00FFFF",X"00FFFF",X"FF00FF",X"000000",X"00FF00",X"FFFF00",X"FF00FF",X"000000",X"00FFFF",X"00FFFF",X"000000",X"FF00FF",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00"),
	(X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"FFFF00",X"FF0000",X"FF0000",X"FF0000",X"FF0000",X"FF0000",X"FF0000",X"00FF00",X"FFFF00",X"FF0000",X"FF00FF",X"00FFFF",X"00FFFF",X"FF00FF",X"FF0000",X"00FF00",X"0000FF",X"FF0000",X"FFFFFF",X"0000FF",X"00FF00",X"FFFFFF",X"FF0000",X"00FF00",X"0000FF",X"FF0000",X"FFFFFF",X"00FF00",X"FF0000",X"FFFFFF",X"FF0000",X"00FF00",X"FFFF00",X"FF0000",X"FF00FF",X"00FFFF",X"00FFFF",X"FF00FF",X"FF0000",X"00FF00",X"FFFF00",X"FF0000",X"FF0000",X"FF0000",X"FF0000",X"FF0000",X"FF0000",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00")
	);
	signal WS2812B_8G8R8B24bitP:integer range 0 to 1:=0;

	--11:全彩色圖RGB :8R8G8B24bit:0~63
	type WS2812B_t8R8G8B24bit_1 is array (0 to 63) of std_logic_vector(23 Downto 0);
	type WS2812B_t8R8G8B24bit is array (0 to 1) of WS2812B_t8R8G8B24bit_1;
	signal WS2812B_8R8G8B24bit:WS2812B_t8R8G8B24bit:=(
	(X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"FFFF00",X"FF00FF",X"000000",X"00FFFF",X"00FFFF",X"000000",X"FF00FF",X"00FF00",X"FFFF00",X"000000",X"FF00FF",X"00FFFF",X"00FFFF",X"FF00FF",X"000000",X"00FF00",X"FFFF00",X"FFFFFF",X"FFFFFF",X"0000FF",X"FFFFFF",X"FFFFFF",X"FFFFFF",X"00FF00",X"FFFF00",X"FFFFFF",X"FFFFFF",X"FFFFFF",X"FF0000",X"FFFFFF",X"FFFFFF",X"00FF00",X"FFFF00",X"000000",X"FF00FF",X"00FFFF",X"00FFFF",X"FF00FF",X"000000",X"00FF00",X"FFFF00",X"FF00FF",X"000000",X"00FFFF",X"00FFFF",X"000000",X"FF00FF",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00"),
	(X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"FFFF00",X"FF0000",X"FF0000",X"FF0000",X"FF0000",X"FF0000",X"FF0000",X"00FF00",X"FFFF00",X"FF0000",X"FF00FF",X"00FFFF",X"00FFFF",X"FF00FF",X"FF0000",X"00FF00",X"0000FF",X"FF0000",X"FFFFFF",X"0000FF",X"00FF00",X"FFFFFF",X"FF0000",X"00FF00",X"0000FF",X"FF0000",X"FFFFFF",X"00FF00",X"FF0000",X"FFFFFF",X"FF0000",X"00FF00",X"FFFF00",X"FF0000",X"FF00FF",X"00FFFF",X"00FFFF",X"FF00FF",X"FF0000",X"00FF00",X"FFFF00",X"FF0000",X"FF0000",X"FF0000",X"FF0000",X"FF0000",X"FF0000",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00",X"00FF00")
	);
	signal WS2812B_8R8G8B24bitP:integer range 0 to 1:=0;

--	------------------------------------------------------------------------
--	component MPU6050_I2C_256_driver is
--	   Port(I2CCLK,RESET:in std_logic;			--系統時脈,系統重置
--			MPU6050_AD0:in std_logic;			--裝置碼:選位
--			MPU6050_INT:in std_logic;
--			SCL:out std_logic;				--介面IO:SCL,如有接提升電阻時可設成inout
--			SDA:inout std_logic;				--介面IO:SDA
--	
--			MPU6050_AFS_SELP:in integer range 0 to 3;--+-2g(16384),+-4g(8192),+-8g(4096),+-16g(2048)
--			MPU6050_GFS_SELP:in integer range 0 to 3;--+-250°/S(131),+-500°/S(65.5),+-1000°/S(32.8),+-2000°/S(16.4)
--			MPU6050_Sample_Rate:in integer range 0 to 1000;
--			MPU6050_INTresponseNs:in integer range 0 to 255;--INT幾次後才回應1次
--			MPU6050_dpNs:in integer range 0 to 2;--小數位數
--	
--			MPU6050_uploadck:in std_logic;			--上傳速率
--			MPU6050_loadck:buffer std_logic;	--上傳速率操作
--			MPU6050upload:buffer boolean;		--啟動上傳
--			MPU6050_AxyzTGxyz_16bit:out std_logic_vector(15 downto 0);
--			MPU6050_AxyzTGxyz:out integer range 0 to 262143;--524287;
--			MPU6050_AxyzTGxyz_N:out integer range 0 to 65535;
--			MPU6050_AxyzTGxyz_PN:out integer range 0 to 1;
--			MPU6050_AxyzTGxyzs:in integer range 0 to 6
--			);
--	End component;
--	Signal MPU6050_dpNs:integer range 0 to 2:=0;--小數位數
--	Signal MPU6050_loadck:std_logic;--上傳速率操作
--	Signal MPU6050upload:boolean;		--啟動上傳
--	Signal MPU6050_AxyzTGxyz_16bit:std_logic_vector(15 downto 0);
--    Signal MPU6050_AxyzTGxyz:integer range 0 to 262143;--524287;
--    Signal MPU6050_AxyzTGxyz_N:integer range 0 to 65535;
--    Signal MPU6050_AxyzTGxyz_PN:integer range 0 to 1;
--    Signal MPU6050_AxyzTGxyzs:integer range 0 to 6;
--	--1-----
--	type MPU6050_NT is array (0 to 6) of integer range 0 to 65535;--正原始資料值
--	signal MPU6050_N:MPU6050_NT:=(0,0,0,0,0,0,0);
--	type MPU6050_PNT is array (0 to 6) of integer range 0 to 1;--正負
--	signal MPU6050_PN:MPU6050_PNT:=(0,0,0,0,0,0,0);
--	type MPU6050_CALT is array (0 to 6) of integer range 0 to 262143;--524287;--轉值
--	signal MPU6050_CAL:MPU6050_CALT:=(0,0,0,0,0,0,0);
--	--2-----
--	signal MPU6050_AxN,MPU6050_AyN,MPU6050_AzN,MPU6050_GxN,MPU6050_GyN,MPU6050_GzN,MPU6050_TN:integer range 0 to 65535;--原始資料
--	signal MPU6050_AxPN,MPU6050_AyPN,MPU6050_AzPN,MPU6050_GxPN,MPU6050_GyPN,MPU6050_GzPN,MPU6050_TPN:integer range 0 to 1;--正負
--	signal MPU6050_Axcal,MPU6050_Aycal,MPU6050_Azcal,MPU6050_Gxcal,MPU6050_Gycal,MPU6050_Gzcal,MPU6050_Tcal:integer range 0 to 262143;--轉值
--
--	--OV2640_SCCB_driver------------------------------------------------------------------------------------	
--	component OV2640_SCCB_driver is
--	   generic
--		(OV2640_image_W:natural:=OV2640_image_WS;--定義記憶體深度:0~addr_length個
--		 OV2640_image_H:natural:=OV2640_image_HS--定義記憶體初始值設定檔名
--		);
--	   Port(  SCCBCLK,RESET:in std_logic;		--系統時脈,系統重置
--			  SCL:out std_logic;				--介面IO:SCL,(有的模組有提升電阻、有的沒有)
--			  SDA:inout std_logic;				--介面IO:SDA,(有的模組有提升電阻、有的沒有)
--			  OV2640_Dx:in std_logic_vector(7 downto 0);
--			  OV2640_PLCK,OV2640_VSYNC,OV2640_HREF:in std_logic;
--			  OV2640_RESET:buffer std_logic;		--OV2640_PWDN不接(直接接GND)
--			  AUTOEXPOSURE,Light_Mode,Color_Saturation,Brightness,Contrast,Special_effects:in integer range 0 to 15;
--			  getnewframe:in std_logic:='0';
--			  getimage_x,getimage_y:in integer range 0 to 1600;
--			  getimage_xoff,getimage_yoff:in integer range 0 to 1600;
--			  newframeok,OV2640_ini_ok:buffer std_logic:='0';
--			  OV2640_rclk:in std_logic;
--			  OV2640_image_P:in integer range 0 to OV2640_image_W*OV2640_image_H;
--			  OV2640_get_image:out std_logic_vector(15 downto 0);
--
--			  OV2640_VSYNCs:buffer std_logic;--觀測用
--			  OV2640_HREF_N,vxxx:buffer integer range 0 to 5000--觀測用
--			 );
--	end component OV2640_SCCB_driver;
--	signal getnewframe:std_logic:='0';
--    signal newframeok,OV2640_ini_ok,OV2640_VSYNCs:std_logic:='0';
--    signal OV2640_image_P:integer range 0 to OV2640_image_WS*OV2640_image_HS;
--    signal OV2640_get_image:std_logic_vector(15 downto 0);
--    signal getimage_x,getimage_y,getimage_xoff,getimage_yoff:integer range 0 to 1600;
--    signal OV2640_HREF_N,vxxx:integer range 0 to 5000;
--    signal AUTOEXPOSURE,Light_Mode,Color_Saturation,Brightness,Contrast,Special_effects:integer range 0 to 15:=0;

	----ADS1115_16BIT_i2c_driver------------------------------------------------------------------------
	component ADS1115_16BIT_i2c_driver is
	   Port(I2CCLK,RESET,S_reset:in std_logic;			--系統時脈,RESET:I2C重置,S_reset系統重置
			ADS1115_ADDR:in std_logic_vector(1 downto 0);	--裝置碼:選位;00ADDR=GND ,01ADDR=VCC ,10ADDR=SDA ,11ADDR=SCL
			ADS1115_ALERT_RDY:in std_logic;
			SCL:out std_logic;					--介面IO:SCL,如有接提升電阻時可設成inout
			SDA:inout std_logic;				--介面IO:SDA
	
			ADS1115_Input_MUX:in std_logic_vector(7 downto 0);--1:enable ,0:disable
			ADS1115_Input_FSR_PGA:in std_logic_vector(23 downto 0);--FSR;000:FSR=±6.144V, 001:FSR=±4.096V ,010:FSR=±2.048V (default) ,011:FSR=±1.024V ,100:FSR=±0.512V ,101:FSR=±0.256V ,110:FSR=±0.256V ,111:FSR=±0.256V
			ADS1115_Input_DR:in std_logic_vector(23 downto 0);--DR;000:8SPS ,001:16SPS ,010:32SPS ,011:64SPS ,100:128SPS (default) ,101:250SPS ,110: 75SPS ,111:860SPS
			
			ADS1115_uploadck:in std_logic;		--上傳速率
			ADS1115_loadck:buffer std_logic;	--上傳速率操作
			ADS1115upload:buffer std_logic;		--啟動上傳
			ADS1115_ADC_16bit:out std_logic_vector(15 downto 0);
			ADS1115_ok:out std_logic		
		   );
	end component ADS1115_16BIT_i2c_driver;

	signal ADS1115_RESET:std_logic:='0';
	--signal ADS1115_Input_MUX:std_logic_vector(7 downto 0):="11111111";--1:enable ,0:disable
	signal ADS1115_Input_MUX:std_logic_vector(7 downto 0):="00110000";--1:enable ,0:disable--搖桿

--	--4線電阻式觸控板
--	--FSR;000:FSR=±6.144V, 001:FSR=±4.096V ,010:FSR=±2.048V (default) ,011:FSR=±1.024V ,100:FSR=±0.512V ,101:FSR=±0.256V ,110:FSR=±0.256V ,111:FSR=±0.256V
--	signal ADS1115_Input_FSR_PGA:std_logic_vector(23 downto 0):="011011001001011011011011";	--4線電阻式觸控板
--	--DR;000:8SPS ,001:16SPS ,010:32SPS ,011:64SPS ,100:128SPS (default) ,101:250SPS ,110:475SPS ,111:860SPS
--	signal ADS1115_Input_DR:std_logic_vector(23 downto 0):="111111100100111111111111";	--4線電阻式觸控板

	--搖桿
	--FSR;000:FSR=±6.144V, 001:FSR=±4.096V ,010:FSR=±2.048V (default) ,011:FSR=±1.024V ,100:FSR=±0.512V ,101:FSR=±0.256V ,110:FSR=±0.256V ,111:FSR=±0.256V
	signal ADS1115_Input_FSR_PGA:std_logic_vector(23 downto 0):="011011001001011011011011";	--搖桿
	--DR;000:8SPS ,001:16SPS ,010:32SPS ,011:64SPS ,100:128SPS (default) ,101:250SPS ,110:475SPS ,111:860SPS
	signal ADS1115_Input_DR:std_logic_vector(23 downto 0):="111111111111111111111111";	--搖桿
--	signal ADS1115_Input_DR:std_logic_vector(23 downto 0):="111111101101111111111111";	--搖桿

	signal ADS1115_loadck:std_logic;	--上傳速率操作
	signal ADS1115upload:std_logic;		--啟動上傳
	signal ADS1115_ADC_16bit:std_logic_vector(15 downto 0);
	signal ADS1115_ok:std_logic;

	type ADS1115_T0 is array (0 to 15) of std_logic_vector(15 Downto 0);
	signal ADS1115_adcS:ADS1115_T0:=(OTHERS=>X"0000");--ADC原值
	type ADS1115_T1 is array (0 to 15) of integer range 0 to 635535;
	signal ADS1115_adcN:ADS1115_T1:=(OTHERS=>0);--ADC正值
	type ADS1115_T2 is array (0 to 15) of integer range 0 to 1;-- 0:+,1:-
	signal ADS1115_adc_signed:ADS1115_T2:=(OTHERS=>0);
	signal ADS1115_adcP:integer range 0 to 15;
	signal ADS1115_bin:integer range 0 to 15:=15;--轉換位元數
	
--	--4線電阻式觸控板
--	--ADS1115:AIN0=Vd->Vx ,ADS1115:AIN1=Hl->Vy
--	--Vu:接1MΩ到VCC(3.3V)
--	component TouchPAD_4_driver is
--	port 
--		(	TouchPAD_clk,TouchPAD_reset: in std_logic;
--			ADS1115_RESET: out std_logic;
--			ADS1115_ok: in std_logic;
--			ADS1115_Input_MUX:out std_logic_vector(7 downto 0);--1:enable ,0:disable--4線電阻式觸控板
--			Vx,Vy:in integer range 0 to 65536;
--			TouchPAD_Vud_Hlr:inout std_logic_vector(3 downto 0):="ZZZZ";
--			TouchPAD_dx0: in integer range 0 to 32767:=5000;--水平基底
--			TouchPAD_dy0: in integer range 0 to 32767:=3000;--垂直基底
--			TouchPAD_dxx:in integer range 0 to 32767:=2000;--水平等分
--			TouchPAD_dyy:in integer range 0 to 32767:=2000;--垂直等分
--			TouchPAD_dx,TouchPAD_dy: out integer range 0 to 31;
--			TouchPAD_ok: buffer std_logic
--		);
--	end component;
--
----	type TouchPAD_Vud_Hlr_T is array (0 to 3) of std_logic_vector(3 Downto 0);
----	constant TouchPAD_Vud_Hlr_Ts:TouchPAD_Vud_Hlr_T:=("ZZZZ","ZZ0Z","ZZ01","01ZZ");--off,test,Vx,Vy
----	signal TouchPAD_Vud_Hlr_S:integer range 0 to 3:=0;--off,test,Vx,Vy
--	signal TouchPAD_reset,TouchPAD_ok:std_logic:='0';
--	signal TouchPAD_dx,TouchPAD_dy:integer range 0 to 31;
--	constant TouchPAD_dx0:integer range 0 to 32767:=5000;--水平基底
--	constant TouchPAD_dy0:integer range 0 to 32767:=3000;--垂直基底
----	signal TouchPAD_dxx:integer range 0 to 32767:=2000;--水平等分
----	signal TouchPAD_dyy:integer range 0 to 32767:=2000;--垂直等分
	
	--=====================================================================================
	--搖桿
	component Joystick_driver is
		port 
		(	Joystick_clk,Joystick_reset: in std_logic;
			ADS1115_RESET: out std_logic;
			ADS1115_ok: in std_logic;
			Vx,Vy:in integer range 0 to 65536;
			SW:in std_logic;
			Joystick_keyS: buffer integer range 0 to 63;
			Joystick_ok: buffer std_logic
		);
	end component;
	signal Joystick_reset,Joystick_ok:std_logic:='0';
	signal Joystick_keyS,Joystick_keyStest:integer range 0 to 63;
	signal Joystick_So:integer range 0 to 255;

	-------------------------------------------------------------------------------------
	type D7_T is array (7 downto 0) of integer range 0 to 38;
	signal D7_DB:D7_T;		--顯示資料
	signal d7dot,flashs,flash_a_g:std_logic_vector(7 downto 0);
	signal flash_a_gs:std_logic_vector(6 downto 0);
	signal scanP:integer range 0 to 7;	--掃瞄指標
	--BCD碼解共陽極七段顯示碼gfedcba
	type D7LED_T is array (0 to 38) of std_logic_vector(6 Downto 0);
	constant Disp7:D7LED_T:=("1000000","1111001","0100100","0110000","0011001","0010010","0000010","1111000","0000000","0010000","1111111",--0:0123456789space
							 "0001000","0000011","1000110","0100001","0000110","0001110","1000010","0001001","1001111","1110001","0001010",--11:AbC...........
							 "1000111","0101010","0101011","0100011","0001100","0011000","0101111","0010010","0000111","1000001","1110011",--22:LMn...........
							 "1010101","0110110","0010001","0100100","1111101","1111001");--33:WXyz!:
	--0123456789 ABCDEFGHIJKLMNOPQRSTUVWXYZ!:
	--0123456789 abcdefghijklmnopqrstuvwxyz!:

	-- tft lcd_st7735------------------------------------------------------------------------
	--st7735指令表格式:
	type st7735_T is array (0 to 27) of std_logic_vector(7 Downto 0);
	signal st7735_IT:st7735_T:=(X"11",	--0 Default SLPIN(10h), SLPOUT(11h), 120ms:--休眠/喚醒

								X"29", 	--1 DISPON (29h), Default DISPOFF (28h), 120ms:--顯示on/off

								X"B4", 	--2 INVCTR (B4h): Display Inversion Control:--反相控制
								X"03",  --3 Default(03h): 0 0 0 0 0 NLA NLB NLC: 00000011

								X"36", 	--4 MADCTL (36h): Memory Data Access Control:--記憶體進出入順序及顯示控制
								X"C0", 	--5 Default(00h): MY(0) MX(0) MV(0) ML(0) RGB(0) MH(0) - -

								X"38",	--6 Default IDMOFF (38h)(4k,65k,262k), IDMON (39h)(only 8 color):--色彩限定

								X"20", 	--7 Default INVOFF (20h): Display Inversion Off, INVON (21h): Display Inversion On:--不反相／反相顯示

								X"13",	--8 Default NORON (13h): Normal Display Mode On, PTLON (12h): Partial Display Mode On:--正常／部分顯示模式

								X"30", 	--9 PTLAR (30h): Partial Area:--顯示部分範圍設定
								X"00",	--10 PSL
								X"00",	--11
								X"00",	--12 PEL
								X"A1",	--13

								X"3A",	--14 COLMOD (3Ah): Interface Pixel Format:--色彩深度設定(12-bit,16-bit,18-bit)
								X"06",	--15 Default(06h):18 bit pixel format, (05h):16 bit pixel format, (03h):12 bit pixel format

								X"2A", 	--16 CASET (2Ah): Column Address Set, Default 0~131:132:--frame x範圍設定0~131共132
								X"00",  --17 XS
								X"00",  --18
								X"00", 	--19 XE
								X"83",  --20 (131)

								X"2B", 	--21 RASET (2Bh): Row Address Set, Default 0~161:162:--frame y範圍設定0~161共162
								X"00",  --22 YS
								X"00",  --23
								X"00",  --24 YE
								X"A1",  --25 (161)

								X"2C", 	--26 RAMWR (2Ch): Memory Write:--寫入顯示資料
								
								X"28" 	--27 user defined region(must expand on its own):DISPON (29h), Default DISPOFF (28h), 120ms:--顯示on/off,
								);

	type st7735_cT0 is array (0 to 2) of std_logic_vector(7 Downto 0);--(R,G,B)
	type st7735_cT1 is array (0 to 15) of st7735_cT0;
	signal st7735_8baseCOLOR:st7735_cT1:=((X"00",X"00",X"00"),--0 BLACK
										  (X"FF",X"00",X"00"),--1 RED
										  (X"00",X"FF",X"00"),--2 GREEN
										  (X"00",X"00",X"FF"),--3 BLUE
										  (X"FF",X"FF",X"00"),--4 YELLOW
										  (X"FF",X"00",X"FF"),--5 MAGENTA
										  (X"00",X"FF",X"FF"),--6 CYAN
										  (X"FF",X"FF",X"FF"),--7 WHITE
										  (X"9E",X"AA",X"29"),--8 user defined
										  (X"D2",X"CC",X"63"),--9 user defined
										  (X"BD",X"FD",X"C4"),--10 user defined
										  (X"00",X"00",X"00"),--11 user defined
										  (X"00",X"00",X"00"),--12 user defined
										  (X"00",X"00",X"00"),--13 user defined
										  (X"00",X"00",X"00"),--14 user defined
										  (X"00",X"00",X"FF")--15 user defined
										  );--user defined

	signal B1_COLORi,B0_COLORi,monoC:integer range 0 to 9;

	signal st7735_DATA_C_INC:integer range 0 to 16;
	signal st7735_COM_PN,st7735_COM_PN0:integer range 0 to 31;
	signal st7735_COM_POINTER,st7735_COM_POINTERs:integer range 0 to 127;
	signal st7735_P_CLK,st7735_P_RESET,st7735_P_ok:std_logic;
	signal st7735_reset0:std_logic;--啟動TFT_LCD首次清空

	signal gdata,gdata0,gdata1,gdata2,gdata3,gdata4,gdata5,gdata6,gdata7:std_logic_vector(15 Downto 0);
	signal gdata8,gdata9,gdata10,gdata11,gdata12,gdata13,gdata14,gdata15:std_logic_vector(15 Downto 0);
	signal fc2,bc2:st7735_cT0:=(X"00",X"00",X"00");
	signal cbis:std_logic_vector(3 Downto 0);
	signal st7735_ch:std_logic_vector(3 Downto 0);	

	signal st7735_COLMOD,st7735_INVCTR,st7735_MADCTL,st7735_IDMOFF_ON:std_logic_vector(7 Downto 0);
	signal st7735_INVOFF_ON,st7735_NORON_PTLON,st7735_DISPON_OFF:std_logic_vector(7 Downto 0);
	signal st7735_PSL,st7735_PEL:integer range 0 to 255;
	signal st7735_DATA_CPOINTER,st7735_DATA_RPOINTER:integer range 0 to 255;
	signal st7735_DATA_CPOINTER_begin,st7735_DATA_CPOINTER_end,st7735_x,st7735_xincN:integer range 0 to 255;
	signal st7735_DATA_RPOINTER_begin,st7735_DATA_RPOINTER_end,st7735_y:integer range 0 to 255;
	signal st7735_xinc1,st7735_xinc1_C,st7735_xinc1_M:integer range 0 to 65535;
	signal st7735_time_Dn:integer range 0 to 100000000;--2s
	signal isword:boolean:=false;				--圖形或字型?圖形
	signal word_w,W_w_b:integer range 0 to 128;	--字寬,bit餘數
	signal shift_x:integer range 0 to 127:=0;	--x移位數
	signal shift_y:integer range 0 to 159:=0;	--y移位數
	signal st7735_x0,d0_setN:integer range 0 to 15;--去前導零,去前導零處理位數設定
	signal remove_leading_0:std_logic;			--去前導零on/off
	type st7735_DATA_T is array (0 to 7) of integer range 0 to 255;
	signal st7735_DATA:st7735_DATA_T;
	
	signal st7735_DATA_TSL2561,st7735_DATA_DHT11_T,st7735_DATA_DHT11_H:st7735_DATA_T;--前1次資料備份(暫停更新)
		--=109.10.27=======================
	signal st7735_VL1,st7735_VL2:std_logic_vector(15 Downto 0);
	signal st7735_xx1,st7735_xx2,st7735_yy1,st7735_yy2:integer range 0 to 255;
	signal gdata565:std_logic_vector(15 Downto 0);
	signal is_OV2640:boolean;

	-- -----------------------------------------------------
	signal FD:std_logic_vector(27 downto 0);					 	--除頻器
	signal SW_CLK,E115_1_1_MainCLK,OLED_P_CLK,OLED_P_RESET:std_logic;--防彈跳時脈,主控器操控頻率,OLED

	--計時計數
	signal times:integer range 0 to 4095;
	signal times1,times2,times3,times4,times5,sound_Times:integer range 0 to 1023;
	signal S0on:std_logic;

	--指撥開關
	type M7_0T is array (0 to 8) of std_logic_vector(2 downto 0);
	signal M70s:M7_0T;

	signal M701,M702,M701s,M710s,M702x,M702xx:std_logic_vector(7 downto 0);
	signal M:integer range 0 to 15;	--操作指撥開關,去前導零
	--signal M,check0:integer range 0 to 15;	--操作指撥開關,去前導零

	signal MMx,MM:std_logic_vector(1 downto 0);
	signal M7_76543210,M7s:std_logic_vector(7 downto 0);
	signal MMs:integer range 0 to 7;
	signal Mx:std_logic_vector(3 downto 0);

	--七段顯示器
	signal Fp,f6,fx,Fpx:integer range 0 to 9;
	type F012345_T is array (0 to 9) of D7_T;
	signal F012345:F012345_T:=( (19,24,16,10,10,10,0,0),--0(INF.  XX)
								(19,24,16,10,10,10,0,0),--1(INF.  XX)
								(19,24,16,10,10,10,0,0),--2(INF.  XX)
								(19,24,16,10,10,10,0,0),--3(INF.  XX)
								(19,24,16,10,10,10,0,0),--4(INF.  XX)
								(19,24,16,10,10,10,0,0),--5(INF.  XX)
								(19,24,16,10,10,10,0,0),--6(INF.  XX)
								(19,24,16,10,10,10,0,0),--7(INF.  XX)
								(19,24,16,10,10,10,0,0),--8(INF.  XX)
								(10,10,10,10,10,10,10,10)
								);

--==tft lcd 圖形===================================================================================
	--字型&圖形 16bit
	signal beFriendC_P,beFriendC_PP:integer range 0 to addr_length_N;--addr_length_N 定義記憶體深度0~811
--	type beFriendt is array (0 to 811) of integer range 0 to 65535;--(0,2^14-1)16bit
--	constant beFriend:beFriendt:=
--	type beFriendt1 is array (0 to 63) of std_logic_vector(15 downto 0);
--	type beFriendt2 is array (0 to 18) of beFriendt1;
	--32x32 x 19 (0~18)
--	signal beFriend:beFriendt2:=
--	(
--	(X"00FF",X"FF00",X"0100",X"0080",X"0100",X"0080",X"0200",X"0040",X"0200",X"0040",X"0400",X"0020",X"0400",X"0020",X"0800",X"0010",X"0800",X"0010",X"1000",X"0008",X"1000",X"0008",X"2000",X"0004",X"2000",X"0004",X"4000",X"0002",X"4000",X"0002",X"8000",X"0001",X"8000",X"0001",X"4000",X"0002",X"4000",X"0002",X"2000",X"0004",X"2000",X"0004",X"1000",X"0008",X"1000",X"0008",X"0800",X"0010",X"0800",X"0010",X"0400",X"0020",X"0400",X"0020",X"0200",X"0040",X"0200",X"0040",X"0100",X"0080",X"0100",X"0080",X"00FF",X"FF00"),--0 p00六邊形
--	(X"000F",X"F000",X"0070",X"0E00",X"0080",X"0100",X"0300",X"00C0",X"0400",X"0020",X"0800",X"0010",X"1000",X"0008",X"1000",X"0008",X"2000",X"0004",X"4000",X"0002",X"4000",X"0002",X"4000",X"0002",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"4000",X"0002",X"4000",X"0002",X"4000",X"0002",X"2000",X"0004",X"1000",X"0008",X"1000",X"0008",X"0800",X"0010",X"0400",X"0020",X"0300",X"00C0",X"0080",X"0100",X"0070",X"0E00",X"000F",X"F000"),--1 p01圓
--	(X"FFFF",X"FFFF",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"FFFF",X"FFFF"),--2 P02方
--	(X"0001",X"8000",X"0001",X"8000",X"0002",X"4000",X"0002",X"4000",X"0004",X"2000",X"0004",X"2000",X"0008",X"1000",X"0008",X"1000",X"0010",X"0800",X"0010",X"0800",X"0020",X"0400",X"0020",X"0400",X"0040",X"0200",X"0040",X"0200",X"0080",X"0100",X"0080",X"0100",X"0100",X"0080",X"0100",X"0080",X"0200",X"0040",X"0200",X"0040",X"0400",X"0020",X"0400",X"0020",X"0800",X"0010",X"0800",X"0010",X"1000",X"0008",X"1000",X"0008",X"2000",X"0004",X"2000",X"0004",X"4000",X"0002",X"4000",X"0002",X"8000",X"0001",X"FFFF",X"FFFF"),--3 P03三角形
--	(X"0001",X"8000",X"0002",X"4000",X"0004",X"2000",X"0008",X"1000",X"0010",X"0800",X"0020",X"0400",X"0040",X"0200",X"0080",X"0100",X"0100",X"0080",X"0200",X"0040",X"0400",X"0020",X"0800",X"0010",X"1000",X"0008",X"2000",X"0004",X"4000",X"0002",X"8000",X"0001",X"8000",X"0001",X"4000",X"0002",X"2000",X"0004",X"1000",X"0008",X"0800",X"0010",X"0400",X"0020",X"0200",X"0040",X"0100",X"0080",X"0080",X"0100",X"0040",X"0200",X"0020",X"0400",X"0010",X"0800",X"0008",X"1000",X"0004",X"2000",X"0002",X"4000",X"0001",X"8000"),--4 p04凌形
--	(X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"FFFF",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"FFFF",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000"),--5 p05長方形
--	(X"FFFF",X"FFFF",X"8000",X"0001",X"4000",X"0002",X"4000",X"0002",X"2000",X"0004",X"2000",X"0004",X"1000",X"0008",X"1000",X"0008",X"0800",X"0010",X"0800",X"0010",X"0400",X"0020",X"0400",X"0020",X"0200",X"0040",X"0200",X"0040",X"0100",X"0080",X"0100",X"0080",X"0080",X"0100",X"0080",X"0100",X"0040",X"0200",X"0040",X"0200",X"0020",X"0400",X"0020",X"0400",X"0010",X"0800",X"0010",X"0800",X"0008",X"1000",X"0008",X"1000",X"0004",X"2000",X"0004",X"2000",X"0002",X"4000",X"0002",X"4000",X"0001",X"8000",X"0001",X"8000"),--6 p06倒三角形
--	(X"007F",X"FE00",X"0080",X"0100",X"0100",X"0080",X"0200",X"0040",X"0400",X"0020",X"0800",X"0010",X"1000",X"0008",X"2000",X"0004",X"4000",X"0002",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"8000",X"0001",X"4000",X"0002",X"2000",X"0004",X"1000",X"0008",X"0800",X"0010",X"0400",X"0020",X"0200",X"0040",X"0100",X"0080",X"0080",X"0100",X"007F",X"FE00"),--7 p07八邊形
--	(X"00FF",X"FF00",X"01FF",X"FF80",X"01FF",X"FF80",X"03FF",X"FFC0",X"03FF",X"FFC0",X"07FF",X"FFE0",X"07FF",X"FFE0",X"0FFF",X"FFF0",X"0FFF",X"FFF0",X"1FFF",X"FFF8",X"1FFF",X"FFF8",X"3FFF",X"FFFC",X"3FFF",X"FFFC",X"7FFF",X"FFFE",X"7FFF",X"FFFE",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"7FFF",X"FFFE",X"7FFF",X"FFFE",X"3FFF",X"FFFC",X"3FFF",X"FFFC",X"1FFF",X"FFF8",X"1FFF",X"FFF8",X"0FFF",X"FFF0",X"0FFF",X"FFF0",X"07FF",X"FFE0",X"07FF",X"FFE0",X"03FF",X"FFC0",X"03FF",X"FFC0",X"01FF",X"FF80",X"01FF",X"FF80",X"00FF",X"FF00"),--8 P20滿六邊形
--	(X"000F",X"F000",X"007F",X"FE00",X"00FF",X"FF00",X"03FF",X"FFC0",X"07FF",X"FFE0",X"0FFF",X"FFF0",X"1FFF",X"FFF8",X"1FFF",X"FFF8",X"3FFF",X"FFFC",X"7FFF",X"FFFE",X"7FFF",X"FFFE",X"7FFF",X"FFFE",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"7FFF",X"FFFE",X"7FFF",X"FFFE",X"7FFF",X"FFFE",X"3FFF",X"FFFC",X"1FFF",X"FFF8",X"1FFF",X"FFF8",X"0FFF",X"FFF0",X"07FF",X"FFE0",X"03FF",X"FFC0",X"00FF",X"FF00",X"007F",X"FE00",X"000F",X"F000"),--9 p21滿圓
--	(X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF"),--10 P22滿方
--	(X"0001",X"8000",X"0001",X"8000",X"0003",X"C000",X"0003",X"C000",X"0007",X"E000",X"0007",X"E000",X"000F",X"F000",X"000F",X"F000",X"001F",X"F800",X"001F",X"F800",X"003F",X"FC00",X"003F",X"FC00",X"007F",X"FE00",X"007F",X"FE00",X"00FF",X"FF00",X"00FF",X"FF00",X"01FF",X"FF80",X"01FF",X"FF80",X"03FF",X"FFC0",X"03FF",X"FFC0",X"07FF",X"FFE0",X"07FF",X"FFE0",X"0FFF",X"FFF0",X"0FFF",X"FFF0",X"1FFF",X"FFF8",X"1FFF",X"FFF8",X"3FFF",X"FFFC",X"3FFF",X"FFFC",X"7FFF",X"FFFE",X"7FFF",X"FFFE",X"FFFF",X"FFFF",X"FFFF",X"FFFF"),--11 P23滿三角形
--	(X"0001",X"8000",X"0003",X"C000",X"0007",X"E000",X"000F",X"F000",X"001F",X"F800",X"003F",X"FC00",X"007F",X"FE00",X"00FF",X"FF00",X"01FF",X"FF80",X"03FF",X"FFC0",X"07FF",X"FFE0",X"0FFF",X"FFF0",X"1FFF",X"FFF8",X"3FFF",X"FFFC",X"7FFF",X"FFFE",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"7FFF",X"FFFE",X"3FFF",X"FFFC",X"1FFF",X"FFF8",X"0FFF",X"FFF0",X"07FF",X"FFE0",X"03FF",X"FFC0",X"01FF",X"FF80",X"00FF",X"FF00",X"007F",X"FE00",X"003F",X"FC00",X"001F",X"F800",X"000F",X"F000",X"0007",X"E000",X"0003",X"C000",X"0001",X"8000"),--12 p24滿凌形
--	(X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000"),--13 p25滿長方形
--	(X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"7FFF",X"FFFE",X"7FFF",X"FFFE",X"3FFF",X"FFFC",X"3FFF",X"FFFC",X"1FFF",X"FFF8",X"1FFF",X"FFF8",X"0FFF",X"FFF0",X"0FFF",X"FFF0",X"07FF",X"FFE0",X"07FF",X"FFE0",X"03FF",X"FFC0",X"03FF",X"FFC0",X"01FF",X"FF80",X"01FF",X"FF80",X"00FF",X"FF00",X"00FF",X"FF00",X"007F",X"FE00",X"007F",X"FE00",X"003F",X"FC00",X"003F",X"FC00",X"001F",X"F800",X"001F",X"F800",X"000F",X"F000",X"000F",X"F000",X"0007",X"E000",X"0007",X"E000",X"0003",X"C000",X"0003",X"C000",X"0001",X"8000",X"0001",X"8000"),--14 p26滿倒三角形
--	(X"007F",X"FE00",X"00FF",X"FF00",X"01FF",X"FF80",X"03FF",X"FFC0",X"07FF",X"FFE0",X"0FFF",X"FFF0",X"1FFF",X"FFF8",X"3FFF",X"FFFC",X"7FFF",X"FFFE",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"7FFF",X"FFFE",X"3FFF",X"FFFC",X"1FFF",X"FFF8",X"0FFF",X"FFF0",X"07FF",X"FFE0",X"03FF",X"FFC0",X"01FF",X"FF80",X"00FF",X"FF00",X"007F",X"FE00"),--15 p27滿八邊形
--	(X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000"),--16 p30空白
--	(X"0003",X"8000",X"003F",X"F800",X"00FF",X"FE00",X"03FC",X"7F80",X"0FE0",X"0FE0",X"1F80",X"01F8",X"7E00",X"007E",X"F803",X"801F",X"F00F",X"F00F",X"C03F",X"FC03",X"00FE",X"7E00",X"01F0",X"1F80",X"03E0",X"07C0",X"0780",X"03E0",X"1F00",X"00F8",X"1E03",X"C078",X"1C0F",X"F038",X"001F",X"F800",X"003C",X"7C00",X"00F8",X"1E00",X"01F0",X"0F00",X"03E0",X"07C0",X"03C0",X"03C0",X"0380",X"01C0",X"0003",X"C000",X"0007",X"E000",X"000F",X"F000",X"000F",X"F000",X"000F",X"F000",X"0007",X"E000",X"0003",X"C000",X"0000",X"0000"),--17 wifi
--	(X"0001",X"8000",X"0001",X"8000",X"0003",X"C000",X"0003",X"C000",X"0003",X"C000",X"0007",X"E000",X"0007",X"E000",X"0007",X"E000",X"000F",X"F000",X"000F",X"F000",X"000F",X"F000",X"001F",X"F800",X"FFFF",X"FFFF",X"FFFF",X"FFFF",X"7FFF",X"FFFE",X"1FFF",X"FFF8",X"0FFF",X"FFF0",X"07FF",X"FFE0",X"01FF",X"FF80",X"00FF",X"FF00",X"007F",X"FE00",X"00FF",X"FF00",X"00FF",X"FF00",X"00FF",X"FF00",X"01FF",X"FF80",X"01FE",X"7F80",X"01FC",X"3F80",X"03F0",X"0FC0",X"03E0",X"07C0",X"03C0",X"03C0",X"0700",X"00E0",X"0600",X"0060")--18 p30p30星星
--	);


	signal F012345_6_7,F012345_6_5,M7_76543210_7downto5,M7_76543210_4downto2:integer range 0 to 15;
	
	signal WS2812BP_C_R,WS2812BP_C_G,WS2812BP_C_B:std_logic_vector(2 downto 0);
	
begin
--=====================================================================================
--2024.03.30
UARTTx: RS232_T4 Port Map(SCLK,S_RESET_T,DL,ParityN,StopN,F_Set,Status_Ts,TX_W,TXData,TX);			--RS232傳送模組
UARTRx: RS232_R4 Port Map(SCLK,S_RESET_R,DL,ParityN,StopN,F_Set,Status_Rs,Rdatalength,Rx_R,RD,RxDs);--RS232接收模組

--UARTTx2: RS232_T4 Port Map(SCLK,S_RESET_T2,DL2,ParityN2,StopN2,F_Set2,Status_Ts2,TX_W2,TXData2,TX2);			--RS232傳送模組
--UARTRx2: RS232_R4 Port Map(SCLK,S_RESET_R2,DL2,ParityN2,StopN2,F_Set2,Status_Rs2,Rdatalength2,Rx_R2,RD2,RxDs2);--RS232接收模組	

--key board 4x4
U3: k4x4 port Map(FD(17),S_RESET,ki,ko,kn,kv,kASCII,kok,koo);

--=====================================================================================
--搖桿
Joystick1:Joystick_driver
		port map
		(	FD(17),Joystick_reset,
			ADS1115_RESET,
			ADS1115_ok,
			ADS1115_adcN(4),ADS1115_adcN(5),
			M70s(8)(2),
			Joystick_keyS,
			Joystick_ok
		);

----=====================================================================================	
--	--4線電阻式觸控板
--	--ADS1115:AIN0=Vd->Vx ,ADS1115:AIN1=Hl->Vy
--	--Vu:接1MΩ到VCC(3.3V)
--TouchPAD:TouchPAD_4_driver
--	port  map
--		(	FD(17),TouchPAD_reset,--TouchPAD_clk,TouchPAD_reset: in std_logic;
--			ADS1115_RESET,--ADS1115_RESET: out std_logic;
--			ADS1115_ok,--ADS1115_ok: in std_logic;
--			ADS1115_Input_MUX,--ADS1115_Input_MUX:out std_logic_vector(7 downto 0);--1:enable ,0:disable--4線電阻式觸控板
--			ADS1115_adcN(4),ADS1115_adcN(5),--Vx,Vy:in integer range 0 to 65536;
--			TouchPAD_Vud_Hlr,--TouchPAD_Vud_Hlr:inout std_logic_vector(3 downto 0):="ZZZZ";
--			5000,--TouchPAD_dx0: in integer range 0 to 32767:=5000;--水平基底
--			3000,--TouchPAD_dy0: in integer range 0 to 32767:=3000;--垂直基底
--			2000,--TouchPAD_dxx:in integer range 0 to 32767:=2000;--水平等分
--			2000,--TouchPAD_dyy:in integer range 0 to 32767:=2000;--垂直等分
--			TouchPAD_dx,TouchPAD_dy,--TouchPAD_dx,TouchPAD_dy: out integer range 0 to 31;
--			TouchPAD_ok
--		);

----=====================================================================================
----串列式4位七段顯示器模組(4位or8位:74HC595 & 74HC595)驅動器
--U4:D74HC595_serial_driver port map( SCLK,--FD(0),	--移位速率
--									S_RESET,--重置
--									D7LED,	--本次字形
--									scanP,	--本次位數
--									D74HC595_SCLK,	--74HC595_SCLK
--									D74HC595_RCLK,	--74HC595_RCLK
--									D74HC595_SDi	--74HC595_SDi
--									);

----串列式8位七段顯示器模組(MAX7219)驅動器
--U5:max7219_D7Sx8_serial_driver port map(FD(0),--移位速率
--										S_RESET,--重置
--										MAX7219_s_D,--本次信息
--										MAX7219_s_A,--本次置
--										MAX7219_DIN,
--										MAX7219_CLK,
--										MAX7219_LOAD
--										);

--WS2812B驅動器----------------------------------------------------------------------------------------
WS2812BN: WS2812B_Driver port map(WS2812BCLK,WS2812BRESET,WS2812B_loadck,WS2812B_LEDGRBdata,WS2812B_reload,WS2812B_emitter_ok,WS2812Bout);

----MPU6050驅動器----------------------------------------------------------------------------------------
--UMPU6050: MPU6050_I2C_256_driver port map(FD(5),S_RESET,		--系統時脈,系統重置
--										  '0',		--MPU6050_AD0,	--裝置碼:選位
--										  MPU6050_INT,
--										  MPU6050_SCL,				--介面IO:SCL,如有接提升電阻時可設成inout
--										  MPU6050_SDA,				--介面IO:SDA
--										  0,		--MPU6050_AFS_SELP:range 0 to 3;+-2g(16384),+-4g(8192),+-8g(4096),+-16g(2048)
--										  3,		--MPU6050_GFS_SELP:range 0 to 3;+-250°/S(131),+-500°/S(65.5),+-1000°/S(32.8),+-2000°/S(16.4)
--										  4,		--MPU6050_Sample_Rate:in integer range 0 to 1000
--										  2,		--MPU6050_INTresponseNs:in integer range 0 to 255;INT幾次後才回應1次
--										  2,		--MPU6050_dpNs,--小數位數0,1,2
--										  SCLK,						--上傳速率
--										  MPU6050_loadck,			--上傳速率操作
--										  MPU6050upload,			--啟動上傳
--										  MPU6050_AxyzTGxyz_16bit,	--16bit
--										  MPU6050_AxyzTGxyz,		-- range 0 to 200000
--										  MPU6050_AxyzTGxyz_N,		-- range 0 to 65536
--										  MPU6050_AxyzTGxyz_PN,		-- range 0 to 1
--										  MPU6050_AxyzTGxyzs		--MPU6050_AxyzTGxyzs	-- range 0 to 6
--										 );

----OV2640
--UOV2640: OV2640_SCCB_driver 
--	   Port map(FD(5),S_RESET,			--系統時脈,系統重置
--			    OV2640_SCL,				--介面IO:SCL,如有接提升電阻時可設成inout
--			    OV2640_SDA,				--介面IO:SDA
--			    OV2640_Dx,
--			    OV2640_PLCK,
--			    OV2640_VSYNC,
--			    OV2640_HREF,
--			    OV2640_RESET,
--			    AUTOEXPOSURE,			--0~4
--			    Light_Mode,				--0~5
--			    Color_Saturation,		--0~4
--			    Brightness,				--0~4
--			    Contrast,				--0~4
--			    Special_effects,		--0~7
--			    getnewframe,
--			    getimage_x,getimage_y,
--			    getimage_xoff,getimage_yoff,
--			    newframeok,OV2640_ini_ok,
--			    SCLK,
--			    OV2640_image_P,
--			    OV2640_get_image,
--
--				OV2640_VSYNCs,--觀測用
--			    OV2640_HREF_N,vxxx--觀測用
--			   );

----ADS1115_16BIT_i2c_driver------------------------------------------------------------------------
ADS1115: ADS1115_16BIT_i2c_driver--
	   Port map(FD(4),ADS1115_RESET,S_RESET,--系統時脈,RESET:I2C重置,S_reset系統重置
				"00",	--裝置碼:選位;00ADDR=GND ,01ADDR=VCC ,10ADDR=SDA ,11ADDR=SCL
				ADS1115_ALERT_RDY,
				ADS1115_SCL,				--介面IO:SCL,如有接提升電阻時可設成inout
				ADS1115_SDA,				--介面IO:SDA
	
				ADS1115_Input_MUX,--1:enable ,0:disable
				ADS1115_Input_FSR_PGA,--FSR;000:FSR=±6.144V, 001:FSR=±4.096V ,010:FSR=±2.048V (default) ,011:FSR=±1.024V ,100:FSR=±0.512V ,101:FSR=±0.256V ,110:FSR=±0.256V ,111:FSR=±0.256V
				ADS1115_Input_DR,--DR;000:8SPS ,001:16SPS ,010:32SPS ,011:64SPS ,100:128SPS (default) ,101:250SPS ,110: 75SPS ,111:860SPS
			
				SCLK,			--上傳速率
				ADS1115_loadck,	--上傳速率操作
				ADS1115upload,	--啟動上傳
				ADS1115_ADC_16bit,
				ADS1115_ok		
				);

--ROM driver
ROM: E111_01_01_rom Port Map(beFriendC_PP,SCLK,q);

--tft_lcd-------------------------------------------------------------------
st7735_spi_tft_lcd:st7735_spi_tft_lcd_4w_driver_3
			port map(st7735_CLK,st7735_RESET,	--系統時脈,系統重置
			  st7735_RES,st7735_BLS,			--介面控制:RESX,BL輸入
			  DCi,				--00:命令 01:命令參數 11:g資料
			  cmpai,			--命令_參數 輸入,水平8點image
			  cbi,				--色盤(4bit):xx01(12bit)、xx10(16bit)、xx11(18bit)
			  fcri,fcgi,fcbi,	--色系
			  bcri,bcgi,bcbi,	--色系
			  d8_1i,			--水平剩餘點數
			  shift_Hdni,		--水平shift點數0..15
			  --------------------------------------------------------------
			  st7735_RESX,		--介面IO:RESX輸出
			  st7735_CS,		--介面IO:CSX輸出
			  st7735_DC,		--介面IO:DCX輸出
			  st7735_SCL,		--介面IO:SCL輸出
			  st7735_SDA,		--介面IO:SDA輸出
			  st7735_BL,		--介面IO:BL輸出
			  --------------------------------------------------------------
			  st7735_reLOAD,	--載入旗標:0 可載入
			  st7735_LoadCK,	--載入時脈
			  st7735_spi_ok		--完成旗標
			);

st7735_RES<=S_RESET;

----st7735指令=========================================================================
--反相控制							--INVCTR: Display Inversion Control
st7735_IT(3)<=st7735_INVCTR;		--3 Default(03h): 0 0 0 0 0 NLA NLB NLC: 00000011
--記憶體進出入順序及顯示控制		--MADCTL (36h): Memory Data Access Control
st7735_IT(5)<=st7735_MADCTL;		--5 Default(00h): MY(0) MX(0) MV(0) ML(0) RGB(0) MH(0) - -
--色彩限定OFF(38h)／ON(39h)
st7735_IT(6)<=st7735_IDMOFF_ON;		--6 Default IDMOFF (38h)(4k,65k,262k), IDMON (39h)(only 8 color):
--不反相(20h)／反相(21h)顯示
st7735_IT(7)<=st7735_INVOFF_ON;		--7 Default INVOFF (20h): Display Inversion Off, INVON (21h): Display Inversion On
--正常(13h)／部分(12h)顯示模式
st7735_IT(8)<=st7735_NORON_PTLON;	--8 Default NORON (13h): Normal Display Mode On, PTLON (12h): Partial Display Mode On
--顯示部分範圍設定					--PTLAR
st7735_IT(11)<=CONV_STD_LOGIC_VECTOR(st7735_PSL,8);	--11 PSL7~PSL0(X"00")
st7735_IT(13)<=CONV_STD_LOGIC_VECTOR(st7735_PEL,8);	--13 PEL7~PEL0(X"A1")
--色彩深度設定 						--Interface Pixel Format:(12-bit,16-bit,18-bit)
st7735_IT(15)<=st7735_COLMOD;		--15 Default(06h):18 bit pixel format, (05h):16 bit pixel format, (03h):12 bit pixel format
----frame x範圍設定					--CASET:
st7735_IT(18)<=CONV_STD_LOGIC_VECTOR((st7735_DATA_CPOINTER_begin mod 128)+2,8);	--18 XS7~XS0(X"00")
st7735_IT(20)<=CONV_STD_LOGIC_VECTOR((st7735_DATA_CPOINTER_end mod 128)+2,8);	--20 XE7~XE0(X"83")
--frame y範圍設定					--RASET
st7735_IT(23)<=CONV_STD_LOGIC_VECTOR((st7735_DATA_RPOINTER_begin mod 160)+1,8);	--23 YS7~YS0(X"00")
st7735_IT(25)<=CONV_STD_LOGIC_VECTOR((st7735_DATA_RPOINTER_end mod 160)+1,8);	--25 YE7~YE0(X"A1")
--顯示ON/OFF設定					--27 DISPON (29h), Default DISPOFF (28h)
st7735_IT(27)<=st7735_DISPON_OFF;

--=====================================================================================
--2024.03.30
--FPGA上傳RS232
	TXData<=FPGA_ESP8266(CMDnS-CMDn);--上傳資料1byte
	--x2
	--TXData2<=FPGA_ESP82662(CMDnS2-CMDn2);--上傳資料1byte

-----------------------------
MMx<=M702(1)&M702(0);--M7_76543210(1)&M7_76543210(0);	--M指撥開關狀態設定

-- --------------------------
E115_1_1_MainCLK<=FD(17) when sys_uartFs='0' else SCLK;--E113_1_1_Main主控器操作速率

E115_1_1_Main:process(E115_1_1_MainCLK)
variable k,k2:integer range 0 to 31;
variable k00sw:boolean;
begin
	if S_RESET='0' then		--系統重置
		MM<=not MMx;		--虛擬指撥開關不等於實體指撥開關狀態
--		D7_DB<=(0,0,0,0,0,0,0,0);	--清除顯示資料
--		flash_a_g<=(others=>'0');	--off gfedcba閃爍
--		flashs<=(others=>'0');		--off 小數點閃爍
--		d7dot<=(others=>'0');		--off 小數點

		D7_DB<=(10,10,10,10,10,10,10,10);	--清除顯示資料
		flash_a_g<="00000000";	--off gfedcba閃爍
		flashs<="00000000";		--off 小數點閃爍
		d7dot<="00000000";		--off 小數點

		WS2812BP_reset<='0';
		WS2812BP_Ms<=0;--0~8
		WS2812B_COLORsc1<=0;
		WS2812B_B1_COLORi<=1;
		WS2812B_B0_COLORi<=2;
		WS2812B_dir<=0;
		WS2812BP_time_Dn<=1;
		WS2812B_xyshift<=0;
		WS2812B_flash_enable<='0';
		WS2812B_flashNS<=4;
		WS2812B_flashNES<='1';--回原始
		WS2812B_flash_add<="0000000000000000000000000000000000000000000000000000000000000000";--(others=>'0');
		WS2812B_flash_adds<=0;	--0:原狀 1:圖1 2:LED硬體1 3:圖雙1-2 4:LED硬體雙1-2 5:顏色1 6:雙顏色1-2 7:不等於顏色1 8:不等於雙顏色1-2
		WS2812B_ColorS1<=X"00FF00";--GRB
		WS2812B_ColorD1<=X"FFFF00";--GRB
		WS2812B_ColorS2<=X"FF0000";--GRB
		WS2812B_ColorD2<=X"FF00FF";--GRB
		WS2812B_flash_speed<=5;--0~7
		WS2812B_reset0<='0';
		WS2812BP_C_R<="111";WS2812BP_C_G<="111";WS2812BP_C_B<="111";

		WS2812B_mask_enable<='0';--mask致能
		WS2812B_mask_add<=(others=>'0');--mask addr
		WS2812B_mask_adds<=1;--1:圖1 2:LED硬體1
		WS2812B_mask_Ms<=2;--0:原狀 1:not 2:and 3:or 4:xor
		WS2812B_maskColorS1or2<=0;--0:無 1:ColorS1 2:ColorS1 & ColorS2 3:/=ColorS1 4:/=(ColorS1 & ColorS2)
		WS2812B_maskColorS1<=X"FF00FF";--GRB
		WS2812B_maskColorS2<=X"FF00FF";--GRB
		WS2812B_mask_R<=X"FF";WS2812B_mask_G<=X"FF";WS2812B_mask_B<=X"FF";--mask

		ADS1115_adcP<=0;
		
		Joystick_reset<='0';

		k:=16;						--無效鍵值
		S0on<='0';					--取消S0按鈕紀錄
		MMs<=5;						--處理結束
		Mx<=(others=>'0');			--功能執行紀錄
		st7735_reset0<='0';			--啟動TFT_LCD首次清空
		d0_setN<=7;					--去前導零處理位數設定

		--2024.03.30
		S_RESET_T<='0';			--關閉RS232傳送
		S_RESET_R<='0';			--關閉RS232接收
		Rx_R<='0';				--取消讀取信號
		TX_W<='0';				--取消資料載入信號
		CMDn_R<=0;				--接收數量(2 byte)
		CMDn_RS<=0;				--接收緩衝區偏移量
		CMDn<=0;				--上傳數量(0 byte)
		CMDnS<=0;				--上傳緩衝區偏移量

		kxx<='0';
		Joystickxx<='0';

		--x2
		--S_RESET_T2<='0';		--關閉RS232傳送
		--S_RESET_R2<='0';		--關閉RS232接收
		--Rx_R2<='0';				--取消讀取信號
		--TX_W2<='0';				--取消資料載入信號
		--CMDn_R2<=0;				--接收數量(2 byte)
		--CMDn_RS2<=0;			--接收緩衝區偏移量
		--CMDn2<=0;				--上傳數量(0 byte)
		--CMDnS2<=0;				--上傳緩衝區偏移量

		ESP8266RESETtime<=400;--800
		ESP8266_POWER<='0';	--經由L293D提供可控電源給ESP8266:off:L293D_1A=0=>1Y=0V
		sys_uartFs<='0';	--select sys f
		
		fp<=9;

	elsif (Rx_R='1' and Status_Rs(2)='0') then	--rs232接收即時處理
		Rx_R<='0';
	elsif (Rx_R2='1' and Status_Rs2(2)='0') then--rs232接收即時處理
		Rx_R2<='0';

	elsif rising_edge(E115_1_1_MainCLK) then
		--搖桿
		Joystick_reset<='1';
		--UART x1 x2===============================================
		if ESP8266RESETtime=0 then
			S_RESET_T<='1';			--RS232傳送 ON
			S_RESET_R<='1';			--RS232接收 ON
			--S_RESET_T2<='0';		--RS232傳送 OFF
			--S_RESET_R2<='0';		--RS232接收 OFF
		else
			ESP8266RESETtime<=ESP8266RESETtime-1;
			if ESP8266RESETtime=500 then
				ESP8266_POWER<='1';		--經由L293D提供可控電源給ESP8266:on:L293D_1A=1=>1Y=?V
			end if;
		end if;

		--UART x1 x2  ...==========================================
		--UART: x1 x2 全雙工
		if (S_RESET_T='1'and CMDn>0)or(S_RESET_R='1'and Status_Rs(2)='1'and CMDn_R>0) then
			sys_uartFs<='1';	--select uart f
			--x1
			if S_RESET_T='1'and CMDn>0 and TX_W='0'then--上傳剩餘數量
				if Status_Ts(1)='0' then--傳送緩衝區已空
					TX_W<='1';	--傳送資料載入
				end if;
			elsif TX_W='1'and Status_Ts(1)='1' then
				TX_W<='0';			--取消傳送資料載入時脈
				CMDn<=CMDn-1;		--指標指向下一筆資料
			end if;

			-----------------------
			--x1
			if S_RESET_R='1'and Status_Rs(2)='1'and Rx_R='0'and CMDn_R>0 then
				Rx_R<='1';					--讀取信號
				if CMDn_RS=511 then	--第一筆為實際數量
					CMDn_R<=conv_integer(RxDs);
					CMDn_RS<=conv_integer(RxDs);
				else
					CMDn_R<=CMDn_R-1;			--筆數減1
					ESP8266_FPGA(CMDn_RS-CMDn_R)<=RxDs;	--存入接收緩衝區
					ESP8266_FPGA_int(CMDn_RS-CMDn_R)<=conv_integer(RxDs);	--存入接收緩衝區

					--如傳輸資料中有未使用的碼時，此時可當作結束碼，如X"FF"
					if CMDn_RS=510 and RxDs=X"FF" then
						CMDn_R<=0;--結束接收
						CMDn_RS<=CMDn_RS-CMDn_R;--本次接收數
					end if;

					--如傳輸資料中有未使用的2碼時，此時可當作結束碼，如 X"FE" & X"FF"
					pre_item<=RxDs;--前一項
					if CMDn_RS=509 and CMDn_RS/=CMDn_R then
						if pre_item=X"FE" and RxDs=X"FF" then
							CMDn_R<=0;--結束接收
							CMDn_RS<=CMDn_RS-CMDn_R-1;--本次接收數
						end if;
					end if;

				end if;
			end if;

		--------------------------------------------------------
		else
			sys_uartFs<='0';	--select sys f
			--k4x4處理===========================
			k:=16;
			if kok='1' then	--按鈕輸入PB0~PB3
				k:=kv;--kv;0~3
				k2:=kv;--kv;0~3 k2:裝置原值
			elsif CMDn_R=0 and S_RESET_R='1' then--key0~key8
				k:=ESP8266_FPGA_int(0)+5;--5~13
				k2:=ESP8266_FPGA_int(0);--k2:裝置原值
				------------------------------------------------
				--避免如你的8266電源不穩定可能使系統誤動作(電源問題應先排除為上策)
				--如你的8266電源是穩定的可以取消這一部分
				if Rdatalength/=0 then
					S_RESET_R<='0';			--關閉RS232接收
					k:=16;
				end if;
				------------------------------------------------
				kxx<=not kxx;
			elsif Joystick_ok='1' then
				k:=Joystick_keyS+20;--20~28:20上 21下 22左 23右 24左上 25左下 26右上 27右下 28SW
				k2:=Joystick_keyS;	--k2:裝置原值0~8:0上 1下 2左 3右 4左上 5左下 6右上 7右下 8SW
				Joystickxx<=not Joystickxx;
			end if;
			CMDn_R<=1;
			if k/=16 then
				kout<=31-k;		--觀察用
			end if;

			if MM/=MMx then --實體指撥開關/=虛擬指撥開關狀態
				--sys_uartFs<='0';	--select sys f
				MM<=MMx;				--虛擬指撥開關等於實體指撥開關狀態
				S0on<='0';				--取消按鈕紀錄
				--UART-----------------------------------------
				S_RESET_T<='0';			--RS232傳送 OFF
				S_RESET_R<='0';			--RS232接收 OFF
	--			S_RESET_T2<='0';		--RS232傳送 OFF
	--			S_RESET_R2<='0';		--RS232接收 OFF
				CMDn_R<=1;	--接收數量(1 byte)
				CMDn_RS<=1;	--接收緩衝區偏移量
				CMDnS<=1;	--上傳緩衝區偏移量

				-------------------------------------------
				WS2812BP_reset<='0';
				WS2812B_8baseCOLOR(1 to 3)<=((X"FF",X"00",X"00"),--1 RED
										     (X"00",X"FF",X"00"),--2 GREEN
										     (X"00",X"00",X"FF"));--3 BLUE
				WS2812B_flash_enable<='0';
				WS2812B_mask_enable<='0';--mask致能
				-------------------------------------------
				st7735_P_RESET<='0';			--st7735_P off
				st7735_BLS<='1';				--背光on
				st7735_DATA_C_INC<=16;			--1~16
				st7735_COLMOD<=X"05";			--15 Default(06h)(18-bit/pixel)=R(6bit)G(6bit)B(6bit):(X"06"18-bit)(X"05"16-bit)(X"03"12-bit);
				st7735_INVCTR<=X"03";			--3 Default(03h): 0 0 0 0 0 NLA NLB NLC: 00000011
				st7735_MADCTL<=X"C0";			--4 Default(00h):MY(0) MX(0) MV(0) ML(0) RGB(0) MH(0) - -
				st7735_IDMOFF_ON<=X"38";		--6 Default IDMOFF (38h)(4k,65k,262k), IDMON (39h)(only 8 color)
				st7735_INVOFF_ON<=X"20";		--7 Default INVOFF (20h): Display Inversion Off, INVON (21h): Display Inversion On
				st7735_NORON_PTLON<=X"13";		--8 Default NORON (13h): Normal Display Mode On, PTLON (12h): Partial Display Mode On
				st7735_DISPON_OFF<=X"29";		--27 DISPON (29h), Default DISPOFF (28h)
				st7735_PSL<=0;					--列起點
				st7735_PEL<=161;				--列終點
				st7735_DATA_CPOINTER_begin<=0;	--行起點
				st7735_DATA_RPOINTER_begin<=0;	--列起點
				st7735_DATA_CPOINTER_end<=127;	--行終點 128:0~127
				st7735_DATA_RPOINTER_end<=159;	--列終點 160:0~159
				if st7735_reset0='0' then
					st7735_COM_POINTERs<=0;		--tft lcd命令指標
				else
					st7735_COM_POINTERs<=16;	--tft lcd命令指標
				end if;
				st7735_time_Dn<=0;				--完成後延遲時間設定
				B1_COLORi<=0;					--1選色 黑
				B0_COLORi<=7;					--0選色 白
				monoC<=0;						--單色操作
				isword<=false;					--圖形或字型:圖形
				remove_leading_0<='0';			--去前導零off
				d0_setN<=7;						--去前導零處理位數設定
				word_w<=20;						--字寬
				gdata0<=(others=>'0');			--單色圖樣	
				cbis<="0010";					--色盤:單色16bit
				st7735_ch<="0000";				--ch="0000"
				shift_y<=0;shift_x<=0;			--shift=0
			elsif st7735_reset0='0' then	--TFT_LCD首次清空
				if st7735_P_ok='1' then
					st7735_reset0<='1';
					st7735_P_RESET<='0';
				else
					gdata0<=(others=>'0');	--單色圖樣(全白)
					st7735_P_RESET<='1';
				end if;

			elsif WS2812B_reset0='0' then	--WS2812B首次清空
				if WS2812BP_ok='1' then
					WS2812B_reset0<='1';
					WS2812BP_reset<='0';
				else
					WS2812BP_Ms<=0;--0~8
					WS2812B_COLORsc1<=0;
					WS2812BP_reset<='1';
				end if;

			else
				--=====================================================================================
				--系統操作-----------------------------------------------------------------------------
				case MMx is
					--(128 X 160 TFT LCD測試)模式
					when "00" =>
						if S0on='0' then
							if k=0 then--啟動測試
								S0on<='1';	--紀錄S0on
								times1<=0;
								times2<=1;
								times3<=0;
								st7735_time_Dn<=0;
								st7735_P_RESET<='1';----全白
								k00sw:=true;
							end if;

						elsif k=1 then	--完成程序
							MM<=not MMx;--虛擬指撥開關等於實體指撥開關狀態

						else
							if st7735_P_ok='0' then
								st7735_P_RESET<='1';--on
							else
								st7735_P_RESET<='0';--off
								if k00sw then
									st7735_ch<="0001";		--ch="0001"
									B1_COLORi<=1;			--1選色:紅1
									B0_COLORi<=7;			--0選色:白7
									isword<=true;			--圖形或字型:字型
									word_w<=32;				--字寬
									st7735_DATA_CPOINTER_begin<=0;	--行起點
									st7735_DATA_CPOINTER_end<=127;	--行終點
									st7735_DATA_RPOINTER_begin<=10;	--列起點
									st7735_DATA_RPOINTER_end<=41;	--列終點
									st7735_DATA<=(times1,times1+1,times1+2,times1+3,0,0,0,0);--ABCD EFGH IJKL MNOP QRST UVWX YZss
--									if times1=24 then
--										st7735_DATA(3)<=26;--s
--									end if;
									times1<=(times1+4)mod 28;		--下一步
									beFriendC_P<=960;
									st7735_time_Dn<=0;		--完成後延遲時間設定0s
								else
									st7735_ch<="0001";		--ch="0001"
									B1_COLORi<=3;			--1選色:藍3
									B0_COLORi<=7;			--0選色:白7
									isword<=true;			--圖形或字型:字型
									word_w<=24;				--字寬
									st7735_DATA_CPOINTER_begin<=4;	--行起點
									st7735_DATA_CPOINTER_end<=123;	--行終點
									st7735_DATA_RPOINTER_begin<=70;	--列起點
									st7735_DATA_RPOINTER_end<=101;	--列終點
									st7735_DATA<=(11,times3,13,times2,12,0,0,0);--[y,x]
									times2<=(times2 mod 8)+1;
									times3<=(times3+times2/8)mod 9;
									--or
--									if times2=8 then
--										times2<=1;
--										if times3=8 then
--											times3<=0;
--										else
--											times3<=times3+1;
--										end if;
--									else
--										times2<=times2+1;
--									end if;
									beFriendC_P<=0;
									st7735_time_Dn<=50000000;		--完成後延遲時間設定1s
								end if;
								k00sw:=not k00sw;
							end if;
						end if;

					--(七段顯示器測試)模式
					when "01" =>
						D7_DB<=F012345(fp);	--顯示預設值
						if fp<9 then
							d7dot<=("00010000");--off--小數點
						end if;
						if k>4 and k<14 then
							----k2:裝置原值
--							fp<=k2;
--							F012345(k2)(0)<=(k2) mod 10;
--							F012345(k2)(1)<=(k2) / 10;

							fp<=k-5;
							F012345(k-5)(0)<=(k-5) mod 10;
							F012345(k-5)(1)<=(k-5) / 10;
						end if;
							
					--(資訊連動測試)模式
					when "10" =>
						if S0on='0' then
							if k=0 then--啟動測試
								S0on<='1';	--紀錄S0on
								st7735_time_Dn<=0;
								st7735_P_RESET<='1';--全白
								times1<=1;
								WS2812BP_reset<='1';
								WS2812BP_Ms<=5;
								WS2812B_dir<=0;
								WS2812BP_time_Dn<=300;--0.3s
								WS2812B_RGB3bitNx64(2)<=WS2812B_RGB3bitNx64(0);
								WS2812B_RGB3bitNx64P<=2;
							end if;

						elsif k=1 then	--完成程序
							MM<=not MMx;--虛擬指撥開關等於實體指撥開關狀態
						else
						--10LCD show----------------------------------------
							if WS2812BP_ok='0' then
								WS2812BP_reset<='1';
							else
								WS2812BP_reset<='0';
								times1<=times1+1;
								if times1<48 then
									if times1 mod 6=0 then
										WS2812B_RGB3bitNx64(2)<=WS2812B_RGB3bitNx64(2)(61 to 63) &  WS2812B_RGB3bitNx64(2)(0 to 60); 
									else
										WS2812B_RGB3bitNx64(2)<=WS2812B_RGB3bitNx64(2)(63) & WS2812B_RGB3bitNx64(2)(0 to 62);
									end if;
								elsif times1=48 then
									WS2812B_RGB3bitNx64(2)<=WS2812B_RGB3bitNx64(1);
									WS2812BP_time_Dn<=0;--0.001s
									WS2812B_xy<=36;
								elsif times1=49 then
									times1<=times1;
									WS2812BP_reset<='1';
									--k=20~28:20上 21下 22左 23右 24左上 25左下 26右上 27右下 28SW
									if k=20 then--20上
										if WS2812B_xy<56 then
											WS2812B_RGB3bitNx64(2)<=WS2812B_RGB3bitNx64(2)(56 to 63) &  WS2812B_RGB3bitNx64(2)(0 to 55);
											WS2812BP_reset<='0';
											WS2812B_xy<= WS2812B_xy+8;
										end if;
									elsif k=21 then--21下
										if WS2812B_xy>15 then
											WS2812B_RGB3bitNx64(2)<=WS2812B_RGB3bitNx64(2)(8 to 63) &  WS2812B_RGB3bitNx64(2)(0 to 7);
											WS2812BP_reset<='0';
											WS2812B_xy<= WS2812B_xy-8;
										end if;
									elsif k=22 then--22左
										if WS2812B_xy mod 8/=7 then
											WS2812B_RGB3bitNx64(2)<=WS2812B_RGB3bitNx64(2)(63) & WS2812B_RGB3bitNx64(2)(0 to 62);
											WS2812BP_reset<='0';
											WS2812B_xy<= WS2812B_xy+1;
										end if;
									elsif k=23 then--23右
										if WS2812B_xy mod 8/=1 then
											WS2812B_RGB3bitNx64(2)<=WS2812B_RGB3bitNx64(2)(1 to 63) & WS2812B_RGB3bitNx64(2)(0);
											WS2812BP_reset<='0';
											WS2812B_xy<= WS2812B_xy-1;
										end if;
									elsif k=28 then --28SW
										times1<=times1+1;
										WS2812BP_reset<='1';
									end if;
								else
									times1<=times1;
									WS2812BP_reset<='1';
								end if;
							end if;
						end if;

					--(整合型測試)模式
					when "11" =>
						if S0on='0' then
							if k=0 then--啟動測試
								S0on<='1';	--紀錄S0on
								D7_DB<=(others=>10);		--顯示預設值00000000
								d7dot<=(others=>'0');	--off--小數點
								times1<=0;
								times2<=0;
								times3<=0;
								times4<=0;
								times5<=0;
								st7735_time_Dn<=0;
								st7735_P_RESET<='1';----全白

								WS2812BP_reset<='1';
								WS2812BP_Ms<=5;
								WS2812B_dir<=0;
								WS2812BP_time_Dn<=0;--0.4s
								WS2812B_RGB3bitNx64(2)<=(others=>0);
								WS2812B_RGB3bitNx64P<=2;
								WS2812B_xy<=0;
								--亮度7階
								WS2812B_8baseCOLOR(1 to 3)<=((X"9F",X"00",X"00"),--1 RED
															 (X"00",X"9F",X"00"),--2 GREEN
															 (X"00",X"00",X"9F"));--3 BLUE
								WS2812BP_C_R<="100";WS2812BP_C_G<="100";WS2812BP_C_B<="100";

								fp<=9;
							end if;

						elsif k=1 then	--完成程序
							MM<=not MMx;--虛擬指撥開關等於實體指撥開關狀態

						else
							D7_DB<=F012345(fp);	--顯示預設值
							if fp<9 then
								d7dot<=("00010000");--off--小數點
							end if;
							if st7735_P_ok='0' or WS2812BP_ok='0' then
								WS2812BP_reset<='1';
								st7735_P_RESET<='1';--on
							else
								WS2812BP_reset<='0';
								st7735_P_RESET<='0';--off
								times3<=times3+1;
								if times3=0 then
									st7735_ch<="0001";		--ch="0001"
									B1_COLORi<=1;			--1選色:紅1
									B0_COLORi<=7;			--0選色:白7
									isword<=true;			--圖形或字型:字型
									word_w<=32;				--字寬
									st7735_DATA_CPOINTER_begin<=0;	--行起點
									st7735_DATA_CPOINTER_end<=127;	--行終點
									st7735_DATA_RPOINTER_begin<=10;	--列起點
									st7735_DATA_RPOINTER_end<=41;	--列終點
									st7735_DATA<=(0,1,2,3,0,0,0,0);--ABCD
									beFriendC_P<=960;
									st7735_time_Dn<=0;		--完成後延遲時間設定0s
								elsif times3=1 then
									st7735_ch<="0001";		--ch="0001"
									B1_COLORi<=3;			--1選色:藍3
									B0_COLORi<=7;			--0選色:白7
									isword<=true;			--圖形或字型:字型
									word_w<=24;				--字寬
									st7735_DATA_CPOINTER_begin<=4;	--行起點
									st7735_DATA_CPOINTER_end<=123;	--行終點
									st7735_DATA_RPOINTER_begin<=70;	--列起點
									st7735_DATA_RPOINTER_end<=101;	--列終點
									st7735_DATA<=(11,times1,13,times2,12,0,0,0);--[x,y]
									beFriendC_P<=0;
									if times1>0 then
										WS2812B_RGB3bitNx64(2)<=(others=>0);
										WS2812B_RGB3bitNx64(2)(WS2812B_xy to WS2812B_xy+1)<=(4,4);
										WS2812B_RGB3bitNx64(2)(WS2812B_xy+8 to WS2812B_xy+9)<=(4,4);
									end if;
									WS2812B_8baseCOLOR(1 to 3)<=((WS2812BP_C_R & "11111",X"00",X"00"),--1 RED
																 (X"00",WS2812BP_C_G & "11111",X"00"),--2 GREEN
										                         (X"00",X"00",WS2812BP_C_B & "11111"));--3 BLUE

								else
									WS2812BP_reset<='1';--on
									st7735_P_RESET<='1';--on
									times3<=times3;
									if times4/=0 and times5/=0 then
										if k=8 then--key3
											fp<=3;
											F012345(3)(0)<=times5 mod 10;
											F012345(3)(1)<=times5 / 10;
--											or
--											F012345(3)(0)<=WS2812B_xy/8+1;--y
--											F012345(3)(1)<=WS2812B_xy/10;
											
										end if;
									elsif times3=2 and times1=0 then --28SW
										if k=28 then --28SW
											times1<=1;
											times2<=1;
											times3<=1;
										end if;

									else
										--k=20~28:20上 21下 22左 23右 24左上 25左下 26右上 27右下 28SW
										case k is
											when 2 =>--PB2:亮度提高一級
												if WS2812BP_C_R<7 then
													WS2812BP_C_R<=WS2812BP_C_R+1;WS2812BP_C_G<=WS2812BP_C_G+1;WS2812BP_C_B<=WS2812BP_C_B+1;
													times3<=1;
												end if;
											when 3 =>--PB3:亮度降低一級
												if WS2812BP_C_R>2 then
													WS2812BP_C_R<=WS2812BP_C_R-1;WS2812BP_C_G<=WS2812BP_C_G-1;WS2812BP_C_B<=WS2812BP_C_B-1;
													times3<=1;
												end if;
											when 20 =>--20上
												if times2<7 then
													times2<=times2+1;
													WS2812B_xy<=WS2812B_xy+8;
													times3<=1;
												end if;
											when 21 =>--21下
												if times2>1 then
													times2<=times2-1;
													WS2812B_xy<=WS2812B_xy-8;
													times3<=1;
												end if;
											when 22 =>--22左
												if times1<7 then
													times1<=times1+1;
													WS2812B_xy<=WS2812B_xy+1;
													times3<=1;
												end if;
											when 23 =>--23右
												if times1>1 then
													times1<=times1-1;
													WS2812B_xy<=WS2812B_xy-1;
													times3<=1;
												end if;
											when 28 =>--28SW
												times3<=1;
												times4<=times1;
												times5<=times2;
												times1<=0;
												times2<=0;
											when others =>
												--
										end case;

									end if;
								end if;
							end if;
						end if;

					when others =>	
						null;
				end case;
				------------------------------------------------------------------------------------------------------------------------
			end if;
		end if;
	end if;
end process E115_1_1_Main;

--=====================================================================================
--ASD1115 ADCdata upload
process(ADS1115_loadck)
variable ASD1115load:std_logic:='0';
variable ADS1115loadP:integer range 0 to 15;
begin
	if ASD1115load/=ADS1115upload then
		ASD1115load:=ADS1115upload;
		ADS1115loadP:=0;
	elsif rising_edge(ADS1115_loadck) then
		if ADS1115loadP<8 then
			ADS1115_adcS(ADS1115loadP)<=ADS1115_ADC_16bit;
			if ADS1115_ADC_16bit(15)='0' then
				ADS1115_adc_signed(ADS1115loadP)<=0;
				ADS1115_adcN(ADS1115loadP)<=conv_integer(ADS1115_ADC_16bit)/(2**(15-ADS1115_bin));
			else
				ADS1115_adc_signed(ADS1115loadP)<=1;
				ADS1115_adcN(ADS1115loadP)<=(conv_integer(not ADS1115_ADC_16bit)+1)/(2**(15-ADS1115_bin));
			end if;
			ADS1115loadP:=ADS1115loadP+1;
		end if;
	end if;
end process;

----=====================================================================================
--七段顯示器---------------------------------------------------
--8位數掃瞄器
scan_P:process(FD(14),S_RESET)
begin
	if S_RESET='0' then
		scanP<=0;		--位數取值指標
		SCANo<="00000000";	--掃瞄信號 2803
		--SCANo<="11111111";	--掃瞄信號 共陰
	elsif rising_edge(FD(14)) then
		scanP<=scanP+1;
		SCANo<=SCANo(6 downto 0)&SCANo(7);
		if scanP=7 then
			scanP<=0;
			SCANo<="00000001";--掃瞄信號 2803
			--SCANo<="11111110";--掃瞄信號 共陰		
		end if;
	end if;
end process scan_P;

--BCD碼解共陽極七段顯示碼pgfedcba:d7dot(scanP)=1有小數點 ,flashs(scanP)=1小數點閃爍
flash_a_gs<="1111111" when (flash_a_g(scanP) and FD(23))='1' else "0000000";--gfedcba閃爍
D7LED<=not((not d7dot(scanP)or(d7dot(scanP)and flashs(scanP)and FD(23)))
		& (Disp7(D7_DB(scanP))or flash_a_gs));
--MAX7219
--MAX7219_s_D<=conv_std_logic_vector(MAX7219_s_intensity,8) when isMAX7219_s_intensity else
--			 conv_std_logic_vector(MAX7219_s_scan,8) when isMAX7219_s_scan else not(D7LED(7)&D7LED(0)&D7LED(1)&D7LED(2)&D7LED(3)&D7LED(4)&D7LED(5)&D7LED(6));
--MAX7219_s_A<=10 when isMAX7219_s_intensity else
--			 11 when isMAX7219_s_scan else scanP+1;

--WS2812BP=====================================================================================
WS2812BPCK<=SCLK;--WS2812BP操作頻率選擇
WS2812BP:process(WS2812BPCK)
variable swok:integer range 0 to 3;
variable WS2812B_LEDGRBdataS:std_logic_vector(23 downto 0);
variable mx16_1,mx16_2:std_logic_vector(15 downto 0);
variable WS2812B_N:integer range 0 to 64;
variable WS2812B_N1:integer range 0 to 63;
variable WS2812B_N3:integer range 0 to 7;
variable WS2812B_GRB_ok,FD20_27,WS2812B_flashS,WS2812B_flashNES1:std_logic;
variable WS2812B_flashN:integer range 0 to 15;--閃爍次數:0:結束，1~14次，15無限次數
variable RGBN:integer range 0 to 15;
variable td:integer range 0 to 50000;--.001s
variable tds:integer range 0 to 5000;--5s
type WS2812B_dirT is array (0 to 2) of integer range 0 to 63;
type WS2812B_dirT1 is array (0 to 15) of WS2812B_dirT;
constant WS2812B_dirxy:WS2812B_dirT1:=((0,1,1),		--0:0度
									   (56,56,57),	--1:順90度
									   (63,63,63),	--2:順180度
									   (7,8,7),		--3:順270度
									   (7,63,15),	--4:水平映射
									   (63,56,55),	--5:水平映射+順90度
									   (56,1,49),	--6:水平映射+順180度
									   (0,8,9),		--7:水平映射+順270度
									   (56,1,49),	--8:垂直映射
									   (0,8,9),		--9:垂直映射+順90度
									   (7,63,15),	--10:垂直映射+順180度
									   (63,56,55),	--11:垂直映射+順270度
									   (63,63,63),	--12:水平映射+垂直映射
									   (7,8,7),		--13:水平映射+垂直映射+順90度
									   (0,1,1),		--14:水平映射+垂直映射+順180度
									   (56,56,57)	--15:水平映射+垂直映射+順270度
									  );
variable WS2812B_flash_adds2:integer range 0 to 15;	--0:原狀 1:圖1 2:LED硬體1 3:圖雙1-2 4:LED硬體雙1-2 5:顏色1 6:雙顏色1-2 7:不等於顏色1 8:不等於雙顏色1-2
variable WS2812B_mask_adds2:integer range 0 to 1;--1:圖1 2:LED硬體1
variable WS2812B_mask_Ms2:integer range 0 to 15;--0:原狀 1:not 2:and 3:or 4:xor
begin
	if WS2812BP_reset='0' then
		swok:=0;
		WS2812BP_ok<='0';
		WS2812B_loadck<='0';
		WS2812B_GRB_ok:='0';
	elsif rising_edge(WS2812BPCK) then
		if swok<2 then
			if swok=0 then
				swok:=1;
				WS2812B_N1:=WS2812B_dirxy(WS2812B_dir)(0)+WS2812B_xyshift;--起點
				tds:=WS2812BP_time_Dn;
				td:=50000;--.001s
				WS2812B_N:=0;
				WS2812B_N3:=7;--7次
				FD20_27:=FD(20+WS2812B_flash_speed);
				WS2812BRESET<='0';
				if WS2812BP_ok='0' then
					WS2812B_flashN:=WS2812B_flashNS;
					WS2812B_flashNES1:=WS2812B_flashNES;
					WS2812B_flashS:=FD(20+WS2812B_flash_speed);
				end if;
			else
				if WS2812B_N=64 then--end
					if WS2812B_emitter_ok='0' then
						if tds=0 or WS2812BP_ok='1' then
							WS2812BP_ok<='1';	--end
							swok:=2;
							FD20_27:=FD(20+WS2812B_flash_speed);
						else
							td:=td-1;--delay time
							if td=0 then
								tds:=tds-1;
								td:=50000;--.001s
							end if;
						end if;
					end if;
				else
					if WS2812B_GRB_ok='0' then
						WS2812BRESET<='1';
						case WS2812BP_Ms is
							when 0 =>--基本色指定色:WS2812B_COLORsc1
								WS2812B_LEDGRBdataS:=WS2812B_8baseCOLOR(WS2812B_COLORsc1)(1) & WS2812B_8baseCOLOR(WS2812B_COLORsc1)(0) & WS2812B_8baseCOLOR(WS2812B_COLORsc1)(2);

							--右左_下上_橫
							when 1 =>--單色圖64bit指定色:WS2812B_64(,,) :WS2812B_64(WS2812B_64P)
								if WS2812B_64(WS2812B_64P)(WS2812B_N1)='1'
									then WS2812B_LEDGRBdataS:=WS2812B_8baseCOLOR(WS2812B_B1_COLORi)(1) & WS2812B_8baseCOLOR(WS2812B_B1_COLORi)(0) & WS2812B_8baseCOLOR(WS2812B_B1_COLORi)(2);
									else WS2812B_LEDGRBdataS:=WS2812B_8baseCOLOR(WS2812B_B0_COLORi)(1) & WS2812B_8baseCOLOR(WS2812B_B0_COLORi)(0) & WS2812B_8baseCOLOR(WS2812B_B0_COLORi)(2);
								end if;

							when 2 =>--單色圖(8x8bit)指定色:WS2812B_8x8((),()):WS2812B_8x8(WS2812B_8x8P)
								if WS2812B_8x8(WS2812B_8x8P)(WS2812B_N1/8)(WS2812B_N1 mod 8)='1'
									then WS2812B_LEDGRBdataS:=WS2812B_8baseCOLOR(WS2812B_B1_COLORi)(1) & WS2812B_8baseCOLOR(WS2812B_B1_COLORi)(0) & WS2812B_8baseCOLOR(WS2812B_B1_COLORi)(2);
									else WS2812B_LEDGRBdataS:=WS2812B_8baseCOLOR(WS2812B_B0_COLORi)(1) & WS2812B_8baseCOLOR(WS2812B_B0_COLORi)(0) & WS2812B_8baseCOLOR(WS2812B_B0_COLORi)(2);
								end if;	

							when 3 =>--單色圖(16x4bit)指定色WS2812B_16x4((),()):WS2812B_16x4(WS2812B_16x4P)
								if WS2812B_16x4(WS2812B_16x4P)(WS2812B_N1/16)(WS2812B_N1 mod 16)='1'
									then WS2812B_LEDGRBdataS:=WS2812B_8baseCOLOR(WS2812B_B1_COLORi)(1) & WS2812B_8baseCOLOR(WS2812B_B1_COLORi)(0) & WS2812B_8baseCOLOR(WS2812B_B1_COLORi)(2);
									else WS2812B_LEDGRBdataS:=WS2812B_8baseCOLOR(WS2812B_B0_COLORi)(1) & WS2812B_8baseCOLOR(WS2812B_B0_COLORi)(0) & WS2812B_8baseCOLOR(WS2812B_B0_COLORi)(2);
								end if;

							when 4 =>--RGB 8色圖(3bit)(RGB3bit x64:WS2812B_RGB3bitx64((),()):WS2812B_RGB3bitx64(WS2812B_RGB3bitx64P)
								RGBN:=WS2812B_8cRGB(conv_integer(WS2812B_RGB3bitx64(WS2812B_RGB3bitx64P)(WS2812B_N1)));
								WS2812B_LEDGRBdataS:=WS2812B_8baseCOLOR(RGBN)(1) & WS2812B_8baseCOLOR(RGBN)(0) & WS2812B_8baseCOLOR(RGBN)(2);

							when 5 =>--RGB 8色圖(3bit:0~7)(0~7x64:WS2812B_RGB3bitNx64((),()):WS2812B_RGB3bitNx64(WS2812B_RGB3bitNx64P)
								WS2812B_LEDGRBdataS:=WS2812B_8baseCOLOR(WS2812B_8cRGB(WS2812B_RGB3bitNx64(WS2812B_RGB3bitNx64P)(WS2812B_N1)))(1) &
													WS2812B_8baseCOLOR(WS2812B_8cRGB(WS2812B_RGB3bitNx64(WS2812B_RGB3bitNx64P)(WS2812B_N1)))(0) &
													WS2812B_8baseCOLOR(WS2812B_8cRGB(WS2812B_RGB3bitNx64(WS2812B_RGB3bitNx64P)(WS2812B_N1)))(2);

							when 6 =>--RGB 8色圖(RGB轉色表N:3bit:0~7)(0~7x64:WS2812B_RGB3bitTNx64((),()):WS2812B_RGB3bitTNx64(WS2812B_RGB3bitTNx64P)
								WS2812B_LEDGRBdataS:=WS2812B_8baseCOLOR(WS2812B_RGB3bitTNx64(WS2812B_RGB3bitTNx64P)(WS2812B_N1))(1) &
													WS2812B_8baseCOLOR(WS2812B_RGB3bitTNx64(WS2812B_RGB3bitTNx64P)(WS2812B_N1))(0) &
													WS2812B_8baseCOLOR(WS2812B_RGB3bitTNx64(WS2812B_RGB3bitTNx64P)(WS2812B_N1))(2);

							when 7 =>--RGB 8色圖(3bit)(RGB3bit x64:WS2812B_RGB3bitx64((),()):WS2812B_RGB3bitx64(WS2812B_RGB3bitx64P)
								RGBN:=WS2812B_8cGRB(conv_integer(WS2812B_GRB3bitx64(WS2812B_GRB3bitx64P)(WS2812B_N1)));
								WS2812B_LEDGRBdataS:=WS2812B_8baseCOLOR(RGBN)(1) & WS2812B_8baseCOLOR(RGBN)(0) & WS2812B_8baseCOLOR(RGBN)(2);

							when 8 =>--GRB 8色圖(3bit:0~7)(0~7x64:WS2812B_GRB3bitNx64((),()):WS2812B_GRB3bitNx64(WS2812B_GRB3bitNx64P)
								WS2812B_LEDGRBdataS:=WS2812B_8baseCOLOR(WS2812B_8cGRB(WS2812B_RGB3bitNx64(WS2812B_RGB3bitNx64P)(WS2812B_N1)))(1) &
													WS2812B_8baseCOLOR(WS2812B_8cGRB(WS2812B_RGB3bitNx64(WS2812B_RGB3bitNx64P)(WS2812B_N1)))(0) &
													WS2812B_8baseCOLOR(WS2812B_8cGRB(WS2812B_RGB3bitNx64(WS2812B_RGB3bitNx64P)(WS2812B_N1)))(2);

							when 9 =>--全彩色圖(8R8G/8B80=16bitx2):WS2812B_8R8G_8B16bit(WS2812B_8R8G_8B16bitP)(WS2812B_N1)
								mx16_1:=WS2812B_8R8G_8B16bit(WS2812B_8R8G_8B16bitP)(WS2812B_N1*2);--RG
								mx16_2:=WS2812B_8R8G_8B16bit(WS2812B_8R8G_8B16bitP)(WS2812B_N1*2+1);--B
								WS2812B_LEDGRBdataS:=mx16_1(7 downto 0)&mx16_1(15 downto 8)&mx16_2(15 downto 8);

							when 10 =>--全彩色圖(24bit)8G8R8B24bit:WS2812B_8G8R8B24bit(WS2812B_8G8R8B24bitP)(WS2812B_N1)
								WS2812B_LEDGRBdataS:=WS2812B_8G8R8B24bit(WS2812B_8G8R8B24bitP)(WS2812B_N1);

							when 11 =>--全彩色圖(24bit)8R8G8B24bit:WS2812B_8R8G8B24bit(WS2812B_8R8G8B24bitP)(WS2812B_N1)
								WS2812B_LEDGRBdataS:=WS2812B_8R8G8B24bit(WS2812B_8R8G8B24bitP)(WS2812B_N1)(15 downto  8)& 
													 WS2812B_8R8G8B24bit(WS2812B_8R8G8B24bitP)(WS2812B_N1)(23 downto 16)&
													 WS2812B_8R8G8B24bit(WS2812B_8R8G8B24bitP)(WS2812B_N1)(7 downto 0);

							when others =>
								-- 
						end case;
						WS2812B_GRB_ok:='1';

						--顏色轉換 閃爍-----------------------
						WS2812B_flash_adds2:=0;
						if WS2812B_flash_enable='1' then
							if (FD20_27 xor WS2812B_flashS)='1' then
								WS2812B_flash_adds2:=WS2812B_flash_adds;
							end if;
						else
							WS2812B_flash_adds2:=WS2812B_flash_adds;
						end if;
						case WS2812B_flash_adds2 is
							when 1 =>--1:圖1
								if WS2812B_flash_add(WS2812B_N1)='1' then
									WS2812B_LEDGRBdataS:=WS2812B_ColorD1;--(others=>'0');
								end if;
							when 2 =>--2:LED硬體1
								if WS2812B_flash_add(WS2812B_N)='1' then
									WS2812B_LEDGRBdataS:=WS2812B_ColorD1;--(others=>'0');
								end if;
							when 3 =>--3:圖雙1-2
								if WS2812B_flash_add(WS2812B_N1)='1' then
									WS2812B_LEDGRBdataS:=WS2812B_ColorD1;--(others=>'0');
								else
									WS2812B_LEDGRBdataS:=WS2812B_ColorD2;--(others=>'0');
								end if;
							when 4 =>--4:LED硬體雙1-2
								if WS2812B_flash_add(WS2812B_N)='1' then
									WS2812B_LEDGRBdataS:=WS2812B_ColorD1;--(others=>'0');
								else
									WS2812B_LEDGRBdataS:=WS2812B_ColorD2;--(others=>'0');
								end if;
							when 5 =>--5:顏色1
								if WS2812B_LEDGRBdataS=WS2812B_ColorS1 then
									WS2812B_LEDGRBdataS:=WS2812B_ColorD1;--(others=>'0');
								end if;
							when 6 =>--6:雙顏色1-2
								if WS2812B_LEDGRBdataS=WS2812B_ColorS1 then
									WS2812B_LEDGRBdataS:=WS2812B_ColorD1;--(others=>'0');
								elsif WS2812B_LEDGRBdataS=WS2812B_ColorS2 then
									WS2812B_LEDGRBdataS:=WS2812B_ColorD2;--(others=>'0');
								end if;
							when 7 =>--7:不等於顏色1
								if WS2812B_LEDGRBdataS/=WS2812B_ColorS1 then
									WS2812B_LEDGRBdataS:=WS2812B_ColorD1;--(others=>'0');
								end if;
							when 8 =>--8:不等雙顏色1-2
								if WS2812B_LEDGRBdataS/=WS2812B_ColorS1 then
									WS2812B_LEDGRBdataS:=WS2812B_ColorD1;--(others=>'0');
								elsif WS2812B_LEDGRBdataS/=WS2812B_ColorS2 then
									WS2812B_LEDGRBdataS:=WS2812B_ColorD2;--(others=>'0');
								end if;
							when others =>
								-- 
						end case;

						-- mask
						if WS2812B_mask_enable='1' then
							WS2812B_mask_adds2:=0;
							if WS2812B_mask_adds=1 and WS2812B_mask_add(WS2812B_N1)='1' then
								WS2812B_mask_adds2:=1;
							elsif WS2812B_mask_adds=2 and WS2812B_mask_add(WS2812B_N)='1' then
								WS2812B_mask_adds2:=1;
							end if;

							if WS2812B_mask_adds2/=0 then
								WS2812B_mask_Ms2:=0;
								if WS2812B_maskColorS1or2=0 then--0:無
									WS2812B_mask_Ms2:=WS2812B_mask_Ms;
								elsif WS2812B_maskColorS1or2=1 then--1:ColorS1
									if WS2812B_LEDGRBdataS=WS2812B_maskColorS1 then
										WS2812B_mask_Ms2:=WS2812B_mask_Ms;
									end if;
								elsif WS2812B_maskColorS1or2=2 then--2:ColorS1 & ColorS2
									if WS2812B_LEDGRBdataS=WS2812B_maskColorS1 then
										WS2812B_mask_Ms2:=WS2812B_mask_Ms;
									elsif WS2812B_LEDGRBdataS=WS2812B_maskColorS2 then
										WS2812B_mask_Ms2:=WS2812B_mask_Ms;
									end if;
								elsif WS2812B_maskColorS1or2=3 then--3:/=ColorS1
									if WS2812B_LEDGRBdataS/=WS2812B_maskColorS1 then
										WS2812B_mask_Ms2:=WS2812B_mask_Ms;
									end if;
								elsif WS2812B_maskColorS1or2=4 then--4:/=(ColorS1 & ColorS2)
									if WS2812B_LEDGRBdataS/=WS2812B_maskColorS1 then
										WS2812B_mask_Ms2:=WS2812B_mask_Ms;
									elsif WS2812B_LEDGRBdataS/=WS2812B_maskColorS2 then
										WS2812B_mask_Ms2:=WS2812B_mask_Ms;
									end if;
								end if;

								case WS2812B_mask_Ms2 is
									when 1 =>--not
										WS2812B_LEDGRBdataS:=not WS2812B_LEDGRBdataS;
									when 2 =>--and
										WS2812B_LEDGRBdataS:=WS2812B_LEDGRBdataS and (WS2812B_mask_G & WS2812B_mask_R & WS2812B_mask_B);
									when 3 =>--or
										if WS2812B_LEDGRBdataS(23 downto 16)/=0 then
											WS2812B_LEDGRBdataS(23 downto 16):=WS2812B_LEDGRBdataS(23 downto 16) or WS2812B_mask_G;
										end if;
										if WS2812B_LEDGRBdataS(15 downto 8)/=0 then
											WS2812B_LEDGRBdataS(15 downto 8):=WS2812B_LEDGRBdataS(15 downto 8) or WS2812B_mask_R;
										end if;
										if WS2812B_LEDGRBdataS(7 downto 0)/=0 then
											WS2812B_LEDGRBdataS(23 downto 16):=WS2812B_LEDGRBdataS(23 downto 16) or WS2812B_mask_G;
										end if;
									when 4 =>--xor
										WS2812B_LEDGRBdataS:=WS2812B_LEDGRBdataS xor (WS2812B_mask_G & WS2812B_mask_R & WS2812B_mask_B);
									when others =>
									-- 
								end case;
							end if;
						end if;

						WS2812B_LEDGRBdata<=WS2812B_LEDGRBdataS;

						-----------------------
						if WS2812B_N3=0 then
							WS2812B_N1:=WS2812B_N1+WS2812B_dirxy(WS2812B_dir)(2);
						else
							WS2812B_N1:=WS2812B_N1+WS2812B_dirxy(WS2812B_dir)(1);
						end if;
						WS2812B_N3:=WS2812B_N3-1;

					elsif WS2812B_loadck='0' then	--等待載入
						WS2812B_loadck<='1';
					else
						WS2812B_loadck<='0';
						WS2812B_N:=WS2812B_N+1;
						WS2812B_GRB_ok:='0';
					end if;
				end if;
			end if;
		--LED閃爍自動更新
		elsif WS2812B_flash_enable='1' and (FD(20+WS2812B_flash_speed)/=FD20_27) then
			if WS2812B_flashN/=0 then
				swok:=0;
				if WS2812B_flashN/=15 then--次數控制
					if (WS2812B_flashS xor FD(20+WS2812B_flash_speed))='1' then
						WS2812B_flashN:=WS2812B_flashN-1;
					end if;
				end if;
			elsif WS2812B_flashNES1='1' then--回原始
				swok:=0;
				WS2812B_flashNES1:=not WS2812B_flashNES1;
			end if;
		end if;
	end if;
end process WS2812BP;

--=====================================================================================
--tft lcd顯示器
--頁顯示資料解碼
--去前導零xxx.x
st7735_x0<=0 when st7735_DATA(0)>0 or remove_leading_0='0' or d0_setN=1 else
		   1 when st7735_DATA(1)>0 or d0_setN=2 else
		   2 when st7735_DATA(2)>0 or d0_setN=3 else
		   3 when st7735_DATA(3)>0 or d0_setN=4 else
		   4 when st7735_DATA(4)>0 or d0_setN=5 else
		   5 when st7735_DATA(5)>0 or d0_setN=6 else
		   6 when st7735_DATA(6)>0 or d0_setN=7 else
		   7;

--查字:isword=true ,--查圖:isword=false
beFriendC_PP<=beFriendC_P+st7735_xinc1_C+shift_y*word_w+shift_x when isword=false and monoC=1 else	--彩圖  :左上角圖shift_y and shift_x				--查圖
			  --beFriendC_P+st7735_xinc1_M+shift_y*W_w_b+shift_x 	when isword=false			  else	--單色圖:左上角圖shift_y and shift_x:16				--查圖
			   beFriendC_P+st7735_xinc1_M+shift_y*W_w_b+shift_x/16 	when isword=false			  else	--單色圖:左上角圖shift_y and shift_x:16				--查圖
			  beFriendC_P+st7735_DATA(st7735_x/W_w_b)*W_w_b*(st7735_DATA_RPOINTER_end-st7735_DATA_RPOINTER_begin+1)+(st7735_x mod W_w_b)+st7735_y*W_w_b;--查字

gdata1<=q when isword=false or (isword and(st7735_x/W_w_b>=st7735_x0)) else (others=>'0');--去前導零

--OV2640_image_P<=st7735_xinc1_C+shift_y*word_w+shift_x;
--gdata4<=OV2640_get_image;
--==============================================
--st7735_DATA_C_INC<=16;--1 to 16
--monoC<=0;				--單色圖操作
--word_w<=28;			--查字:字寬,查圖:圖寬
--st7735_DATA(x,x,x,x,x)--查字
--cbis<="0010";			--色盤:單色16bit
--
--16bit(5R6G5B)彩圖
--st7735_DATA_C_INC<=1;	--1
--monoC<=1;				--彩圖操作
--word_w<=28;			--圖寬
--cbis<="0110";			--色盤:彩圖 16bit
--==彩圖 16bit=======================================
--gdata565<= OV2640_get_image when is_OV2640 else q;
gdata565<=  q;
fc2(0)<="000"&gdata565(15 downto 11);--R
fc2(1)<="00"&gdata565(10 downto 5);--G
fc2(2)<="000"&gdata565(4 downto 0);--B
--fc2(0)<="000"&gdata1(15 downto 11);--R
--fc2(1)<="00"&gdata1(10 downto 5);--G
--fc2(2)<="000"&gdata1(4 downto 0);--B

-----------------------------------------------------
--水平線
gdata2<=(others=>'1') when st7735_yy1=st7735_y or st7735_yy2=st7735_y else (others=>'0');
--垂直線
gdata3<=st7735_VL1 when st7735_xx1=st7735_x else
		st7735_VL2 when st7735_xx2=st7735_x else (others=>'0');

--tft lcd顯示器================
--單色圖
with st7735_ch select
gdata<=gdata0	 when "0000",
	   gdata1 	 when "0001",
	   gdata2 	 when "0010",
	   gdata3 	 when "0011",
	   gdata4 	 when "0100",
	   gdata5 	 when "0101",
	   gdata6 	 when "0110",
	   gdata7 	 when "0111",
	   "1111111111111111"when "1000",
	   gdata9 	 when "1001",
	   gdata10 	 when others;

--色盤-------------------------
cbi<=cbis;

--單色圖1配色 或 彩色圖色------
fcri<=st7735_8baseCOLOR(B1_COLORi)(0) when monoC=0 else fc2(0);
fcgi<=st7735_8baseCOLOR(B1_COLORi)(1) when monoC=0 else fc2(1);
fcbi<=st7735_8baseCOLOR(B1_COLORi)(2) when monoC=0 else fc2(2);
--單色圖0配色---------------
bcri<=st7735_8baseCOLOR(B0_COLORi)(0) when monoC=0 else bc2(0);
bcgi<=st7735_8baseCOLOR(B0_COLORi)(1) when monoC=0 else bc2(0);
bcbi<=st7735_8baseCOLOR(B0_COLORi)(2) when monoC=0 else bc2(0);

--==========================
--單色圖水平剩餘點數解碼:st7735_DATA_C_INC:1~16
d8_1i<=(word_w mod 16)		when isword and (word_w mod 16)/=0 and (st7735_x mod W_w_b)=W_w_b-1 else
		st7735_DATA_C_INC	when st7735_DATA_CPOINTER+st7735_DATA_C_INC-1<=st7735_DATA_CPOINTER_end
							else st7735_DATA_CPOINTER_end-st7735_DATA_CPOINTER+1;
shift_Hdni<=shift_x mod 16 when st7735_x=0 and monoC=0 else 0;

--字型word							
W_w_b<=word_w/16 when (word_w mod 16)=0 else (word_w/16)+1;

-------命令-----------------------------------------------單色圖
cmpai<="00000000"&st7735_IT(st7735_COM_POINTER) when DCi(1)='0' else gdata;

-------命令參數解碼---------------------------------------------------
with st7735_IT(st7735_COM_POINTER) select	--only write command
st7735_COM_PN0<=1	when X"26", --GAMSET
				4	when X"2A", --CASET
				4	when X"2B", --RASET
				31	when X"2C", --SW:=false;--RAMWR 準備傳送顯示資料
				4	when X"30", --PTLAR
				1	when X"36", --MADCTL
				1	when X"3A", --COLMOD
				3	when X"B1", --FRMCTR1
				3	when X"B2", --FRMCTR2
				6	when X"B3", --FRMCTR3
				1	when X"B4", --INVCTR
				2	when X"B6", --DISSET5
				2	when X"C0", --PWCTR1
				1	when X"C1", --PWCTR2
				4	when X"C2", --PWCTR3
				4	when X"C3", --PWCTR4
				2	when X"C4", --PWCTR5
				2	when X"C5", --VMCTR1
				1	when X"C7", --VMOFCTR
				16	when X"E0", --GAMCTRP1
				16	when X"E1", --GAMCTRN1
				2	when X"FC", --PWCTR6
				3	when X"FF", --VCOM4L
				0	when others;--others command

--------------------------------------------------------------
st7735_CLK<=SCLK;			--st7735操作速率
st7735_P_CLK<=SCLK;			--st7735_P操作速率
st7735_P:process(st7735_P_CLK,st7735_P_RESET)
	variable SW:Boolean;	--狀態控制旗標
	variable SWok:std_logic;--完成控制旗標
	variable td:integer range 0 to 100000000;
begin
	if st7735_P_RESET='0' then
		st7735_RESET<='0';		--st7735_spi_tft_lcd_4w_driver重置
		st7735_COM_POINTER<=st7735_COM_POINTERs;--命令起點
		st7735_LoadCK<='0';		--Load CK
		st7735_COM_PN<=st7735_COM_PN0;
		SW:=true;				--載入狀態旗標
		if st7735_COM_PN0=31 then
			SW:=false;			--載入狀態旗標
		end if;
		st7735_x<=0;			--行x POINTER
		st7735_y<=0;			--列y POINTER
		st7735_xincN<=0;		--行x incN POINTER
		st7735_xinc1<=0;		--列x inc 1... POINTER
		st7735_xinc1_C<=0;		--彩圖
		st7735_xinc1_M<=0;		--單色圖
		st7735_P_ok<='0';		--st7735_P 完成指標
		SWok:='0';
		DCi<="00";				--DC--命令參數解碼
		td:=st7735_time_Dn;		--完成後延遲時間<=2S
	elsif rising_edge(st7735_P_CLK) then
		st7735_LoadCK<='0';
		if SWok='1' then
			if td=0 then
				st7735_P_ok<='1';	--結束
			else
				td:=td-1;
			end if;
		elsif st7735_RESET='0' then
			st7735_RESET<='1';		--啟動 st7735_spi_tft_lcd_4w_driver
			st7735_DATA_CPOINTER<=st7735_DATA_CPOINTER_begin;--行起點
			st7735_DATA_RPOINTER<=st7735_DATA_RPOINTER_begin;--列起點
		elsif st7735_COM_POINTER<st7735_IT'length and st7735_COM_PN/=31 then	--傳送命令
			if st7735_COM_PN=0 then
				DCi<="00";	--DC--命令參數解碼
			else
				DCi<="01";	--DC--命令參數解碼
			end if;
			if SW=true then
				st7735_COM_POINTER<=st7735_COM_POINTER+1;
				SW:=false;
			elsif st7735_reLOAD='0' then--載入
				st7735_LoadCK<='1';
				SW:=true;
				if st7735_COM_PN/=0 then
					st7735_COM_PN<=st7735_COM_PN-1;
				else	--命令參數解碼
					st7735_COM_PN<=st7735_COM_PN0;
					if st7735_COM_PN0=31 then	--RAMWR 準備傳送顯示資料
						SW:=false;				--載入狀態旗標
					end if;
				end if;
			end if;
		elsif st7735_COM_PN/=31 then	--只下指令
			SWok:=st7735_spi_ok;	--等待結束
		elsif st7735_DATA_RPOINTER<=st7735_DATA_RPOINTER_end then	--傳送顯示資料(畫面更新)
			DCi<="11";	--DC--命令參數解碼 顯示資料
			if SW then
				if isword and (word_w mod 16)/=0 and (st7735_x mod W_w_b)=W_w_b-1 then
					st7735_DATA_CPOINTER<=st7735_DATA_CPOINTER+(word_w mod 16);			--下一行或段
					st7735_xincN<=st7735_xincN+(word_w mod 16);
				else
					if monoC=0 then
						if st7735_x=0 then 
							st7735_DATA_CPOINTER<=st7735_DATA_CPOINTER+st7735_DATA_C_INC-(shift_x mod 16);		--下一行或段
							st7735_xincN<=st7735_xincN+st7735_DATA_C_INC-(shift_x mod 16);
						else
							st7735_DATA_CPOINTER<=st7735_DATA_CPOINTER+st7735_DATA_C_INC;		--下一行或段
							st7735_xincN<=st7735_xincN+st7735_DATA_C_INC;
						end if;
					else
						st7735_DATA_CPOINTER<=st7735_DATA_CPOINTER+st7735_DATA_C_INC;		--下一行或段
						st7735_xincN<=st7735_xincN+st7735_DATA_C_INC;
					end if;
				end if;
				st7735_x<=st7735_x+1;
				st7735_xinc1<=st7735_xinc1+1;
				st7735_xinc1_C<=st7735_xinc1_C+1;
				st7735_xinc1_M<=st7735_xinc1_M+1;
				if st7735_DATA_CPOINTER+st7735_DATA_C_INC>st7735_DATA_CPOINTER_end then	--資料換頁
					st7735_DATA_CPOINTER<=st7735_DATA_CPOINTER_begin;
					st7735_xincN<=0;
					st7735_x<=0;
					st7735_DATA_RPOINTER<=st7735_DATA_RPOINTER+1;--資料換頁 下一ROW
					st7735_y<=st7735_y+1;
					st7735_xinc1_C<=(st7735_y+1)*word_w;
					st7735_xinc1_M<=(st7735_y+1)*W_w_b;
				end if;
				SW:=false;				--載入狀態旗標
			elsif st7735_reLOAD='0' and DCi="11" then
				st7735_LoadCK<='1';
				SW:=true;				--載入狀態旗標
			end if;
		else
			SWok:=st7735_spi_ok;	--等待結束
		end if;
	end if;
end process st7735_P;

--=====================================================================================
--M7_76543210<=M70s(7)(2)&M70s(6)(2)&M70s(5)(2)&M70s(4)(2)&M70s(3)(2)&M70s(2)(2)&M70s(1)(2)&M70s(0)(2);--功能選擇
M701<=M70s(7)(1)&M70s(6)(1)&M70s(5)(1)&M70s(4)(1)&M70s(3)(1)&M70s(2)(1)&M70s(1)(1)&M70s(0)(1);
M702<=M70s(7)(2)&M70s(6)(2)&M70s(5)(2)&M70s(4)(2)&M70s(3)(2)&M70s(2)(2)&M70s(1)(2)&M70s(0)(2);
SW_CLK<=FD(18);	--防彈跳操作速率
process(SW_CLK)	--防彈跳
begin
	--M4..0防彈跳
	for i in 0 to 8 loop
		If M7_0(i)=M70s(i)(2) then
			M70s(i)<=M70s(i)(2)&"00";
		elsif rising_edge(SW_CLK) then
			M70s(i)<=M70s(i)+1;
		end if;
	end loop;
end process;

-- --------------------------
--除頻器
Freq_Div:process(SCLK)
begin
	if S_RESET='0' then
		FD<=(others=>'0');
		WS2812BCLK<='0';			--WS2812BN驅動頻率
	elsif rising_edge(SCLK) then
		FD<=FD+1;	--除頻器
		if FD2=6 then	--6~12急速運行
			FD2<=(others=>'0');
			WS2812BCLK<=not WS2812BCLK;--50MHz/20=2.5MHz T.=. 0.4us
		else
			FD2<=FD2+1;
		end if;
	end if;
end process Freq_Div;

-- ----------------------------
end HGL;