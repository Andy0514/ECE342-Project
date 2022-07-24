	component PROBE_256 is
		port (
			source     : out std_logic_vector(255 downto 0);        -- source
			source_clk : in  std_logic                      := 'X'  -- clk
		);
	end component PROBE_256;

	u0 : component PROBE_256
		port map (
			source     => CONNECTED_TO_source,     --    sources.source
			source_clk => CONNECTED_TO_source_clk  -- source_clk.clk
		);

