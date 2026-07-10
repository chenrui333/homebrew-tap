class Rkik < Formula
  desc "Rusty Klock Inspection Kit - Simple NTP Client"
  homepage "https://github.com/aguacero7/rkik"
  url "https://github.com/aguacero7/rkik/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "275c468e639ecd45f3e3051fb6df74f99ab61d76a67ad304874d111741501064"
  license "MIT"
  head "https://github.com/aguacero7/rkik.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab0195aac4319345e64eac11263e44b78f1dc06948130c669ce46fc5ec3666b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5ee97c53ca3363066fc613fd19ce8e8275902c8c92686c07a2a34bedc427f47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ef5a8339d73b24297ad2e2cd9a1bb80c1c437857c567925ea7ac6ea2a56019c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85b5ea41116ecfb88866c9fd83dc8782be5be5f5b6994dfb5a220d820f170203"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9f217ef0b93ef5ac87641435a70a315b30c60adc5e9d11a373619a384a519d8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rkik --version")

    ENV["RKIK_CONFIG_DIR"] = testpath
    system bin/"rkik", "preset", "add", "test", "--", "ntp", "pool.ntp.org"
    assert_match "test: ntp pool.ntp.org", shell_output("#{bin}/rkik preset list")
  end
end
