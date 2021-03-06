----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:03:22 10/10/2017 
-- Design Name: 
-- Module Name:    AddressDecoder - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AddressDecoder is
    Port ( A : in  std_logic_vector (11 downto 8);
           B : out  std_logic_vector (10 downto 8); -- to EPROM
           CLK : in std_logic;
           PHI0 : in std_logic;
           RNW : in  std_logic;
           NDEV_SEL : in  std_logic;    -- $C0n0 - $C0nF
           NIO_SEL : in  std_logic;     -- $Cs00 - $CsFF
           NIO_STB : in  std_logic;     -- $C800 - $CFFF
           NRESET : in std_logic;
           DATA_EN : out  std_logic;    -- to CPLD
           NG : out  std_logic;         -- to bus transceiver
           NOE : out  std_logic;
           LED : out  std_logic);       -- to EPROM
end AddressDecoder;

architecture Behavioral of AddressDecoder is

    signal cfxx : std_logic;            -- $C800 - $CFFF disable
    signal ndev_sel_int : std_logic;
    signal nio_sel_int : std_logic;
    signal nio_stb_int : std_logic;
    signal ncs : std_logic;             -- $C800 - $CFFF enabled
    signal a_int : std_logic_vector (11 downto 8);

begin

    -- According to Apple IIgs Tech Note #68
    -- in order to prevent bus fights with video data,
    -- data from peripheral to CPU shall be valid on the bus
    -- only from the first rising edge of 7M when any select
    -- line is low (Phi0 high) to the falling edge of Phi0
    
    -- $C0xx to $C7xx is mapped to EEPROM bank 0
    -- $C8xx to $CExx is mapped to banks 1 to 7
    
    LED <= ncs;
    B(8) <= (a_int(11) and not a_int(8))
         or (a_int(11) and a_int(10) and a_int(9));
    B(9) <= (a_int(11) and not a_int(9) and a_int(8))
         or (a_int(11) and a_int(9) and not a_int(8))
         or (a_int(11) and a_int(10) and a_int(9));
    B(10) <= (a_int(11) and a_int(10))
         or (a_int(11) and a_int(9) and a_int(8));
         
    DATA_EN <= RNW and not NDEV_SEL;
    NG   <= (ndev_sel_int and nio_sel_int and nio_stb_int)
         or (ndev_sel_int and nio_sel_int and ncs)
         or not PHI0;
    NOE  <= not RNW 
         or not NDEV_SEL
         or (not NIO_STB and ncs);
    
    cfxx <= a_int(8) and a_int(9) and a_int(10) and not nio_stb_int;
    
    process(NRESET, nio_sel_int, cfxx)
    begin
        if (NRESET = '0' or cfxx = '1') then
            ncs <= '1';
        elsif falling_edge(nio_sel_int) then
            ncs <= '0';
        end if;
    end process;
    
    process(NRESET, CLK)
    begin
        if(NRESET = '0') then
            ndev_sel_int <= '1';
            nio_sel_int <= '1';
            nio_stb_int <= '1';
            a_int <= "0000";
        elsif rising_edge(CLK) then
            ndev_sel_int <= NDEV_SEL;
            nio_sel_int <= NIO_SEL;
            nio_stb_int <= NIO_STB;
            a_int <= A;
        end if;
    end process;
    
end Behavioral;

