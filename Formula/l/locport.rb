class Locport < Formula
  desc "Manage local ports across projects"
  homepage "https://github.com/klevo/locport"
  url "https://github.com/klevo/locport/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "5c30f9930c45ce4c8052235f1d8c2df3741e20f56a864be53ae1fcc8aee3ddfa"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "cbbb2e9c9366740f77900f56fd7c0e95139795226e868c926450e2e0cd846394"
  end

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
