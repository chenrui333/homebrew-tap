class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.5.6.tar.gz"
  sha256 "b9c6272b83667ced07897948a1c9f0405b33a717e49d6b5d080de68f1f121df1"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "69cc4981b92fa806f0bd3100584a3b5de1c3dd117fe8db3a42e4932a00e40592"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69cc4981b92fa806f0bd3100584a3b5de1c3dd117fe8db3a42e4932a00e40592"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69cc4981b92fa806f0bd3100584a3b5de1c3dd117fe8db3a42e4932a00e40592"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab218c7194ff0fe05927d6c9f20163e6e5660d7be811f446fedb8ba57c38e9cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab218c7194ff0fe05927d6c9f20163e6e5660d7be811f446fedb8ba57c38e9cc"
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
