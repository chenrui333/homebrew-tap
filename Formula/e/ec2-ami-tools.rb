class Ec2AmiTools < Formula
  desc "Amazon EC2 AMI Tools (helps bundle Amazon Machine Images)"
  homepage "https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-up-ami-tools.html"
  url "https://ec2-downloads.s3.amazonaws.com/ec2-ami-tools-1.5.19.zip"
  sha256 "bdda4494bea7d55dfff995459dd4705a953f3365bbc69f03430c796b5cc1dd7f"

  revision 1

  livecheck do
    url "https://ec2-downloads.s3.amazonaws.com/"
    regex(/>ec2-ami-tools[._-]v?(\d+(?:\.\d+)+)\.zip</i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "1fac626f8dfb68e274927f77b3515fa8ca00883d3ed3f694220dba428c0ce5fa"
  end

  depends_on "openjdk"
  depends_on "ruby"

  resource "rexml" do
    url "https://rubygems.org/downloads/rexml-3.4.4.gem"
    sha256 "19e0a2c3425dfbf2d4fc1189747bdb2f849b6c5e74180401b15734bc97b5d142"
  end

  deny_network_access!

  def install
    # File.exists? was removed in Ruby 3.2.
    Pathname.glob("lib/**/*.rb").each do |file|
      inreplace file, "File.exists?", "File.exist?" if file.read.include?("File.exists?")
    end
    gem_home = libexec/"gems"
    env = { JAVA_HOME: formula_opt_prefix("openjdk"), EC2_AMITOOL_HOME: libexec, GEM_HOME: gem_home,
            PATH: "#{formula_opt_bin("ruby")}:$PATH" }
    rm Dir["bin/*.cmd"] # Remove Windows versions
    libexec.install Dir["*"]
    system "gem", "install", resource("rexml").cached_download, "--local", "--ignore-dependencies",
                  "--no-document", "--install-dir", gem_home
    Pathname.glob("#{libexec}/bin/*") do |file|
      next if file.directory?

      basename = file.basename
      next if basename.to_s == "service"

      (bin/basename).write_env_script file, env
    end
  end

  def caveats
    <<~EOS
      Before you can use these tools you must export some variables to your $SHELL.
        export AWS_ACCESS_KEY="<Your AWS Access ID>"
        export AWS_SECRET_KEY="<Your AWS Secret Key>"
        export AWS_CREDENTIAL_FILE="<Path to the credentials file>"
    EOS
  end

  test do
    assert_match version.to_s, shell_output(bin/"ec2-ami-tools-version")

    output = shell_output("#{bin}/ec2-bundle-image --not-a-real-option 2>&1", 1)
    if OS.mac?
      assert_match "EC2::Platform::Unsupported", output
    else
      assert_match "invalid option: --not-a-real-option", output
    end
  end
end
