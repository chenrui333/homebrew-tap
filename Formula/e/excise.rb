class Excise < Formula
  desc "Surgical terminal storage navigator"
  homepage "https://github.com/findyourexit/excise"
  url "https://github.com/findyourexit/excise/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "a48ea802d3f42090e9d2298fb9f8c0d438c24babfe033e0795a56a61ed4d24f6"
  license "MIT"
  head "https://github.com/findyourexit/excise.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62b46282305f4c2d5300a1073afa8bed7757024a660849e386c6da322f1a1f5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8a84f50f2fc3ea1838b7855c1e812cf073278f9c241a8956df6cc982eee9ecb"
    sha256 cellar: :any,                 arm64_linux:   "e56ef78cfc13140887d898140bc5bbeeadd8ce953783527f7cfad4e21456f84b"
    sha256 cellar: :any,                 x86_64_linux:  "0a1f3ecff42c384031595239c97118b9af4ee4eb6f0cec77341b2a774d064e86"
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
    assert_match version.to_s, shell_output("#{bin}/excise --version")

    fixture = testpath/"fixture"
    (fixture/"nested").mkpath
    (fixture/"nested/file.txt").write("fixture data\n")
    report = testpath/"report.json"
    system bin/"excise", "--format", "json", "--output", report, fixture
    assert_path_exists report
    assert_match "file.txt", report.read
  end
end
