class Dvm < Formula
  desc "Deno Version Manager"
  homepage "https://github.com/justjavac/dvm"
  url "https://github.com/justjavac/dvm/archive/refs/tags/v1.11.7.tar.gz"
  sha256 "c3e3954f4fb6053c9ff411bb6a76491e0505ca89ade98a7f49b314830b471300"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bbce9cd6111e1586bb52276d614bedd78b1c4dcf306f1a8e7870ec26ddf78b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cb7ea0874045da5387971e2af85881c59137aa56b0a98dbbdc8026138ebd9fa"
    sha256 cellar: :any,                 arm64_linux:   "afc70045c168b44dad130c3b1e06d00ae364127a2ee1d21640f3b8125da85acf"
    sha256 cellar: :any,                 x86_64_linux:  "7c28ccaee8475ab46ef80669913379fcf07ab3c7eaaa96ba62a2f9d12972eeb7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dvm", "completions")
  end

  test do
    output = shell_output("#{bin}/dvm info")
    assert_match "dvm #{version}", output
    assert_match(/^deno\s+\S+$/, output.lines[1].chomp)
    assert_match "dvm root #{Dir.home}/.dvm", output

    assert_match version.to_s, shell_output("#{bin}/dvm --version")
  end
end
