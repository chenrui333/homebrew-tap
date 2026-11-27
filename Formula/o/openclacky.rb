class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.5.26.tar.gz"
  sha256 "4223e501c847b809a072828325d4ae9a9127134f1ecd5e63b8995617d92b94de"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "6cbe0e17ba03ec2e6e52fd2207166d54502a2859d0d6b6e0a11e7ac58616b363"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36b9f267f6c8e7dada0c72e159cfdc8998200467b6307a23a6678c3de1d7de0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36b9f267f6c8e7dada0c72e159cfdc8998200467b6307a23a6678c3de1d7de0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f57425ab298a3630f7be57851bf376386c699b4c72ee03bc4672181af77da14e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f57425ab298a3630f7be57851bf376386c699b4c72ee03bc4672181af77da14e"
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
