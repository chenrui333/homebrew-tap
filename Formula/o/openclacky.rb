class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.5.10.tar.gz"
  sha256 "6611a5edeedf2ef0a72aafb037473929834eea2e924037eecc5ceaf360dbce1f"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1b716839e290e5b440cc18857b17251713aeb13bd8ae332f4bad1dd074e98e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1b716839e290e5b440cc18857b17251713aeb13bd8ae332f4bad1dd074e98e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1b716839e290e5b440cc18857b17251713aeb13bd8ae332f4bad1dd074e98e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbfdd202853a61554a9f023437e4e652f7599519e8321f55aa4970686b0f14f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbfdd202853a61554a9f023437e4e652f7599519e8321f55aa4970686b0f14f3"
  end

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec

    system "git", "init"
    system "git", "add", "."
    system "gem", "build", "openclacky.gemspec"
    system "gem", "install", "--no-document", "openclacky-#{version}.gem"

    %w[clacky openclacky clarky].each do |cmd|
      (bin/cmd).write_env_script libexec/"bin"/cmd, GEM_HOME: ENV["GEM_HOME"]
    end
  end

  test do
    assert_match "agent", shell_output("#{bin}/clacky help")
    assert_match "Commands", shell_output("#{bin}/openclacky help")
  end
end
