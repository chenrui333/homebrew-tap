class Locport < Formula
  desc "Manage local ports across projects"
  homepage "https://github.com/klevo/locport"
  url "https://github.com/klevo/locport/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "c71206e688e0867a704c609a31bc38bc70b5bbe6d0a9144413aa905d29fd27f0"
  license "MIT"

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    ENV["NOKOGIRI_USE_SYSTEM_LIBRARIES"] = "1"

    system "bundle", "config", "set", "without", "development", "test"
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
