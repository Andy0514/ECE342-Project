	component PROBE_32 is
		port (
			probe : in std_logic_vector(31 downto 0) := (others => 'X')  -- probe
		);
	end component PROBE_32;

	u0 : component PROBE_32
		port map (
			probe => CONNECTED_TO_probe  -- probes.probe
		);

