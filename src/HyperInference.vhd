library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity HyperInference is
    generic (
        SAMPLE_ADDR_WIDTH   : integer := 10;
        SAMPLE_DATA_WIDTH   : integer := 8;
        CLASS_DATA_WIDTH    : integer := 26;    -- 26 is enough for ISOLET.
        CLASS_ADDR_WIDTH    : integer := 12;
        PARALLEL            : integer := 64;
        DIMENSIONS          : integer := 8192;
        TOTAL_INDEXES       : integer := 8192;
        CLASSES             : integer := 10        
    );
    port (
        clk             : in std_logic;
        rst             : in std_logic;
        start           : in std_logic;
        done            : out std_logic;
        class           : out std_logic_vector(4 downto 0);
        samples_addr    : out std_logic_vector(SAMPLE_ADDR_WIDTH - 1 downto 0);
        feature         : in std_logic_vector(SAMPLE_DATA_WIDTH - 1 downto 0)
    );
end HyperInference;

architecture Behavioral of HyperInference is
       
    signal class_addr   : UNSIGNED(CLASS_ADDR_WIDTH - 1 downto 0);
    signal class_bits   : std_logic_vector(CLASS_DATA_WIDTH - 1 downto 0);      
    
    type CountersArray is array(natural range <>) of UNSIGNED(11 downto 0);
    signal counters : CountersArray(0 to 9);
    signal smaller  : UNSIGNED(11 downto 0);
    
    signal bits_av: std_logic;
    signal bits, encoded_bits: std_logic_vector(PARALLEL - 1 downto 0);
    signal counting: std_logic;
    
    type State is (INIT, WAITING_BITS, HAMMING, READ_CLASS_HVS_BITS);
    signal currentState : State;
    
    signal i        : integer;
    signal count_bits : integer;    
      
begin
        
    HV_ENCODER: entity work.Encoder(Behavioral)
        generic map (
            PARALLEL        => PARALLEL,
            FEATURE_WIDTH   => SAMPLE_DATA_WIDTH,
            INDEX_WIDTH     => 13, 
            DIMENSIONS      => DIMENSIONS,
            TOTAL_INDEXES   => TOTAL_INDEXES,
            MAX_X           => 28,
            MAX_Y           => 28
        )
        port map (
            clk         => clk,
            rst         => rst,
            start       => start,
            address     => samples_addr,
            feature     => feature,
            bits_av     => bits_av,
            bits        => bits,
            halt        => counting,
            done        => done           
        );
        
    CLASS_HVS: entity work.Memory(BlockRAM)
        generic map (
            imageFileName   => "class_hvs.txt",         
            DATA_WIDTH      => CLASS_DATA_WIDTH,
            ADDR_WIDTH      => CLASS_ADDR_WIDTH
        )
        port map (
            clock           => clk,
            wr              => '0',
            write_address   => (others=>'0'),
            read_address    => std_logic_vector(class_addr),
            data_i          => (others=>'0'),        
            data_o          => class_bits
        );
        
    counting <= '1' when currentState = HAMMING or currentState = READ_CLASS_HVS_BITS else '0';
    
    process(clk, rst)
    begin
        if rst = '1' then
            counters <= (others=>(others=>'0'));            
            currentState <= INIT;
            
        elsif rising_edge(clk) then
            case currentState is
                when INIT =>
                    class_addr <= (others=>'0');
                    currentState <= WAITING_BITS;
                    
                when WAITING_BITS =>
                    i <= 0;
                    if bits_av = '1' then
                        encoded_bits <= bits;                        
                        currentState <= HAMMING;
                        smaller <= counters(0);
                        class <= "00000";
                        count_bits <= 0;
                    end if;
                    
                when HAMMING =>
                    if count_bits < PARALLEL then
                        if encoded_bits(count_bits) = class_bits(i) then
                            counters(i) <= counters(i) + 1;                       
                        end if;
                        
                        if counters(i) < smaller then
                            smaller <= counters(i);
                            class <= STD_LOGIC_VECTOR(TO_UNSIGNED(i, class'length));
                        end if;
                        
                        i <= i + 1;
                        
                        if i = CLASSES - 1 then
                            class_addr <= class_addr + 1;
                            count_bits <= count_bits + 1;
                            i <= 0;
                            currentState <= READ_CLASS_HVS_BITS;
                        end if;
                    else
                        currentState <= WAITING_BITS;
                    end if;
                    
                when READ_CLASS_HVS_BITS =>
                    currentState <= HAMMING;
                    
                when others =>
            end case;     
        end if;
    end process;    
  

end Behavioral;
