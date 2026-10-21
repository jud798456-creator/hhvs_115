--st7735_spi_tft_lcd_4w_driver_2
--109.07.22疭禬鰐硉
--Creator by YHGL
--﹃家Α Write mode
--DCi(2bit):00:㏑ 01:㏑把计 11:g戈
--cmpai(16bit):--㏑_把计 块,虫︹キ16翴image
--cb︹絃(4bit):xx01(12bit)xx10(16bit)xx11(18bit)
--fcrifcgifcbi(8bit):︹╰
--bcribcgibcbi(8bit):︹╰

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_unsigned.all;

--------------------------------------------------------------------------
entity  st7735_spi_tft_lcd_4w_driver_3 is
   port(  st7735_CLK,st7735_RESET:in std_logic;		--╰参,╰参竚
		  st7735_RES:in std_logic;					--ざ北:RESx块
		  st7735_BLS:in std_logic;					--ざ北:BL块
		  DCi:in std_logic_vector(1 downto 0);		--00:㏑ 01:㏑把计 11:g戈
		  
		  --cmpai:in std_logic_vector(7 downto 0);	--㏑_把计 块,キ8翴image
		  cmpai:in std_logic_vector(15 downto 0);	--㏑_把计 块,キ16翴image
		  
		  cbi:in std_logic_vector(3 downto 0);		--︹絃(4bit):xx01(12bit)xx10(16bit)xx11(18bit)
		  fcri,fcgi,fcbi:in std_logic_vector(7 downto 0);--︹╰
		  bcri,bcgi,bcbi:in std_logic_vector(7 downto 0);--︹╰
		  
		  --d8_1i:in integer range 0 to 8;			--キ逞緇翴计
		  d8_1i:in integer range 0 to 16;			--キ逞緇翴计1~16
		  shift_Hdni:integer range 0 to 15;			--キshift翴计0..15
		  --------------------------------------------------------------
		  st7735_RESX:out std_logic;				--ざIO:RESx块
		  st7735_CS:buffer std_logic;				--ざIO:CSx块
		  st7735_DC:out std_logic;					--ざIO:DCx块
		  st7735_SCL:buffer std_logic;				--ざIO:SCL块
		  st7735_SDA:out std_logic;					--ざIO:SDA块
		  st7735_BL:out std_logic;					--ざIO:BL块
		  --------------------------------------------------------------
		  st7735_reLOAD:out std_logic;				--更篨夹:0 更
		  st7735_LoadCK:in std_logic;				--更
		  st7735_spi_ok:buffer std_logic 			--ЧΘ篨夹
		);
end st7735_spi_tft_lcd_4w_driver_3;

--------------------------------------------------------------------------
architecture YHGL of st7735_spi_tft_lcd_4w_driver_3 is
	signal cmpa_hcd:std_logic_vector(23 downto 0);		--㏑_㏑把计_翴︹眒
	signal DCi_Bf,DC:std_logic_vector(1 downto 0);		--DC
	
	--signal cmpai_Bf,cmpa:std_logic_vector(7 downto 0);	--㏑_㏑把计_g戈
	signal cmpai_Bf,cmpa:std_logic_vector(15 downto 0);	--㏑_㏑把计_g戈
	
	signal fcri_Bf,fcr,fcgi_Bf,fcg,fcbi_Bf,fcb:std_logic_vector(7 downto 0);
	signal bcri_Bf,bcr,bcgi_Bf,bcg,bcbi_Bf,bcb:std_logic_vector(7 downto 0);
	signal cbi_Bf,cb:std_logic_vector(3 downto 0);		--︹絃
		
	--signal di:integer range 0 to 7;						--翴夹
	signal di:integer range 0 to 15;					--翴夹
	
	--signal d8_1i_Bf,d8_1:integer range 0 to 8;			--キ逞緇翴计
	signal d8_1i_Bf,d8_1:integer range 0 to 16;			--キ逞緇翴计1~16
	signal shift_Hdn_Bf:integer range 0 to 15;			--キshift翴计0..15
	
	signal cmpa_hcdi,cmpa_hcdis:integer range 0 to 31;	--㏑_㏑把计_g戈夹
	signal Buffer_Clr,Buffer_Empty:std_logic;
begin

