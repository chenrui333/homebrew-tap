class Openclacky < Formula
  desc "Token-efficient open-source AI Agent with skill system and IM integrations"
  homepage "https://github.com/clacky-ai/openclacky"
  url "https://github.com/clacky-ai/openclacky/archive/refs/tags/v1.5.19.tar.gz"
  sha256 "ac552ea11c7af3d0ecd18f62e6ef2d9d95e04597a5ccf6731b0f755d30a47ac8"
  license "MIT"
  head "https://github.com/clacky-ai/openclacky.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "31ce4a44755a55f3e8ee5710543944808813933c03c1014448a1f1cbaa6eb42c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31ce4a44755a55f3e8ee5710543944808813933c03c1014448a1f1cbaa6eb42c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65e82c2db6dd5d5c27049c04bc10499e94f108e4b88aa9cbe07b83ffb653d377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65e82c2db6dd5d5c27049c04bc10499e94f108e4b88aa9cbe07b83ffb653d377"
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
