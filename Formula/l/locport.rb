class Locport < Formula
  desc "Manage local ports across projects"
  homepage "https://github.com/klevo/locport"
  url "https://github.com/klevo/locport/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "bbcf5132d77fc1f058df061881a8f098ad31f050298bb3d00d1ab59e75dcde37"
  license "MIT"

  depends_on "ruby"

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_WITHOUT"] = "development test"
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["GEM_HOME"] = libexec
    ENV["NOKOGIRI_USE_SYSTEM_LIBRARIES"] = "1"

    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "Index file", shell_output("#{bin}/locport info")

    system bin/"locport", "add", "myapp.localhost"
    assert_match "myapp.localhost", shell_output("#{bin}/locport list")
  end
end
