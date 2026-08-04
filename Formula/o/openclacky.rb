class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.5.5.tar.gz"
  sha256 "7f3f26a6bf6129ed58c6b007b492252e2769ce491e279923ef2e981706071611"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f3aa0c4bda25d298b28dc20ab2adeceba6a401689360203b2d39f05fc4d6a70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f3aa0c4bda25d298b28dc20ab2adeceba6a401689360203b2d39f05fc4d6a70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f3aa0c4bda25d298b28dc20ab2adeceba6a401689360203b2d39f05fc4d6a70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed9666357d25efb1de0c1d3eb6d1b39d3017072af9fa4b9f361bb2536c02d866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed9666357d25efb1de0c1d3eb6d1b39d3017072af9fa4b9f361bb2536c02d866"
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
