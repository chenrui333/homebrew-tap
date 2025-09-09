class Rkik < Formula
  desc "Rusty Klock Inspection Kit - Simple NTP Client"
  homepage "https://github.com/aguacero7/rkik"
  url "https://github.com/aguacero7/rkik/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "4cb847440079a66c3269701e2226540332fe2de806f071096401c9fb5d5b912f"
  license "MIT"
  head "https://github.com/aguacero7/rkik.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "deca30ecd3ad78a2dbb1fef05bc5478c2b520c4b591586db6582fb033e685b14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "814b23b08e3f0343191f24c518510fc90efd5a84ebd6cb0d40e8c0020c7f4ee2"
    sha256 cellar: :any_skip_relocation, ventura:       "5267a72af482cd91bbf9bb426e646b3d14a6405d42e446b929ed12f229d43346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57d51eb8f27d01941662cab1cc0bef7ed5de98e2afce9077f4ba32716d1c7d1d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Error querying server 'time.google.com':
    # Input/output error: Resource temporarily unavailable (os error 35)
    return if OS.mac? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match <<~EOS, shell_output("#{bin}/rkik --server time.google.com --verbose")
      Stratum: 1
      Reference ID: GOOG
    EOS
  end
end
