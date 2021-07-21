Note:
	Ensure to provide a store directory in the script.
	
	Usage: ./to-pkcs12 <systemname> <*.key> <*.cer>
		* <systemname> -- Should reflect the name of the system you are making the p12 for
					   -- This is only used to create a directory for the rest of the files to go in
		* <*.key> -- The key file that needs to be used.
		* <*.cer> -- The certificate file to be used.