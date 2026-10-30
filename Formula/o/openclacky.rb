class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.5.22.tar.gz"
  sha256 "92c01e6c476bb8be23ba2f9608948f235882bb6a164fea0ad86fc5af0dc945e9"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "613d4d259bbabab263801b47fac8e342f40919ac3e43e0d73a6cff7904cc4112"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "613d4d259bbabab263801b47fac8e342f40919ac3e43e0d73a6cff7904cc4112"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5e7b5d2d16b5b4f8558452be19bf99c07f2aae3067412daa9323cd514879d82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5e7b5d2d16b5b4f8558452be19bf99c07f2aae3067412daa9323cd514879d82"
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
