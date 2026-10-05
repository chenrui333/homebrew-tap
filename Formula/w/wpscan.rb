class Wpscan < Formula
  desc "WordPress security scanner"
  homepage "https://wpscan.com"
  url "https://github.com/wpscanteam/wpscan/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "6211c5d1f88daf84e1949cff4309e8c12212409746a1cef26e1ee9d0a5d9395f"
  license :cannot_represent # Source is public, commercial use requires a paid license
  head "https://github.com/wpscanteam/wpscan.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256               arm64_tahoe:   "e6999d56b2c7fc97ff62ac91db947b11c6f2a85226c7a2f793d69e0c6d673616"
    sha256               arm64_sequoia: "1492f6af40f39ccfd130969a83c1df3efc905a8151adcb4214d231338855a82f"
    sha256               arm64_sonoma:  "af29b9c8de71b5e7da73a563b4c21debf494cef15ce84822f193cd207be7c897"
    sha256 cellar: :any, arm64_linux:   "e4a7036d80107c6e81d3a929ab1337ab9b5ec286f4510f532f9fb175728605e1"
    sha256 cellar: :any, x86_64_linux:  "2470b1027c61de1fbb51da74c487a90e36a8303b56f5da4e58f52dda591ed47d"
  end

  depends_on "ruby" # Some gems require >= ruby 2.7
  depends_on "xz" # for liblzma

  on_linux do
    depends_on "libffi"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    # Cache the gemspec's runtime dependencies. A hand-maintained resource list no longer
    # satisfied wpscan 4.x (missing `ferrum`, `ostruct`, `fiddle`; needs `activesupport >= 7.1`).
    ENV["GEM_HOME"] = buildpath/".bundle-gems"
    ENV["BUNDLE_WITHOUT"] = "development"
    # Keep source gems so native extensions build against Homebrew libraries.
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    system "bundle", "cache", "--no-install"
    rm_r buildpath/".bundle-gems"
  end

  def install
    ENV["GEM_HOME"] = libexec

    # Install every gem cached by `fetch` into libexec, even if the Ruby install already has a copy.
    Dir["vendor/cache/*.gem"].each do |gem|
      args = ["--local", "--ignore-dependencies", "--no-document", gem]
      # Fix segmentation fault on Apple Silicon
      # Ref: https://github.com/ffi/ffi/issues/864#issuecomment-875242776
      args += ["--", "--enable-libffi-alloc"] if File.basename(gem).start_with?("ffi-") && OS.mac? && Hardware::CPU.arm?
      system "gem", "install", *args
    end

    system "gem", "build", "wpscan.gemspec"
    system "gem", "install", "--local", "--ignore-dependencies", "--no-document", "wpscan-#{version}.gem"
    bin.install libexec/"bin/wpscan"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    # Avoid references to the Homebrew shims directory
    if OS.mac?
      shims_references = Dir[libexec/"extensions/**/mkmf.log"].select { |f| File.file? f }
      inreplace shims_references, Superenv.shims_path.to_s, "<**Reference to the Homebrew shims directory**>",
                audit_result: false
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wpscan --version")

    # `--update` downloads the vulnerability database; without it a scan stops before sending any request.
    output = shell_output("#{bin}/wpscan --url http://example.com --no-update 2>&1", 4)
    assert_match "Update required, you can not run a scan if a database file is missing.", output
  end
end
