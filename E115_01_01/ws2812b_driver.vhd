--CPLD oR FPGA
--WS2812BCLK .=. 0.4us(9)
--WS2812B驅動器

Library IEEE;						--連結零件庫
Use IEEE.std_logic_1164.all;		--引用套件
Use IEEE.std_logic_unsigned.all;	--引用套件

-- ----------------------------------------------------
entity WS2812B_Driver is
	port(	WS2812BCLK,WS2812BRESET,WS2812B_loadck:in std_logic;--操作頻率,重置,載入ck
			WS2812B_LEDGRBdata:in std_logic_vector(23 downto 0);--色彩資料
			WS2812B_reload,WS2812B_emitter_ok,WS2812Bout:out std_logic		--要求載入,發射狀態,發射輸出 
		);
end entity WS2812B_Driver;

-- -----------------------------------------------------
architecture HGL of WS2812B_Driver is
	signal LEDGRBdata0,LEDGRBdata1:std_logic_vector(23 downto 0);--色彩資料載入
	signal DATA01:std_logic_vector(2 downto 0):="000";			 --編碼位元:bit out=>0:100,1:110
	signal DATAn:integer range 0 to 31:=0;	--色彩資料位元指標
	signal bitn:integer range 0 to 3:=0;	--編碼位元發射數
	type WS2812B_t24bit is array (0 to 63) of std_logic_vector(23 Downto 0);
	signal WS2812B_receive_buffer:WS2812B_t24bit;
	signal WS2812B_receive_bufferP,WS2812B_get_bufferP:integer range 0 to 64:=0;
-- --------------------------
begin

WS2812Bout<=DATA01(2);--LED色彩資料位元輸出

--預載緩衝器--------------------------------------------
LEDdata_load:
process(WS2812B_loadck,WS2812BRESET)
begin
	if WS2812BRESET='0' then
		WS2812B_receive_bufferP<=0;
	elsif rising_edge(WS2812B_loadck) then	--色彩資料載入ck
		WS2812B_receive_buffer(WS2812B_receive_bufferP)<=WS2812B_LEDGRBdata;	--色彩資料載入緩衝器
		WS2812B_receive_bufferP<=WS2812B_receive_bufferP+1;
	end if;
end process LEDdata_load;

WS2812B_Send:--------------------------------------------
process(WS2812BCLK,WS2812BRESET)
begin
	if WS2812BRESET='0' then
		DATA01<="000";	--輸出停止位元
		WS2812B_emitter_ok<='0';	--停止發射
		DATAn<=0;		--等待發射位元數
		bitn<=0;		--編碼位元發射剩0位元
		WS2812B_get_bufferP<=0;
	elsif rising_edge(WS2812BCLK) then
		if bitn/=0 then			--尚有編碼位元未發射
			DATA01<=DATA01(1 downto 0) & "0";--發射位元
			bitn<=bitn-1;					 --編碼位元發射位元減1
		elsif DATAn/=0 then		--尚有資料位元未編碼
			DATA01<='1' & LEDGRBdata0(DATAn-1) & '0';--發射位元編碼(等待發射位元編碼成3位元)
			DATAn<=DATAn-1;				--等待發射位元數減1
			bitn<=2;					--編碼位元發射剩2位元
		elsif WS2812B_get_bufferP/=WS2812B_receive_bufferP then	--緩衝器已有色彩資料進來
			LEDGRBdata0<=WS2812B_receive_buffer(WS2812B_get_bufferP);	--色彩資料載入
			WS2812B_get_bufferP<=WS2812B_get_bufferP+1;
			DATAn<=23;					--等待發射位元數
			DATA01<='1' & WS2812B_receive_buffer(WS2812B_get_bufferP)(23) & '0';--發射位元編碼(等待發射位元編碼成3位元)
			bitn<=2;					--編碼位元發射剩2位元
			WS2812B_emitter_ok<='1';				--發射中
		else					--緩衝器無色彩資料
			WS2812B_emitter_ok<='0';				--停止發射
		end if;
	end if;
end process WS2812B_Send;
--------------------------------------------
end HGL;
