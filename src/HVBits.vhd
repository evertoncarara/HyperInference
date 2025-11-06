----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/22/2025 10:17:18 AM
-- Design Name: 
-- Module Name: HVBits - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.NUMERIC_STD.ALL;


entity HVBits is
    port (         
        t       : in std_logic_vector(15 downto 0);
        o       : out std_logic
    );
end HVBits;


architecture MNIST_seed1 of HVBits is

    signal rt: UNSIGNED(15 downto 0);  
    signal rotate: integer;
    
    signal a: UNSIGNED(1 downto 0);
    signal b: UNSIGNED(3 downto 0);
    
begin
    
    rotate <= TO_INTEGER(UNSIGNED(t(3 downto 0)));

    rt <= ROTATE_LEFT(UNSIGNED(t), rotate);
   
    -- Python indexes:  00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15
    -- VHDL indexes:    15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
    
    a(0) <= rt(7) xor rt(6);
    a(1) <= rt(5) xor rt(4);   
    
    o <= a(0) xor a(1);
    
end MNIST_seed1;


architecture MNIST_seed2 of HVBits is

    signal rt: UNSIGNED(15 downto 0);  
    signal rotate: integer;
    
    signal a: UNSIGNED(3 downto 0);   

begin
    
    rotate <= TO_INTEGER(UNSIGNED(t(3 downto 0)));

    rt <= ROTATE_LEFT(UNSIGNED(t), rotate);
    
    -- Python indexes:  00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15
    -- VHDL indexes:    15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
       
    a(0) <= rt(15) xor rt(14);
    a(1) <= rt(13) xor rt(12);
    a(2) <= rt(11) xor rt(10);
    a(3) <= rt(9) xor rt(8);
      
    o <= a(0) xor a(1) xor a(2) xor a(3); 
   
end MNIST_seed2;


architecture MNIST_seed3 of HVBits is

    signal rt: UNSIGNED(15 downto 0);  
    signal rotate: integer;
    
    signal a: UNSIGNED(3 downto 0);    

begin
    
    rotate <= TO_INTEGER(UNSIGNED(t(3 downto 0)));

    rt <= ROTATE_LEFT(UNSIGNED(t), rotate);
    
    -- Python indexes:  00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15
    -- VHDL indexes:    15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
  
    a(0) <= rt(7) xor rt(6);
    a(1) <= rt(5) xor rt(4);
    a(2) <= rt(3) xor rt(2);
    a(3) <= rt(12) xor rt(13);
    
    o <= a(0) xor a(1) xor a(2) xor a(3);
    
end MNIST_seed3;