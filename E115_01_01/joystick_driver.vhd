--creator by HGL
--2026.07.17
--穘膘
--ADS1115_Input_MUX<="00110000";--Vx(AINP = AIN0 and AINN = GND),Vy(AINP = AIN1 and AINN = GND)
--ADS1115:AIN0=Vx ,ADS1115:AIN1=Vy
--  : 4=00100
--  : 2=00010
--オ  :16=10000
--  : 8=01000
--Sw  : 1=00001
--オ: 20=10100
--オ: 18=10010
--: 12=01100
--: 10=01010

--オ:20	--: 4	--:12
--オ  :16	--Sw: 1	--  : 8
--オ:18	--: 2	--:10
--锣传
--オ:35	--:31	  --:37
--オ  :33	--Sw:39	  --  :34
--オ:36	--:32   --:38
--锣传
--オ:4	--:0	--:6
--オ  :2	--Sw:8 	--  :3
--オ:5	--:1 	--:7

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Joystick_driver is
	port 
	(	Joystick_clk,Joystick_reset: in std_logic;
		ADS1115_RESET: out std_logic;
		ADS1115_ok: in std_logic;
		Vx,Vy:in integer range 0 to 65536;
		SW:in std_logic;
		Joystick_keyS: buffer integer range 0 to 63;
		Joystick_ok: buffer std_logic
	);
end entity;

architecture HGL of Joystick_driver is
begin
JoystickP:process(Joystick_clk)
variable Joystick_S,Joystick_S_end:integer range 0 to 255;
variable Joystick_keyN:integer range 0 to 31;
variable Joystick_H,Joystick_V:std_logic_vector(1 Downto 0);
variable Joystick_sw:std_logic;
variable Joystick_key:integer range 0 to 63;

begin
	if Joystick_reset='0' then
		ADS1115_RESET<='0';
		Joystick_S:=0;
		Joystick_keyN:=0;
		Joystick_S_end:=80;--北癳硉瞯
		Joystick_ok<='0';
	elsif rising_edge(Joystick_clk) then
		case Joystick_S is
			when 0 =>--癬﹍
				if Joystick_S_end/=0 then
					Joystick_S_end:=Joystick_S_end-1;
				else
					Joystick_S_end:=80;
					Joystick_S:=1;
				end if;

			when 1 =>
				ADS1115_RESET<='0';
				Joystick_S:=2;
			when 2 =>--代Vx Vy Sw
				ADS1115_RESET<='1';
				if ADS1115_ok='1' then
					--Vx
					if Vx<8000 then--Vxオ
						Joystick_H:="10";
					elsif Vx>22000 then--Vx
						Joystick_H:="01";
					else
						Joystick_H:="00";--Vxい
					end if;
					--Vy
					if Vy<8000 then--Vy
						Joystick_V:="10";
					elsif Vy>22000 then--Vy
						Joystick_V:="01";
					else
						Joystick_V:="00";--Vyい
					end if;
					--Sw
					if SW='1' then
						Joystick_sw:='0';
					else
						Joystick_sw:='1';
					end if;
					Joystick_key:=conv_integer(Joystick_H & Joystick_V & Joystick_sw);
					Joystick_S:=3;
				end if;

			when 3 =>
				if Joystick_key/=0 and Joystick_keyN<5 then      
					if Joystick_keyS/=Joystick_key then
						Joystick_keyS<=Joystick_key;
						Joystick_keyN:=0;
					else
						Joystick_keyN:=Joystick_keyN+1;
					end if;
					Joystick_S:=1;
				elsif Joystick_keyN/=5 then
					Joystick_S:=1;
					Joystick_keyN:=0;
				else
					--オ:20	--: 4	--:12
					--オ  :16	--Sw: 1	--  : 8
					--オ:18	--: 2	--:10
					--锣传
					--オ:36	--:32		--:38
					--オ  :34	--Sw:40 	--  :35
					--オ:37	--:33 	--:39
					--锣传
					--オ:4	--:0	--:6
					--オ  :2	--Sw:8 	--  :3
					--オ:5	--:1 	--:7
					Joystick_S:=4;
					case Joystick_keyS is
						when 4=>--
							Joystick_keyS<=0;--32;--
						when 2=>--
							Joystick_keyS<=1;--33;--
						when 16=>--オ
							Joystick_keyS<=2;--34;--オ
						when 8=>--
							Joystick_keyS<=3;--35;--
						when 20=>--オ
							Joystick_keyS<=4;--36;--オ
						when 18=>--オ
							Joystick_keyS<=5;--37;--オ
						when 12=>--
							Joystick_keyS<=6;--38;--
						when 10=>--
							Joystick_keyS<=7;--39;--
						when 1=>--SW
							Joystick_keyS<=8;--40;--SW
						when others =>
							Joystick_S:=1;
							Joystick_keyN:=0;
					end case;
				end if;

			when others =>
				Joystick_S:=Joystick_S+1;
				Joystick_ok<='0';
				if Joystick_S=20 then
					Joystick_ok<='1';
				end if;
				if Joystick_S=Joystick_S_end then
					Joystick_S:=1;
					Joystick_keyN:=0;
				end if;

		end case;
	end if;
end process;

end HGL;
