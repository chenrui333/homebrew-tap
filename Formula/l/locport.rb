class Locport < Formula
  desc "Manage local ports across projects"
  homepage "https://github.com/klevo/locport"
  url "https://github.com/klevo/locport/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "bbcf5132d77fc1f058df061881a8f098ad31f050298bb3d00d1ab59e75dcde37"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "528d2e69754462ebe7141e17c868ebaa8f8e77994d22e150def2294419393bb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "528d2e69754462ebe7141e17c868ebaa8f8e77994d22e150def2294419393bb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06033970d6e50f8ba5f15538dcd0a6d73205dcca981b3a99871218a936769920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06033970d6e50f8ba5f15538dcd0a6d73205dcca981b3a99871218a936769920"
  end

  depends_on "ruby"

  # The test assigns and lists ports by probing loopback TCP sockets.
  allow_network_access! :test

  def fetch
    # Keep Bundler's lock and path-gem binstubs out of Ruby's shared gem dir.
    ENV["BUNDLE_PATH"] = ".bundle"
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_WITHOUT"] = "development test"
    system "bundle", "cache", "--no-install"
  end

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["GEM_HOME"] = libexec
    # Keep Bundler's path-gem binstubs out of Ruby's shared bindir.
    ENV["BUNDLE_SYSTEM_BINDIR"] = libexec/"bin"
    ENV["NOKOGIRI_USE_SYSTEM_LIBRARIES"] = "1"

    system "bundle", "install", "--local"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--local", "#{name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "Index file", shell_output("#{bin}/locport info")

    system bin/"locport", "add", "myapp.localhost"
    assert_match "myapp.localhost", shell_output("#{bin}/locport list")
  end
end
