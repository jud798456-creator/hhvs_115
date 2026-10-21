--109.07.xx
Library ieee;
Use IEEE.std_logic_1164.all;
Use IEEE.numeric_std.all;

Entity E111_01_01_rom is
	generic
	(	addr_length : natural;--定義記憶體深度:0~addr_length個
		ram_init_file_set : string--定義記憶體初始值設定檔名
	);
	Port
	(
		addr	: in natural range 0 to addr_length;--定義記憶體深度:0~addr_length個
		clk		: in std_logic;
		q:out std_logic_vector(15 downto 0);
		qq:out std_logic_vector(15 downto 0)
	);
End entity;

Architecture E111_01_01_rom_Arch of E111_01_01_rom is
	--建立2維陣列:寬度:16位元,深度:0~addr_length個
	Subtype word_t is std_logic_vector(15 downto 0);
	Type memory_t is array(addr_length downto 0) of word_t;
		
	--預置ROM記憶體內容
	Signal rom : memory_t ;
	Attribute ram_init_file : string;
	Attribute ram_init_file of rom : signal is ram_init_file_set;--定義記憶體初始值設定檔名

Begin
	--ROM記憶體內容的讀出
	Process(clk)
	Begin
		If(rising_edge(clk)) then
			q <= rom(addr);
			qq <= rom(addr+1);
		End if;
	End process;
		
End E111_01_01_rom_Arch;
