class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.5.24.tar.gz"
  sha256 "4d6b5351db3ca9c614e063577cf42e19a9855331c0570cc9cb60b2d035845efd"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a737302c526f61c9c4a4a565c650fafbfe29e4e0d213f76f9def248cf436b666"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a737302c526f61c9c4a4a565c650fafbfe29e4e0d213f76f9def248cf436b666"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1af5f33c3bd204cb560fe35a8c5f40d46517c4b98c6f59165c3f6c8cc43c1e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1af5f33c3bd204cb560fe35a8c5f40d46517c4b98c6f59165c3f6c8cc43c1e8"
  end

  depends_on "ruby"

  deny_network_access!

  def fetch
    # Bundler still generates executables for the `gemspec` path gem; keep them out of HOMEBREW_PREFIX.
    ENV["GEM_HOME"] = buildpath/".bundle-gems"
    system "bundle", "cache", "--no-install"
    rm_r buildpath/".bundle-gems"
  end

  def install
    ENV["GEM_HOME"] = libexec

    system "git", "init"
    # The gemspec packages `git ls-files`; keep the fetched gem cache out of the gem.
    system "git", "add", ".", ":!vendor/cache"
    system "gem", "build", "openclacky.gemspec"
    # Resolve runtime dependencies from the gems cached by `fetch`.
    cd "vendor/cache" do
      system "gem", "install", "--local", "--no-document", buildpath/"openclacky-#{version}.gem"
    end

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
