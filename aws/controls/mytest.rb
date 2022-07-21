# copyright: 2018, The Authors
# Execute the inpsec file 
# inspec exec aws/ -t aws:// --input-file aws/inputs.yml 


title "Sample Section"
aws_vpc_id="vpc-07c77644b5ec1d89c" #  input("aws_vpc_id")

# You add controls here
control "aws-single-vpc-exists-check" do                                    # A unique ID for this control.
  impact 1.0                                                                # The criticality, if this control fails.
  title "Check to see if custom VPC exists."                                # A human-readable title.
  describe aws_region('eu-west-2') do
    it { should exist }
  end

  describe aws_vpc do
    it { should exist }
  end

  describe aws_vpc('vpc-0789a2846607df361') do
    it { should exist }
  end
  
end

control "aws-security-group" do 
  impact 1.0                                                                # The criticality, if this control fails.
  title "Check if the security groups exist and have correct ports open." 
  sec_group_name = input("sec_group_name")  
  db_sec_group = input("db_sec_group_name")

  describe aws_security_groups.where( group_name: 'default') do
    it { should exist }
  end

  describe aws_security_group(group_name: sec_group_name) do
    it { should exist }
    it { should allow_in(port: 22, ipv4_range: '0.0.0.0/0') }
    it { should allow_in(port: 80, ipv4_range: '0.0.0.0/0') }
  end
  describe aws_security_group(group_name: db_sec_group) do
    it { should exist }
    it { should allow_in(port: 22, security_group: "sg-0e3bf88d332d48282") }
  end
end