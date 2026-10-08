class Datui < Formula
  desc "Data exploration in the terminal"
  homepage "https://derekwisong.github.io/datui/"
  url "https://github.com/derekwisong/datui/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "98cb55b978b4309e0b35719581366df41abaa340b2747881def34ee6d1aeecec"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2fad1e9ab01094ca9c16ef1762a374fef7cec0b8ba01800d42aaca0dc7a8182"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01e354d52cf8871407d964f65659625c8d301722ad8384ae14bfce9c8f8d48bf"
    sha256 cellar: :any,                 arm64_linux:   "38b18c95140503f09c2643db849bb417dd4b105cb25a914c313b62ef3f0a652d"
    sha256 cellar: :any,                 x86_64_linux:  "52947362723980195feb93204db8efcfc5886ca71c2029472f44ea5fb716628c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "fontconfig"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", "--bin", "datui", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/datui --version")

    output = shell_output("HOME=#{testpath} #{bin}/datui config init")
    assert_match(/Wrote .*config\.toml/, output)
  end
end
