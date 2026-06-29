class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "f8e1ed6ee8d52def2462c30c6904ccdfe52b764b6568fea122e1e4bbf55419d3"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dd66926dbce965ab4f15788f80f27fe45db7b9966b919c580bf0fd1d5af5a5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dd66926dbce965ab4f15788f80f27fe45db7b9966b919c580bf0fd1d5af5a5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dd66926dbce965ab4f15788f80f27fe45db7b9966b919c580bf0fd1d5af5a5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ff44b6b4fdf1cebb79b56d521ab1e0afff12806ed22c21f58383f9253d668dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ff44b6b4fdf1cebb79b56d521ab1e0afff12806ed22c21f58383f9253d668dd"
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
