--creator by HGL
--2026.07.xx
--2x2
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity k4x4 is
	port 
	(	kf,reset: in std_logic;
		ki: in std_logic_vector(1 downto 0);
		ko: buffer std_logic_vector(1 downto 0);
		kn,kv: buffer integer range 0 to 16;
		kASCII: out std_logic_vector(7 downto 0);
		kok,koo: buffer std_logic	--koo測試觀察用
	);
end entity;

architecture HGL of k4x4 is
	signal ki2,ko2:std_logic_vector(3 downto 0);
	signal ks:integer range 0 to 255:=0;--鍵盤操作
	constant ks_end:integer range 0 to 255:=200;--控制回送速率
	type k_T is array (0 to 15) of integer range 0 to 16;

	--k4x4:--鍵值轉換表
	--位置碼kn	鍵值kv 
--	0123		01xx =>	 0		 1		16		16
--	4567	->	23xx =>	 2		 3		16		16
--	89AB	->	xxxx =>	16		16		16		16
--	CDEF		xxxx =>	16		16		16		16

	--k4x4:--鍵值轉換表
	constant kn_kv:k_T:=( 0, 1,16,16,
						  2, 3,16,16,
						 16,16,16,16,
						 16,16,16,16 );--鍵值轉換表

	--k4x4:--鍵值轉換表
	type k_ASCIIT is array (0 to 15) of std_logic_vector(7 downto 0);
	constant kn_kASCII:k_ASCIIT:=( X"30",X"31",X"32",X"33",
								   X"32",X"33",X"35",X"37",
								   X"36",X"37",X"38",X"0B",
								   X"0C",X"0D",X"0E",X"0F");--鍵值轉換表

begin
	ki2<="11" & ki;
	ko<=ko2(1 downto 0);
	kv<=kn_kv(kn);--位置碼轉鍵值
	kASCII<=kn_kASCII(kn);
	kok<='1' when ks=20 else '0';
	process (kf)
	begin
		if ks=ks_end or reset='0' then
			kn<=0;
			ko2<="1110";
			ks<=0;
		elsif rising_edge(kf) then
			if ks>0 then
				ks<=ks+1;
				if ki2=15 and (ks<2 or ks>25) then
					ks<=ks_end;
				end if;
			elsif ki2(kn/4)='0' then				 
				ks<=1;
				koo<=not koo;	--koo測試觀察用
			else
				kn<=kn+1;
				if kn=15 then ks<=ks_end; end if;
				ko2<=ko2(2)&ko2(1)&ko2(0)&ko2(3);				
			end if;
		end if;
	end process;

end HGL;
