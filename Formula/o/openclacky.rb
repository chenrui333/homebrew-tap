class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.5.15.tar.gz"
  sha256 "4b869201c1463c6f75534927ba650a0c1040911b33a2cb9d932c9cc500746619"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28450e7960d96426b2620608134301155fdf0be3b322123fc4e57c22d59efacf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28450e7960d96426b2620608134301155fdf0be3b322123fc4e57c22d59efacf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2476157146ee631ed1f4fdf43b72fd26a01e689be1168bdf78f683fd7aaa237a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2476157146ee631ed1f4fdf43b72fd26a01e689be1168bdf78f683fd7aaa237a"
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