st7735_RESX<=st7735_RES;
st7735_BL<=st7735_BLS;
-----------------------------------
--㏑_㏑把计_翴︹眒絪絏竟
cmpa_hcd<=--㏑_把计 块
	"00000000"& cmpa when DC(1)='0' else--㏑_把计
	--虫︹キ8翴皌︹
	"000000000000"&fcr(3 downto 0)&fcg(3 downto 0)&fcb(3 downto 0) 	when cmpa(di)='1' and cb="0001" else--12bit
	"000000000000"&bcr(3 downto 0)&bcg(3 downto 0)&bcb(3 downto 0) 	when cmpa(di)='0' and cb="0001" else--12bit
	"00000000"&fcr(4 downto 0)&fcg(5 downto 0)&fcb(4 downto 0) 		when cmpa(di)='1' and cb="0010" else--16bit
	"00000000"&bcr(4 downto 0)&bcg(5 downto 0)&bcb(4 downto 0) 		when cmpa(di)='0' and cb="0010" else--16bit
	fcr(5 downto 0)&"00"&fcg(5 downto 0)&"00"&fcb(5 downto 0)&"00" 	when cmpa(di)='1' and cb="0011" else--24bit
	bcr(5 downto 0)&"00"&bcg(5 downto 0)&"00"&bcb(5 downto 0)&"00" 	when cmpa(di)='0' and cb="0011" else--24bit
	fcr&fcg&fcb 													when cmpa(di)='1' and cb="0000" else--24bit
	bcr&bcg&bcb 													when cmpa(di)='0' and cb="0000" else--24bit
	--虫翴︹眒
	"000000000000"&fcr(3 downto 0)&fcg(3 downto 0)&fcb(3 downto 0)	when cb="0101" else--12bit
	"00000000"&fcr(4 downto 0)&fcg(5 downto 0)&fcb(4 downto 0) 		when cb="0110" else--16bit
	fcr(5 downto 0)&"00"&fcg(5 downto 0)&"00"&fcb(5 downto 0)&"00" 	when cb="0111" else--24bit
	--眒︹瓜翴(8bit RGB)
	"000000000000"&fcr(7 downto 4)&fcg(7 downto 4)&fcb(7 downto 4)	when cb="1001" else--12bit
	"00000000"&fcr(7 downto 3)&fcg(7 downto 2)&fcb(7 downto 3) 		when cb="1010" else--16bit
	fcr&fcg&fcb 													when cb="1011" else--24bit
	--杆眒︹瓜翴(じパfcb->fcg->fcr块)
	fcr&fcg&fcb 													when cb="1101" else--12bit
	fcr&fcg&fcb 													when cb="1110" else--16bit
	fcr&fcg&fcb 													when cb="1111" else--24bit
	--睲
	"000000000000000000000000";--others:0100,1000,1100 --24bit
--bit decode
cmpa_hcdis<=11 when cb(1 downto 0)="01" else
			15 when cb(1 downto 0)="10" else
			23 when cb(1 downto 0)="11" else 23;--00

-----------------------------------
st7735_reLOAD<=Buffer_Empty or Buffer_Clr;

Data_in:Process(st7735_LoadCK,st7735_RESET)
Begin
If st7735_RESET='0' or Buffer_Clr='1' Then
	Buffer_Empty<='0';
Elsif st7735_LoadCK'event and st7735_LoadCK='1' Then
	DCi_Bf<=DCi;
	cmpai_Bf<=cmpai;
	fcri_Bf<=fcri;fcgi_Bf<=fcgi;fcbi_Bf<=fcbi;
	bcri_Bf<=bcri;bcgi_Bf<=bcgi;bcbi_Bf<=bcbi;
	cbi_Bf<=cbi;
	d8_1i_Bf<=d8_1i;
	shift_Hdn_Bf<=shift_Hdni;
	Buffer_Empty<='1';		--Buffer_Empty='1'ボΤ戈糶(﹟ゼ肚)
End If;
End Process Data_in;

--DC--SDA-------------------------------
st7735_DC<=DC(0);--00:㏑ 01:㏑把计 11:g戈
st7735_SDA<=cmpa_hcd(cmpa_hcdi);

process(st7735_CLK,st7735_RESET)
begin
	if st7735_RESET='0' then
		Buffer_Clr<='0';
		DC<=DCi;
		cmpa<=cmpai;
		cmpa_hcdi<=7;
		st7735_CS<='1';
		st7735_SCL<='0';
		st7735_spi_ok<='0';	--砞ゼЧΘ篨夹
	elsif rising_edge(st7735_CLK) then
		Buffer_Clr<='0';	--挡睲埃buffer
		if st7735_spi_ok='1' then	--ЧΘ
			st7735_CS<='1';				--st7735 end
		elsif st7735_CS='1' then
			st7735_CS<='0';				--st7735 start 
		elsif st7735_SCL='0' then--and times=0 then
			st7735_SCL<='1';			--SCL 0->1
		else
			st7735_SCL<='0';			--SCL 1->0 or SCL 0->0
			if cmpa_hcdi>0 then			--㏑_㏑把计_g戈 癳Ч?
				cmpa_hcdi<=cmpa_hcdi-1;	--秸俱SDA夹
				
			--elsif DC(1)='1' and cb(3 downto 2)="00" and di>(8-d8_1) then--虫︹皌︹?
			elsif DC(1)='1' and cb(3 downto 2)="00" and di>(16-d8_1) then--虫︹皌︹?
				
				di<=di-1;
				cmpa_hcdi<=cmpa_hcdis;
			elsif Buffer_Empty='1' then	--掸竒秈ㄓ
				DC<=DCi_Bf;
				cmpa<=cmpai_Bf;
				fcr<=fcri_Bf;fcg<=fcgi_Bf;fcb<=fcbi_Bf;
				bcr<=bcri_Bf;bcg<=bcgi_Bf;bcb<=bcbi_Bf;
				cb<=cbi_Bf;
				d8_1<=d8_1i_Bf;
				
				--di<=7;
				di<=15-shift_Hdn_Bf;
				
				if DCi_Bf(1)='0' then
					cmpa_hcdi<=7;	--癳じ计8
				elsif cbi_Bf(1 downto 0)="01" then
					cmpa_hcdi<=11;	--癳じ计12
				elsif cbi_Bf(1 downto 0)="10" then
					cmpa_hcdi<=15;	--癳じ计16
				else				--11 or 00
					cmpa_hcdi<=23;	--癳じ计24
				end if;
				Buffer_Clr<='1';	--睲埃buffer
			else
				st7735_spi_ok<='1';--砞非称挡篨夹
			end if;
		end if;
	end if;
end process;

--------------------------------------------------------------
end YHGL;
