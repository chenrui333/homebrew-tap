class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.3.7.tar.gz"
  sha256 "3fc50f1a5cebeff7ed5238e3b6192903bd6d7d9e133116577e7b1f56ea1e2bd0"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "194567f653f158c9c0ef5ba9980f6b8ef6ea1e830b7092e0d1a84ef50185dcb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "194567f653f158c9c0ef5ba9980f6b8ef6ea1e830b7092e0d1a84ef50185dcb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "194567f653f158c9c0ef5ba9980f6b8ef6ea1e830b7092e0d1a84ef50185dcb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30ee52de553e9da9787a350e1adc4c486547acfb5e05e25c4bce07a5b756099f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30ee52de553e9da9787a350e1adc4c486547acfb5e05e25c4bce07a5b756099f"
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
