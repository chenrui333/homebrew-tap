class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "26e480f7253f55a1a70d9a9ab3e3194f1d4cca04ecb7a18072107f0e84517f1b"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63956ef04590a5508dc08f594138457c5445159e26dbc9f9bb63a0f9308435af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63956ef04590a5508dc08f594138457c5445159e26dbc9f9bb63a0f9308435af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63956ef04590a5508dc08f594138457c5445159e26dbc9f9bb63a0f9308435af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "976a6b747838f9704bd4e3188335bbc60f43a6b2083b840bcbf11ad65ce716ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "976a6b747838f9704bd4e3188335bbc60f43a6b2083b840bcbf11ad65ce716ce"
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
