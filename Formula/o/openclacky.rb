class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "37d0465d767c46bfabce59bc673dc505aa8eeeef157d31e0eb19ebe56a8535f4"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2acf90039c4b84b223a9915bd56c58630a3a3248c799eeb58db809db926e0fd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2acf90039c4b84b223a9915bd56c58630a3a3248c799eeb58db809db926e0fd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2acf90039c4b84b223a9915bd56c58630a3a3248c799eeb58db809db926e0fd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0dcee5be7c4cdda7c1d712c8aa9e836932f570cf021fe6cfe66bb1c83956fb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0dcee5be7c4cdda7c1d712c8aa9e836932f570cf021fe6cfe66bb1c83956fb4"
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
