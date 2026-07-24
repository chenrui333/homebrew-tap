class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "20cef666b7e6c33abadafa0aea30707ee8a9f760c2904536e7eef88577028b19"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3f2a80d22021f0a35044e1c01ede9b34c59aaaa848d1a7d09198aad7ccf178d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3f2a80d22021f0a35044e1c01ede9b34c59aaaa848d1a7d09198aad7ccf178d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3f2a80d22021f0a35044e1c01ede9b34c59aaaa848d1a7d09198aad7ccf178d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dfe86bf289fd1046e9d5ec232951faf2511cfe2521d7bdb509efef067a3d265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dfe86bf289fd1046e9d5ec232951faf2511cfe2521d7bdb509efef067a3d265"
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
