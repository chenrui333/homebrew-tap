class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.5.18.tar.gz"
  sha256 "19cf2985db13ef671d6db034f87f51022803e83979424d1091f2971d3d642995"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42f7c03c7276c5e84327914d07193c48d1b850937fdf21ccebee13ab8ca59aff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42f7c03c7276c5e84327914d07193c48d1b850937fdf21ccebee13ab8ca59aff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07d72166bd49f6bb35b58b1e941b966bdf602e137ada39b44b5c81aff03cc1d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07d72166bd49f6bb35b58b1e941b966bdf602e137ada39b44b5c81aff03cc1d1"
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
