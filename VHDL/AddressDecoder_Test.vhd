--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:42:22 10/10/2017
-- Design Name:   
-- Module Name:   C:/Git/AppleIISd/VHDL/AddressDecoder_Test.vhd
-- Project Name:  AppleIISd
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: AddressDecoder
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY AddressDecoder_Test IS
END AddressDecoder_Test;
 
ARCHITECTURE behavior OF AddressDecoder_Test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT AddressDecoder
    PORT(
         A : IN  std_logic_vector(11 downto 8);
         B : OUT  std_logic_vector(10 downto 8);
         CLK : IN std_logic;
         PHI0 : IN std_logic;
         RNW : IN  std_logic;
         NDEV_SEL : IN  std_logic;
         NIO_SEL : IN  std_logic;
         NIO_STB : IN  std_logic;
         NRESET : IN  std_logic;
         DATA_EN : OUT  std_logic;
         NG : OUT  std_logic;
         NOE : OUT  std_logic;
         LED : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(11 downto 8) := "0101";
   signal RNW : std_logic := '1';
   signal NDEV_SEL : std_logic := '1';
   signal NIO_SEL : std_logic := '1';
   signal NIO_STB : std_logic := '1';
   signal NRESET : std_logic := '1';
   signal CLK : std_logic := '0';
   signal PHI0 : std_logic := '1';

 	--Outputs
   signal B : std_logic_vector(10 downto 8);
   signal DATA_EN : std_logic;
   signal NG : std_logic;
   signal NOE : std_logic;
   signal LED : std_logic;
   
   -- Clock period definitions
   constant CLK_period : time := 142 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: AddressDecoder PORT MAP (
          A => A,
          B => B,
          CLK => CLK,
          PHI0 => PHI0,
          RNW => RNW,
          NDEV_SEL => NDEV_SEL,
          NIO_SEL => NIO_SEL,
          NIO_STB => NIO_STB,
          NRESET => NRESET,
          DATA_EN => DATA_EN,
          NG => NG,
          NOE => NOE,
          LED => LED
        );
 
   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 
   PHI0_process :process(CLK)
   variable counter : integer range 0 to 7;
   begin
        if rising_edge(CLK) or falling_edge(CLK) then
            counter := counter + 1;
            if counter = 7 then
                PHI0 <= not PHI0;
                counter := 0;
            end if;
        end if;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state.
      wait for CLK_period * 10;
      NRESET <= '0';
      wait for CLK_period * 20;
      NRESET <= '1';
      wait for CLK_period * 10;

      -- insert stimulus here 
      -- C0nX access
      A <= "0000";  -- must become "000"
      wait until rising_edge(PHI0);
      NDEV_SEL <= '0';
      wait until falling_edge(PHI0);
      NDEV_SEL <= '1';
      wait until rising_edge(PHI0);
      
      -- CnXX access
      A <= "0100";  -- must become "000"     
      wait until rising_edge(PHI0);
      NIO_SEL <= '0';
      wait until falling_edge(PHI0);
      NIO_SEL <= '1';
      wait until rising_edge(PHI0);
      
      -- C8xx access, selected
      A <= "1000";  -- must become "001"      
      wait until rising_edge(PHI0);
      NIO_STB <= '0';
      wait until falling_edge(PHI0);
      NIO_STB <= '1';
      wait until rising_edge(PHI0);
      
      -- C9xx access, selected
      A <= "1001";  -- must become "010"      
      wait until rising_edge(PHI0);
      NIO_STB <= '0';
      wait until falling_edge(PHI0);
      NIO_STB <= '1';
      wait until rising_edge(PHI0);
      
      -- CPLD access
      A <= "0101";  -- must become "000"      
      wait until rising_edge(PHI0);
      NDEV_SEL <= '0';
      wait until falling_edge(PHI0);
      NDEV_SEL <= '1';
      wait until rising_edge(PHI0);
      
      -- CFFF access
      A <= "1111";  -- must become "111"      
      wait until rising_edge(PHI0);
      NIO_STB <= '0';
      wait until falling_edge(PHI0);
      NIO_STB <= '1';
      wait until rising_edge(PHI0);
      
      -- C8xx access, unselected
      A <= "1000"; -- must become "001"      
      wait until rising_edge(PHI0);
      NIO_STB <= '0';
      wait until falling_edge(PHI0);
      NIO_STB <= '1';
      wait until rising_edge(PHI0);

      wait;
   end process;

END;
