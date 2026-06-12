class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.2.17.tar.gz"
  sha256 "5a47761676835a0de55881c631f6521246627426b754be43255e619c9a1955ee"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97365d4c61150697ef75518bdb1270b2b6c8182d410d347569953ad2c3229bc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97365d4c61150697ef75518bdb1270b2b6c8182d410d347569953ad2c3229bc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97365d4c61150697ef75518bdb1270b2b6c8182d410d347569953ad2c3229bc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "004c10ab617d7e816402bb56b5388a5a100145b335236aa332124d5ed64ac8ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "004c10ab617d7e816402bb56b5388a5a100145b335236aa332124d5ed64ac8ca"
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
