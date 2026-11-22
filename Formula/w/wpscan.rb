class Wpscan < Formula
  desc "WordPress security scanner"
  homepage "https://wpscan.com"
  url "https://github.com/wpscanteam/wpscan/archive/refs/tags/v4.2.1.tar.gz"
  sha256 "31c1c6ff21a0abf7cdb2b1390372ff0028f720c5d3a4cd4878cb5ba3ca7e6bbb"
  license :cannot_represent # Source is public, commercial use requires a paid license
  head "https://github.com/wpscanteam/wpscan.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "e57842ee94340ecd6a2322e604c5709cad06358cfc5183d8858d99c200cc5bb7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37404438b8075a63aeb4af74673d4c3d8a592a5a2ab9a516082ec43e86fc7764"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e77849e943ee8323187c5ce1ee24c4725d8702140d65fdb7dd51f93c8859c272"
    sha256 cellar: :any,                 arm64_linux:   "652754ae6af16189334dc4f7651a1c274addd452c5ed888e4850889b3437b186"
    sha256 cellar: :any,                 x86_64_linux:  "aa7f5f402311c26eb7ec98846bef64d646eb75924e88e52a3528875f37061da1"
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
      libexec.glob("extensions/**/mkmf.log").each do |log|
        inreplace log, Superenv.shims_path.to_s, "<**Reference to the Homebrew shims directory**>",
                  audit_result: false
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wpscan --version")

    # `--update` downloads the vulnerability database; without it a scan stops before sending any request.
    output = shell_output("#{bin}/wpscan --url http://example.com --no-update 2>&1", 4)
    assert_match "Update required, you can not run a scan if a database file is missing.", output
  end
end
