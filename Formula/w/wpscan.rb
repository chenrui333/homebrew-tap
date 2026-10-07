class Wpscan < Formula
  desc "WordPress security scanner"
  homepage "https://wpscan.com"
  url "https://github.com/wpscanteam/wpscan/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "6211c5d1f88daf84e1949cff4309e8c12212409746a1cef26e1ee9d0a5d9395f"
  license :cannot_represent # Source is public, commercial use requires a paid license
  head "https://github.com/wpscanteam/wpscan.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58cbaf1637a7ae946f096720ac22b9861090bd1d025ce03235e53d9fd02c086b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fed07dcdf3943d4e4952258fc039a402a1da43efd57b78d9f81947390f59d76"
    sha256 cellar: :any,                 arm64_linux:   "cf237166669005b1d6f20a9b3830ef1c8ae5be5d91689e0a81b1af516ad3cd6e"
    sha256 cellar: :any,                 x86_64_linux:  "859a32cb12f253833dfcfa240954c4743b9477af70a6cd5d2f030879fdd0ece2"
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
