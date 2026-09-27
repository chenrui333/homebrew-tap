class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.5.16.tar.gz"
  sha256 "4fe16692780016ad09880e91c63cfb5988029c4f1e2b8a1a70a4875d7f29e07e"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cab0eab70c19fce1c7c3524ea751a4ac0275f6e39bd627a1305f686f695ec6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cab0eab70c19fce1c7c3524ea751a4ac0275f6e39bd627a1305f686f695ec6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6037333341559fefe69027bce2e6979d383f0379b1c273392260917a5bd60854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6037333341559fefe69027bce2e6979d383f0379b1c273392260917a5bd60854"
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
    # FIXME: Upstream does not expose a version command; replace this with a CLI version check when available.
    gem_spec = Gem::Specification.load((libexec/"specifications/openclacky-#{version}.gemspec").to_s)
    assert_equal version.to_s, gem_spec.version.to_s

    output = with_env("CLACKY_TELEMETRY" => "0") do
      shell_output("#{bin}/clacky agent --list --path #{testpath}")
    end
    assert_match "No sessions found.", output
  end
end
