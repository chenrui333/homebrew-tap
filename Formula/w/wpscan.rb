class Wpscan < Formula
  desc "WordPress security scanner"
  homepage "https://wpscan.com"
  url "https://github.com/wpscanteam/wpscan/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "fa140b4ed31741da80d6e5f936a3a8c6cc87a0c6ebe093d87e1248cd7596257d"
  license :cannot_represent # Source is public, commercial use requires a paid license
  head "https://github.com/wpscanteam/wpscan.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "453601d02e2c871267397328abd52b71cc1a15d2fed9ba397264789b4a03580c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd9c3c284fceed5354b97eb702819d0128dfef4b96fe36b4925b99209679f9f9"
    sha256 cellar: :any,                 arm64_linux:   "c158d524ce4a969f4a3d3d57ef0950f4036cb96a5dbcaccc7b81c324b29afeb0"
    sha256 cellar: :any,                 x86_64_linux:  "a2de7621124398f50ebee36db7bd7751da7835aece7c77c33981be59d26d913a"
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
