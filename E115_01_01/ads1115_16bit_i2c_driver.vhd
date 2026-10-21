--ADS1115_16BIT_i2c_driver
--Creator by HGL
--ADS1115_ID="10010"內定+ADS1115_ADDR:
--ADS1115_ADDR=GND"1001000"X48 ,ADS1115_ADDR=VCC"1001001"X49 ,ADS1115_ADDR=SDA"1001010"X4A ,ADS1115_ADDR=SCL"1001011"X4B
--Address=(8:bit 0~255)(r=1/w=0)

library ieee;
	use IEEE.std_logic_1164.all;
	use IEEE.std_logic_unsigned.all;
	use ieee.std_logic_arith.all;

--------------------------------------------------------------------------
Entity ADS1115_16BIT_i2c_driver is
   Port(I2CCLK,RESET,S_reset:in std_logic;			--系統時脈,系統重置
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
End ADS1115_16BIT_i2c_driver;
--單筆操作:D_W_R_N=1
--多筆操作:由D_W_R_N指定,每完成1筆回D_W_R_Nok,收到reWR後再進行下一筆

--------------------------------------------------------------------------
Architecture HGL of ADS1115_16BIT_i2c_driver is
	Signal ADDR:std_logic_vector(7 downto 0);	--位置
	Signal DATAin:std_logic_vector(7 downto 0);	--資料輸入
	Signal DATAout:std_logic_vector(7 downto 0);	--資料輸出
	Signal RW:std_logic;								--讀寫
	Signal RWN:integer range 0 to 15;				--嘗試讀寫次數
	Signal D_W_R_N:integer range 0 to 63;		 	--連續讀寫次數
	Signal D_W_R_Nok:std_logic;				--讀寫1次數旗標
	Signal reWR:std_logic;						--已寫入或讀出資料
	Signal Wdata:std_logic_vector(29 downto 0);		--寫命令表
	Signal Rdata:std_logic_vector(40 downto 0);		--讀命令表
	Signal I2C_RESET:std_logic;
	Signal I2Creset,SCLs,SDAs,I2Cok,I2CS:std_logic;
	Signal I:integer range 0 to 2;		 				--相位指標
	Signal WN,WNend:integer range 0 to 29;			 	--命令指標
	Signal RN,RNs:integer range 0 to 40;				--命令指標
	Signal PN:integer range 0 to 29;					--命令指標
	Signal RWNS:integer range 0 to 15;					--嘗試讀寫次數計數器
	Signal D_W_R_Ns:integer range 0 to 63;
	Signal I2C_ADDR:std_logic_vector(6 downto 0);
	Signal sw,swreset:boolean:=false;
	type ADS1115_T0 is array (0 to 15) of std_logic_vector(7 Downto 0);
	signal ADS1115_C_D:ADS1115_T0:=(OTHERS=>X"00");
	signal ADS1115_C_D_P,ADS1115loadP:integer range 0 to 15;
	Signal ADS1115loads:std_logic:='0';
	Signal isini,chn:integer range 0 to 15;
	type ADS1115_CHNT0 is array (0 to 7) of std_logic_vector(15 Downto 0);
	signal ADS1115_CHN:ADS1115_CHNT0:=(OTHERS=>X"0000");
	signal ADS1115_Input_MUXs:std_logic_vector(7 downto 0);

Begin
---------------------------------------------------------------------------
--ADDR=GND"1001000"X48 ,ADDR=VCC"1001001"X49 ,ADDR=SDA"1001010"X4A ,ADDR=SCL"1001011"X4B
I2C_ADDR<="10010" & ADS1115_ADDR;--ID & ADS1115_ADDR; ID<="10010"
DATAin<=ADS1115_C_D(ADS1115_C_D_P);

--單筆操作:D_W_R_N=1
--多筆操作:由D_W_R_N指定,每完成1筆回D_W_R_Nok,收到reWR後再進行下一筆
Process(I2CCLK,RESET,S_reset)
Begin
	If RESET='0' or S_reset='0' Then
		sw<=false;
		ADS1115_Input_MUXs<=ADS1115_Input_MUX;
		I2C_RESET<='0';
		ADS1115loads<='0';
		if S_reset='0' then
			swreset<=true;
		end if;
		if swreset then
			isini<=0;
		else
			isini<=2;
		end if;
		ADS1115_ok<='0';

	Elsif Rising_Edge(I2CCLK) Then
		if sw then--run I2C
			if D_W_R_N>0 then
				if D_W_R_Nok='0' then
					I2C_RESET<='1';
					reWR<='0';
				--elsif (reWR='0' and D_W_R_N>1)or(D_W_R_N=1 and I2CoK='1') then
				elsif reWR='0' then
					ADS1115_C_D_P<=ADS1115_C_D_P+1;--write
					if RW='1' then--read
						ADS1115_CHN(chn)<=ADS1115_CHN(chn)(7 downto 0) & DATAout;
					end if;
					D_W_R_N<=D_W_R_N-1;
					reWR<='1';
				end if;
			else--I2C ok
				if isini=3 then
					ADS1115_Input_MUXs(chn)<='0';
				end if;
				I2C_RESET<='0';
				sw<=false;
			end if;

		else
			ADS1115_C_D_P<=0;
			if isini=0 then--conversion-ready function of the ALERT/RDY pin
				ADDR<="00000011";--Hi_thresh Register
				ADS1115_C_D(0)<="10000000";--Hi_thresh[15:8]
				ADS1115_C_D(1)<="00000000";--Hi_thresh[7:0]
				RW<='0';	--/WRITE
				D_W_R_N<=2;	--連續讀取D_W_R_N次
				isini<=1;
				sw<=true;

			elsif isini=1  then--conversion-ready function of the ALERT/RDY pin
				ADDR<="00000010";--Lo_thresh Register
				ADS1115_C_D(0)<="00000000";--Lo_thresh[15:8]
				ADS1115_C_D(1)<="00000000";--Lo_thresh[7:0]
				RW<='0';	--/WRITE
				D_W_R_N<=2;	--連續讀取D_W_R_N次
				isini<=2;
				sw<=true;

			elsif isini=2  then
				ADDR<="00000001";--Config register
				RW<='0';	--/WRITE
				D_W_R_N<=2;	--連續讀取D_W_R_N次
				isini<=3;
				sw<=true;

				if ADS1115_Input_MUXs(0)='1' then--000 : AINP = AIN0 and AINN = AIN1
					chn<=0;
					ADS1115_C_D(0)<="1000" & ADS1115_Input_FSR_PGA(2 downto 0) & '1';--Config register[15:8]=>OS MUX[2:0] PGA[2:0] MODE(1:Single-shot mode)
					ADS1115_C_D(1)<=ADS1115_Input_DR(2 downto 0) & "00000";--Config register[7:0]=>DR[2:0] COMP_MODE COMP_POL COMP_LAT COMP_QUE[1:0]
				elsif ADS1115_Input_MUXs(1)='1' then--001 : AINP = AIN0 and AINN = AIN3
					chn<=1;
					ADS1115_C_D(0)<="1001" & ADS1115_Input_FSR_PGA(5 downto 3) & '1';--Config register[15:8]=>OS MUX[2:0] PGA[2:0] MODE(1:Single-shot mode)
					ADS1115_C_D(1)<=ADS1115_Input_DR(5 downto 3) & "00000";--Config register[7:0]=>DR[2:0] COMP_MODE COMP_POL COMP_LAT COMP_QUE[1:0]
				elsif ADS1115_Input_MUXs(2)='1' then--010 : AINP = AIN1 and AINN = AIN3
					chn<=2;
					ADS1115_C_D(0)<="1010" & ADS1115_Input_FSR_PGA(8 downto 6) & '1';--Config register[15:8]=>OS MUX[2:0] PGA[2:0] MODE(1:Single-shot mode)
					ADS1115_C_D(1)<=ADS1115_Input_DR(8 downto 6) & "00000";--Config register[7:0]=>DR[2:0] COMP_MODE COMP_POL COMP_LAT COMP_QUE[1:0]
				elsif ADS1115_Input_MUXs(3)='1' then--011 : AINP = AIN2 and AINN = AIN3
					chn<=3;
					ADS1115_C_D(0)<="1011" & ADS1115_Input_FSR_PGA(11 downto 9) & '1';--Config register[15:8]=>OS MUX[2:0] PGA[2:0] MODE(1:Single-shot mode)
					ADS1115_C_D(1)<=ADS1115_Input_DR(11 downto 9) & "00000";--Config register[7:0]=>DR[2:0] COMP_MODE COMP_POL COMP_LAT COMP_QUE[1:0]
				elsif ADS1115_Input_MUXs(4)='1' then--100 : AINP = AIN0 and AINN = GND
					chn<=4;
					ADS1115_C_D(0)<="1100" & ADS1115_Input_FSR_PGA(14 downto 12) & '1';--Config register[15:8]=>OS MUX[2:0] PGA[2:0] MODE(1:Single-shot mode)
					ADS1115_C_D(1)<=ADS1115_Input_DR(14 downto 12) & "00000";--Config register[7:0]=>DR[2:0] COMP_MODE COMP_POL COMP_LAT COMP_QUE[1:0]
				elsif ADS1115_Input_MUXs(5)='1' then--101 : AINP = AIN1 and AINN = GND
					chn<=5;
					ADS1115_C_D(0)<="1101" & ADS1115_Input_FSR_PGA(17 downto 15) & '1';--Config register[15:8]=>OS MUX[2:0] PGA[2:0] MODE(1:Single-shot mode)
					ADS1115_C_D(1)<=ADS1115_Input_DR(17 downto 15) & "00000";--Config register[7:0]=>DR[2:0] COMP_MODE COMP_POL COMP_LAT COMP_QUE[1:0]
				elsif ADS1115_Input_MUXs(6)='1' then--110 : AINP = AIN2 and AINN = GND
					chn<=6;
					ADS1115_C_D(0)<="1110" & ADS1115_Input_FSR_PGA(20 downto 18) & '1';--Config register[15:8]=>OS MUX[2:0] PGA[2:0] MODE(1:Single-shot mode)
					ADS1115_C_D(1)<=ADS1115_Input_DR(20 downto 18) & "00000";--Config register[7:0]=>DR[2:0] COMP_MODE COMP_POL COMP_LAT COMP_QUE[1:0]
				elsif ADS1115_Input_MUXs(7)='1' then--111 : AINP = AIN3 and AINN = GND
					chn<=7;
					ADS1115_C_D(0)<="1111" & ADS1115_Input_FSR_PGA(23 downto 21) & '1';--Config register[15:8]=>OS MUX[2:0] PGA[2:0] MODE(1:Single-shot mode)
					ADS1115_C_D(1)<=ADS1115_Input_DR(23 downto 21) & "00000";--Config register[7:0]=>DR[2:0] COMP_MODE COMP_POL COMP_LAT COMP_QUE[1:0]
				else --end
					sw<=false;
					isini<=4;
					ADS1115loads<=not ADS1115loads;
				end if;

			elsif isini=3 then
				if ADS1115_ALERT_RDY='0' then
					ADDR<="00000000";--Conversion Register
					RW<='1';	--read
					D_W_R_N<=2;	--連續讀取D_W_R_N次
					isini<=2;
					sw<=true;
				end if;

			elsif isini=4 then
				ADS1115_ok<='1';
				swreset<=false;
			end if;
		end if;
	end If;

end process;

--ADS1115 data upload--------------------------
ADS1115_ADC_16bit<=ADS1115_CHN(ADS1115loadP);

process(ADS1115_uploadck)
begin
	if ADS1115upload/=ADS1115loads then
		ADS1115upload<=ADS1115loads;
		ADS1115loadP<=0;
		ADS1115_loadck<='0';
	elsif rising_edge(ADS1115_uploadck) then
		if ADS1115loadP<8 then
			ADS1115_loadck<=not ADS1115_loadck;
			if ADS1115_loadck='1' then
				ADS1115loadP<=ADS1115loadP+1;
			end if;
		end if;
	end if;
end process;

--I2C==READ & WRITE================
-----------------------------------
SDA<='0' when SDAs='0' else 'Z';
SCL<='0' when SCLs='0' else '1';
--介面IO:SCL,如有接提升電阻時可設成inout
--SCL<='0' when SCLs='0' Else 'Z';
--MPU6050模組上已有接提升電阻
-----------------------------------
process(I2CCLK,I2C_RESET)
begin
	if I2C_RESET='0' then
		--I2C
		--Write
		--      S      裝置碼     /寫  ack     位址    ack  寫入資料  ack    P
		--		s   I2C_ADDR7bit  /W   ack   MPU_ADDR  ack   w_DATA   ack    P
		Wdata<='0' &  I2C_ADDR  & '0' & '1' &   ADDR  & '1' & DATAin & '1' & "00";	--(0)沒用到,結束碼
		--page write:D_W_R_Ns>1,WN再從10起,下一筆放入Wdata(10 downto 3)<=DATAin;
		WN<=29;

		--Random Read:
		--      S      裝置碼     /寫   ack     位址    ack
		--      S    I2C_ADDR7bit  W    ack   MPU_ADDR  ack    Sr    I2C_ADDR7bit   R    ack     R_DATA     ack    P
		Rdata<='0' &  I2C_ADDR  & '0' & '1' &   ADDR  & '1' & "10" &  I2C_ADDR   & '1' & '1' & "11111111" & '1' & "00";	--(0)沒用到,結束碼
		RN<=40;	--指定位址讀取
		RNs<=40;

		I<=0;
		WNend<=0;

		PN<=29;

		SCLs<='1';
		SDAs<='1';
		I2CoK<='0';
		I2CS<='0';

		RWNS<=RWN;			--嘗試讀寫次數
		D_W_R_Ns<=D_W_R_N;	--連續讀取D_W_R_N次
		D_W_R_Nok<='0';
		I2Creset<='0';

	elsif rising_edge(I2CCLK) then
		if I2Cok='0' then
		--失敗再嘗試
			if I2Creset='1' then	--重新起始
				SCLs<='1';			--bus暫停
				SDAs<='1';
				I<=0;RN<=RNs;WN<=29;
				if PN=0 then		--暫停時間
					PN<=29;
					I2Creset<='0';
					RWNS<=RWNS-1;	--嘗試讀寫次數
					if RWNS<=1 then
						I2Cok<='1';	--完成
						I2CS<='1';	--失敗
					end if;
				else
					PN<=PN-1;
				end if;

	--	RW='0':Byte Write or Page Write to EEPROM and chech Write ok
			elsif RW='0' then
				if D_W_R_Nok='1' then
					D_W_R_Nok<=not reWR;		--繼續下一筆寫入
					Wdata(10 downto 3)<=DATAin;	--下一筆載入
				elsif WN=WNend then 			--WNend結束點(正常時為0,MAXII_V erase非零)
					SDAs<='1';						--Stop
					I2CoK<='1';
					D_W_R_Nok<='1';
				else
					I<=I+1;
					case I is
						when 0 =>
							SDAs<=Wdata(WN);
						when 1 =>
							SCLs<='1';
							WN<=WN-1;
							if WN=20 or WN=11 or WN=2 then
								I2Creset<=SDA;	--讀EEPROM發出的ACK(低態:正常,高態:錯誤)
							end if;
						when oThers =>
							SCLs<='0';
							I<=0;
							if D_W_R_Ns/=1 and WN=1 then	--Page write
								D_W_R_Nok<='1';
								D_W_R_Ns<=D_W_R_Ns-1;
								WN<=10;
							end if;
					end case;
				end if;

	--	RW='1':Random Read EEPROM or squential read
			else
				if D_W_R_Nok='1' then
					D_W_R_Nok<=not reWR;
				elsIf RN=0 then
					SDAs<='1';						--Stop
					I2CoK<='1';						--完成
					D_W_R_Nok<='1';
				else
					I<=I+1;
					case I is
						when 0 =>
							SDAs<=Rdata(RN);
						when 1 =>
							SCLs<='1';
							RN<=RN-1;
							if RN=31 or RN=22 or RN=11 then
								I2Creset<=SDA;		--讀EEPROM發出的ACK(低態:正常,高態:錯誤)	
							end if;
							if RN<11 and RN>2 then
								DATAout<=DATAout(6 downto 0) & SDA;--讀EEPROM發出資料位元
							end if;
							If RN=21 then			--restart
								I<=0;
							end if;
						when oThers =>
							SCLs<='0';
							I<=0;
							if D_W_R_Ns/=1 then		--連續讀取D_W_R_Ns次
								Rdata(2)<='0';		--回0:acknowledge
								if RN=1 Then
									D_W_R_Nok<='1';
									D_W_R_Ns<=D_W_R_Ns-1;
									RN<=10;
								end if;
							else
								Rdata(2)<='1';		--回1:not acknowledge
							end if;
					end case;
				end if;
			end if;
		end if;
	end if;

end process;

--------------------------------------------------------------
end HGL;