library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity HyperInference_tb is
end HyperInference_tb;

architecture Behavioral of HyperInference_tb is

    constant DIMENSIONS         : integer := 8192;
    constant CLASSES            : integer := 10;
    constant PARALLEL           : integer := 78; -- 78 limit for MNIST

    -- Memories constants
    constant SAMPLE_ADDR_WIDTH  : integer := 10;
    constant SAMPLE_DATA_WIDTH  : integer := 8;   
    
    constant CLASS_ADDR_WIDTH   : integer := 12;
    constant CLASS_DATA_WIDTH   : integer := 26; -- 26 is enough for ISOLET.
    
    constant TOTAL_INDEXES      : integer := 3200;        
    
    signal samples_addr : std_logic_vector(SAMPLE_ADDR_WIDTH - 1 downto 0);
    signal feature      : std_logic_vector(SAMPLE_DATA_WIDTH - 1 downto 0);    
       
    signal done: std_logic;    
    
    signal clk      : std_logic := '0';
    signal rst      : std_logic;
    signal start    : std_logic;  
      
begin

    clk <= not clk after 5 ns; -- 10ns = 100MHz
    rst <= '1', '0' after 15 ns;
    
    SAMPLE: entity work.Memory(BlockRAM)
        generic map (
            imageFileName   => "image.txt",         
            DATA_WIDTH      => SAMPLE_DATA_WIDTH,
            ADDR_WIDTH      => SAMPLE_ADDR_WIDTH
        )
        port map (
            clock           => clk,
            wr              => '0',
            write_address   => (others=>'0'),
            read_address    => STD_LOGIC_VECTOR(samples_addr),
            data_i          => (others=>'0'),        
            data_o          => feature
        );
    
    HYPER_INFERENCE: entity work.HyperInference(behavioral)
        generic map (
            SAMPLE_ADDR_WIDTH   => SAMPLE_ADDR_WIDTH,
            SAMPLE_DATA_WIDTH   => SAMPLE_DATA_WIDTH,
            CLASS_ADDR_WIDTH    => CLASS_ADDR_WIDTH,
            CLASS_DATA_WIDTH    => CLASS_DATA_WIDTH,
            PARALLEL            => PARALLEL,
            DIMENSIONS          => DIMENSIONS,
            TOTAL_INDEXES       => TOTAL_INDEXES,
            CLASSES             => CLASSES
        )
        port map (
            clk             => clk,
            rst             => rst,
            start           => start,
            samples_addr    => samples_addr,
            feature         => feature,            
            done            => done           
        );
        
   
    process
    begin
        start <= '0';
        
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        start <= '1';
        
        wait until rising_edge(clk);
        start <= '0';
        
        wait;
    end process;

end Behavioral;
