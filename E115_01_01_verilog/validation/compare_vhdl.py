import sys, subprocess, shutil, re, tempfile, json, os
from types import SimpleNamespace
from pathlib import Path

BASE=Path(tempfile.mkdtemp(prefix='vhdl-verilog-'))
VALIDATION=Path(__file__).resolve().parent
RTL=VALIDATION.parent
SRC=RTL.parent/'E115_01_01'
IV=os.environ.get('IVERILOG','iverilog')
IVLIB=os.environ.get('IVERILOG_LIBDIR')
VVP=os.environ.get('VVP','vvp')
GHDL=os.environ.get('GHDL','ghdl')
REF=BASE/'ref';REF.mkdir()

def run(args,cwd=None):
 r=subprocess.run([str(x) for x in args],cwd=cwd,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
 if r.returncode:raise RuntimeError(' '.join(map(str,args))+'\n'+r.stdout)
 return r.stdout

mods={k:SimpleNamespace(**v) for k,v in json.loads((VALIDATION/'ports.json').read_text()).items()}
for f in SRC.glob('*.vhd'):
 s='\n'.join(l.split('--')[0] for l in f.read_bytes().decode('cp950',errors='replace').splitlines())
 s=s.replace('((others=>0))','(others=>0)')
 if f.stem=='e115_01_01':continue
 s=re.sub(r'(\bsignal\s+i\s*:\s*integer\s+range\s+0\s+to\s+)2',r'\g<1>3',s,flags=re.I) if f.stem=='ads1115_16bit_i2c_driver' else s
 (REF/f.name).write_text(s)

run([GHDL,'-a','--std=08','-fsynopsys','--workdir='+str(REF),*REF.glob('*.vhd')])

def width(s):
 w=s['type']['w']
 return int(eval(w.replace('clog2','clog2'),{'clog2':lambda n:max(1,(n-1).bit_length()),'txrd_buff':511}))

def check(name,n,values,observe=None):
 m=mods[name];d=BASE/('test_'+name);d.mkdir(exist_ok=True)
 ins=[s for s in m.ports if s['direction'] in ('in','inout')]
 outs=[s for s in m.ports if s['direction'] in ('out','buffer') and (observe is None or s['name'] in observe)]
 wi=sum(width(s) for s in ins);wo=sum(width(s) for s in outs)
 rows=[]
 for step in range(n):
  v=values(step)
  rows.append(''.join(format(v.get(s['name'],0),'0'+str(width(s))+'b') for s in ins))
 (d/'inputs.txt').write_text('\n'.join(rows)+'\n')
 vdecl=[];hdecl=[];vload=[];hload=[];vout=[];hout=[]
 for s in m.ports:
  nm=s['name'];w=width(s);inp=s in ins;t=s['type']['kind']
  vdecl.append(('reg' if inp else 'wire')+f' [{w-1}:0] {nm};')
  if t=='int':htype='integer range 0 to '+s['type']['hi'].replace('txrd_buff','511')
  elif w==1:htype='std_logic'
  else:htype=f'std_logic_vector({w-1} downto 0)'
  hdecl.append(f'signal {nm}: {htype};')
 off=wi
 for s in ins:
  nm=s['name'];w=width(s);off-=w
  sl=f'iv({off+w-1} downto {off})'
  if s['type']['kind']=='int':val=f'to_integer(unsigned(to_stdlogicvector({sl})))'
  elif w==1:val=f'to_stdlogicvector(iv)({off})'
  else:val=f'to_stdlogicvector({sl})'
  hload.append(f'{nm} <= {val};')
 for s in outs:
  nm=s['name'];w=width(s);vout.append(nm)
  if s['type']['kind']=='int':vv=f'std_logic_vector(to_unsigned({nm},{w}))'
  elif w==1:vv=f'std_logic_vector\'(0 => {nm})'
  else:vv=nm
  hout.append(f'write(ln,to_string({vv}));')
 params=' #(.txrd_buff(511))' if m.params else ''
 vh='\n'.join(['`timescale 1ns/1ps','module tb;',*vdecl,f'reg [{wi-1}:0] vectors [0:{n-1}];','integer i, f;',name+params+' dut ('+', '.join('.'+s['name']+'('+s['name']+')' for s in m.ports)+');','initial begin', '$readmemb("inputs.txt", vectors);','f = $fopen("verilog.txt", "w");',f'for (i=0;i<{n};i=i+1) begin','{'+', '.join(s['name'] for s in ins)+'} = vectors[i];','#1;','$fdisplay(f,"%b", {'+', '.join(vout)+'});','#9;','end','$fclose(f);','$finish;','end','endmodule'])
 # inout bus external stimulus needs a separate resolved driver in Verilog.
 for s in ins:
  if s['direction']=='inout':
   nm=s['name'];vh=vh.replace(f'reg [0:0] {nm};',f'wire {nm}; reg {nm}_drive; assign {nm} = {nm}_drive;')
   vh=vh.replace('{'+', '.join(x['name'] for x in ins)+'}', '{'+', '.join(x['name']+('_drive' if x['direction']=='inout' else '') for x in ins)+'}')
 (d/'tb.v').write_text(vh)
 gener=' generic map(txrd_buff=>511)' if m.params else ''
 hh='\n'.join(['library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all; use std.textio.all;','entity tb is end;','architecture test of tb is',*hdecl,'begin','dut:entity work.'+name+gener+' port map('+', '.join(s['name']+'=>'+s['name'] for s in m.ports)+');','process','file fi:text open read_mode is "inputs.txt";','file fo:text open write_mode is "vhdl.txt";',f'variable iv:bit_vector({wi-1} downto 0);','variable ln:line;','begin',f'for i in 0 to {n-1} loop','readline(fi,ln); read(ln,iv);',*hload,'wait for 1 ns;',*hout,'writeline(fo,ln);','wait for 9 ns;','end loop;','std.env.stop; wait;','end process;','end;'])
 # Feed 1 as Z for an open-drain input driver.
 if any(s['direction']=='inout' for s in ins):
  vh=(d/'tb.v').read_text().replace('assign sda = sda_drive;',"assign sda = sda_drive ? 1'bZ : 1'b0;")
  (d/'tb.v').write_text(vh)
  hh=hh.replace('sda <= to_stdlogicvector(iv)('+str(next(wi-sum(width(x) for x in ins[:j+1]) for j,s in enumerate(ins) if s['name']=='sda'))+');',"sda <= 'Z' when to_stdlogicvector(iv)("+str(next(wi-sum(width(x) for x in ins[:j+1]) for j,s in enumerate(ins) if s['name']=='sda'))+")='1' else '0';")
 (d/'tb.vhd').write_text(hh)
 run([GHDL,'-a','--std=08','-fsynopsys','--workdir='+str(REF),d/'tb.vhd'])
 run([GHDL,'-r','--std=08','-fsynopsys','--workdir='+str(REF),'tb','--assert-level=error'],d)
 run([IV,*(['-B',IVLIB] if IVLIB else []),'-g2001','-s','tb','-o',d/'sim',d/'tb.v',RTL/(name+'.v')])
 run([VVP,d/'sim'],d)
 ref=(d/'vhdl.txt').read_text().splitlines();got=(d/'verilog.txt').read_text().splitlines()
 assert len(ref)==len(got)==n
 bad=[];known=0;trans=set()
 for i,(r,g) in enumerate(zip(ref,got)):
  assert len(r)==len(g)==wo
  if i<10:continue
  known+=sum(c in '01' for c in r)
  trans.add(r)
  if any(a in '01' and a!=b for a,b in zip(r,g)):
   bad.append((i,r,g))
   if len(bad)==5:break
 if bad:raise AssertionError((name,bad))
 msg=f'{name}: PASS ({n} samples, {known} known output bits, {len(trans)} output states)'
 print(msg,flush=True);return msg

def uart(s):
 return dict(clk=s%2,reset=int(s>=8),dl=3,parityn=0,stopn=0,f_set=15,tx_w=int(s%1500 in (40,41,42,43)),txdata=(s//1500*37+0x55)%256,rx_r=int(s%1800 in range(1300,1320)),rd=1)

# Compile both event-accurate simulation and synthesis preprocessing paths.
for defines in ([],['-DSYNTHESIS']):
 run([IV,*(['-B',IVLIB] if IVLIB else []),'-g2001','-Wall',*defines,'-s','e115_01_01','-o',BASE/'top',*sorted(RTL.glob('*.v'))])
print('e115_01_01: both preprocessing paths compile',flush=True)
run([IV,*(['-B',IVLIB] if IVLIB else []),'-g2001','-s','rom_tb','-o',BASE/'rom',VALIDATION/'rom_tb.v',RTL/'e111_01_01_rom.v'])
rom_result=run([VVP,BASE/'rom'],VALIDATION).strip()
assert 'PASS' in rom_result and 'FAIL' not in rom_result,rom_result
print(rom_result,flush=True)

results=[]
if len(sys.argv)==1 or 'ws2812b_driver' in sys.argv:
 results.append(check('ws2812b_driver',1500,lambda s:dict(ws2812bclk=s%2,ws2812breset=int(s>=8),ws2812b_loadck=int(s in (20,21,400,401,800,801)),ws2812b_ledgrbdata=(s//400*0x112233+0x81a55a)%2**24)))
if len(sys.argv)==1 or 'joystick_driver' in sys.argv:
 results.append(check('joystick_driver',6000,lambda s:dict(joystick_clk=s%2,joystick_reset=int(s>=8),ads1115_ok=1,vx=(0,15000,30000)[(s//600)%3],vy=(30000,15000,0)[(s//600)%3],sw=(s//1800)%2)))
if len(sys.argv)==1 or 'k4x4' in sys.argv:
 results.append(check('k4x4',3000,lambda s:dict(kf=s%2,reset=int(s>=8),ki=2),['ko','kn','kv','kascii','kok']))
if len(sys.argv)==1 or 'st7735_spi_tft_lcd_4w_driver_3' in sys.argv:
 def lcd(s):
  case=s//500;return dict(st7735_clk=s%2,st7735_reset=int(s%500>=8),st7735_res=1,st7735_bls=1,dci=3 if case else 1,cmpai=0xa55a,cbi=case%4,fcri=0xff,fcgi=0x87,fcbi=0x12,bcri=0x1f,bcgi=0x43,bcbi=0x98,d8_1i=3,shift_hdni=2,st7735_loadck=int(s%500 in (20,21,22,23)))
 results.append(check('st7735_spi_tft_lcd_4w_driver_3',2500,lcd))
if len(sys.argv)==1 or 'rs232_t4' in sys.argv:
 results.append(check('rs232_t4',30000,uart))
if len(sys.argv)==1 or 'rs232_r4' in sys.argv:
 def rx(s):
  v=uart(s);v['rx_r']=0;bit=(s-100)//118;byte=0xa5
  v['rd']=1 if bit<0 or bit>=10 else 0 if bit==0 else (byte>>(bit-1))&1 if bit<9 else 1
  return v
 results.append(check('rs232_r4',8000,rx))
if len(sys.argv)==1 or 'ads1115_16bit_i2c_driver' in sys.argv:
 results.append(check('ads1115_16bit_i2c_driver',10000,lambda s:dict(i2cclk=s%2,reset=int(s>=8),s_reset=int(s>=8),ads1115_addr=0,ads1115_alert_rdy=0,sda=0,ads1115_input_mux=0x30,ads1115_input_fsr_pga=0x6d96db,ads1115_input_dr=0xffffff,ads1115_uploadck=0)))
(BASE/'differential-results.txt').write_text('\n'.join(results)+'\n')

print("Trace files:",BASE)
