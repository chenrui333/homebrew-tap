class Perch < Formula
  desc "Terminal social client for Mastodon and Bluesky"
  homepage "https://perch.ricardodantas.me/"
  url "https://github.com/ricardodantas/perch/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "c799e5e9ce323822560f419c7efc8d0a647528966d4105ab76c67fce4fe9356d"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75bd538825641db40907115bd5f85372afec73385231d8ef7129d1dfc6cbf32a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b85afd59289906dc5593dc0c195a84d9eccbd7ff42be4ec262c8654eaf8ffc32"
    sha256 cellar: :any,                 arm64_linux:   "ac020721d1b1236c3e5873a112369d9ccfc53e5619f087664534c5bf5ff9163c"
    sha256 cellar: :any,                 x86_64_linux:  "5ebbc90410f718c6b81d75fb914742a78e241cc1d6846eb88c14f2ca65c439cc"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("HOME=#{testpath} #{bin}/perch --version")
    assert_match "No accounts configured.", shell_output("HOME=#{testpath} #{bin}/perch accounts")
  end
end
