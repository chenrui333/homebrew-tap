class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.5.13.tar.gz"
  sha256 "ba3a69323bc4f744856bbdef7226b27da9f54541bd7af982e031568406a19f99"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdc11f6e8778ea975f63a615d7b158ca16782ef07a82d2d1a696e67847234a75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdc11f6e8778ea975f63a615d7b158ca16782ef07a82d2d1a696e67847234a75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdc11f6e8778ea975f63a615d7b158ca16782ef07a82d2d1a696e67847234a75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89d7af5e92ec97f0e94aa8808955cd432273c3ec577d7d509247c431e520f737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89d7af5e92ec97f0e94aa8808955cd432273c3ec577d7d509247c431e520f737"
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
