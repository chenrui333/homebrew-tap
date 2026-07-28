class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "ff25c3c48696745c713d62df3d1b45b5ccd17f6289a2dda5d873823e6dd44d7a"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f50f137c54da964c02b80bff96f47d99120154a6db4ad1acad3c40cb3a1e8134"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f50f137c54da964c02b80bff96f47d99120154a6db4ad1acad3c40cb3a1e8134"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f50f137c54da964c02b80bff96f47d99120154a6db4ad1acad3c40cb3a1e8134"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7dd33bb1a2e07328fd5cfecd5c7585c2bf4f66a21b044533d9df734ebbd1c6bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dd33bb1a2e07328fd5cfecd5c7585c2bf4f66a21b044533d9df734ebbd1c6bd"
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
