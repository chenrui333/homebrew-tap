class Locport < Formula
  desc "Manage local ports across projects"
  homepage "https://github.com/klevo/locport"
  url "https://github.com/klevo/locport/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "e8bc684ee239ddef9c2d98f24f34a9b716e5f539a96300959db278a8e156a56b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "93fc50147ac6b40b0fbe6671fdb8622363cd8c4e71e0164ca98a6d6710e1aaf0"
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
    assert_match "Projects index", shell_output("#{bin}/locport info")

    (testpath/".local/share/locport/projects").write("[]")
    assert_match "All hosts and ports are unique", shell_output("#{bin}/locport list")
  end
end
