class Locport < Formula
  desc "Manage local ports across projects"
  homepage "https://github.com/klevo/locport"
  url "https://github.com/klevo/locport/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "81ba77accf8ac659a42a4dffd4a6c573a004299d7f0888036afc1fc896c32b4c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92c9c93e4f6d533ac333075ace1ee4444e37f47407c03e1b9d078bc41371eecb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e2b11cc7d2597625af0f0599e9752d35404bff33eb4afe6b9909615da43797b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "522340f6af16f9e4eda2ebfeebcd8b123971fd3194f51e7dbde4a70fe201b01d"
  end

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
